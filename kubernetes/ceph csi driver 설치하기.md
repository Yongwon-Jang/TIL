## ceph csi driver 설치하기

1. helm 설치

```
# curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
```

2. helm repo 로 부터 ceph csi driver 설치

```
# helm repo add ceph-csi https://ceph.github.io/csi-charts
```

- helm 2.x 버전

  ```
  # helm install --namespace "ceph-csi-rbd" --name "ceph-csi-rbd" ceph-csi/ceph-csi-rbd
  ```

- helm 3.x 버전

  ```
  # kubectl create namespace "ceph-csi-rbd"
  # helm install --namespace "ceph-csi-rbd" "ceph-csi-rbd" ceph-csi/ceph-csi-rbd
  ```

3. 설치 확인

```
# kubectl get csidrivers.storage.k8s.io
NAME               ATTACHREQUIRED   PODINFOONMOUNT   STORAGECAPACITY   TOKENREQUESTS   REQUIRESREPUBLISH   MODES        AGE
rbd.csi.ceph.com   true             false            false             <unset>         false               Persistent   20m
```

