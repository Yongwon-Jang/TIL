## Affinity

> Affinity란 선호도란 뜻으로, Pod를 선호하는 Node에서 띄울 수 있게 하는 옵션이다.



#### Affinity 종류

- nodeAffinity
  - Pod를 배치할 때, 어떤 Node에 스케쥴링 할지 설정 한다.
- podAffinity
  - Pod를 배치할 때, 실행 중인 Pod들 중에 선호하는 Pod를 찾아 해당 Pod와 동일한 Node로 배치하도록 설정한다.
- podAntiAffinity
  - 실행 중인 Pod등 중에, 선호하지 않는 Pod가 실행중인 Node를 피해서 배치하도록 설정한다.

#### nodeAffinity

- 옵션

  - **required**DuringScheduling**Ignored**DuringExecution  
    - 반드시 충족해야 하는 조건 (Hard)
    - Label이 매칭 되는 Node에만 Pod 배포 가능

  - **preferred**DuringScheduling**Ignored**DuringExecution
    - 선호하는 조건 (Soft)
    - 우선순위가 더 높은 Node에 배포

- Node label 설정

  - label로 node를 지정해 줄 수 있기 때문에 미리 label을 등록해줘야 한다.
  - 명령어

  ```
  # kubectl label nodes [Node name] [key]=[value]
  ```

  - 예시

  ```
  # kubectl label nodes k8s1 mykey=myvalue
  node/k8s1 labeled
  ```

- pod.yaml (required)

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: emptypod
    labels:
      solution: test
  
  spec:
    replicas: 3
    selector:
      matchLabels:
        name: emptypod
    template:
      metadata:
        labels:
          name: emptypod
      spec:
        containers:
          - name: testpod1
            image: nginx
            imagePullPolicy: Always
  
            volumeMounts:
              - name: volempty1
                mountPath: "/home/yw"
  
            command:
              - sleep
              - infinity
  
        volumes:
          - name: volempty1
            emptyDir: {}
  
        affinity:
          nodeAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              nodeSelectorTerms:
              - matchExpressions:
                - key: mykey
                    operator: In
                    values:
                    - myvalue
  ```

  - 지정해준 label의 key - value를 적어주면 된다.
  - values 에는 여러개가 들어갈 수 있고, `operator: In` 은 or 옵션이라고 생각하면 된다.
  - operator 옵션
    - `In`: 노드 라벨 값이 `values`에 포함되어야 합니다.
    - `NotIn`: 노드 라벨 값이 `values`에 포함되지 않아야 합니다.
    - `Exists`: 노드 라벨의 키가 존재해야 합니다.
    - `DoesNotExist`: 노드 라벨의 키가 존재하지 않아야 합니다.
    - `Gt`: 노드 라벨 값이 `values`에 지정한 값보다 크거나 같아야 합니다. (숫자 비교에 사용)
    - `Lt`: 노드 라벨 값이 `values`에 지정한 값보다 작거나 같아야 합니다. (숫자 비교에 사용)

- pod.yaml (preferred)

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: emptypod
    labels:
      solution: test
  
  spec:
    replicas: 3
    selector:
      matchLabels:
        name: emptypod
    template:
      metadata:
        labels:
          name: emptypod
      spec:
        containers:
          - name: testpod1
            image: nginx
            imagePullPolicy: Always
  
            volumeMounts:
              - name: volempty1
                mountPath: "/home/yw"
  
            command:
              - sleep
              - infinity
  
        volumes:
          - name: volempty1
            emptyDir: {}
  
        affinity:
          nodeAffinity:
            preferredDuringSchedulingIgnoredDuringExecution:
              - weight: 40
                preference:
                  matchExpressions:
                  - key: mykey
                    operator: In
                    values:
                    - myvalue
  ```

  - weight : 우선순위를 지정하는 값이다. 가장 높은 숫자를 가진 노드가 우선적으로 선택된다.
  - 예를 들어, 위의 YAML 코드에서 `weight: 40`은 `mykey` 라벨의 값이 `myvalue`인 노드에 대해 스케줄링할 때, 해당 노드가 우선적으로 선택되는 가중치를 40으로 설정한 것입니다. 다른 노드와 가중치를 비교하여, 더 높은 가중치를 가진 노드에 Pod가 더 선호적으로 스케줄링된다.



### podAffinity

- 사용법은 nodeAffinity 와 거의 동일하다.

- 테스트를 위해 특정 node에 띄울 pod가 하나 필요하다

  ```yaml
  spec:
    selector:
      matchLabels:
        app: test
  ```

  인 pod를 하나띄우고 시작

- pod.yaml (required)

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: emptypod
    labels:
      solution: test
  
  spec:
    replicas: 3
    selector:
      matchLabels:
        name: emptypod
    template:
      metadata:
        labels:
          name: emptypod
      spec:
        containers:
          - name: testpod1
            image: nginx
            imagePullPolicy: Always
  
            volumeMounts:
              - name: volempty1
                mountPath: "/home/yw"
  
            command:
              - sleep
              - infinity
  
        volumes:
          - name: volempty1
            emptyDir: {}
  
        affinity:
          podAffinity:
            requiredDuringSchedulingIgnoredDuringExecution:
              labelSelector:
              - matchExpressions:
                - key: app
                  operator: In
                  values:
                  - test
              topologyKey: kubernetes.io/hostname
  ```

- 토폴로지 키 (Topology Key)

  - 쿠버네티스 Node에 설정된 Label에 대해서, Label Selector를 수행할 **노드의 범위**를 결정한다.

  - Topology Key는 노드의 레이블 key를 설정하는 것이며, 어떠한 값을 key name으로 넣어도 상관없지만 다음과 같은 3가지 key를 주로 쓴다.
    - 노드 단위: kubernetes.io/hostname
    - 존 단위: topology.kubernetes.io/zone
      - AZ(Availablity Zone: 가용영역)
    - 리전 단위: topology.kubernetes.io/region
      - 말그대로 지역 (서울, 도쿄 등)

- pod.yaml (preferred)

  ```yaml
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: emptypod
    labels:
      solution: test
  
  spec:
    replicas: 3
    selector:
      matchLabels:
        name: emptypod
    template:
      metadata:
        labels:
          name: emptypod
      spec:
        containers:
          - name: testpod1
            image: nginx
            imagePullPolicy: Always
  
            volumeMounts:
              - name: volempty1
                mountPath: "/home/yw"
  
            command:
              - sleep
              - infinity
  
        volumes:
          - name: volempty1
            emptyDir: {}
  
        affinity:
          podAffinity:
            preferredDuringSchedulingIgnoredDuringExecution:
            - weight: 100
              podAffinityTerm:
                labelSelector:
                  matchExpressions:
                  - key: app
                    operator: In
                    values:
                    - test
                topologyKey: kubernetes.io/hostname
  ```

  

### podAntiAffinity

- 사용법은 `podAffinity` 와 크게 다르지 않다
- pod.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: emptypod
  labels:
    solution: test

spec:
  replicas: 3
  selector:
    matchLabels:
      name: emptypod
  template:
    metadata:
      labels:
        name: emptypod
    spec:
      containers:
        - name: testpod1
          image: nginx
          imagePullPolicy: Always

          volumeMounts:
            - name: volempty1
              mountPath: "/home/yw"

          command:
            - sleep
            - infinity

      volumes:
        - name: volempty1
          emptyDir: {}

      affinity:
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            labelSelector:
            - matchExpressions:
              - key: app
                operator: In
                values:
                - test
            topologyKey: kubernetes.io/hostname
```



#### 참고

- https://velog.io/@pinion7/Kubernetes-%EB%A6%AC%EC%86%8C%EC%8A%A4-Affinity%EC%97%90-%EB%8C%80%ED%95%B4-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B3%A0-%EC%8B%A4%EC%8A%B5%ED%95%B4%EB%B3%B4%EA%B8%B0