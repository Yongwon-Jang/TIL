Rocky Linux에서 IP 설정하는 방법은 크게 **두 가지**가 있습니다:

---

## ✅ 1. **nmcli (NetworkManager CLI)** – 권장 방법 (Rocky 8, 9 기준)

```bash
nmcli connection show
```

위 명령으로 활성 연결 이름 확인 후 아래처럼 설정합니다.

### 🔧 예: `ens160` 인터페이스에 고정 IP 설정

```bash
nmcli connection modify ens160 \
  ipv4.addresses 192.168.1.100/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns 8.8.8.8 \
  ipv4.method manual
```

적용:

```bash
nmcli connection down ens160 && nmcli connection up ens160
```

---

## ✅ 2. **nmtui (TUI 툴)** – 메뉴 기반 설정

```bash
nmtui
```

1. `Edit a connection` 선택
2. 사용할 인터페이스 선택 후 Enter
3. IPv4 설정에서:

    * Method를 `Manual`로 변경
    * IP, Gateway, DNS 입력
4. 저장 후 `Back` → `Activate a connection`으로 반영

---

## ✅ 3. **Netplan 또는 `ifcfg` 설정 (구버전용)**

Rocky Linux는 기본적으로 \*\*NetworkManager + `nmcli/nmtui`\*\*를 사용하지만, 구버전에서 직접 설정 파일을 수정할 수도 있습니다.

### `/etc/sysconfig/network-scripts/ifcfg-ens160` (Rocky 8 기준)

```ini
TYPE=Ethernet
BOOTPROTO=none
NAME=ens160
DEVICE=ens160
ONBOOT=yes
IPADDR=192.168.1.100
PREFIX=24
GATEWAY=192.168.1.1
DNS1=8.8.8.8
```

적용:

```bash
nmcli connection reload
nmcli connection up ens160
```

> `ifcfg-*` 방식은 점차 deprecated 예정이니 가능하면 `nmcli`나 `nmtui`를 사용하는 것을 권장합니다.

---

## ✅ 현재 IP 확인

```bash
ip addr show
# 또는
nmcli device show
```

---

필요하다면 DHCP 설정 방법이나 KVM 환경의 NAT/Bridge 관련 IP 설정도 도와드릴 수 있어요.
