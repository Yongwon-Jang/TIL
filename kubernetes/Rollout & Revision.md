## Rollout & Revision

### Rollout

> Kubernetes(K8s)의 리소스 롤아웃은 클러스터 내에서 새로운 애플리케이션 버전이나 업데이트를 배포하는 과정을 의미합니다. Kubernetes는 배포와 관리의 복잡성을 줄이고자 다양한 메커니즘을 제공합니다. 이 중에서 대표적인 것이 "롤아웃"이며, 이는 주로 `Deployment` 리소스를 통해 수행됩니다.

### 주요 개념 및 용어

1. **Deployment**:
   - 배포를 정의하는 기본 리소스. 애플리케이션의 원하는 상태를 설명하고, 현재 상태와 비교하여 자동으로 조정합니다.

2. **ReplicaSet**:
   - 특정 개수의 Pod를 항상 실행하도록 보장합니다. Deployment는 실제 Pod의 수를 조정하기 위해 ReplicaSet을 관리합니다.

3. **Pod**:
   - Kubernetes에서 배포 가능한 가장 작은 컴퓨팅 단위. 컨테이너 하나 또는 여러 개로 구성될 수 있습니다.

### 롤아웃 과정

1. **Deployment 생성 및 업데이트**:
   - 초기 `Deployment`를 생성하면 Kubernetes는 지정된 개수의 Pod를 생성하고 이를 관리합니다.
   - 만약 `Deployment`의 스펙(예: 컨테이너 이미지, 환경 변수 등)이 변경되면 새로운 ReplicaSet이 생성되고, 점진적으로 새로운 Pod를 생성하면서 기존 Pod를 대체합니다.

2. **롤아웃 전략**:
   - **Recreate**: 모든 기존 Pod를 종료하고 새로운 Pod를 생성합니다. 서비스 다운타임이 발생할 수 있습니다.
   - **RollingUpdate**: 점진적으로 새로운 Pod를 생성하고 기존 Pod를 종료합니다. 기본 전략이며, 서비스의 연속성을 보장합니다.

### 롤아웃 명령어

1. **롤아웃 상태 확인**:
   ```bash
   kubectl rollout status deployment/<deployment-name>
   ```

2. **롤아웃 히스토리 확인**:
   ```bash
   kubectl rollout history deployment/<deployment-name>
   ```

3. **롤백**:
   - 특정 버전으로 롤백:
     ```bash
     kubectl rollout undo deployment/<deployment-name> --to-revision=<revision-number>
     ```
   - 마지막 안정된 버전으로 롤백:
     ```bash
     kubectl rollout undo deployment/<deployment-name>
     ```

### 예시

#### Deployment 생성

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app-container
        image: my-app:1.0
```

#### Deployment 업데이트

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app-container
        image: my-app:2.0
```

위와 같은 Deployment 정의 파일을 사용해 업데이트하면, Kubernetes는 새로운 ReplicaSet을 생성하고 기존 Pod를 점진적으로 새로운 Pod로 교체합니다.

#### 결론

`Kubernetes의 롤아웃 기능은 애플리케이션 업데이트를 효율적이고 안전하게 수행할 수 있도록 도와줍니다. 다양한 롤아웃 전략과 관련 명령어를 통해 서비스의 가용성을 유지하면서도 최신 상태로 업데이트할 수 있습니다.`



### Revision

>  Kubernetes에서 리비전(revision)은 `Deployment` 리소스의 변경 이력을 관리하는 개념입니다. 리비전은 특정 시점의 `Deployment` 상태를 나타내며, 각 리비전은 `Deployment`의 스펙이 변경될 때마다 증가합니다. 이를 통해 이전 상태로 롤백하거나, 변경 이력을 추적할 수 있습니다.

### 리비전 개념

- **리비전 번호**:
  - `Deployment`가 처음 생성되면 리비전 번호가 1로 시작합니다.
  - `Deployment`의 스펙이 업데이트될 때마다 리비전 번호가 1씩 증가합니다.

- **리비전 히스토리**:
  - `Deployment` 리비전 히스토리는 변경 이력 및 이전 상태를 저장합니다.
  - 이를 통해 사용자는 특정 리비전으로 롤백할 수 있으며, 변경 사항을 쉽게 추적할 수 있습니다.

### 리비전 관련 명령어

1. **롤아웃 히스토리 확인**:
   ```bash
   kubectl rollout history deployment/<deployment-name>
   ```

   이 명령어는 특정 `Deployment`의 리비전 히스토리를 보여줍니다. 예를 들어:

   ```bash
   kubectl rollout history deployment/my-app
   ```

   출력 예시:
   ```
   deployments "my-app"
   REVISION  CHANGE-CAUSE
   1         <none>
   2         kubectl set image deployment/my-app my-app-container=my-app:2.0
   ```

2. **특정 리비전 상세 정보 확인**:
   ```bash
   kubectl rollout history deployment/<deployment-name> --revision=<revision-number>
   ```

   예시:
   ```bash
   kubectl rollout history deployment/my-app --revision=2
   ```

   출력 예시:
   ```
   deployments "my-app" with revision #2
   Pod Template:
     Labels:       app=my-app
     Containers:
      my-app-container:
       Image:      my-app:2.0
       Port:       <none>
       Environment:  <none>
       Mounts:     <none>
   ```

3. **롤백**:
   - 특정 리비전으로 롤백:
     ```bash
     kubectl rollout undo deployment/<deployment-name> --to-revision=<revision-number>
     ```

     예시:
     ```bash
     kubectl rollout undo deployment/my-app --to-revision=1
     ```

   - 마지막 안정된 버전으로 롤백:
     ```bash
     kubectl rollout undo deployment/<deployment-name>
     ```

### 예시

`Deployment`를 처음 생성했을 때 리비전 1이 생성됩니다. 그 후 이미지를 업데이트하면 리비전 2가 생성됩니다. 만약 두 번째 업데이트가 실패하거나 문제가 생기면 리비전 1로 롤백할 수 있습니다.

```bash
# Initial Deployment
kubectl apply -f deployment.yaml

# Update Deployment
kubectl set image deployment/my-app my-app-container=my-app:2.0

# Check rollout history
kubectl rollout history deployment/my-app

# Rollback to revision 1
kubectl rollout undo deployment/my-app --to-revision=1
```

#### 결론

`Kubernetes의 리비전 시스템은 `Deployment`의 변경 이력을 관리하고 추적하는 데 유용합니다. 리비전을 통해 사용자는 특정 시점의 상태로 롤백하거나, 변경 이력을 쉽게 추적할 수 있습니다. 이를 통해 애플리케이션의 신뢰성과 가용성을 높일 수 있습니다.`