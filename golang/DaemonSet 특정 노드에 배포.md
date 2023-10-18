## DaemonSet 특정 노드에 배포

- DaemonSet 은 모든 노드에 Pod를 띄우는 컨트롤러이다.
- 하지만 nodeSelector로 특정 노드에만 DaemonSet 을 띄우게 할 수 있다.



#### 일반 데몬셋 띄우기

- daemonset.yaml

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemonset-test
  labels:
    app: daemonset
spec:
  selector:
    matchLabels:
      name: daemon-test
  template:
    metadata:
      labels:
        name: daemon-test
    spec:
      containers:
      - name: fluentd
        image: nginx
        volumeMounts:
        - name: my-vol
          mountPath: /home/yw
      volumes:
      - name: my-vol
        emptyDir: {}
```

- 결과
  - 모든 노드에 pod가 띄워졌음을 확인할 수 있다.

```
[root@k8s1 daemonset]# kubectl get pod -owide
NAME                                    READY   STATUS    RESTARTS      AGE     IP             NODE   NOMINATED NODE   READINESS GATES
daemonset-test-cbd2t                    1/1     Running   0             8s      10.233.64.14   k8s1   <none>           <none>
daemonset-test-dkktn                    1/1     Running   0             8s      10.233.96.8    k8s3   <none>           <none>
daemonset-test-xqdrv                    1/1     Running   0             8s      10.233.88.9    k8s2   <none>           <none>

```



#### 특정 노드에만 데몬셋 띄우기

- nodeSelector 이용해서 k8s1, k8s3 노드에만 띄워 볼 예정

- 1, 3 노드에 label 설정 

  - `kubectl label nodes k8s1 mykey=myvalue`
  - `kubectl label nodes k8s3 mykey=myvalue`

  ```
  kubectl get nodes --show-labels
  NAME   STATUS   ROLES           AGE    VERSION   LABELS
  k8s1   Ready    control-plane   133d   v1.26.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s1,kubernetes.io/os=linux,mykey=myvalue,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
  k8s2   Ready    control-plane   133d   v1.26.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s2,kubernetes.io/os=linux,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
  k8s3   Ready    control-plane   133d   v1.26.3   beta.kubernetes.io/arch=amd64,beta.kubernetes.io/os=linux,kubernetes.io/arch=amd64,kubernetes.io/hostname=k8s3,kubernetes.io/os=linux,mykey=myvalue,node-role.kubernetes.io/control-plane=,node.kubernetes.io/exclude-from-external-load-balancers=
  ```

- daemonset.yaml

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: daemonset-test
  labels:
    app: daemonset
spec:
  # 노드셀렉터 추가
  selector:
    matchLabels:
      name: daemon-test
  template:
    metadata:
      labels:
        name: daemon-test
    spec:
      containers:
      - name: fluentd
        image: nginx
        volumeMounts:
        - name: my-vol
          mountPath: /home/yw
      volumes:
      - name: my-vol
        emptyDir: {}
      nodeSelector:
        mykey: myvalue
```

- 결과

```
[root@k8s1 daemonset]# kubectl get pod -owide
NAME                                    READY   STATUS    RESTARTS      AGE     IP             NODE   NOMINATED NODE   READINESS GATES
daemonset-test-9v7ss                    1/1     Running   0             9s      10.233.64.14   k8s1   <none>           <none>
daemonset-test-mthc8                    1/1     Running   0             9s      10.233.96.8    k8s3   <none>           <none>

```

- 지정한 k8s1, k8s3 노드에서만 파드가 뜨는 걸 확인할 수 있다.