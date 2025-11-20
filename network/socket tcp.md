# 🚀 **TCP 소켓 통신의 전체 흐름 (송신 과정 중심)**

## 1️⃣ **애플리케이션 계층**

* 프로그램이 `send()` 또는 `write()` 로 데이터를 보냄.
* TCP는 바이트 스트림이므로 애플리케이션은 데이터 경계를 신경 쓰지 않음.

---

# 2️⃣ **TCP 계층 (전송 계층) — 핵심 부분**

### ✔ (1) **버퍼링 (Send Buffer 적재)**

프로그램이 보낸 데이터는 **TCP Send Buffer** 에 저장됨.

이 버퍼는 OS가 관리하며
애플리케이션이 보낸다고 바로 전송되는 게 아니라 **TCP가 적절히 나눠서 전송**함.

---

### ✔ (2) **세그먼트(Segment) 분할**

MSS(Maximum Segment Size)에 맞춰 세그먼트로 나눔.

예:

* 애플리케이션 전송: 20 KB
* MSS: 1460 bytes

→ 약 14개 세그먼트로 나눠서 전송됨.

---

### ✔ (3) **TCP 헤더 구성**

각 세그먼트에 다음 정보를 붙임:

* Source Port / Destination Port
* Sequence Number (데이터 순서)
* ACK Number
* Flags (SYN, ACK, FIN 등)
* Window size
* Checksum

특히 중요한 것:
**Sequence Number** ← 데이터 순서 보장
**Checksum** ← 오류 검출

---

### ✔ (4) **흐름 제어 — Sliding Window**

수신자의 버퍼 상황을 고려해 **Window Size** 만큼만 전송할 수 있음.

수신자가 "나 바빠 → window 줄여" 하면 송신자는 전송량 줄임.

---

### ✔ (5) **혼잡 제어**

네트워크가 혼잡하면 패킷 손실이 증가함.
TCP는 다음 알고리즘으로 속도를 자동 조절함:

* Slow Start
* Congestion Avoidance
* Fast Retransmit
* Fast Recovery

즉, TCP는 **네트워크 상태를 보면서 전송 속도를 동적으로 조절**함.

---

### ✔ (6) **전송**

세그먼트가 IP 계층으로 넘어감.

---

## 3️⃣ **IP 계층 (네트워크 계층)**

TCP 세그먼트에 IP 헤더 추가 → IP Packet 생성

* Source IP
* Destination IP
* TTL
* Fragmentation 정보 등

라우터를 통해 목적지까지 전달됨.

---

## 4️⃣ **Ethernet 계층 (데이터 링크 계층)**

MAC 헤더 추가 → Ethernet Frame 완성

LAN 환경에서는:

* Source MAC
* Destination MAC
* CRC (프레임 오류 검사)

---

## 5️⃣ **수신 측에서의 처리**

### ✔ (1) 데이터 링크 → IP → TCP 순서로 역언캡슐레이션

---

### ✔ (2) TCP 계층에서 하는 일

#### 🔹 데이터 순서 재조립 (Reordering)

네트워크 상의 패킷은 **순서가 뒤바뀔 수 있음**
→ TCP는 Sequence Number로 원래 순서를 복원.

#### 🔹 중복 패킷 제거

Sequence Number 기준으로 중복 제거.

#### 🔹 오류 검출 (Checksum)

잘못된 패킷은 폐기 → 재전송 요청.

#### 🔹 ACK 전달

수신한 바이트까지 ACK 번호를 송신자에게 전달.

---

### ✔ (3) 버퍼에 저장 후 애플리케이션에 전달

TCP Receive Buffer 에 저장 → 애플리케이션에서 `recv()` 호출 시 전달.

---

# 📌 **정리: TCP가 보장해주는 것**

| 기능     | 의미                   |
| ------ | -------------------- |
| 연결 지향  | 3-way handshake 로 연결 |
| 순서 보장  | Sequence Number      |
| 신뢰성 보장 | Checksum, 재전송        |
| 흐름 제어  | Sliding Window       |
| 혼잡 제어  | 네트워크 상태 기반 전송 조절     |

TCP는 **신뢰성을 보장하는 소켓 통신 방식**이기 때문에 파일 전송, RPC, HTTP 대부분에서 쓰임.

---

# 필요하면 추가로 더 설명해줄게 🔥

* 3-way handshake 상세 흐름
* TCP 재전송 메커니즘(RTO, RTT 계산)
* SYN Flood 공격과 방어
* TCP와 UDP 비교
  원하면 바로 더 설명해줄게!
