## nodeSeletor

> Pod가 생성될 Worker Node를 지정하는 가장 간단한 방법

- nodeSeletor로 key/Value Label을 지정한 후 해당  Label을 가지고 있는 Worker Node에 Pod를 생성하는 방법이다.

### nodeSeletor 사용 방법

#### 1. Worker Node의 Label 확인

```
# kubectl get nodes --show-labels
NAME   STATUS   ROLES           AGE   VERSION   LABELS
k8s1   Ready    control-plane   78d   v1.26.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s1,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
k8s2   Ready    control-plane   78d   v1.26.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s2,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
k8s3   Ready    control-plane   78d   v1.26.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s3,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
```

- 각 Node의 CPU 종류, OS 종류, host name 이 Label 로 설정 되어있는 것을 확인 할 수 있다.
- 이러한 기존의 Label을 지정해서 nodeSeletor를 사용할 수 있다.
- 이번에는 Label을 직접 추가해서 추가한 Label을 인식해 Pod를 생성해보겠음.

#### 2. Node에 Label 추가

- 명령어

```
# kubectl label nodes [Node name] [key]=[value]
```

```
# kubectl label nodes k8s1 mykey=myvalue
node/k8s1 labeled

# kubectl get nodes --show-labels | grep k8s1
NAME   STATUS   ROLES           AGE   VERSION   LABELS
k8s1   Ready    control-plane   78d   v1.26.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s1,kubernetes.io/os=linux,mykey=myvalue,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
```

- label 이 추가된 것을 확인할 수 있다.

#### 3. nodeSeletor를 사용해서 특정 Worker Node에 Pod 띄우기

- pod.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: emptypod
  labels:
    solution: test

spec:
  replicas: 1
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
      nodeSeletor:
        mykey: myvalue
```

```
# kubectl apply -f pod.yaml
```

```
# kubectl get pod -owide
emptypod-8564554689-8wdxb                                         1/1     Running   0             65s   10.233.64.13   k8s1   <none>           <none>
emptypod-8564554689-bvm4k                                         1/1     Running   0             65s   10.233.64.12   k8s1   <none>           <none>
emptypod-8564554689-vvhj7                                         1/1     Running   0             65s   10.233.64.11   k8s1   <none>           <none>
```

- 3개의 pod 모두 k8s1 노드에 뜨는 것을 확인할 수 있다.

#### 4. Label 삭제

- 명령어

```
# kubectl label nodes [Nodes name] [key]-
```

```
# kubectl label nodes k8s1 mykey-
```

```
# kubectl get nodes --show-labels
k8s1   Ready    control-plane   78d   v1.26.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s1,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
```

- 해당 label 이 삭제 된 것을 확인할 수 있다.

