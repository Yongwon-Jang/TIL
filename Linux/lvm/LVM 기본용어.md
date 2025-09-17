# LVM 기본 용어

* **PV (Physical Volume)**
  실제 물리 디스크(또는 파티션, 가상디스크 `/dev/sdb`, `/dev/vdb1` 등)를 LVM이 사용하도록 초기화한 것. `pvcreate /dev/sdb` 로 만듭니다.

* **VG (Volume Group)**
  하나 이상의 PV를 묶어 만든 저장소 풀(pool). 예: 여러 디스크를 합쳐 `vg_data`라는 풀을 만들면, 그 풀에서 논리볼륨(LV)을 생성합니다. `vgcreate vg_data /dev/sdb /dev/sdc`

* **LV (Logical Volume)**
  VG에서 할당한 논리적 볼륨(파티션처럼 사용). 파일시스템을 만들고 마운트해서 사용합니다. 예: `/dev/vg_data/lv_home`. `lvcreate -L 100G -n lv_home vg_data`

* **PE (Physical Extent) / LE (Logical Extent)**
  PV는 일정 크기의 블록(PE) 단위로 나뉘고, LV는 LE(논리 익스텐트)를 PE에 대응시켜 할당됩니다. PE 크기는 VG 생성 시 설정(기본값 보통 4MiB). PE 크기는 큰 볼륨을 많이 만들 계획이면 크게 잡는 것이 메타데이터 비용을 줄일 수 있습니다.

* **Snapshot (스냅샷)**
  특정 시점의 LV 상태를 잡아두는 기능. 전통 스냅샷은 COW(복사-쓰기) 방식이라 오버헤드가 있고, 쓰기량이 많으면 성능 저하 또는 스냅샷 공간 부족 문제가 생깁니다. LVM thin snapshot은 더 가볍고 추천됩니다.

* **Thin provisioning (씬 프로비저닝)**
  실제 물리공간을 나중에 채우는(overcommit) 방식. 가상 크기를 크게 주고 실제 사용량만큼만 물리공간을 소모합니다(저장공간 효율 ↑). 단, 오버커밋 주의.

* **device-mapper**
  LVM은 kernel의 device-mapper를 이용해 `/dev/mapper/<vg>-<lv>` 와 `/dev/<vg>/<lv>` 장치를 제공.

# 개념적 흐름 (한 줄 요약)

물리 디스크 → **PV** 초기화 → PV들을 묶어 **VG** 생성 → VG에서 **LV**를 할당 → LV 위에 파일시스템 생성 → 마운트하여 사용.

# 주요 용도 / 언제 쓰나

* 디스크 확장/축소(유연한 볼륨 관리)
* 운영 중(가능한 경우) 파일시스템 확장(online resize)
* 스냅샷을 이용한 일관성 있는 백업(특히 DB/파일시스템)
* 디스크 교체/마이그레이션 (pvmove)
* thin provisioning으로 저장공간 효율화
* 디스크 레벨 스트라이핑/미러링(LV 레벨) / 캐시(SSD 캐시) 등 고급 구성

# 실무에서 자주 쓰는 명령어 (예시 포함)

> 기본 조회

```bash
lsblk                 # 블록 디바이스 구조 확인
pvs                   # PV 목록
vgs                   # VG 목록
lvs                   # LV 목록
pvdisplay / vgdisplay / lvdisplay
```

> PV / VG / LV 생성

```bash
pvcreate /dev/sdb
vgcreate vg_data /dev/sdb /dev/sdc
lvcreate -n lv_home -L 100G vg_data
mkfs.ext4 /dev/vg_data/lv_home
mount /dev/vg_data/lv_home /home
```

> LV 확장 (파일시스템도 같이 확장)

```bash
# LV만 확장
lvextend -L +50G /dev/vg_data/lv_home

# LV와 파일시스템을 함께 확장 (신버전 LVM에서는 -r 또는 --resizefs 사용 가능)
lvextend -r -L +50G /dev/vg_data/lv_home

# 또는 수동으로 파일시스템 확장 (ext4)
resize2fs /dev/vg_data/lv_home

# xfs (마운트 포인트로 확장)
xfs_growfs /home
```

> LV 축소 (주의!)

* 축소는 위험(데이터 손실 가능). 먼저 파일시스템을 축소한 뒤 LV를 줄여야 함.
* XFS는 축소를 지원하지 않으므로 **언마운트 후 다른 방식** 필요.

```bash
# 예: ext4 마운트 해제 -> resize2fs -> lvreduce
umount /mnt/myvol
resize2fs /dev/vg_data/lv_data 50G
lvreduce -L 50G /dev/vg_data/lv_data
mount /dev/vg_data/lv_data /mnt/myvol
```

> 스냅샷 생성(전통 방식)

```bash
# 스냅샷용 공간(여기선 5G)을 잡고 스냅샷 생성
lvcreate -L 5G -s -n lv_home_snap /dev/vg_data/lv_home

# 스냅샷 마운트(읽기 전용으로 백업)
mount -o ro /dev/vg_data/lv_home_snap /mnt/backup

# 작업 끝나면 제거
umount /mnt/backup
lvremove /dev/vg_data/lv_home_snap
```

**권장 패턴(일관성 있는 백업):**

1. `fsfreeze -f /mountpoint` (가능하면)
2. 스냅샷 생성
3. `fsfreeze -u /mountpoint`
4. 스냅샷에서 백업 진행 → lvremove

> Thin pool 방식 (씬 볼륨 생성)

```bash
# 씬 풀(메타+데이터 합성) 생성 (예시)
lvcreate -L 50G --type thin-pool -n thinpool vg_data

# 씬 볼륨(가상 크기 200G) 생성
lvcreate -V 200G --thin -n thinvol1 vg_data/thinpool
```

> 디스크 교체 / 데이터 이동 (pvmove)

```bash
pvcreate /dev/sdc
vgextend vg_data /dev/sdc
pvmove /dev/sdb      # /dev/sdb의 데이터 전체를 다른 PV로 이동
vgreduce vg_data /dev/sdb
pvremove /dev/sdb
```

> 메타데이터(백업/복구)

```bash
vgcfgbackup vg_data    # /etc/lvm/backup/vg_data 에 저장
vgcfgrestore -f /etc/lvm/backup/vg_data vg_data
```

> VG 활성화 / 비활성화

```bash
vgchange -ay vg_data   # 활성화 (auto activate)
vgchange -an vg_data   # 비활성화
```

# 주의사항 & 실무 팁

* **스냅샷 용량 부족 주의**: 전통 COW 스냅샷은 원본에 쓰기가 많이 발생하면 스냅샷이 빨리 찹니다(스냅샷이 full 되면 에러). 적절한 크기 확보 또는 thin snapshots 사용 권장.
* **XFS는 축소 불가**: XFS 파일시스템은 줄일 수 없습니다. 늘리기는 가능(xfs\_growfs). 따라서 LV를 축소해야 한다면 ext4 같은 FS를 쓰거나 재파티션/백업-재포맷 방식 필요.
* **파일시스템 안전성 확보**: 온라인 스냅샷/백업 시 DB 등은 애플리케이션 레벨로 일관성(예: DB flush/transaction flush, 또는 LVM 스냅샷 전 `fsfreeze`) 확보 필요.
* **PE 크기 고려**: PE 크기는 VG 생성 시 정합니다(`vgcreate --physicalextentsize 64M`). 많은 큰 LV를 만들 계획이면 PE를 크게 잡아 메타데이터 절감. 일반적 사용은 기본값(4MiB)으로 충분.
* **메타데이터 백업**: 중요한 VG를 다룰 때는 `vgcfgbackup`으로 메타데이터를 정기 백업하세요.
* **암호화**: 일반적 권장 방식은 `LUKS`로 PV(물리 디바이스)를 암호화한 뒤 LVM을 그 위에 구성하는 방법(즉, LUKS -> LVM). 괜찮은 대안으로 LVM으로 논리볼륨을 만든 뒤 각각 LUKS로 암호화(LV -> LUKS) 할 수도 있음. 보안/운영 편의성에 따라 선택.
* **부트 루트 볼륨에 LVM 사용**: 루트를 LVM으로 구성할 수 있으나 initramfs에서 LVM을 활성화하도록 설정해야 부팅 가능. 배포판별로 기본 지원 여부 확인.

# 고급 기능(간단 소개)

* **lvmcache**: SSD를 캐시로 사용해 HDD LV의 성능을 올리는 기능.
* **LV 미러/RAID**: `lvconvert --type mirror` 또는 LVM의 RAID 기능으로 데이터 복제 가능.
* **thin snapshots**: 전통 스냅샷보다 효율적이고 관리가 쉬움(권장).
* **lvconvert --type raid1 / raid5**: LVM 자체적으로 RAID 타입 설정 가능(요구사항/버전 확인).

# 간단 요약(체크리스트)

* 디스크 유연하게 관리 → LVM 사용.
* **확장**은 비교적 안전(online 가능), **축소**는 위험(특히 XFS).
* 백업 전 **스냅샷 + fsfreeze** 패턴 권장.
* thin provisioning은 공간 효율 ↑, 오버커밋 위험 존재.
* 항상 `pvs`, `vgs`, `lvs`로 상태 확인하고 `vgcfgbackup`으로 메타데이터 백업.

---

원하시면 다음 중 하나를 바로 보여드릴게요 (원하시는 걸 골라 주세요) —

1. 실제 예시로 `/dev/sdb` 1개로 PV/VG/LV 만들기 → 파일시스템 생성 → 마운트까지의 명령 모음.
2. 기존 LV를 온라인으로 안전하게 **확장하는** 단계별 예시 (ext4 / xfs 각각).
3. **스냅샷을 이용한 백업 절차**(DB/파일서버용 시나리오).
4. thin-provisioning 적용 예시와 주의사항.

원하시는 번호 말해 주세요 — 바로 예시 명령과 절차를 보여드릴게요.
