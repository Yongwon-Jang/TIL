## Nutanix CSI Driver

> 테스트를 위해 `nutanix` 가 아닌 환경에서 `Nutanix CSI Driver`를 설치해서 프로비저닝 해보았다.

### 참조 문서

- https://portal.nutanix.com/page/documents/details?targetId=CSI-Volume-Driver-v2_4_1:CSI-Volume-Driver-v2_4_1

### CSI Driver 설치

- ntnx-csi-rbac
  - https://github.com/nutanix/csi-plugin/blob/master/deploy/ntnx-csi-rbac.yaml
- ntnx-csi-node
  - https://github.com/nutanix/csi-plugin/blob/master/deploy/ntnx-csi-node.yaml
- ntnx-csi-provisioner
  - https://github.com/nutanix/csi-plugin/blob/master/deploy/ntnx-csi-provisioner.yaml

- ntnx-csi-driver
  - https://github.com/nutanix/csi-plugin/blob/master/deploy/csi-driver.yaml

위 yaml 파일들을 apply 하면 csi driver 가 설치 된다.

```
[root@jangco-cdm nutanix]# k get csidrivers.storage.k8s.io | grep nutanix
csi.nutanix.com    false            true             false             <unset>         false               Persistent   80m
```



#### Storage Class

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
    name: ntnx-sc
provisioner: csi.nutanix.com
parameters:
    nfsServer: 192.168.0.165
    nfsPath: /root/yw
    storageType: NutanixFiles
```

```yaml
kind: StorageClass
apiVersion: storage.k8s.io/v1
metadata:
    name: nfs-sc
provisioner: csi.nutanix.com
parameters:
    dynamicProv: ENABLED
    nfsServerName: csi-nfs
    csi.storage.k8s.io/provisioner-secret-name: ntnx-secret
    csi.storage.k8s.io/provisioner-secret-namespace: kube-system
    storageType: NutanixFiles
```

- nutanix files 에는 두가지 방식으로 storage-class 를 생성할 수 있는데 아래 방식은 실제 nutanix 환경이 있어야 사용이 가능하다.(추정) 그래서 첫번째 방식으로 `nfs server`  의 ip, path 를 입력해서 sc 를 생성하였다

#### 결과

- storage-class 잘 생성되었고 그걸 이용해 pvc 를 동적으로 생성할 수 있었다.
- nfs csi-driver 로 생성한 것과 마찬가지로 pv name 으로 디렉터리가 마운트 경로에 생성되었다.
- pod 도 정상적으로 마운트 가능

