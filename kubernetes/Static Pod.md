## Static Pod

> k8s 클러스터의 특정 노드에 직접 배치되는 pod. kubelet 디렉터리 아래에 정의된 정적 yaml 파일을 사용하여 생성할 수 있다.

#### static pod 동작

- API를 통하지 않고 pod가 생성된다.
- `/var/lib/kubelet/config.yaml`에 staticPodPath를 지정할 수 있고(기본값 `/etc/kubernetes/manifests`), 해당 위치에 yaml 파일을 생성만 해주면 자동으로 **해당 노드**에 파드가 생성된다.



#### 테스트

- `/etc/kubernetes/manifests` 위치에 yaml 파일 생성

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
```

- 파일을 생성만 하면 apply 하지 않아도 pod가 생성 되는 것을 확인할 수 있다.

```
# kubectl get pod
NAME                                                              READY   STATUS    RESTARTS      AGE
emptypod-596d89bc65-5fnbw                                         1/1     Running   0             175m
emptypod-596d89bc65-b9c7x                                         1/1     Running   0             175m
emptypod-596d89bc65-w2h2j                                         1/1     Running   0             175m
```



#### Static Pod 의 주요 특징

- kubelet이 직접 관리하기 때문에 `kube-apiserver`와의 통신이 필요하지 않다.
  - `kube-apiserver`가 정상 동작하지 않는 상태에서도 클러스터 구성요소를 안전하게 실행할 수 있음
- 해당 노드에만 바인딩되기 때문에 다른 노드에는 배치되지 않는다.
- kubelet이 포함된 노드에서 발생하는 로그와 오류 메시지를 쉽게 확인할 수 있다.