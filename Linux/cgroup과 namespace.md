### **cgroup(Control Groups)이란?**
**cgroup(Control Groups)**은 **리눅스 커널에서 프로세스의 자원 사용을 제한하고 관리하는 기능**이다. CPU, 메모리, I/O, 네트워크 대역폭 등의 자원을 컨트롤할 수 있도록 한다.

---

## **🔹 주요 기능**
1. **리소스 제한 (Resource Limiting)**
    - 특정 프로세스 그룹이 사용할 수 있는 CPU, 메모리, 디스크 I/O, 네트워크 등을 제한할 수 있음.
    - 예: 하나의 컨테이너가 CPU를 50% 이상 사용하지 못하게 설정 가능.

2. **리소스 할당 (Resource Allocation)**
    - 특정 프로세스 그룹에 더 많은 자원을 우선적으로 배정할 수 있음.
    - 예: 중요 서비스에 더 많은 CPU 시간을 할당.

3. **리소스 모니터링 (Resource Monitoring)**
    - 프로세스 그룹의 메모리 사용량, CPU 사용량, I/O 대역폭 등을 모니터링 가능.
    - Kubernetes가 pod의 자원을 감시할 때 사용.

4. **프로세스 격리 (Process Isolation)**
    - 프로세스를 그룹으로 묶어 다른 프로세스 그룹과 독립적으로 실행 가능.
    - 컨테이너 기술(Docker, Kubernetes)의 핵심 요소 중 하나.

---

## **🔹 계층 구조 (Hierarchy)**
cgroup은 계층적인 구조를 가짐. 즉, 부모 그룹이 있고 그 아래 자식 그룹을 만들 수 있음.

```
/sys/fs/cgroup/
│── cpu/
│── memory/
│── blkio/
│── devices/
│── freezer/
│── pids/
└── net_cls/
```
- `cpu/` → CPU 사용량 제한
- `memory/` → RAM 사용 제한
- `blkio/` → 블록 디바이스(I/O) 제어
- `devices/` → 디바이스 접근 제한
- `freezer/` → 프로세스 일시 정지 및 재개
- `pids/` → 생성할 수 있는 프로세스 수 제한

---

## **🔹 cgroup 예제**
### **1. 메모리 사용 제한**
```bash
mkdir /sys/fs/cgroup/memory/my_group
echo 500M > /sys/fs/cgroup/memory/my_group/memory.limit_in_bytes
echo $$ > /sys/fs/cgroup/memory/my_group/cgroup.procs
```
- `my_group`이라는 cgroup을 만들고 **메모리를 500MB로 제한**.
- 현재 프로세스를 해당 그룹에 추가.

### **2. CPU 사용 제한**
```bash
mkdir /sys/fs/cgroup/cpu/my_group
echo 50000 > /sys/fs/cgroup/cpu/my_group/cpu.cfs_quota_us
echo $$ > /sys/fs/cgroup/cpu/my_group/cgroup.procs
```
- `my_group`을 만들고 **CPU 사용률을 50%로 제한**.
- 현재 프로세스를 해당 그룹에 추가.

---

## **🔹 cgroup과 컨테이너 (Docker & Kubernetes)**
- **Docker**
    - 컨테이너를 실행하면 cgroup을 자동으로 생성하여 CPU, 메모리 사용량을 제한함.
    - `docker stats` 명령어로 컨테이너별 리소스 사용량을 확인할 수 있음.

- **Kubernetes**
    - `requests`와 `limits` 설정을 통해 pod의 리소스 제한 가능.
  ```yaml
  resources:
    requests:
      memory: "256Mi"
      cpu: "250m"
    limits:
      memory: "512Mi"
      cpu: "500m"
  ```
    - 이 설정은 내부적으로 cgroup을 활용하여 pod가 지정된 리소스 이상을 사용하지 못하게 함.

---

## **🔹 요약**
| 기능 | 설명 |
|------|------|
| 리소스 제한 | CPU, 메모리, 네트워크 등 사용량을 제한 |
| 리소스 할당 | 특정 프로세스 그룹에 자원을 우선 배정 |
| 리소스 모니터링 | 사용량을 추적하고 통계 수집 |
| 프로세스 격리 | 컨테이너, VM 등에서 독립된 환경 제공 |
| 컨테이너 활용 | Docker, Kubernetes 등에서 핵심 기능으로 사용 |

`cgroup`은 컨테이너 기술의 필수 요소로, Kubernetes와 Docker에서 Pod/컨테이너의 리소스 제어에 활용됨. 🚀

---

# **Linux Namespace란?**
**Linux Namespace**는 프로세스가 운영체제의 특정 리소스를 독립적으로 사용할 수 있도록 격리하는 기술이다.   
이 기술은 컨테이너(Docker, Kubernetes)에서 **프로세스를 서로 독립된 환경에서 실행**하도록 하는 핵심 요소 중 하나이다.

---

## **🔹 Namespace의 역할**
- 시스템 리소스를 **프로세스 단위로 격리**하여 독립적인 실행 환경을 제공.
- **컨테이너 환경**에서 서로 다른 프로세스들이 독립적인 네트워크, 파일 시스템, PID를 갖도록 함.
- **보안 강화**, **충돌 방지**, **리소스 격리** 등의 장점이 있음.

---

## **🔹 Namespace의 종류**
| **Namespace** | **격리 대상** | **설명** |
|--------------|------------|---------|
| **PID (Process ID)** | 프로세스 ID | 프로세스 ID를 격리하여 컨테이너 내부에서 별도의 프로세스 트리를 사용 |
| **Mount** | 파일 시스템 | 각 프로세스가 서로 다른 마운트 포인트(파일 시스템)를 사용할 수 있도록 격리 |
| **Network** | 네트워크 인터페이스 | 각 프로세스가 독립적인 IP 주소, 네트워크 인터페이스를 가질 수 있도록 격리 |
| **IPC (Inter-Process Communication)** | 프로세스 간 통신 | 각 프로세스 그룹이 서로 다른 메시지 큐, 공유 메모리를 사용하도록 격리 |
| **UTS (Unix Timesharing System)** | 호스트네임 및 도메인 네임 | 프로세스가 서로 다른 호스트네임을 가질 수 있도록 격리 |
| **User** | 사용자 및 그룹 ID | 서로 다른 사용자 ID 및 그룹 ID를 가질 수 있도록 격리 |
| **Cgroup** | 자원 할당 | CPU, 메모리 등 리소스 사용량을 제한하고 제어할 수 있도록 격리 |

---

## **🔹 Namespace 동작 방식**
### **1. PID Namespace (프로세스 격리)**
- 프로세스를 격리하여 **각 프로세스 그룹이 별도의 프로세스 ID 트리를 가짐**.
- 컨테이너 내부에서 `PID 1`은 해당 컨테이너에서 실행되는 첫 번째 프로세스가 됨.
- 컨테이너 내부 프로세스는 **호스트의 다른 프로세스를 볼 수 없음**.

```bash
unshare --fork --pid --mount-proc bash
```
- 새로운 PID 네임스페이스를 생성하여 격리된 환경에서 `bash` 실행.
- `ps aux`를 실행하면 새로운 프로세스 트리에서 **PID 1**이 된 것을 확인 가능.

---

### **2. Mount Namespace (파일 시스템 격리)**
- 서로 다른 프로세스 그룹이 서로 다른 **파일 시스템 마운트**를 사용하도록 격리.
- 컨테이너에서 호스트의 파일 시스템을 보호할 수 있음.

```bash
unshare --mount --propagation private bash
```
- 새로운 마운트 네임스페이스에서 `bash` 실행.
- `mount -t tmpfs none /mnt`로 특정 디렉토리에 마운트해도, **호스트에는 영향을 주지 않음**.

---

### **3. Network Namespace (네트워크 격리)**
- 각 네임스페이스는 **고유한 네트워크 인터페이스와 IP 주소**를 가짐.
- 컨테이너 간 네트워크 격리를 위해 사용됨.

```bash
ip netns add mynet
ip netns exec mynet ip link set lo up
ip netns exec mynet ip a
```
- `mynet`이라는 새로운 네트워크 네임스페이스를 생성하고, 루프백 인터페이스를 활성화.
- `mynet` 네임스페이스 내부에서 **독립적인 네트워크 설정**을 확인 가능.

---

### **4. IPC Namespace (프로세스 간 통신 격리)**
- **Shared Memory, Message Queue** 같은 IPC 리소스를 서로 다른 프로세스가 공유하지 못하도록 격리.

```bash
unshare --ipc bash
```
- 새로운 IPC 네임스페이스에서 `bash` 실행.
- `ipcs` 명령어로 공유 메모리 확인 시, 기존과 다른 결과가 나옴.

---

### **5. UTS Namespace (호스트네임 격리)**
- 각 네임스페이스가 서로 다른 **호스트네임 및 도메인네임**을 가질 수 있도록 함.

```bash
unshare --uts bash
hostname my-container
hostname
```
- 호스트네임을 `my-container`로 변경했을 때, **현재 네임스페이스 내에서만 적용됨**.

---

### **6. User Namespace (사용자 격리)**
- 컨테이너 내에서 **루트 권한을 가질 수 있지만, 호스트에서는 권한이 제한됨**.

```bash
unshare --user --map-root-user bash
whoami  # root (컨테이너 내부에서는 root지만 실제 호스트에서는 root 아님)
```
- 컨테이너 내부에서는 `root`로 보이지만, **호스트에서는 실제 권한이 없음**.

---

## **🔹 Namespace와 cgroup 차이점**
| **기능** | **Namespace** | **cgroup** |
|---------|-------------|------------|
| 역할 | 리소스 "격리" | 리소스 "제한 및 할당" |
| 예제 | PID, Network, Mount 격리 | CPU, 메모리, I/O 사용량 제한 |
| 사용 방식 | 각 프로세스 그룹이 서로 다른 환경 사용 | 특정 그룹이 사용할 수 있는 리소스 양을 조절 |
| 컨테이너 활용 | 네트워크, 프로세스 ID, 파일 시스템을 독립적으로 사용 | 컨테이너당 CPU, 메모리 사용량을 제한 |

---

## **🔹 Namespace의 활용**
✅ **컨테이너 기술 (Docker, Kubernetes)**
- 각 컨테이너는 **독립적인 네임스페이스**를 가지므로, 서로 다른 컨테이너의 프로세스를 볼 수 없음.
- 컨테이너마다 개별적인 네트워크, 파일 시스템, 사용자 환경을 제공.

✅ **샌드박스 환경**
- 개발 및 테스트 환경을 독립적으로 실행할 수 있음.
- 격리된 환경에서 애플리케이션을 실행하여 시스템 전체에 영향을 주지 않음.

✅ **보안 강화**
- 프로세스 간 충돌 방지.
- 컨테이너에서 실행되는 프로세스가 호스트의 중요한 자원에 접근하지 못하도록 보호.

---

## **🔹 정리**
| **특징** | **설명** |
|---------|---------|
| **리소스 격리** | 프로세스마다 독립적인 환경을 제공 |
| **컨테이너 필수 요소** | Docker, Kubernetes에서 프로세스를 격리하여 실행 |
| **보안 및 충돌 방지** | 프로세스 간 간섭을 방지하고 안전한 실행 환경 제공 |
| **여러 종류 존재** | PID, Mount, Network, IPC, UTS, User, Cgroup 등 다양한 네임스페이스 지원 |

`Namespace`는 **Linux 컨테이너 환경에서 필수적인 요소**이며, `cgroup`과 함께 사용되어 컨테이너의 격리성과 리소스 제어를 담당한다. 🚀