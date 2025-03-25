## PVC Clone
> PVC를 새로운 볼륨으로 Clone 할 수 있다.

- 제약사항
  - 복제 지원(VolumePVCDataSource)은 CSI 드라이버에서만 사용할 수 있다.
  - 복제 지원은 동적 프로비저너만 사용할 수 있다.
  - CSI 드라이버는 볼륨 복제 기능을 구현했거나 구현하지 않았을 수 있다.
  - PVC는 대상 PVC와 동일한 네임스페이스에 있는 경우에만 복제할 수 있다(소스와 대상은 동일한 네임스페이스에 있어야 함).
  - 복제는 서로 다른 스토리지 클래스에 대해서도 지원된다.
  - 대상 볼륨은 소스와 동일하거나 다른 스토리지 클래스여도 된다.
  - 기본 스토리지 클래스를 사용할 수 있으며, 사양에 storageClassName을 생략할 수 있다.
  - 동일한 VolumeMode 설정을 사용하는 두 볼륨에만 복제를 수행할 수 있다(블록 모드 볼륨을 요청하는 경우에는 반드시 소스도 블록 모드여야 한다)

### 복제 방법
- 원본 PVC
    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: ori-pvc
      namespace: yw
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 5Gi
      storageClassName: ceph-csi-storageclass
      volumeMode: Filesystem
    ```
  
- 복제 PVC
    ```yaml
    apiVersion: v1
    kind: PersistentVolumeClaim
    metadata:
      name: clone-pvc
      namespace: yw
    spec:
      accessModes:
        - ReadWriteOnce
      resources:
        requests:
          storage: 5Gi
      dataSource:
        kind: PersistentVolumeClaim
        name: ori-pvc
      storageClassName: ceph-csi-storageclass
      volumeMode: Filesystem
    ```
  - spec.resources.requests.storage 에 용량 값을 지정해야 하며, 지정한 값은 소스 볼륨의 용량과 같거나 또는 더 커야 한다.

- 결과
  - 그 결과로 지정된 소스 `ori-pvc` 과 동일한 내용을 가진 `clone-pvc` 이라는 이름을 가지는 새로운 PVC가 생겨난다.
  ```
  # k get pvc -n yw
  NAME              STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS            AGE
  ceph-pvc          Bound    pvc-632b0fc4-de0d-42a0-a651-4e4471f8c068   5Gi        RWO            ceph-csi-storageclass   47m
  ceph-pvc-clone    Bound    pvc-dda0e600-35fa-407d-934f-3610b61a998d   5Gi        RWO            ceph-csi-storageclass   32m
  ```
  - 데이터 확인
    - 원본 볼륨에서 1초 단위로 데이터를 쓰는 스크립트를 실행 
    ```
    # tail current.txt
    namespace:yw pod:ori-pod 2025-03-25 01:03:06
    namespace:yw pod:ori-pod 2025-03-25 01:03:07
    namespace:yw pod:ori-pod 2025-03-25 01:03:08
    namespace:yw pod:ori-pod 2025-03-25 01:03:09
    namespace:yw pod:ori-pod 2025-03-25 01:03:10
    namespace:yw pod:ori-pod 2025-03-25 01:03:11
    namespace:yw pod:ori-pod 2025-03-25 01:03:12
    namespace:yw pod:ori-pod 2025-03-25 01:03:13
    namespace:yw pod:ori-pod 2025-03-25 01:03:14
    namespace:yw pod:ori-pod 2025-03-25 01:03:15
    ```

    - Clone한 PVC를 Pod에 연결해서 데이터 확인
    ```
    Current time: Tue Mar 25 01:03:20 AM KST 2025
    persistentvolumeclaim/ceph-pvc-clone2 created
    ```
    ```
    # tail current.txt
    namespace:yw pod:ori-pod 2025-03-25 01:03:10
    namespace:yw pod:ori-pod 2025-03-25 01:03:11
    namespace:yw pod:ori-pod 2025-03-25 01:03:12
    namespace:yw pod:ori-pod 2025-03-25 01:03:13
    namespace:yw pod:ori-pod 2025-03-25 01:03:14
    namespace:yw pod:ori-pod 2025-03-25 01:03:15
    namespace:yw pod:ori-pod 2025-03-25 01:03:16
    namespace:yw pod:ori-pod 2025-03-25 01:03:17
    namespace:yw pod:ori-pod 2025-03-25 01:03:18
    namespace:yw pod:ori-pod 2025-03-25 01:03:19
    ```
    - 결과 : `01:03:20`에 clone PVC 생성 - `01:03:19`까지 데이터 보유 (오차범위 내 시점 유지)
    
### Usage
- 새 PVC를 사용할 수 있게 되면, 복제된 PVC는 다른 PVC와 동일하게 소비된다. 또한, 이 시점에서 새롭게 생성된 PVC는 독립된 오브젝트이다.
- 원본 dataSource PVC와는 무관하게 독립적으로 소비하고, 복제하고, 스냅샷의 생성 또는 삭제를 할 수 있다. 이는 소스가 새롭게 생성된 복제본에 어떤 방식으로든 연결되어 있지 않으며, 새롭게 생성된 복제본에 영향 없이 수정하거나, 삭제할 수도 있는 것을 의미한다.