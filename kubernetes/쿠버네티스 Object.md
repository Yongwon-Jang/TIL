## Objects in k8s

> - Kubernetes의 Object는 쿠버네티스 시스템에서 영구한 객체이다. 즉 오프젝트가 생성되면 kubernetes는 이 상태를 영구히 유지하기 위해 작동한다.
> - Object는 spec, status등의 값을 가지고, Key-Value 형태로 etcd에 저장된다
> - "Persistent entities in the kubernetes system"으로 정의되어 있으며 Kubernetes에 저장된 실체들 이라고 생각하면 도니다.

#### Object 필드

- 모든 k8s 객체들은 공통적으로 두 개의 필드를 가진다
  - Spec : 객체가 가질 상태에 대한 명세 정보
  - Status : 실제 클러스터에서 객체가 가진 상태 정보(Kubernetes가 계속 검증하고 반영한다.)



#### 기본 Objects

1. Pod

   - 쿠버네티스에서 실행되는 최소 단위이다. 독립적인 공간과 IP를 가진다.

2. Namespace

   - 쿠버네티스 클러스터에서 사용되는 리소소들을 구분해서 관리하는 그룹이다.

3. Volume

   - 파드가 사라지더라고 저장/보존이 가능하며 파드에서 사용할 수 있는 디렉터리를 제공한다.

4. Service

   - 파드의 집합을 의미

   - 파드는 유동적이기 때문에 접속 정보가 고정되지 않으므로, 파드 접속을 안정적으로 유지하기 위한 기능이다.

#### 그 외 Object

- 디플로이먼트 (Deployment)
- 데몬셋 (DaemonSet)
- 컨피그맵 (ConfigMap)
- 레플리카셋 (ReplicaSet)
- PV (PersistentVolume)
- PVC (PersistentVolumeClaim)
- 스테이트풀셋 (StatefulSet)

