## PVC로 생성한 rbd image 찾기

1. pvc manifest 확인
```
# kubectl get pvc <pvc-name> -o yaml
```
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
  namespace: my-namespace
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
status:
  phase: Bound
  volumeName: pvc-123e4567-e89b-12d3-a456-426614174000
```
2. volumeName 으로 pv manifest 확인
```
kubectl get pv pvc-123e4567-e89b-12d3-a456-426614174000 -o yaml
```
```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pvc-123e4567-e89b-12d3-a456-426614174000
spec:
  csi:
    driver: rbd.csi.ceph.com
    fsType: ext4
    volumeHandle: 0001-0024-3f51dc46-2f5c-44e6-bb25-8d4e6b2f45c0-0000000000000001-1a2b3c4d5e6f7g8h9i0j
```
- 여기서 volumeHandle 값이 Ceph RBD 이미지의 이름이다.

3. Ceph 클러스터에서 RBD 이미지 찾기
```
rbd ls <pool-name>

rbd ls my-pool
```