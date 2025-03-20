## **CRI (Container Runtime Interface)란?**
**CRI (Container Runtime Interface)**는 **Kubernetes가 컨테이너 런타임(Container Runtime)과 상호작용하기 위한 표준 인터페이스**다.  
즉, Kubernetes가 **컨테이너를 실행하고 관리할 수 있도록 컨테이너 런타임과 연결하는 역할**을 한다.

---

## **🔥 CRI가 왜 필요할까?**
초기 Kubernetes는 **Docker에 종속적**이었다. 하지만 다양한 컨테이너 런타임(`containerd`, `CRI-O`, `Kata Containers` 등)이 등장하면서  
**런타임 간의 호환성을 보장**하고, **유연성을 제공**하기 위해 CRI가 도입되었다.

✅ CRI를 사용하면 Kubernetes는 특정 컨테이너 런타임(Docker, containerd 등)에 **종속되지 않고** 다양한 런타임을 지원할 수 있다.

---

## **🛠 CRI 구성 요소**
### **1️⃣ kubelet**
- Kubernetes 노드에서 실행되며 **CRI를 통해 컨테이너 런타임과 통신**
- `kubelet` → **CRI** → 컨테이너 런타임(`containerd`, `CRI-O` 등)

### **2️⃣ CRI gRPC API**
- `kubelet`이 컨테이너 런타임과 통신하기 위해 사용하는 **gRPC 기반 API**
- 주요 API:
    - **CreateContainer** → 컨테이너 생성
    - **StartContainer** → 컨테이너 실행
    - **StopContainer** → 컨테이너 중지
    - **RemoveContainer** → 컨테이너 삭제

### **3️⃣ 컨테이너 런타임 (containerd, CRI-O 등)**
- `kubelet`의 요청을 받아 실제로 컨테이너를 실행하는 소프트웨어
- 대표적인 CRI 지원 런타임:
    - **containerd** → Docker에서 분리된 경량 런타임 (Kubernetes 기본 런타임)
    - **CRI-O** → OpenShift와 같은 환경에서 사용되는 경량 런타임
    - **Kata Containers** → 가상화 기술을 활용한 보안 강화 런타임

---

## **🎯 CRI를 지원하는 대표적인 컨테이너 런타임**
| 컨테이너 런타임 | 설명 |
|---------------|----------------------|
| **containerd** | Docker에서 분리된 경량화된 컨테이너 런타임, Kubernetes 기본 사용 |
| **CRI-O** | Kubernetes 전용으로 개발된 컨테이너 런타임 |
| **Kata Containers** | 보안 강화를 위해 경량 VM 기반으로 컨테이너 실행 |

---

## **📌 CRI의 작동 방식**
1. `kubelet`이 CRI를 통해 컨테이너 런타임에 컨테이너 생성 요청 (`CreateContainer`)
2. 컨테이너 런타임이 실제로 컨테이너를 실행 (`StartContainer`)
3. `kubelet`은 런타임 상태를 모니터링하며 필요 시 컨테이너 중지 및 삭제 (`StopContainer`, `RemoveContainer`)

➡️ Kubernetes가 컨테이너 런타임과 직접 통신하는 것이 아니라 **CRI를 통해 표준화된 방식으로 컨테이너를 실행 및 관리**

---

## **🔗 Docker와 CRI의 관계**
Kubernetes 1.20부터 Docker는 공식적으로 지원되지 않음 (`dockershim` 제거)  
➡️ 대신 `containerd` 또는 `CRI-O` 같은 **CRI 호환 런타임을 사용**해야 함

✅ **Docker 자체는 CRI를 지원하지 않지만, containerd는 CRI를 지원하므로 Kubernetes에서 사용 가능**

---

## **✅ 정리**
- CRI는 **Kubernetes가 컨테이너 런타임과 통신하기 위한 표준 인터페이스**
- `kubelet`이 **CRI를 통해 containerd, CRI-O 등과 통신**하여 컨테이너를 실행 및 관리
- **Docker는 CRI를 직접 지원하지 않지만, containerd를 통해 Kubernetes에서 사용 가능**
- CRI를 사용하면 **다양한 컨테이너 런타임과의 호환성 확보**

🔥 **즉, CRI 덕분에 Kubernetes는 특정 컨테이너 런타임에 종속되지 않고 유연하게 동작할 수 있음!**