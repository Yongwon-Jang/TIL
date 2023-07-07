## NFS CSI Driver 설치 및 VolumeSnapshot

> NFS Server 설정이 완료되었다고 가정하고 진행하였습니다.

#### VolumeSnapshot 관련 CRD 및 Controller 생성

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotclasses.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshotcontents.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/client/config/crd/snapshot.storage.k8s.io_volumesnapshots.yaml

kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/deploy/kubernetes/snapshot-controller/rbac-snapshot-controller.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes-csi/external-snapshotter/master/deploy/kubernetes/snapshot-controller/setup-snapshot-controller.yaml
```

#### nfs.csi.k8s.io 설치

```
# curl -skSL https://raw.githubusercontent.com/kubernetes-csi/csi-driver-nfs/master/deploy/install-driver.sh | bash -s master --
```

- 참고
  - https://github.com/kubernetes-csi/csi-driver-nfs/blob/master/docs/install-csi-driver-master.md 여기서 설치 할 수도 있다하니 적어두자

- 설치 확인

```
# kubectl -n kube-system get pod -o wide -l app=csi-nfs-controller
NAME                                  READY   STATUS    RESTARTS   AGE   IP              NODE   NOMINATED NODE   READINESS GATES
csi-nfs-controller-767f94977c-fr774   4/4     Running   0          89m   192.168.6.226   k8s3   <none>           <none>
```

```
# kubectl -n kube-system get pod -o wide -l app=csi-nfs-node
NAME                 READY   STATUS    RESTARTS   AGE   IP              NODE   NOMINATED NODE   READINESS GATES
csi-nfs-node-7t4c5   3/3     Running   0          89m   192.168.6.225   k8s2   <none>           <none>
csi-nfs-node-snv2f   3/3     Running   0          89m   192.168.6.224   k8s1   <none>           <none>
csi-nfs-node-wsz82   3/3     Running   0          89m   192.168.6.226   k8s3   <none>           <none>
```

#### Storage Class

- yaml

```yaml
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
    name: nfs-csi-storageclass
provisioner: nfs.csi.k8s.io
parameters:
    server: 192.168.6.105
    share: /home/nfs/test1/
reclaimPolicy: Delete
allowVolumeExpansion: true
```

#### PVC

- yaml

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: nfs-csi-pvc
spec:
    accessModes:
        - ReadWriteOnce
    volumeMode: Filesystem
    resources:
        requests:
            storage: 10Gi
    storageClassName: nfs-csi-storageclass
```

- PVC를 생성하면 NFS Server에 Dir이 하나 생성되고 그 안에 데이터가 쓰인다. Pod를 만들어서 데이터를 쓰면 NFS Server에 데이터가 잘 들어가는 것을 확인 할 수 있다.

```
# pwd
/home/nfs/test1/pvc-5b7212fd-e548-4155-aa82-387fe0965710

# ls
dummy3G
```

#### VolumeSnapshotClass

- yaml

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: nfs-csi-snapshotclass
driver: nfs.csi.k8s.io
deletionPolicy: Delete
```

#### VolumeSnapshot

- yaml

```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: nfs-vs
spec:
  volumeSnapshotClassName: nfs-csi-snapshotclass
  source:
    persistentVolumeClaimName: nfs-csi-pvc
```

- 생성 완료

```
# kubectl get vs
NAME      READYTOUSE   SOURCEPVC     SOURCESNAPSHOTCONTENT   RESTORESIZE   SNAPSHOTCLASS           SNAPSHOTCONTENT                                    CREATIONTIME   AGE
nfs-vs   true         nfs-csi-pvc                           3126254       nfs-csi-snapshotclass   snapcontent-7adde874-5e1b-4bb3-ab8e-78352b424568   24m            24m
```

- NFS Server 에는 snapshopt-XXX Dir이 생성되고 그 안에 tar 파일이 생성되었다.

```
# pwd
/home/nfs/test1/snapshot-7adde874-5e1b-4bb3-ab8e-78352b424568

# ls
pvc-5b7212fd-e548-4155-aa82-387fe0965710.tar.gz
```



#### 복구

1. Snapshot 데이터를 담을 PVC 생성

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: nfs-csi-pvc-snap1
spec:
    dataSource:
      name: nfs-vs
      kind: VolumeSnapshot
      apiGroup: snapshot.storage.k8s.io
    accessModes:
        - ReadWriteOnce
    volumeMode: Filesystem
    resources:
        requests:
            storage: 10Gi
    storageClassName: nfs-csi-storageclass
```

- PVC를 생성하면 NFS Server 에 Dir 이 하나 더 생성 되고 그 안에는 스냅샷 당시의 데이터가 들어있다.

```
# pwd
/home/nfs/test1/pvc-cdae8127-4120-44e1-a4ca-aec6377ed42b

# ls
dummy3G
```



2. Pod 생성 및 데이터 확인

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: csi-nfs-pod-snap
spec:
  containers:
    - name: rbd-csi
      image: nginx
      volumeMounts:
        - name: mypvc
          mountPath: /home/yw
  volumes:
    - name: mypvc
      persistentVolumeClaim:
        claimName: nfs-csi-pvc-snap1
        readOnly: false
```

- Pod를 이렇게 생성해서 데이터를 확인 해보면 데이터가 잘 들어가 있는 것을 확인 할 수 있다.

```
root@csi-nfs-pod-snap:/home/yw# ls
dummy3G
```

