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

| 복제 방식          | 방식 설명 | 특징                                                  | 사용 사례 |
|----------------|------------|-----------------------------------------------------|------------|
| **Rclone**     | 다양한 클라우드 스토리지를 지원하는 오픈소스 도구 | - 클라우드 스토리지 간 복제<br>- 다양한 스토리지 백엔드 지원<br>- 파일 단위 복제 | - S3, Google Drive, Dropbox 등의 클라우드 스토리지로 백업 |
| **Restic**     |  Restic 기반 데이터 무버를 사용하여 PersistentVolume 데이터의 백업을 지원 | - 다른 방식들과는 다르게클러스터 간 데이터 동기화 목적이 아닌 데이터 백업이 목적     | - 주기적인 백업 및 데이터 보호 |
| **Rsync(SSH)** | 가장 일반적인 파일 동기화 도구 | - 효율적인 파일 복사 및 동기화<br>- 네트워크를 통한 원격 복제              | - 빠른 데이터 동기화가 필요할 때 |
| **Rsync-TLS**  | Rsync에 TLS 암호화를 추가한 방식 | - Rsync 기능 + 데이터 암호화<br>- 안전한 원격 전송                 | - 보안이 중요한 환경에서 Rsync 사용 |
| **Syncthing**  | 실시간 동기화가 가능한 P2P 방식 파일 복제 도구 | - 실시간 복제 지원<br>- 변경 감지 기능                           | - 여러 클러스터 간 실시간 데이터 동기화 |

### CopyMethod
- copyMethod에 따른 PiT(Point-in-Time) 사본 생성 방법
    - Clone
        - 소스 PVC를 그대로 복제해여 새로운 볼륨을 생성
    - Direct
        - data mover가 소스 PVC를 직접 사용 (시점 유지는 어떻게 할 수 있는지?)
    - Snapshot
        - VolumeSnapshot을 생성한 다음, 해당 스냅샷을 사용하여 새 볼륨을 생성

### 주요 리소스 Yaml 파일 (Rsync, Snapshot 방식 기준)
- ReplicationDestination
    ```yaml
    apiVersion: volsync.backube/v1alpha1
    kind: ReplicationDestination
    metadata:
      name: myDest
      namespace: myns
    spec:
      rsync:
        copyMethod: Snapshot
        capacity: 10Gi
        accessModes: ["ReadWriteOnce"]
        storageClassName: my-sc
        volumeSnapshotClassName: my-vsc
    ```
- ReplicationSource
    ```yaml
    apiVersion: volsync.backube/v1alpha1
    kind: ReplicationSource
    metadata:
      name: mySource
      namespace: source
    spec:
      sourcePVC: mysql-pv-claim
      trigger:
        schedule: "*/5 * * * *"
      rsync:
        sshKeys: volsync-rsync-dest-src-database-destination
        address: my.host.com
        copyMethod: Snapshot
    ```

### 복제 흐름
![img.png](img.png)
1. 타겟에 `ReplicationDestination` CR 생성
   - 사용할 PVC를 지정하지 않으면 PVC가 자동으로 생성된다
2. 소스에 `ReplicationSource` CR 생성
   - 소스 PVC의 정보, 복제 방식, 타겟 노드 정보 등이 담겨있다.
3. 소스, 타겟에 복제 경로 생성
   - 소스 : VolumeSnapshot 생성 -> PVC 생성 -> Job(Pod) 생성
   - 타겟 : Job(Pod) 생성
4. 복제 시작
   - Job Command에 입력된 Script 대로 Replication 실행
5. Clean UP (리소스 정리)
   - 소스쪽 VolumeSnapshot, Job
   - 타겟쪽 Job
6. 타겟쪽 VolumeSnapshot 생성

### 그 외 주요 기능
```yaml
apiVersion: volsync.backube/v1alpha1
kind: ReplicationSource
metadata:
  name: mySource
  namespace: myns
spec:
  rsync:
    schedule: "0 2 * * *"
    retain:
      min: 5
      max: 20

```
- scheduler
  - 복제가 실행되는 주기를 지정할 수 있다. ex) `schedule: "0 */6 * * *"` 6시간마다 복제 실행
- retain
  - 백업본을 몇 개 유지할지 결정

### 리소스 삭제는 어떻게?

### 장단점


