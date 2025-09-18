## 1. PV (Physical Volume, 물리 볼륨) 관련

* **생성**

  ```bash
  pvcreate /dev/sdX
  ```
* **조회**

  ```bash
  pvdisplay        # 상세 정보
  pvs              # 요약
  ```
* **삭제**

  ```bash
  pvremove /dev/sdX
  ```

---

## 2. VG (Volume Group, 볼륨 그룹) 관련

* **생성**

  ```bash
  vgcreate vg_name /dev/sdX /dev/sdY ...
  ```
* **조회**

  ```bash
  vgdisplay        # 상세 정보
  vgs              # 요약
  ```
* **확장 (새 PV 추가)**

  ```bash
  vgextend vg_name /dev/sdZ
  ```
* **축소 (PV 제거)**

  ```bash
  vgreduce vg_name /dev/sdZ
  ```
* **삭제**

  ```bash
  vgremove vg_name
  ```

---

## 3. LV (Logical Volume, 논리 볼륨) 관련

* **생성**

  ```bash
  lvcreate -L 10G -n lv_name vg_name      # 크기 지정
  lvcreate -l 100%FREE -n lv_name vg_name # 남은 공간 전부 사용
  ```
* **조회**

  ```bash
  lvdisplay        # 상세 정보
  lvs              # 요약
  ```
* **확장 (크기 늘리기)**

  ```bash
  lvextend -L +5G /dev/vg_name/lv_name
  lvextend -r -L +5G /dev/vg_name/lv_name   # -r 옵션: 파일시스템도 같이 확장
  ```
* **축소 (크기 줄이기, 신중히!)**

  ```bash
  lvreduce -L -5G /dev/vg_name/lv_name
  ```
* **삭제**

  ```bash
  lvremove /dev/vg_name/lv_name
  ```

---

## 4. 전체 구조 조회

* **트리 형태**

  ```bash
  lsblk
  ```
* **LVM 구조 요약**

  ```bash
  pvs   # PV → VG 매핑
  vgs   # VG 요약
  lvs   # LV 요약
  ```

---

## 5. 유용한 관리 명령어

* **VG 이름 변경**

  ```bash
  vgrename old_vg_name new_vg_name
  ```
* **LV 이름 변경**

  ```bash
  lvrename vg_name old_lv_name new_lv_name
  ```
* **마운트 확인**

  ```bash
  df -hT
  ```

---

👉 정리하면,

* `pv*` → 물리 디스크 다룸
* `vg*` → 그룹 관리
* `lv*` → 실제 파일시스템 단위 관리

---

혹시 원하시면 제가 **PV\~VG\~LV 생성 → 파일시스템 생성 → 마운트까지 한 방에 하는 명령어 예시**도 만들어드릴까요?
