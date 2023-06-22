## 볼륨 스냅샷 (Volume Snapshot)

#### VolumeSnapshotContent 와 VolumeSnapshot

- **VolumeSnapshot** 
  - 실제 스냅샷 생성을 요청하는 오브젝트로, 사용자가 생성하게 되는 메타데이터
- **VolumeSnapshotContent**
  - 실제 생성된 스냅샷의 메타데이터를 제공
  - 메타데이터에는 스냅샷 내용, 접근 가능한 위치, 스냅샷의 소스, 어떤 `VolumeSnapshotClass`를 사용했는지 등이 적혀있다.
- **VolumeSnapshotClass**
  - 각 스냅샷 생성 시 CSI 드라이버와 스냅샷 생성에 대한 파라미터를 정의한다.
  - 스토리지 클래스에 대응하는 개념
- `VolumeSnapshotContent` 과 `VolumeSnapshot` 의 관계는 API 리소스`PV` 와 `PVC`의 관계와 유사하다. (완전히 같은 개념은 아님)

>  즉, `VolumeSnapshot` 는 `VolumeSnapshotContent` 을 참조하여 스냅샷을 생성하고 관리한다. `VolumeSnapshot`은 `PVC`와 1:1 관계를 가지며 `PVC`의 상태와 데이터를 스냅샷으로 캡처하여 `VolumeSnapshotContent`에 저장한다. 이렇게 생성된 스냅샷은 필요에 따라 복원하거나 다른 환경으로 이동할 수 있다.

- 글로는 잘 이해가 안되서 스냅샷을 생성하고 복원하는 과정을 따라하며 이해해 보았다.

### Volume Snapshot 사용 하기

- 예시에서 사용되는 yaml 파일은 [문서](https://cloud.google.com/kubernetes-engine/docs/how-to/persistent-volumes/volume-snapshots?hl=ko#v1)를 참조 하였습니다.
- 다음 과정을 진행하기 이전에 `VolumeSnapshot`, `VolumeSnapshotContent`, `VolumeSnapshotClass` CRD 를 k8s 클러스터에 등록해야 합니다.

```
## CRD 생성
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-3.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-3.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-3.0/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml

## 컨트롤러 생성
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-3.0/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/release-3.0/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
```

### VolumeSnapshot 생성

1. PVC 생성

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  storageClassName: standard-rwo
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

```
# kubectl apply -f my-pvc.yaml
```

2. POD 생성

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-app
spec:
  selector:
    matchLabels:
      app: hello-app
  template:
    metadata:
      labels:
        app: hello-app
    spec:
      containers:
      - name: hello-app
        image: google/cloud-sdk:slim
        args: [ "sleep", "3600" ]
        volumeMounts:
        - name: sdk-volume
          mountPath: /usr/share/hello/
      volumes:
      - name: sdk-volume
        persistentVolumeClaim:
          claimName: my-pvc
```

```
# kubectl apply -f my-deployment.yaml
```

3. VolumeSnapshotClass 객체 생성

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: my-snapshotclass
#parameters: # 커스텀 스토리지 위치를 사용하려면 지정 
#  storage-locations: us-east2
driver: pd.csi.storage.gke.io
deletionPolicy: Delete
```

```
# kubectl apply -f volumesnapshotclass.yaml
```

4.  VolumeSnapshot 생성

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: my-snapshot
spec:
  volumeSnapshotClassName: my-snapshotclass
  source:
    persistentVolumeClaimName: my-pvc
```

```
# kubectl apply -f volumesnapshot.yaml
```

- `VolumeSnapshot`을 생성하면 `volumeSnapshotClass`를 통해 `VolumeSnapshotContent` 가 자동으로 생성된다.
- `VolumeSnapshot` 을 생성 한 시점의 스냅샷 메타 데이터가 `VolumeSnapshotContent` 에 저장된다.

### VolumeSnapshot 복원

`PVC`의 `VolumeSnapshot`을 참조하여 기존 볼륨의 데이터가 포함된 새 볼륨을 프로비저닝하거나 스냅샷으로 캡처한 상태로 볼륨을 복원할 수 있다.

1. 복원할 pvc 생성

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-restore
spec:
  dataSource: ## 이 부분에서 복원할 snapshot 데이터를 가져온다.
    name: my-snapshot
    kind: VolumeSnapshot
    apiGroup: snapshot.storage.k8s.io
  storageClassName: standard-rwo
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```

```
# kubectl apply -f pvc-restore.yaml
```

2. POD 수정

```yaml
...
volumes:
- name: my-volume
  persistentVolumeClaim:
    claimName: pvc-restore
```

```
# kubectl apply -f my-deployment.yaml
```

- volume 부분을 업데이트 한다.



여기까지 완료 하면 VolumeSnapshot 을 생성한 시점의 데이터가 POD에 담겨있는 것을 확인 할 수 있다.