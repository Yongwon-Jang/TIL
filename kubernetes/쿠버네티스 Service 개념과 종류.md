## 쿠버네티스 Service 개념과 종류

### 학습 내용

- 서비스 개념
- 서비스 타입
- 서비스 사용하기
- 헤드리스 서비스
- kube-proxy



### kubernetes Service 개념

- 동일한 서비스를 제공하는 Pod그룹의 단일 진입점을 제공

  - 파드들을 하나의 IP로 묶어서 관리 (로드 밸런서 IP가 만들어진다. virture ip  혹은 로드밸런서 ip)
  - Service-definition

  ```
  apiVersion: v1
  kind: Service
  metadata:
  	name:
  ```



### Service Type

- 4가지 Type 지원
  - ClusterIP
    - Pod그룹의 단일 진입점(Virtual IP) 생성
  - NodePort
    - ClusterIP가 생성된 후
    - 모든 Worker Node에 외부에서 접속가능 한 포트가 예약
  - LoadBalancer
    - 클라우드 인프라스트럭처(AWS, Azure, GCP 등)나 오픈스택 클라우드에 적용
    - LoadBalancer를 자동으로 프로비전하는 기능 지원
  - ExternalName
    - 클러스터 안에서 외부에 접속 시 사용할 도메인을 등록해서 사용
    - 클러스터 도메인이 실제 외부 도메인으로 치환되어 동작



### Service 사용

- Service 생성

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  labels:
    app: nginx-app
spec:
  selector:
    app: nginx-app
  type: NodePort
  ports:
  - nodePort: 31000
    ports: 80
    targetPort: 80
```



- pod 생성

```yaml
apiVersion: apps/v1
kind: Deployment
matadata:
  name: nginx-deployment
  labels:
    app: nginx-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx-app
  template:
    metadata:
      labels:
        app: nginx-app
    spec:
      containers:
      - name: nginx-container
        image: nginx:1.7.9
        port:
          containerPort: 80
```

![nodeport](images/nodeport.PNG)





#### 참조

- https://yoonchang.tistory.com/49
