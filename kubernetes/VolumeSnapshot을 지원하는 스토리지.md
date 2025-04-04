아래는 **VolumeSnapshot을 지원하는 볼륨 유형을 우선 정렬한 표**이며, **설명란에 해당 볼륨을 지원하는 CSI 드라이버 이름**을 포함했습니다.

| **볼륨 유형** | **VolumeSnapshot 지원 여부** | **CSI 드라이버**                               |
|--------------|------------------|--------------------------------------------|
| **Ceph RBD** | ✅ | `rbd.csi.ceph.com`                         |
| **NFS** | ✅ | `nfs.csi.k8s.io`                           |
| **Cinder** | ✅ | `cinder.csi.openstack.org`                 |
| **CephFS** | ✅ | `cephfs.csi.ceph.com`                      |
| **Quobyte** | ✅ | `quobyte-csi`                  |
| **AzureDisk** | ✅ | `disk.csi.azure.com`                       |
| **PortworxVolume** | ✅ | `pxd.portworx.com`                         |
| **GCEPersistentDisk** | ✅ | `pd.csi.storage.gke.io`                    |
| **Glusterfs** | ✅ | `org.gluster.glusterfs`                  |
| **AWSElasticBlockStore** | ✅ | `ebs.csi.aws.com`                          |
| **VsphereVolume** | ⚠️ | `csi.vsphere.vmware.com` 블록 볼륨에 대한 스냅샷만 지원 |
| **StorageOS** | ❌ | `storageos` 스냅샷 미지원                        |
| **AzureFile** | ❌ | `file.csi.azure.com` 스냅샷 미지원               |
| **PhotonPersistentDisk** | ❌ | 스냅샷 미지원                                    |
| **ScaleIO** | ❌ | 스냅샷 미지원                                    |
| **Local** | ❌ | 스냅샷 미지원                                    |
| **ISCSI** | ❌ | 스냅샷 미지원                                    |
| **FC (Fibre Channel)** | ❌ | 스냅샷 미지원                                    |
| **Flocker** | ❌ | 스냅샷 미지원                                    |
| **FlexVolume** | ❌ | 스냅샷 미지원                                    |
| **HostPath** | ❌ | 스냅샷 미지원                                    |




- vsphere (블록 볼륨만 지원?)
```yaml


apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshot
metadata:
  name: example-vanilla-rwo-filesystem-snapshot
spec:
  volumeSnapshotClassName: example-vanilla-rwo-filesystem-snapshotclass
  source:
    persistentVolumeClaimName: example-vanilla-rwo-pvc

apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: example-vanilla-rwo-filesystem-snapshotclass
driver: csi.vsphere.vmware.com
deletionPolicy: Delete


```
- ebs
```yaml
apiVersion: snapshot.storage.k8s.io/v1
kind: VolumeSnapshotClass
metadata:
  name: csi-aws-vsc
driver: ebs.csi.aws.com
deletionPolicy: Delete
```