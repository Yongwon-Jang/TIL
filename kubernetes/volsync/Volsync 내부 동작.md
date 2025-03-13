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
