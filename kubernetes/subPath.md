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