## vgimportclone 명령어

* 이름: `vgimportclone` — “Import a VG from cloned PVs” 즉 복제된 PV(Physical Volume)들로부터 VG(Volume Group)를 가져오는(import) 명령어입니다. ([SysTutorials][1])
* 설명: 기존의 PV들을 복제(snapshot, 하드웨어 복제 등)했을 때, 그 복제본을 단순히 시스템에 연결만 하면 원본 VG와 충돌(conflict)할 수 있습니다. `vgimportclone`은 복제된 VG가 **원본과 공존 가능하도록** VG명과 UUID(PV UUID, VG UUID)를 변경해 줍니다. ([SysTutorials][1])

---

## 🔧 사용법 및 옵션

### 기본 형태

```bash
vgimportclone [ 옵션 ] PV1 PV2 …
```

예:

```bash
vgimportclone --basevgname newvg /dev/sdc /dev/sdd
```

위 예시는 `/dev/sdc`와 `/dev/sdd`가 복제된 PV들이고, 이들을 포함하는 VG를 `newvg` 라는 이름으로 변경하면서 가져오겠다는 의미입니다. ([SysTutorials][1])

### 주요 옵션

* `-n` 또는 `--basevgname String`
  복제된 VG에 새로 지정할 기본 VG명(base name)을 설정합니다. 기본값이 없으면 원본 VG명 뒤에 숫자 접미사(suffix)가 추가됩니다. ([SysTutorials][1])
* `-i` 또는 `--import`
  이미 `vgexport`된 VG를 가져올 때 사용됩니다. 복제된 PV이지만 이미 export된 상태라면 이 옵션이 필요합니다. ([SysTutorials][1])
* 기타: `--debug`, `--verbose`, `--test`, `--yes` 등 일반 LVM 명령에서 쓰이는 공통 옵션들. ([SysTutorials][1])

---

## 🧠 동작 흐름 & 의미

1. 원본 VG가 예컨대 `vg00` 이고, 그 PV들이 `/dev/sda`, `/dev/sdb` 라고 합시다.
2. 하드웨어 기반 스냅샷이나 디스크 복제로 `/dev/sdc`, `/dev/sdd` 에 원본 PV들이 복제되어 있다고 가정합니다. ([SysTutorials][1])
3. 이 `/dev/sdc`, `/dev/sdd` 를 시스템에 연결하면, 원본 `vg00` 와 동일한 VG명과 UUID를 가진 복제본이 생기기 때문에 LVM 메타데이터 충돌이 발생할 수 있습니다.
4. `vgimportclone --basevgname vg00_snap /dev/sdc /dev/sdd` 와 같이 실행하면 복제본의 VG명을 `vg00_snap` 으로 변경하고, 내부의 VG UUID 및 PV UUID 등도 새로 생성해서 원본과 독립적인 VG로 만들게 됩니다. ([SysTutorials][1])
5. 이후 복제된 VG는 원본과 병행하여 사용 가능해집니다.

---

## ⚠️ 주의사항

* 복제된 PV들을 원본과 **같은 이름/UUID**로 그대로 사용하면 LVM이 혼란을 겪거나 데이터 손상이 생길 수 있습니다.
* 복제된 PV들은 실제 데이터는 동일하더라도 메타데이터상으로는 “새로운” PV로 취급되어야 합니다. `vgimportclone`이 이 부분을 자동으로 해결해 줍니다.
* `--test` 옵션을 사용하면 실제로 메타데이터를 변경하지 않고 시뮬레이션만 하므로, 실제 적용 전에 시험해볼 수 있습니다. ([SysTutorials][1])
* 복제된 디스크가 원본과 **동시에 활성화되어 있지 않은지**, 혹은 다른 시스템에서 읽히고 있지 않은지 확인해야 합니다.
* VG 이름을 바꿀 때 기존 이름과 충돌이 나면 자동으로 숫자 접미사가 붙습니다 (`vg00_snap1` 등). 그래서 `--basevgname` 옵션을 통해 원하는 이름을 미리 설정할 수 있습니다. ([SysTutorials][1])

---

필요하시면 이 명령어를 **백업·복구 시나리오**에서 어떻게 사용하는지, 실제 예제와 함께 단계별로 보여드릴까요?

[1]: https://www.systutorials.com/docs/linux/man/8-vgimportclone/ "
vgimportclone: Import a VG from cloned PVs - Linux Manuals (8)"
