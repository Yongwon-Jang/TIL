`dmsetup`은 Linux에서 **Device Mapper** 장치를 관리할 수 있게 해주는 명령어입니다. LVM(Logical Volume Manager), cryptsetup(LUKS), multipath 등의 내부에서도 이 명령어를 사용합니다.

---

## ✅ 기본 사용법

```bash
dmsetup <명령어> [옵션]
```

---

## 🔍 자주 사용하는 명령어

| 명령어                         | 설명                            |
| --------------------------- | ----------------------------- |
| `ls`                        | 현재 등록된 device-mapper 장치 목록 표시 |
| `info`                      | 장치의 상태 정보 출력                  |
| `status`                    | 장치의 상태(마운트 여부 등) 출력           |
| `table`                     | 장치의 매핑 테이블을 출력                |
| `remove <name>`             | 특정 장치 제거 (umount 후 사용)        |
| `create <name> < table.txt` | 새로운 장치 생성                     |
| `clear <name>`              | 장치를 초기화                       |

---

## 🧪 예제

### 1. 현재 장치 목록 확인

```bash
dmsetup ls
```

결과:

```
vg0-lvroot     (253:0)
vg0-lvswap     (253:1)
```

### 2. 특정 장치 정보 보기

```bash
dmsetup info /dev/mapper/vg0-lvroot
```

또는:

```bash
dmsetup info vg0-lvroot
```

### 3. 매핑 테이블 확인

```bash
dmsetup table vg0-lvroot
```

### 4. 장치 상태 보기

```bash
dmsetup status
```

### 5. 장치 제거

```bash
dmsetup remove vg0-lvroot
```

> ⚠️ 이 명령은 사용 중인 장치를 제거하려 할 경우 실패합니다. 먼저 `umount` 하고 `swapoff` 등을 수행해야 합니다.

---

## 📚 기타 팁

* LVM이나 암호화 볼륨을 분석할 때 `dmsetup` 명령이 유용합니다.
* `dmsetup info -c`는 CSV 형식으로 정보를 보여줍니다.
* 더 많은 정보: `man dmsetup`

---

필요하시면 LVM 내부에서 `dmsetup`이 어떤 역할을 하는지도 설명드릴 수 있습니다.
