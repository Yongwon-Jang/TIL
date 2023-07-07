## NFS 동적 프로비저닝

#### 사전 준비 사항

- Kubernetes 설치
- NFS 설치 및 설정
  - NFS 서버 설정
  - k8s 모든 노드에 NFS 설치

---

#### NFS 동적 프로비저너 구성

```bash
git clone https://github.com/kubernetes-sigs/nfs-subdir-external-provisioner.git
```

- 위와 같이 git clone을 하면 `nfs-subdir-external-provisioner` 디렉터리가 생성되고 디렉터리 안에는 다음과 같은 파일들이 생성된다.

```
# ls
CHANGELOG.md     Dockerfile            LICENSE   OWNERS          README.md   SECURITY_CONTACTS  cloudbuild.yaml  code-of-conduct.md  docker  go.sum         vendor
CONTRIBUTING.md  Dockerfile.multiarch  Makefile  OWNERS_ALIASES  RELEASE.md  charts             cmd              deploy              go.mod  release-tools
```

- deployment 로 이동

```
# cd /root/nfs-subdir-external-provisioner/deployment
```

- rbac.yaml apply

```
# kubectl apply -f rbac.yaml
```

- deployment.yaml 파일 수정 및 apply

```yaml
          env:
            - name: PROVISIONER_NAME
              value: k8s-sigs.io/nfs-subdir-external-provisioner
            - name: NFS_SERVER
              value: 192.168.6.105 # NFS Server IP
            - name: NFS_PATH
              value: /home/nfs/test1 # NFS Server Mount Path
      volumes:
        - name: nfs-client-root
          nfs:
            server: 192.168.6.105 # NFS Server IP
            path: /home/nfs/test1 # NFS Server Mount Path
```

```
# kubectl apply -f deployment.yaml
```

- storage class

```
# kubectl create -f class.yaml
```

- pvc

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: mypvc-dynamic
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1G
  storageClassName: 'nfs-client'
```

```
# kubectl apply -f pvc.yaml
```

- 위의 단계들을 거치면 pvc가 동적으로 NFS 서버의 볼륨을 할당 받았음을 확인 할 수 있다.

```
# kubectl get pvc
NAME            STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
mypvc-dynamic   Bound    pvc-8c64a988-6280-43f2-9445-42e155e4c0ca   1G         RWX            nfs-client     137m
```

- 이후에 POD를 등록해서 사용하면 된다.

```yaml
---
apiVersion: v1
kind: Pod
metadata:
  name: nfs-dynamic-pod
spec:
  containers:
    - name: web-server
      image: nginx
      volumeMounts:
        - name: mypvc
          mountPath: /home/yongwon
  volumes:
    - name: mypvc
      persistentVolumeClaim:
        claimName: mypvc-dynamic
        readOnly: false
```

- 볼륨 마운트 경로에서 파일을 생성하면

```
/home/yongwon# ls
a.txt
```

- NFS Server에서도 생성 된 것을 볼 수 있다.

  - `default-mypvc-dynamic-pvc-8c64a988-6280-43f2-9445-42e155e4c0ca/` 라는 디렉터리가 생성

  ```
  default-mypvc-dynamic-pvc-8c64a988-6280-43f2-9445-42e155e4c0ca# ls
  a.txt
  ```