## Pod 에 root 권한 주는법

> Pod 에서 작업을 하다 보면 `Operation not permitted` 에러가 자주 발생 하는데 root 권한이 없어서 발생하는 것이다.

```yaml
securityContext:
 privileged: true
```

- pod를 올릴 때 `securityContext`  설정을 해주면 root 권한을 부여 받을 수 있다.

- 전체 pod yaml 예시

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: csi-rbd-demo-pod
spec:
  containers:
    - name: web-server
      image: nginx
      securityContext:
        privileged: true
      volumeMounts:
        - name: mypvc
          mountPath: /var/lib/www/html
  volumes:
    - name: mypvc
      persistentVolumeClaim:
        claimName: rbd-pvc
        readOnly: false
```

- 이런식으로 사용하면 된다.
- 다만 보안상의 문제가 발생할 수 있으니 신중하게 사용하여야 한다.