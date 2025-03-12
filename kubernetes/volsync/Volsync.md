## VolSync란?
> VolSync는 Kubernetes에서 비동기적인 방식으로 **Persistent Volume(PV)** 을 복제하는 **오퍼레이터(operator)**

- VolSync의 특징
  - [공식 문서](https://volsync.readthedocs.io/)
  1. 클러스터 내부 또는 클러스터 간 복제 가능
     - 같은 클러스터 내에서도 PV 복제가 가능하고, 서로 다른 클러스터 간에도 데이터를 복제할 수 있다.
  2. 스토리지 시스템에 독립적
     - 특정 스토리지 유형(Ceph, NFS, EBS 등)에 의존하지 않고, 다양한 스토리지 환경에서 작동할 수 있다.
  3. 원격 복제를 지원하지 않는 스토리지도 복제 가능
     - 일반적으로 원격 복제를 지원하지 않는 스토리지에서도 VolSync를 사용하면 데이터를 복제할 수 있다.
  4. 서로 다른 스토리지 타입(또는 벤더) 간 복제 가능
     - 예를 들어, AWS EBS에서 Ceph RBD로, 또는 NFS에서 다른 블록 스토리지로 데이터를 복제할 수 있다.
  - **주의** : `copyMethod: Snapshot` CSI 스냅샷 기능을 지원해야하기 때문에 지원하는 스토리지에서만 사용 가능

**즉, VolSync는 스토리지 종류와 관계없이 비동기적으로 데이터를 복제할 수 있도록 도와주는 Kubernetes 오퍼레이터라고 할 수 있다.**


### Volsync의 복제 방식 5가지

| 복제 방식 | 방식 설명 | 특징                                                  | 사용 사례 |
|-----------|------------|-----------------------------------------------------|------------|
| **Rclone** | 다양한 클라우드 스토리지를 지원하는 오픈소스 도구 | - 클라우드 스토리지 간 복제<br>- 다양한 스토리지 백엔드 지원<br>- 파일 단위 복제 | - S3, Google Drive, Dropbox 등의 클라우드 스토리지로 백업 |
| **Restic** |  Restic 기반 데이터 무버를 사용하여 PersistentVolume 데이터의 백업을 지원 | - 다른 방식들과는 다르게클러스터 간 데이터 동기화 목적이 아닌 데이터 백업이 목적     | - 주기적인 백업 및 데이터 보호 |
| **Rsync** | 가장 일반적인 파일 동기화 도구 | - 효율적인 파일 복사 및 동기화<br>- 네트워크를 통한 원격 복제              | - 빠른 데이터 동기화가 필요할 때 |
| **Rsync-TLS** | Rsync에 TLS 암호화를 추가한 방식 | - Rsync 기능 + 데이터 암호화<br>- 안전한 원격 전송                 | - 보안이 중요한 환경에서 Rsync 사용 |
| **Syncthing** | 실시간 동기화가 가능한 P2P 방식 파일 복제 도구 | - 실시간 복제 지원<br>- 변경 감지 기능                           | - 여러 클러스터 간 실시간 데이터 동기화 |



### 복제 흐름
1. 소스에서 복제할 PVC 생성 및 데이터 작성
   ```yaml
   apiVersion: v1
   kind: PersistentVolumeClaim
   metadata:
     name: source-pvc  
   spec:
     accessModes:
       - ReadWriteOnce  
     resources:
       requests:
         storage: 10Gi 
     storageClassName: standard 
   ```
2. 해당 PVC를 소스로 하는 `ReplicationSource` 리소스 생성
   - copyMethod에 따른 PiT(Point-in-Time) 사본 생성 방법
     - Clone
       - 소스 PVC를 그대로 복제해여 새로운 볼륨을 생성
     - Direct
       - data mover가 소스 PVC를 직접 사용 (시점 유지는 어떻게 할 수 있는지?)
     - Snapshot
       - VolumeSnapshot을 생성한 다음, 해당 스냅샷을 사용하여 새 볼륨을 생성
    ```yaml
    apiVersion: volsync.backube/v1alpha1
    kind: ReplicationSource
    metadata:
      name: database-source
      namespace: source
    spec:
      # The PVC to sync
      sourcePVC: source-pvc  
      trigger:
        # Synchronize every 6 minutes
        schedule: "*/6 * * * *"
      rclone:
        # The configuration section of the rclone config file to use
        rcloneConfigSection: "aws-s3-bucket"
        # The path to the object bucket
        rcloneDestPath: "volsync-test-bucket/mysql-pv-claim"
        # Secret holding the rclone configuration
        rcloneConfig: "rclone-secret"
        # Method used to generate the PiT copy
        copyMethod: Snapshot
        # The StorageClass to use when creating the PiT copy (same as source PVC if omitted)
        storageClassName: my-sc-name
        # The VSC to use if the copy method is Snapshot (default if omitted)
        volumeSnapshotClassName: my-vsc-name
    ```
3. 타겟에서 소스 PVC의 데이터를 담을 PVC 생성
4. 해당 PVC에 복원을 하기 위한 `ReplicationDestination` 생성
   - 이 과정에서 소스에서 타겟으로의 데이터 복제(Rsync)가 발생
    ```yaml
    apiVersion: volsync.backube/v1alpha1
    kind: ReplicationDestination
    metadata:
      name: database-destination
      namespace: dest
    spec:
      trigger:
        # Every 6 minutes, offset by 3 minutes
        schedule: "3,9,15,21,27,33,39,45,51,57 * * * *"
      rclone:
        rcloneConfigSection: "aws-s3-bucket"
        rcloneDestPath: "volsync-test-bucket/mysql-pvc-claim"
        rcloneConfig: "rclone-secret"
        copyMethod: Snapshot
        accessModes: [ReadWriteOnce]
        capacity: 10Gi
        storageClassName: my-sc
        volumeSnapshotClassName: my-vsc
    ```
5. 복제가 완료되면 해당 PVC의 Snapshot 을 생성(타겟쪽에서 스냅샷 유지가 필요한 경우)
   - Destination 의 CopyMethd를 Snapshot으로 해놓으면 복제가 완료될 때마다 스냅샷(volumeSnapshot)을 생성한다.


### 고려해 볼만한 부분
- 스냅샷 기반 복제을 사용했을 때 현재 replicator에 구현되어있는 방식 보다 효율적인지 확인 필요
- Direct 방식, Snapshot 방식에서 어떻게 Pod를 띄우지 않고 복제하는지 확인해서 그 방법만 따오기

VolSync는 여러 가지 복제 방식을 지원하며, 각각의 방식은 복제 대상의 유형, 성능, 보안 요구 사항 등에 따라 선택할 수 있습니다.


