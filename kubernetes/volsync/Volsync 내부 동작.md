## Volsync 내부 동작
> volsync controller가 어떻게 Source에서 Destination으로 데이터를 복제하는지 코드를 통해 알아봤다.

- [Volsync 소스코드](https://github.com/backube/volsync)


### 기본 동작
- `ReplicationSource` 리소스가 생성되면 `ReplicationSourceReconciler`가 실행된다.
- `ReplicationDestination` 리소스가 생성되면 `ReplicationDestinationReconciler`가 실행된다.

### ReplicationSource controller 
1. 상태 확인
   - 초기 상태 (initialState)
     - `synchronizingState` 상태로 변경
   - 동기화 중 상태 (synchronizingState)
     - `ReplicationSource`와 연결이 된 PVC가 존재하는지 확인
     - copyMethod 확인 및 복제 불륨(PVC) 생성
       - Direct
         - 소스로 지정된 PVC 그대로 사용
       - Clone
         - 소스 PVC와 같은 PVC를 이름만 바꿔서 생성, 이미 존재한다면 
       - Snapshot
     - 소스에 `Job` 리소스 생성
       - ㅇ
   - 정리 상태 (cleaningUpState)

### ReplicationDestination controller








### 활용하면 좋을 코드
- CreateOrUpdate : 리소스가 없으면 생성하고 이미 있으면 Update
```go
func CreateOrUpdate(ctx context.Context, c client.Client, obj client.Object, f MutateFn) (OperationResult, error) {
	key := client.ObjectKeyFromObject(obj)
	if err := c.Get(ctx, key, obj); err != nil {
		if !apierrors.IsNotFound(err) {
			return OperationResultNone, err
		}
		if err := mutate(f, key, obj); err != nil {
			return OperationResultNone, err
		}
		if err := c.Create(ctx, obj); err != nil {
			return OperationResultNone, err
		}
		return OperationResultCreated, nil
	}

	existing := obj.DeepCopyObject()
	if err := mutate(f, key, obj); err != nil {
		return OperationResultNone, err
	}

	if equality.Semantic.DeepEqual(existing, obj) {
		return OperationResultNone, nil
	}

	if err := c.Update(ctx, obj); err != nil {
		return OperationResultNone, err
	}
	return OperationResultUpdated, nil
}
```


스냅샷 ReadyToUse 확인
```go
func (vh *VolumeHandler) ensureSnapshot(ctx context.Context, log logr.Logger,
	src *corev1.PersistentVolumeClaim, name string, isTemporary bool) (*snapv1.VolumeSnapshot, error) {
	snap := &snapv1.VolumeSnapshot{
		ObjectMeta: metav1.ObjectMeta{
			Name:      name,
			Namespace: vh.owner.GetNamespace(),
		},
	}
	logger := log.WithValues("snapshot", client.ObjectKeyFromObject(snap))

	// See if the snapshot exists
	err := vh.client.Get(ctx, client.ObjectKeyFromObject(snap), snap)
	if err != nil {
		if !kerrors.IsNotFound(err) {
			return nil, err
		}

		// Need to create the snapshot - see if we need to wait first for a copy-trigger
		wait, err := vh.waitForCopyTriggerBeforeCloneOrSnap(ctx, log, src)
		if wait || err != nil {
			return nil, err
		}
	}

	op, err := ctrlutil.CreateOrUpdate(ctx, vh.client, snap, func() error {
		if err := ctrl.SetControllerReference(vh.owner, snap, vh.client.Scheme()); err != nil {
			logger.Error(err, utils.ErrUnableToSetControllerRef)
			return err
		}
		utils.SetOwnedByVolSync(snap)
		if isTemporary {
			utils.MarkForCleanup(vh.owner, snap)
		}
		if snap.CreationTimestamp.IsZero() {
			snap.Spec.Source.PersistentVolumeClaimName = &src.Name
			snap.Spec.VolumeSnapshotClassName = vh.volumeSnapshotClassName
		}
		return nil
	})
	if err != nil {
		logger.Error(err, "reconcile failed")
		return nil, err
	}
	if !snap.DeletionTimestamp.IsZero() {
		logger.V(1).Info("snap is being deleted-- need to wait")
		return nil, nil
	}
	if op == ctrlutil.OperationResultCreated {
		vh.eventRecorder.Eventf(vh.owner, snap, corev1.EventTypeNormal,
			volsyncv1alpha1.EvRSnapCreated, volsyncv1alpha1.EvACreateSnap,
			"created %s from %s",
			utils.KindAndName(vh.client.Scheme(), snap), utils.KindAndName(vh.client.Scheme(), src))
	}
	if snap.Status == nil || snap.Status.BoundVolumeSnapshotContentName == nil {
		logger.V(1).Info("waiting for snapshot to be bound")
		if snap.CreationTimestamp.Add(mover.SnapshotBindTimeout).Before(time.Now()) {
			vh.eventRecorder.Eventf(vh.owner, snap, corev1.EventTypeWarning,
				volsyncv1alpha1.EvRSnapNotBound, volsyncv1alpha1.EvANone,
				"waiting for %s to bind; check VolumeSnapshotClass name and ensure CSI driver supports volume snapshots",
				utils.KindAndName(vh.client.Scheme(), snap))
		}
		return nil, nil
	}
	if snap.Status.ReadyToUse != nil && !*snap.Status.ReadyToUse {
		// readyToUse is set to false for this volume snapshot
		logger.V(1).Info("waiting for snapshot to be ready")
		return nil, nil
	}
	// status.readyToUse either is not set by the driver at this point (even though
	// status.BoundVolumeSnapshotContentName is set), or readyToUse=true

	// Snapshot is ready - update copy trigger if necessary
	err = vh.updateCopyTriggerAfterCloneOrSnap(ctx, src)
	if err != nil {
		return snap, err
	}

	logger.V(1).Info("temporary snapshot reconciled", "operation", op)
	return snap, nil
}

```