# 테스트 과정
## 환경 세팅
    - VMware 에서 VM 생성 (SCSI로 2개 디스크)
    - PV 초기화, VG 생성 및 LV 생성 
        # pvcreate /dev/sdb1
        # vgcreate yw /dev/sdb1
        # lvcreate -L 10G yw-date yw

        # lsblk
        NAME          MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
        sda             8:0    0  100G  0 disk
        ├─sda1          8:1    0    1G  0 part /boot
        └─sda2          8:2    0   99G  0 part
        ├─rl-root   253:0    0 63.9G  0 lvm  /
        ├─rl-swap   253:1    0  3.9G  0 lvm  [SWAP]
        └─rl-home   253:2    0 31.2G  0 lvm  /home
        sdb             8:16   0   20G  0 disk
        └─sdb1          8:17   0   20G  0 part
        └─yw-data   253:4    0   10G  0 lvm

    - 해당 VM으로 Clone해서 2개의 VM(A, A')을 만든다.
    - A의 디스크(sdb)를 A'로 옮긴다.
    - A'에는 같은 PVuuid, VGname 을 가지고있는 디스크가 이미 있기 때문에 다음과 같이 나온다.
        - lsblk 로 보녕 sdc 로 해서 3개의 디스크가 잘 나오는거 확인

        # lsblk
        NAME        MAJ:MIN RM  SIZE RO TYPE MOUNTPOINT
        sda           8:0    0  100G  0 disk
        ├─sda1        8:1    0    1G  0 part /boot
        └─sda2        8:2    0   99G  0 part
        ├─rl-root 253:0    0 63.9G  0 lvm  /
        ├─rl-swap 253:1    0  3.9G  0 lvm  [SWAP]
        └─rl-home 253:2    0 31.2G  0 lvm  /home
        sdb           8:16   0   20G  0 disk
        └─sdb1        8:17   0   20G  0 part
        sdc           8:32   0   20G  0 disk
        └─sdc1        8:33   0   20G  0 part
        sr0          11:0    1  2.5G  0 rom
    

## 문제 상황 파악

### 번외 LVM이 아닌경우) UUID가 똑같은 디바이스가 2개일 때 마운트 되는지 확인하기 (blkid로 uuid 확인)
    - uuid 가 같은 disk 두개 준비 (/dev/sdb, /dev/sdc)
    # blkid
    /dev/sdb: UUID="3b3ab96f-c3f9-4466-b98d-9e6ce5d79b97" BLOCK_SIZE="512" TYPE="xfs"
    /dev/sda1: UUID="89cb8434-b494-46be-aaa9-457ab1646cb9" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="1a7a3be2-01"
    /dev/sda2: UUID="NYBplr-JD53-GUdn-ZiBf-eb2I-QtgX-H8cew4" TYPE="LVM2_member" PARTUUID="1a7a3be2-02"
    /dev/sr0: BLOCK_SIZE="2048" UUID="2024-05-27-14-12-55-00" LABEL="Rocky-8-10-x86_64-dvd" TYPE="iso9660" PTUUID="add8671b" PTTYPE="dos"
    /dev/sdc: UUID="3b3ab96f-c3f9-4466-b98d-9e6ce5d79b97" BLOCK_SIZE="512" TYPE="xfs"

    - /dev/sdc 는 mount 불가 -> lvm이 아니라도 disk uuid 가 겹치면 사용할 수 없다.
    # mount /dev/sdb yw1
    # mount /dev/sdc yw2
    mount: /mnt/yw2: wrong fs type, bad option, bad superblock on /dev/sdc, missing codepage or helper program, or other error.

### PVUUID가 겹치는 경우
    - pvdisplay 에서는 경고와 함께 2개의 디스크만 보임
        # pvdisplay
        WARNING: Not using device /dev/sdc1 for PV yE9qA5-Xfim-kQJz-TkrN-XBAz-GvJe-7n6QNF.
        WARNING: PV yE9qA5-Xfim-kQJz-TkrN-XBAz-GvJe-7n6QNF prefers device /dev/sdb1 because device name matches previous.
        --- Physical volume ---
        PV Name               /dev/sdb1
        VG Name               yw
        PV Size               <20.00 GiB / not usable 2.00 MiB
        Allocatable           yes
        PE Size               4.00 MiB
        Total PE              5119
        Free PE               2559
        Allocated PE          2560
        PV UUID               yE9qA5-Xfim-kQJz-TkrN-XBAz-GvJe-7n6QNF

        --- Physical volume ---
        PV Name               /dev/sda2
        VG Name               rl
        PV Size               <99.00 GiB / not usable 3.00 MiB
        Allocatable           yes (but full)
        PE Size               4.00 MiB
        Total PE              25343
        Free PE               0
        Allocated PE          25343
        PV UUID               NYBplr-JD53-GUdn-ZiBf-eb2I-QtgX-H8cew4

### PVUUID는 안겹치는데 VGname 같은경우
    # pvdisplay
        --- Physical volume ---
        PV Name               /dev/sdc1
        VG Name               yw21
        PV Size               <20.00 GiB / not usable 2.00 MiB
        Allocatable           yes
        PE Size               4.00 MiB
        Total PE              5119
        Free PE               2559
        Allocated PE          2560
        PV UUID               F1VyXK-QJF0-lqXZ-83LV-9KER-L9er-u32GAF
        
        WARNING: ignoring metadata seqno 3 on /dev/sdb1 for seqno 4 on /dev/sdd1 for VG yw2.
        WARNING: Inconsistent metadata found for VG yw2.
        See vgck --updatemetadata to correct inconsistency.
        WARNING: outdated PV /dev/sdb1 seqno 3 has been removed in current VG yw2 seqno 4.
        See vgck --updatemetadata to clear outdated metadata.
        WARNING: Device mismatch detected for yw2/data which is accessing /dev/sdb1 instead of /dev/sdd1.
        --- Physical volume ---
        PV Name               /dev/sdd1
        VG Name               yw2
        PV Size               <20.00 GiB / not usable 2.00 MiB
        Allocatable           yes
        PE Size               4.00 MiB
        Total PE              5119
        Free PE               2559
        Allocated PE          2560
        PV UUID               9Q0Hwb-GoiX-N5jf-fglG-rIhW-tjPB-nYRQeW
        
        --- Physical volume ---
        PV Name               /dev/sda2
        VG Name               rl
        PV Size               <99.00 GiB / not usable 3.00 MiB
        Allocatable           yes (but full)
        PE Size               4.00 MiB
        Total PE              25343
        Free PE               0
        Allocated PE          25343
        PV UUID               NYBplr-JD53-GUdn-ZiBf-eb2I-QtgX-H8cew4


    # vgdisplay
        --- Volume group ---
        VG Name               yw21
        System ID
        Format                lvm2
        Metadata Areas        1
        Metadata Sequence No  3
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                1
        Open LV               0
        Max PV                0
        Cur PV                1
        Act PV                1
        VG Size               <20.00 GiB
        PE Size               4.00 MiB
        Total PE              5119
        Alloc PE / Size       2560 / 10.00 GiB
        Free  PE / Size       2559 / <10.00 GiB
        VG UUID               bbgRgn-BwQj-Q0Q9-AlKz-sWCE-uso5-v3tdYr
        
        WARNING: ignoring metadata seqno 3 on /dev/sdb1 for seqno 4 on /dev/sdd1 for VG yw2.
        WARNING: Inconsistent metadata found for VG yw2.
        See vgck --updatemetadata to correct inconsistency.
        WARNING: outdated PV /dev/sdb1 seqno 3 has been removed in current VG yw2 seqno 4.
        See vgck --updatemetadata to clear outdated metadata.
        WARNING: Device mismatch detected for yw2/data which is accessing /dev/sdb1 instead of /dev/sdd1.
        --- Volume group ---
        VG Name               yw2
        System ID
        Format                lvm2
        Metadata Areas        1
        Metadata Sequence No  4
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                1
        Open LV               0
        Max PV                0
        Cur PV                1
        Act PV                1
        VG Size               <20.00 GiB
        PE Size               4.00 MiB
        Total PE              5119
        Alloc PE / Size       2560 / 10.00 GiB
        Free  PE / Size       2559 / <10.00 GiB
        VG UUID               wvuzxP-0oS3-Cwv1-o9xu-nMf3-pe2C-JJlW2C
        
        --- Volume group ---
        VG Name               rl
        System ID
        Format                lvm2
        Metadata Areas        1
        Metadata Sequence No  4
        VG Access             read/write
        VG Status             resizable
        MAX LV                0
        Cur LV                3
        Open LV               3
        Max PV                0
        Cur PV                1
        Act PV                1
        VG Size               <99.00 GiB
        PE Size               4.00 MiB
        Total PE              25343
        Alloc PE / Size       25343 / <99.00 GiB
        Free  PE / Size       0 / 0
        VG UUID               hDAFyr-3rLG-eBOA-0BZ6-Yzxq-T9GH-Wce9Ia

### Centos -> Rocky 로 볼륨을 때서 붙이면 lv 시스템이 정상적으로 안보이는 문제 (Os 배포판이 다를 때)



## 해결 방법 찾는 중
- LVM 관련 메타데이터 위치
  ```
  cat /etc/lvm/backup/<vgname>

  # Generated by LVM2 version 2.03.14(2)-RHEL8 (2021-10-20): Mon Sep 22 10:35:43 2025
  
  contents = "Text Format Volume Group"
  version = 1
  
  description = "Created *after* executing 'vgrename yw2 yw3'"
  
  creation_host = "localhost.localdomain" # Linux localhost.localdomain 4.18.0-553.el8_10.x86_64 #1 SMP Fri May 24 13:05:10 UTC 2024 x86_64
  creation_time = 1758551743      # Mon Sep 22 10:35:43 2025
  
  yw3 {
  id = "wvuzxP-0oS3-Cwv1-o9xu-nMf3-pe2C-JJlW2C"
  seqno = 5
  format = "lvm2"                 # informational
  status = ["RESIZEABLE", "READ", "WRITE"]
  flags = []
  extent_size = 8192              # 4 Megabytes
  max_lv = 0
  max_pv = 0
  metadata_copies = 0
  
          physical_volumes {
  
                  pv0 {
                          id = "9Q0Hwb-GoiX-N5jf-fglG-rIhW-tjPB-nYRQeW"
                          device = "/dev/sdd1"    # Hint only
  
                          status = ["ALLOCATABLE"]
                          flags = []
                          dev_size = 41938944     # 19.998 Gigabytes
                          pe_start = 2048
                          pe_count = 5119 # 19.9961 Gigabytes
                  }
          }
  
          logical_volumes {
  
                  data {
                          id = "p0aJ5O-LRnB-p9KA-PKWS-1sZf-P3nu-ESrnQR"
                          status = ["READ", "WRITE", "VISIBLE"]
                          flags = []
                          creation_time = 1758182492      # 2025-09-18 04:01:32 -0400
                          creation_host = "localhost.localdomain"
                          segment_count = 1
  
                          segment1 {
                                  start_extent = 0
                                  extent_count = 2560     # 10 Gigabytes
  
                                  type = "striped"
                                  stripe_count = 1        # linear
  
                                  stripes = [
                                          "pv0", 0
                                  ]
                          }
                  }
          }
  
  }
  ```
### 메타데이터 수정 후 적용
### vgimportclone
```
  # vgimportclone /dev/sdb1
```
- vgimportclone 명령어로 /dev/sdb1 의