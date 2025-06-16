네! `/dev/sdb`는 보통 두 번째 디스크를 의미하는데, 만약 서버에 `/dev/vdb`가 있다면 그걸로 작업하시면 됩니다. (보통 가상화 환경에서는 `/dev/vdb` 형태로 디스크가 나타나기도 해요.)

아래는 `/dev/vdb`를 기준으로 LVM 파티션 만드는 방법과 이후 LVM 볼륨 구성 과정입니다.

---

## 1. 디스크 파티션 생성 및 LVM 타입으로 변경

```bash
sudo fdisk /dev/vdb
```

`fdisk` 안에서 다음 작업을 수행하세요:

* `n` : 새 파티션 생성
* `p` : 기본 파티션 선택 (대부분 기본으로 하면 됨)
* 파티션 번호 입력 (기본 1)
* 첫 번째 섹터: 엔터 (기본값)
* 마지막 섹터: 엔터 (전체 디스크 사용)
* `t` : 파티션 타입 변경
* 파티션 번호 입력 (예: 1)
* 타입 코드 입력: `8e` (Linux LVM)
* `w` : 변경사항 저장 후 종료

---

## 2. 파티션 적용 확인

```bash
lsblk /dev/vdb
```

새 파티션 `/dev/vdb1`가 생성되고 타입이 `Linux LVM`인지 확인하세요.

---

## 3. 물리볼륨 (Physical Volume, PV) 생성

```bash
sudo pvcreate /dev/vdb1
```

---

## 4. 볼륨 그룹 (Volume Group, VG) 생성

예를 들어 `myvg`라는 이름으로 만듭니다:

```bash
sudo vgcreate myvg /dev/vdb1
```

---

## 5. 논리볼륨 (Logical Volume, LV) 생성

예를 들어 10GB 크기의 `mylv`라는 논리볼륨 생성:

```bash
sudo lvcreate -L 10G -n mylv myvg
```

원하는 크기와 이름으로 변경 가능하고, 전체 VG를 논리볼륨으로 할당하려면 `-l 100%FREE` 옵션을 사용하세요.

---

## 6. 논리볼륨 포맷 (예: ext4)

```bash
sudo mkfs.ext4 /dev/myvg/mylv
```

---

## 7. 마운트할 디렉토리 생성 및 마운트

```bash
sudo mkdir /mnt/mydata
sudo mount /dev/myvg/mylv /mnt/mydata
```

---

## 8. 부팅 시 자동 마운트 설정 (선택 사항)

`/etc/fstab` 파일에 아래 내용 추가:

```
/dev/myvg/mylv  /mnt/mydata  ext4  defaults  0  2
```

---

# 요약

* `/dev/vdb` 또는 해당 디스크를 `fdisk`로 파티션 생성 후, 타입 `8e`로 변경
* `pvcreate` → `vgcreate` → `lvcreate` 순서로 LVM 구성
* 논리볼륨을 포맷하고 마운트

필요하면 다음 단계인 LVM 확장, 스냅샷 등도 알려줄게요!
