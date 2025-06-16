# LVM 테스트 예시

## vgimportclone 명령어 사용 예제

PV UUID가 겹치는 볼륨이 존재하는 상황
```sh
root@vm20:~# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
vda                       253:0    0  25G  0 disk 
├─vda1                    253:1    0   1M  0 part 
├─vda2                    253:2    0   2G  0 part /boot
└─vda3                    253:3    0  23G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0  23G  0 lvm  /
vdd                       253:48   0  25G  0 disk 
├─vdd1                    253:49   0   1M  0 part 
├─vdd2                    253:50   0   2G  0 part 
└─vdd3                    253:51   0  23G  0 part 
root@vm20:~# pvdisplay
  WARNING: Not using device /dev/vdd3 for PV c2fwBe-c0T0-yoeE-E9re-LFTY-wkv4-n31d57.
  WARNING: PV c2fwBe-c0T0-yoeE-E9re-LFTY-wkv4-n31d57 prefers device /dev/vda3 because device is used by LV.
  --- Physical volume ---
  PV Name               /dev/vda3
  VG Name               ubuntu-vg
  PV Size               <23.00 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              5887
  Free PE               0
  Allocated PE          5887
  PV UUID               c2fwBe-c0T0-yoeE-E9re-LFTY-wkv4-n31d57
```

`vgimportclone` 명령어 사용해서 VG 이름 변경 시도
이 명령어는 PV UUID가 겹치는 경우도 대비하여 만들어진 명령어이다.
> https://www.systutorials.com/docs/linux/man/8-vgimportclone/
```sh
root@vm20:~# vgimportclone --basevgname hello /dev/vdd
  Device /dev/vdd is excluded: device is partitioned.
root@vm20:~# vgimportclone --basevgname hello /dev/vdd3
```

명령어 이후 정상적으로 PV가 인식되었다.
하지만 여전히 새로 Attach 된 볼륨에 대한 논리 볼륨은 /dev 경로에 생성되지 않은 상황
```sh
root@vm20:~# pvdisplay
  --- Physical volume ---
  PV Name               /dev/vdd3
  VG Name               hello
  PV Size               <23.00 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              5887
  Free PE               0
  Allocated PE          5887
  PV UUID               CQclep-rp8J-2XRo-sAVe-uahl-2rDn-WddUR1
   
  --- Physical volume ---
  PV Name               /dev/vda3
  VG Name               ubuntu-vg
  PV Size               <23.00 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              5887
  Free PE               0
  Allocated PE          5887
  PV UUID               c2fwBe-c0T0-yoeE-E9re-LFTY-wkv4-n31d57
   
root@vm20:~# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
vda                       253:0    0  25G  0 disk 
├─vda1                    253:1    0   1M  0 part 
├─vda2                    253:2    0   2G  0 part /boot
└─vda3                    253:3    0  23G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0  23G  0 lvm  /
vdd                       253:48   0  25G  0 disk 
├─vdd1                    253:49   0   1M  0 part 
├─vdd2                    253:50   0   2G  0 part 
└─vdd3                    253:51   0  23G  0 part 
root@vm20:~# ls -l /dev/hello
ls: cannot access '/dev/hello': No such file or directory
```

`partprobe` 명령어 이후 잘 인식된 모습
```sh
root@vm20:~# partprobe
Warning: Error fsyncing/closing /dev/mapper/hello2-ubuntu--lv: Input/output error
Warning: Error fsyncing/closing /dev/mapper/world-ubuntu--lv: Input/output error
root@vm20:~# ls -l /dev/hello
total 0
lrwxrwxrwx 1 root root 7 Jun  2 07:00 ubuntu-lv -> ../dm-3
```

---

## libguestfs 사용 예제

- PV UUID 안 겹친 경우

#### 변경 전

```sh
root@vm20:~# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
vda                       253:0    0  25G  0 disk 
├─vda1                    253:1    0   1M  0 part 
├─vda2                    253:2    0   2G  0 part /boot
└─vda3                    253:3    0  23G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0  23G  0 lvm  /
vdb                       253:16   0  25G  0 disk 
├─vdb1                    253:17   0   1M  0 part 
├─vdb2                    253:18   0   2G  0 part 
└─vdb3                    253:19   0  23G  0 part 
root@vm20:~# 
root@vm20:~# 
root@vm20:~# 
root@vm20:~# pvdisplay
  WARNING: VG name ubuntu-vg is used by VGs 2tvDvf-f432-EYBQ-cX4R-fcTU-HaST-43Ozp1 and XFwRL4-Kj0q-7fRy-GkUR-itbV-eEUu-qndmUg.
  Fix duplicate VG names with vgrename uuid, a device filter, or system IDs.
  --- Physical volume ---
  PV Name               /dev/vdb3
  VG Name               ubuntu-vg
  PV Size               <23.00 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              5887
  Free PE               0
  Allocated PE          5887
  PV UUID               A1P6EK-hl11-HInW-fACn-70lP-zz8m-UUYNcM
   
  --- Physical volume ---
  PV Name               /dev/vda3
  VG Name               ubuntu-vg
  PV Size               <23.00 GiB / not usable 0   
  Allocatable           yes (but full)
  PE Size               4.00 MiB
  Total PE              5887
  Free PE               0
  Allocated PE          5887
  PV UUID               c2fwBe-c0T0-yoeE-E9re-LFTY-wkv4-n31d57
   
root@vm20:~# vgdisplay
  WARNING: VG name ubuntu-vg is used by VGs 2tvDvf-f432-EYBQ-cX4R-fcTU-HaST-43Ozp1 and XFwRL4-Kj0q-7fRy-GkUR-itbV-eEUu-qndmUg.
  Fix duplicate VG names with vgrename uuid, a device filter, or system IDs.
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               0
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <23.00 GiB
  PE Size               4.00 MiB
  Total PE              5887
  Alloc PE / Size       5887 / <23.00 GiB
  Free  PE / Size       0 / 0   
  VG UUID               2tvDvf-f432-EYBQ-cX4R-fcTU-HaST-43Ozp1
   
  --- Volume group ---
  VG Name               ubuntu-vg
  System ID             
  Format                lvm2
  Metadata Areas        1
  Metadata Sequence No  2
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                1
  Act PV                1
  VG Size               <23.00 GiB
  PE Size               4.00 MiB
  Total PE              5887
  Alloc PE / Size       5887 / <23.00 GiB
  Free  PE / Size       0 / 0   
  VG UUID               XFwRL4-Kj0q-7fRy-GkUR-itbV-eEUu-qndmUg
   
root@vm20:~# lvdisplay
  WARNING: VG name ubuntu-vg is used by VGs 2tvDvf-f432-EYBQ-cX4R-fcTU-HaST-43Ozp1 and XFwRL4-Kj0q-7fRy-GkUR-itbV-eEUu-qndmUg.
  Fix duplicate VG names with vgrename uuid, a device filter, or system IDs.
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                6ljIlX-jfFI-toZc-CAQ7-SZqz-WWv1-Wv0e3Z
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2025-05-23 05:16:58 +0000
  LV Status              NOT available
  LV Size                <23.00 GiB
  Current LE             5887
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
   
  --- Logical volume ---
  LV Path                /dev/ubuntu-vg/ubuntu-lv
  LV Name                ubuntu-lv
  VG Name                ubuntu-vg
  LV UUID                AmBjXn-YDQD-bj4N-wloR-wpqo-588L-CWaVT8
  LV Write Access        read/write
  LV Creation host, time ubuntu-server, 2025-05-23 05:20:44 +0000
  LV Status              available
  # open                 1
  LV Size                <23.00 GiB
  Current LE             5887
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0
```

#### 변경 작업

```sh
root@vm20:~# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
vda                       253:0    0  25G  0 disk 
├─vda1                    253:1    0   1M  0 part 
├─vda2                    253:2    0   2G  0 part /boot
└─vda3                    253:3    0  23G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0  23G  0 lvm  /
vdb                       253:16   0  25G  0 disk 
├─vdb1                    253:17   0   1M  0 part 
├─vdb2                    253:18   0   2G  0 part 
└─vdb3                    253:19   0  23G  0 part 
root@vm20:~# guestfish

Welcome to guestfish, the guest filesystem shell for
editing virtual machine filesystems and disk images.

Type: ‘help’ for help on commands
      ‘man’ to read the manual
      ‘quit’ to quit the shell

><fs> add /dev/vdb
><fs> run
 100% ⟦▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒⟧ 00:00
><fs> vgrename ubuntu-vg hello
><fs> quit

root@vm20:~# lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
vda                       253:0    0  25G  0 disk 
├─vda1                    253:1    0   1M  0 part 
├─vda2                    253:2    0   2G  0 part /boot
└─vda3                    253:3    0  23G  0 part 
  └─ubuntu--vg-ubuntu--lv 252:0    0  23G  0 lvm  /
vdb                       253:16   0  25G  0 disk 
├─vdb1                    253:17   0   1M  0 part 
├─vdb2                    253:18   0   2G  0 part 
└─vdb3                    253:19   0  23G  0 part 
  └─hello-ubuntu--lv      252:1    0  23G  0 lvm  
```