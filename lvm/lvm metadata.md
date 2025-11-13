좋은 질문이에요. 🔍
LVM의 **Physical Volume(PV)** 은 단순한 디스크 파티션이 아니라, LVM이 인식할 수 있도록 **특별한 메타데이터 영역**을 가지고 있습니다. 이 메타데이터는 LVM이 PV를 인식하고, 어떤 VG(Volume Group)와 LV(Logical Volume)에 속하는지 판단하는 데 핵심적인 역할을 합니다.

---

## 🧩 1. PV 메타데이터의 위치

PV 메타데이터는 디스크의 **시작 부분(보통 첫 번째 몇 MB 내)** 에 저장됩니다.

예시 구조:

```
| Boot sector / Partition table | <-- (MB 0 ~)
| LVM PV Label (sector 1~2)     |
| LVM Metadata Area (few MB)    |
| Data Area (PEs start here)    |
```

* **Label 영역 (512B ~ 4KB)**

    * PV의 시그니처(`LABELONE`)가 있음
    * PV의 UUID, VG 이름, 메타데이터 영역 위치 정보 등을 포함
    * 이 영역을 기반으로 LVM은 “이 파티션이 PV다”라고 인식

* **Metadata Area**

    * VG, LV, PE 매핑 정보 등이 저장됨
    * 일반적으로 PV의 처음 몇 MB(또는 지정된 오프셋)에 존재
    * 복수의 메타데이터 복사본(metadata copies)을 둘 수도 있음

---

## 📦 2. 메타데이터에 저장되는 주요 정보

| 구분                            | 설명                             | 예시                                       |
| ----------------------------- | ------------------------------ | ---------------------------------------- |
| **PV UUID**                   | PV를 고유하게 식별하기 위한 UUID          | `DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy` |
| **VG Name / UUID**            | PV가 속한 Volume Group 이름과 UUID   | `VG Name = yw22`                         |
| **PE Size**                   | Physical Extent의 크기 (기본 4MB 등) | `PE Size = 4.00 MiB`                     |
| **Total PE / Free PE**        | PV 전체의 PE 개수 및 사용 가능한 PE 개수    | `Total PE = 5119, Free PE = 0`           |
| **Metadata area offset/size** | 메타데이터가 저장된 오프셋과 크기             | `metadata areas 0-1`                     |
| **Data area start**           | 실제 LV 데이터가 저장되는 시작 위치          | (보통 메타데이터 끝 이후)                          |

---

## 🔍 실제 확인 방법

### 1️⃣ `pvdisplay -v /dev/sdb1`

PV 메타데이터를 읽어 표시함.

```
--- Physical volume ---
PV Name               /dev/sdb1
VG Name               yw22
PV Size               <20.00 GiB / not usable 2.00 MiB
Allocatable           yes (but full)
PE Size               4.00 MiB
Total PE              5119
Free PE               0
PV UUID               DX1I8b-87Cx-ejS1-mDTd-hxGx-IMgM-ebZVcy
```

### 2️⃣ `dd` 명령으로 원시 메타데이터 영역 보기

```
# dd if=/dev/sdb1 bs=512 count=8 | hexdump -C
```

여기서 “LABELONE” 문자열이 보이면 LVM PV임을 의미합니다.

---

## ⚙️ 3. UUID 변경 시 주의

`pvcreate --uuid` 또는 `pvchange --uuid` 명령으로 PV UUID를 인위적으로 변경할 수는 있습니다.
하지만 **메타데이터에 저장된 VG, LV 매핑 정보와 일치하지 않으면**
VG 전체가 손상되거나 LVM이 PV를 인식하지 못하게 됩니다.

---

## 🧠 요약

| 항목         | 설명                       |
| ---------- | ------------------------ |
| 메타데이터 위치   | 디스크 시작 부분 (보통 첫 수 MB)    |
| 주요 내용      | PV/VG/LV 매핑, UUID, PE 정보 |
| 데이터 영역     | 메타데이터 뒤부터 LV 데이터 저장      |
| UUID 변경 위험 | VG 매핑이 깨져 데이터 손상 위험      |

---

원하신다면, 실제 `hexdump` 로 PV 메타데이터 구조를 직접 눈으로 확인하는 방법도 단계별로 보여드릴 수 있어요.
👉 그렇게 해드릴까요?
