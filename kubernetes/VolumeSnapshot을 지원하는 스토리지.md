Kubernetes에서 **동적 프로비저닝**을 지원하고 **스냅샷(snapshot)** 기능을 제공하는 CSI 드라이버는 다양합니다. 아래 표는 이러한 드라이버를 정리한 것입니다:


| **스토리지 제공업체** | **CSI 드라이버 이름** | **기타 지원 기능** |
|----------------------|---------------------|------------------|
| **Alibaba Cloud** | `diskplugin.csi.alibabacloud.com` | Snapshot, Expansion, Cloning |
| **AWS** | `ebs.csi.aws.com` | Snapshot, Expansion, Cloning |
| **Azure** | `disk.csi.azure.com` | Snapshot, Expansion, Cloning |
| **Ceph RBD** | `rbd.csi.ceph.com` | Snapshot, Expansion, Cloning |
| **CephFS** | `cephfs.csi.ceph.com` | Snapshot, Expansion |
| **CTDI Block Storage** | `csi.ctdi.com` | Snapshot |
| **Datatom-InfinityCSI** | `datatom.csi.infinity` | Snapshot |
| **Datera** | `csi.daterainc.io` | Snapshot, Expansion |
| **Dell EMC PowerMax** | `csi-powermax.dellemc.com` | Snapshot, Expansion, Cloning |
| **Dell EMC PowerScale** | `csi-isilon.dellemc.com` | Snapshot, Expansion |
| **Dell EMC PowerStore** | `csi-powerstore.dellemc.com` | Snapshot, Expansion, Cloning |
| **Dell EMC Unity** | `csi-unity.dellemc.com` | Snapshot, Expansion, Cloning |
| **Dell EMC VxFlexOS** | `csi-vxflexos.dellemc.com` | Snapshot, Expansion, Cloning |
| **DigitalOcean** | `dobs.csi.digitalocean.com` | Snapshot, Expansion |
| **Google Cloud** | `pd.csi.storage.gke.io` | Snapshot, Expansion, Cloning |
| **HPE** | `csi.hpe.com` | Snapshot, Expansion, Cloning |
| **Huawei Storage** | `csi.huawei.com` | Snapshot, Expansion |
| **IBM Block Storage** | `block.csi.ibm.com` | Snapshot, Expansion, Cloning |
| **IBM Storage Scale** | `spectrumscale.csi.ibm.com` | Snapshot, Expansion |
| **Infinidat** | `infinibox-csi-driver` | Snapshot, Expansion |
| **NetApp** | `csi.trident.netapp.io` | Snapshot, Expansion, Cloning |
| **Nutanix** | `csi.nutanix.com` | Snapshot, Expansion, Cloning |
| **OpenEBS** | `cstor.csi.openebs.io` | Snapshot, Expansion, Cloning |
| **Portworx** | `pxd.portworx.com` | Snapshot, Expansion, Cloning |
| **Quobyte** | `quobyte-csi` | Snapshot, Expansion |
| **QingCloud** | `disk.csi.qingcloud.com` | Snapshot, Expansion |
| **QingStor** | `neonsan.csi.qingstor.com` | Snapshot, Expansion |
| **Robin Systems** | `robin` | Snapshot, Expansion, Cloning |
| **SandStone** | `csi-sandstone-plugin` | Snapshot, Expansion |
| **SmartX** | `csi-smtx-plugin` | Snapshot, Expansion |
| **Storidge** | `csi.cio.storidge.com` | Snapshot, Expansion |
| **Tencent Cloud Block Storage** | `com.tencent.cloud.csi.cbs` | Snapshot, Expansion, Cloning |
| **TrueNAS** | `csi.truenas.com` | Snapshot, Expansion |
| **VMware vSphere** | `csi.vsphere.vmware.com` | Snapshot, Expansion, Cloning |
| **VAST Data** | `csi.vastdata.com` | Snapshot, Expansion |
| **Veritas InfoScale Volumes** | `csi.infoscale.veritas.com` | Snapshot, Expansion |
| **XSKY-EBS** | `csi.block.xsky.com` | Snapshot, Expansion |
| **XSKY-FS** | `csi.fs.xsky.com` | Snapshot, Expansion |
| **Bigtera VirtualStor** | `bigtera-csi` | Snapshot, Expansion |
| **BizFlyCloud Block Storage** | `csi-bizflycloud-block` | Snapshot, Expansion |
| **ArStor CSI** | `arstor.csi.driver` | Snapshot, Expansion |
| **cloudscale.ch** | `csi.cloudscale.ch` | Snapshot, Expansion |
| **Zadara-CSI** | `csi.zadara.com` | Snapshot, Expansion |
| **Synology** | `csi.synology.com` | Snapshot, Expansion |

**참고:** 이 목록은 [Kubernetes CSI 드라이버 목록](https://kubernetes-csi.github.io/docs/drivers.html)에서 발췌한 것으로, 드라이버의 기능과 호환성은 버전에 따라 달라질 수 있으므로, 사용 전에 해당 드라이버의 공식 문서를 참조하시기 바랍니다. 