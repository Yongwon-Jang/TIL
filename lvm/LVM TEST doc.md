# LVM Test

## 📋 목차
- [1. filesystem UUID가 겹치는 경우](#1-filesystem-uuid가-겹치는-경우)
- [2. PV UUID가 겹치는 경우](#2-pv-uuid가-겹치는-경우)
- [3. VG Name이 겹치는 경우](#3-vg-name이-겹치는-경우)
- [4. 배포판이 다른 VM에 디스크를 붙였을 때 경우](#4-배포판이-다른-vm에-디스크를-붙였을-때-경우)

---

## 1. filesystem UUID가 겹치는 경우
- **상황**: LVM이 아닌 일반 파티션에서 filesystem UUID 충돌 발생
- **설명**: blkid를 했을 때 같은 filesystem UUID를 가진 디스크는 보이지만 마운트가 불가능

**예시**
```bash
# blkid
/dev/sdb: UUID="3b3ab96f-c3f9-4466-b98d-9e6ce5d79b97" BLOCK_SIZE="512" TYPE="xfs"
/dev/sda1: UUID="89cb8434-b494-46be-aaa9-457ab1646cb9" BLOCK_SIZE="512" TYPE="xfs" PARTUUID="1a7a3be2-01"
/dev/sda2: UUID="NYBplr-JD53-GUdn-ZiBf-eb2I-QtgX-H8cew4" TYPE="LVM2_member" PARTUUID="1a7a3be2-02"
/dev/sr0: BLOCK_SIZE="2048" UUID="2024-05-27-14-12-55-00" LABEL="Rocky-8-10-x86_64-dvd" TYPE="iso9660" PTUUID="add8671b" PTTYPE="dos"
/dev/sdc: UUID="3b3ab96f-c3f9-4466-b98d-9e6ce5d79b97" BLOCK_SIZE="512" TYPE="xfs"
```

**문제점**:
- `/dev/sdc`는 mount 불가 → LVM이 아니라도 disk filesystem UUID가 겹치면 사용할 수 없다.

```bash
# mount /dev/sdc yw2
mount: /mnt/yw2: wrong fs type, bad option, bad superblock on /dev/sdc, missing codepage or helper program, or other error.
```
- 같은 filesystem uuid 를 가진 `/dev/sdb`가 mount 되어있는 상태에서는 `/dev/sdc`를 마운트 하려고 하면 위와 같은 에러가 발생한다. 

**해결방법**:  
- **ext4 파일시스템인 경우**: UUID가 같아도 마운트가 가능하다. ext4는 UUID 충돌에 대해 더 관대하게 처리한다.
  
  **예시**:
  ```bash
  # lsblk -f
  NAME        FSTYPE      LABEL                 UUID                                   MOUNTPOINT
  sda
  ├─sda1      xfs                               89cb8434-b494-46be-aaa9-457ab1646cb9   /boot
  └─sda2      LVM2_member                       NYBplr-JD53-GUdn-ZiBf-eb2I-QtgX-H8cew4
    ├─rl-root xfs                               b5d198da-0388-49a3-84ac-daa4db42aed3   /
    ├─rl-swap swap                              add5d910-2968-48f7-8962-da71a8e1f052   [SWAP]
    └─rl-home xfs                               d756974f-978e-4195-ac65-cced0692737b   /home
  sdb         ext4                              0547ed6e-2a23-4e03-93bf-b390910991d5
  sdc         ext4                              0547ed6e-2a23-4e03-93bf-b390910991d5
  
  [root@localhost ~]# mount /dev/sdc /mnt/sdc
  [root@localhost ~]# mount /dev/sdb /mnt/sdb
  -> 마운트 하는데 문제 없음
  ```
  - 위 예시에서 `/dev/sdb`와 `/dev/sdc`가 동일한 UUID(`0547ed6e-2a23-4e03-93bf-b390910991d5`)를 가지고 있지만, ext4 파일시스템에서는 두 디스크 모두 정상적으로 마운트가 가능하다.
- **xfs 파일시스템인 경우**:
  - `xfs_admin -U generate /dev/sdc` 로 파일시스템 uuid 를 변경하면 마운트가 가능하다.
  - 이후 데이터를 쓰고, `xfs_admin -U <원래_UUID> /dev/sdc`로 원복한다.
  - **참고**: 처음에 `xfs_admin -U generate /dev/sdc` 명령을 하면 다음과 같은 에러가 발생할 수 있다:
    ```bash
    xfs_admin -U generate /dev/sdc
    ERROR: The filesystem has valuable metadata changes in a log which needs to
    be replayed.  Mount the filesystem to replay the log, and unmount it before
    re-running xfs_admin.  If you are unable to mount the filesystem, then use
    the xfs_repair -L option to destroy the log and attempt a repair.
    Note that destroying the log may cause corruption -- please attempt a mount
    of the filesystem before doing this.
    ```
  - 이 경우 한번 마운트를 해주고 나면 파일시스템 로그가 복구되어서 이후에는 uuid 변경이 가능하다:
    ```bash
    mount /dev/sdc /mnt/tmp
    umount /mnt/tmp
    ```

## 2. PV UUID가 겹치는 경우
- **상황**: Physical Volume의 UUID가 중복되어 충돌 발생
- **설명**: `/dev/sdb1`과 `/dev/sdc1`의 PV UUID가 같은 상황인데, pvdisplay 하면 sdb1만 보임

**예시**
```bash
 # pvdisplay
  WARNING: Not using device /dev/sdc1 for PV DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy.
  WARNING: Not using device /dev/sdd1 for PV DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy.
  WARNING: PV DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy prefers device /dev/sdb1 because device name matches previous.
  WARNING: PV DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy prefers device /dev/sdb1 because device name matches previous.
  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               yw22
  PV Size               <20.00 GiB / not usable 2.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              5119
  Free PE               2559
  Allocated PE          2560
  PV UUID               DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy
  
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
```
- 같은 PV uuid, VG uuid, VG name 을 가진 디스크가 3개 존재
  - PV uuid : DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy
  - VG uuid : oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt
  - VG name : yw22

**문제점**:
- pvdisplay에서는 경고와 함께 1개의 디스크만 보임
- 같은 PV UUID, VG UUID, VG Name을 가진 디스크가 여러 개 존재하여 LVM이 구분하지 못함
- LVM이 디바이스 이름이 일치하는 디스크를 우선적으로 선택하여 다른 디스크는 무시됨
- 실제로는 3개의 디스크가 있지만 LVM에서는 1개만 인식하여 나머지 디스크 활용 불가

**해결방법**:
1. vgimportclone 명령어로 VG name 을 변경
```bash
[root@localhost ~]# vgimportclone --basevgname yw1 /dev/sdb1
[root@localhost ~]# vgimportclone --basevgname yw2 /dev/sdc1
[root@localhost ~]# vgimportclone --basevgname yw3 /dev/sdd1

[root@localhost ~]# pvdisplay
  --- Physical volume ---
  PV Name               /dev/sdd1
  VG Name               yw3
  PV Size               <20.00 GiB / not usable 2.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              5119
  Free PE               2559
  Allocated PE          2560
  PV UUID               WY0V0B-d3MU-T2M3-ohIQ-duWr-eMG9-XWTI5J

  --- Physical volume ---
  PV Name               /dev/sdc1
  VG Name               yw2
  PV Size               <20.00 GiB / not usable 2.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              5119
  Free PE               2559
  Allocated PE          2560
  PV UUID               w3qLJV-SeYW-KHVc-hKVh-qc0h-UwpR-Jtm4Y5

  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               yw1
  PV Size               <20.00 GiB / not usable 2.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              5119
  Free PE               2559
  Allocated PE          2560
  PV UUID               vIcevk-xkNK-ip07-VCQa-12K6-xufJ-9jhtsU

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


[root@localhost ~]# vgdisplay
  --- Volume group ---
  VG Name               yw3
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  5
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
  VG UUID               P1OGYm-r6eQ-tOw3-v8eS-IX46-H30O-GNfZV8

  --- Volume group ---
  VG Name               yw2
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  5
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
  VG UUID               tqt4vK-XVb0-64u2-NOjz-OxBM-iU52-aFz1i8

  --- Volume group ---
  VG Name               yw1
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  5
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
  VG UUID               n31Jbd-JIKj-laaT-z8eq-EjT1-Vc11-G50dQl

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
  
[root@localhost ~]# partprobe
  Warning: Unable to open /dev/sr0 read-write (Read-only file system).  /dev/sr0 has been opened read-only.
[root@localhost ~]# ls /dev/mapper/
  control  rl-home  rl-root  rl-swap  yw1-data  yw2-data  yw3-data
```
- `vgimportclone` 명령어로 VG name을 변경하면 PV uuid, VG uuid 도 자동으로 변경된다.
- 이후 `partprobe` 명령어를 해주면 `/dev/mapper` 경로에 `yw1-data  yw2-data  yw3-data` 가 보이면서 마운트가 가능해진다.
2. 볼륨 하나씩 원복(pv uuid, vg name, vg uuid) 하면서 detach  
```bash
[root@localhost ~]# vgchange -an yw1
  0 logical volume(s) in volume group "yw1" now active
[root@localhost ~]# pvcreate --uuid DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy --restorefile /etc/lvm/backup/yw22 -ff /dev/sdb1
  WARNING: Couldn't find device with uuid DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy.
Really INITIALIZE physical volume "/dev/sdb1" of volume group "yw1" [y/n]? y
  WARNING: Forcing physical volume creation on /dev/sdb1 of volume group "yw1"
  Physical volume "/dev/sdb1" successfully created.


[root@localhost ~]# vgcfgrestore -f /etc/lvm/backup/yw22 yw22
  Restored volume group yw22.

[root@localhost ~]# pvs -o +vg_uuid,uuid
  PV         VG   Fmt  Attr PSize   PFree   VG UUID                                PV UUID
  /dev/sda2  rl   lvm2 a--  <99.00g      0  hDAFyr-3rLG-eBOA-0BZ6-Yzxq-T9GH-Wce9Ia NYBplr-JD53-GUdn-ZiBf-eb2I-QtgX-H8cew4
  /dev/sdb1  yw22 lvm2 a--  <20.00g <10.00g oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy
  /dev/sdc1  yw2  lvm2 a--  <20.00g <10.00g tqt4vK-XVb0-64u2-NOjz-OxBM-iU52-aFz1i8 w3qLJV-SeYW-KHVc-hKVh-qc0h-UwpR-Jtm4Y5
  /dev/sdd1  yw3  lvm2 a--  <20.00g <10.00g P1OGYm-r6eQ-tOw3-v8eS-IX46-H30O-GNfZV8 WY0V0B-d3MU-T2M3-ohIQ-duWr-eMG9-XWTI5J

```
- yw1을 원복 완료 (PV uuid, VG name, VG uuid) 이후 detach
- 그 다음 yw2, yw3 순서대로 진행

**⚠️ 주의사항**:
- PV UUID 충돌 해결 후에도 각 디스크의 **filesystem UUID**가 겹칠 수 있다.
- 만약 filesystem UUID가 겹치는 경우, 1번 섹션에서 설명한 방법을 적용해야 한다:
  - **ext4 파일시스템**: UUID가 같아도 마운트 가능
  - **xfs 파일시스템**: `xfs_admin -U generate /dev/xxx` 명령어로 filesystem UUID 변경 필요
  - xfs에서 에러 발생 시: 마운트 → 언마운트 후 UUID 변경

## 3. VG Name이 겹치는 경우
- **상황**: Volume Group 이름이 중복되어 충돌 발생
- **설명**: 같은 VG Name을 가진 여러 VG가 존재하여 충돌 발생
  - `yw22` VG가 두 개 존재 (서로 다른 PV UUID, VG UUID 가짐)
  - LVM이 어떤 VG를 사용할지 구분하지 못함
  - `vgrename uuid` 명령어로 해결 필요
- **참고**: PV UUID는 겹치지 않음

**예시**
```bash
[root@localhost ~]# pvdisplay
  WARNING: VG name yw22 is used by VGs oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt and Z2HFO0-J0M4-jcoJ-wFMd-4gyB-QN6D-KsayyX.
  Fix duplicate VG names with vgrename uuid, a device filter, or system IDs.
  --- Physical volume ---
  PV Name               /dev/sdc1
  VG Name               yw22
  PV Size               <20.00 GiB / not usable 2.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              5119
  Free PE               2559
  Allocated PE          2560
  PV UUID               DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy

  --- Physical volume ---
  PV Name               /dev/sdb1
  VG Name               yw22
  PV Size               <20.00 GiB / not usable 2.00 MiB
  Allocatable           yes
  PE Size               4.00 MiB
  Total PE              5119
  Free PE               2559
  Allocated PE          2560
  PV UUID               3ZQwmc-cTqz-tyGX-3Imy-x4hO-f5PX-ouYSaM


  --- Physical volume ---
  PV Name               /dev/sda2
  VG Name               rl                      # 정상적인 VG
  PV Size               <99.00 GiB / not usable 3.00 MiB
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              25343
  Free PE               0
  Allocated PE          25343
  PV UUID               NYBplr-JD53-GUdn-ZiBf-eb2I-QtgX-H8cew4
```

```bash
[root@localhost ~]vgdisplay
  WARNING: VG name yw22 is used by VGs oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt and Z2HFO0-J0M4-jcoJ-wFMd-4gyB-QN6D-KsayyX.
  Fix duplicate VG names with vgrename uuid, a device filter, or system IDs.
  --- Volume group ---
  VG Name               yw22
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  5
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
  VG UUID               oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt

  --- Volume group ---
  VG Name               yw22
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  7
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
  VG UUID               Z2HFO0-J0M4-jcoJ-wFMd-4gyB-QN6D-KsayyX


  --- Volume group ---
  VG Name               rl                      # 정상적인 VG
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
```

```bash
# 디바이스 접근 확인
[root@localhost ~]# ls -l /dev/yw22/
total 0
lrwxrwxrwx. 1 root root 7 Sep 30 02:05 data -> ../dm-2

[root@localhost ~]# ls -l /dev/mapper/yw22-data
lrwxrwxrwx. 1 root root 7 Sep 30 02:05 /dev/mapper/yw22-data -> ../dm-2
```

**중요한 점**: VG Name이 겹치는 두 VG가 pvdisplay나 vgdisplay를 하면 보이지만, `/dev/yw22/`에는 하나밖에 나오지 않는다.

**문제점**: 
- VG Name이 겹치면서 LVM이 어떤 VG를 사용할지 구분하지 못함
- `vgrename uuid` 명령어로 VG 이름 변경 필요
- 동일한 VG 이름으로 인한 시스템 혼란 야기
- 두 개의 서로 다른 VG가 같은 이름을 사용하여 충돌 발생

**해결방법**:
- VG name 변경
```bash
# vgrename 명령어로 중복된 VG name 변경
[root@localhost ~]# vgrename oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt yw1
  WARNING: VG name yw22 is used by VGs oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt and Z2HFO0-J0M4-jcoJ-wFMd-4gyB-QN6D-KsayyX.
  Fix duplicate VG names with vgrename uuid, a device filter, or system IDs.
  Processing VG yw22 because of matching UUID oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt
  Volume group "oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt" successfully renamed to "yw1"
[root@localhost ~]# vgrename Z2HFO0-J0M4-jcoJ-wFMd-4gyB-QN6D-KsayyX yw2
  Processing VG yw22 because of matching UUID Z2HFO0-J0M4-jcoJ-wFMd-4gyB-QN6D-KsayyX
  Volume group "Z2HFO0-J0M4-jcoJ-wFMd-4gyB-QN6D-KsayyX" successfully renamed to "yw2"
  
[root@localhost ~]# vgdisplay
  --- Volume group ---
  VG Name               yw1
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  6
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
  VG UUID               oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt

  --- Volume group ---
  VG Name               yw2
  System ID
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  8
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
  VG UUID               Z2HFO0-J0M4-jcoJ-wFMd-4gyB-QN6D-KsayyX
```

```bash
# partprobe 명령어로 파티션 테이블 재스캔
[root@localhost ~]# partprobe

# 해결 후 두 VG 모두 정상적으로 접근 가능
[root@localhost ~]# ls -l /dev/yw1/
total 0
lrwxrwxrwx. 1 root root 7 Sep 30 01:56 data -> ../dm-4

[root@localhost ~]# ls -l /dev/yw2/
total 0
lrwxrwxrwx. 1 root root 7 Sep 30 01:11 data -> ../dm-2
```
- VG name 하나씩 원복 하면서 detach
```bash
[root@localhost ~]# vgchange -an yw1
  0 logical volume(s) in volume group "yw1" now active

[root@localhost ~]# pvcreate --uuid RDpQmu-ig7D-1qJP-LN8A-CUr4-StYU-Ns3c1c --restorefile /etc/lvm/backup/yw22 -ff /dev/sdc1
  WARNING: Couldn't find device with uuid RDpQmu-ig7D-1qJP-LN8A-CUr4-StYU-Ns3c1c.
  Really INITIALIZE physical volume "/dev/sdc1" of volume group "yw1" [y/n]? y
  WARNING: Forcing physical volume creation on /dev/sdc1 of volume group "yw1"
  Physical volume "/dev/sdc1" successfully created.

[root@localhost ~]# vgcfgrestore -f /etc/lvm/backup/yw22 yw22
  Restored volume group yw22.

[root@localhost ~]# pvs -o +vg_uuid,uuid
  PV         VG   Fmt  Attr PSize   PFree   VG UUID                                PV UUID
  /dev/sda2  rl   lvm2 a--  <99.00g      0  hDAFyr-3rLG-eBOA-0BZ6-Yzxq-T9GH-Wce9Ia NYBplr-JD53-GUdn-ZiBf-eb2I-QtgX-H8cew4
  /dev/sdc1  yw22 lvm2 a--  <20.00g <10.00g oSubrd-P0V0-DdmQ-rFaJ-Aezm-9HHb-VbXMKt RDpQmu-ig7D-1qJP-LN8A-CUr4-StYU-Ns3c1c
  /dev/sdb1  yw2  lvm2 a--  <20.00g <10.00g RDpQmu-ig7D-1qJP-LN8A-CUr4-StYU-Ns3c1c eNNPRE-QcAR-D8pI-4bta-c8Nk-tTU1-ARBjAz
```
- yw1 원복 완료 (VG name) 이후 detach
- 그 다음 yw2 순서대로 진행
```bash
[root@localhost ~]# vgrename yw2 yw22
  device-mapper: rename ioctl on yw2-data  failed: Device or resource busy
  Failed to rename yw2-data (253:4) to yw22-data
  Failed to reactivate yw22/data.
  Renaming "/dev/yw2" to "/dev/yw22" failed
  Releasing activation in critical section.
  libdevmapper exiting with 1 device(s) still suspended.
  
detach 이후에도 yw22 경로가 남아있어서 실패한다면 삭제 후 rename 해준다.
[root@localhost ~]# rm -rf /dev/yw2/data
[root@localhost ~]# rm -rf /dev/mapper/yw22-data
```


## 4. 배포판이 다른 VM에 디스크를 붙였을 때 경우
- **상황**: 서로 다른 배포판 간 디스크 연결 시 발생하는 문제
- **예시**: Ubuntu → Rocky Linux

**해결방법**: