### subPath

> k8s의 볼륨 마운트는 컨테이너 내부의 특정 경로를 외부 볼륨 또는 볼륨 클레임으로 연결 할 수 있도록 해준다. `subPath`는 볼륨 마운트를 통해 컨테이너 내부의 특정 경로에 대해 하위 경로(sub-ath)를 지정하는 데 사용된다.

- pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: subpath-pod
spec:
  containers:
    - name: my-container
      image: nginx
      volumeMounts:
        - name: my-volume
          mountPath: /var/data
          subPath: subdir
  volumes:
    - name: my-volume
      persistentVolumeClaim:
        claimName: my-pvc
```

여기서 `subPath: subdir`는 PV의 `/var/data/subdir` 디렉토리를 컨테이너의 `/var/data`로 마운트하게 된다. 이로써 컨테이너 내부에서는 `/var/data` 경로만으로 필요한 데이터에 접근할 수 있게 된다. 이를 통해 볼륨을 더 세밀하게 조절하고 데이터를 분리된 경로로 마운트할 수 있게 된다.



### subPathExpr 

- `subPath` 는 정적인 값을 사용하여 마운트 하는거라면, `subPathExpr` 은 환경 변수나 필드 값을 사용하여 동적으로 값을 설정하고 볼륨을 마운트 한다.
- 파드 인스턴스마다 다른 값을 사용하려는 경우에 유용하다.
- 예를 들어, `subPathExpr: $(PREFERRED_FILE)`는 파드에 정의된 환경 변수 `PREFERRED_FILE`의 값에 따라 마운트될 파일을 결정한다.
- pod.yaml

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: subpathexpr-pod
spec:
  containers:
    - name: my-container
      image: nginx
      volumeMounts:
        - name: my-volume
          mountPath: /data
          # 변수 확장에는 괄호를 사용한다(중괄호 아님).
          subPathExpr: $(PREFERRED_TXT_FILE)
  volumes:
    - name: my-volume
      emptyDir: {}
  securityContext:
    runAsUser: 1000
    fsGroup: 2000
```



