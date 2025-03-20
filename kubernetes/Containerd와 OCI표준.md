# **Containerd와 OCI 표준에 대해 알아보자**

## **1. Containerd란?**
### **🔹 Containerd 개요**
`containerd`는 **컨테이너 실행을 담당하는 런타임**으로, 경량화된 컨테이너 관리 도구이다.    
Docker의 핵심 런타임으로 시작했지만, 이후 **독립적인 CNCF(Cloud Native Computing Foundation) 프로젝트**로 발전했다.

✅ **주요 역할**
- **컨테이너 생성 및 실행**
- **이미지 관리 (Pull, Push, Build, Store)**
- **네트워크 및 저장소 관리**
- **OCI 표준을 따르는 컨테이너 런타임**

✅ **Containerd를 사용하는 대표적인 서비스**
- **Docker**: 내부적으로 `containerd`를 사용해 컨테이너를 관리
- **Kubernetes (K8s)**: `containerd`를 기본 컨테이너 런타임으로 지원
- **AWS Fargate, Google Kubernetes Engine (GKE)**: `containerd` 기반 컨테이너 관리

---

## **2. Containerd의 동작 방식**
![containerd-architecture](https://raw.githubusercontent.com/containerd/containerd/main/docs/architecture.png)

### **🔹 컨테이너 실행 과정**
1. **containerd가 이미지 다운로드 (Pull)**
2. **containerd가 OCI 규격에 맞게 컨테이너 실행 요청**
3. **하위 런타임 (`runc`)가 실제 컨테이너 실행**
4. **containerd가 컨테이너의 라이프사이클 (시작, 중지, 삭제) 관리**

---

## **3. OCI (Open Container Initiative)란?**
OCI(Open Container Initiative)는 **컨테이너의 표준을 정의하는 오픈 소스 프로젝트**다.  
Docker가 컨테이너 생태계를 주도하던 시기에 **컨테이너 표준화를 위해 2015년 리눅스 재단이 설립**했다.

✅ **OCI의 목표**
- 컨테이너 환경을 **플랫폼과 관계없이 표준화**
- 특정 업체(Docker 등)에 의존하지 않는 **오픈 표준 개발**
- 컨테이너 **이미지 포맷 및 런타임 표준화**

✅ **OCI의 주요 구성 요소**  
| **OCI 표준** | **설명** |
|-------------|---------|
| **OCI Runtime Specification (런타임 표준)** | 컨테이너를 실행하는 런타임(예: `runc`)의 동작 규칙 |
| **OCI Image Specification (이미지 표준)** | 컨테이너 이미지를 저장하고 배포하는 형식 |
| **OCI Distribution Specification (배포 표준)** | 컨테이너 이미지를 레지스트리에서 저장/다운로드하는 방식 |

---

## **4. Containerd와 OCI의 관계**
`containerd`는 **OCI 표준을 준수하는 컨테이너 런타임**으로, 내부적으로 **OCI Runtime**(`runc`)를 호출하여 컨테이너를 실행한다.

✅ **Containerd는 다음과 같이 OCI 표준을 따름**
- **OCI Image Format**: 컨테이너 이미지를 저장하고 실행할 때 OCI 표준을 사용
- **OCI Runtime**: `runc`와 같은 OCI 호환 런타임을 호출하여 컨테이너 실행
- **OCI Distribution**: 컨테이너 이미지를 OCI 표준 방식으로 Registry (e.g., Docker Hub, Harbor)에서 가져옴

---

## **5. Containerd와 Docker 차이점**
| **구분** | **Containerd** | **Docker** |
|---------|--------------|----------|
| 역할 | 컨테이너 실행 및 관리 | 컨테이너 빌드, 실행, 배포 관리 |
| 구성 요소 | Lightweight 런타임 (`runc` 사용) | `containerd` + 추가 기능 (CLI, Swarm 등) |
| 인터페이스 | CLI 없이 API 기반 | `docker` CLI 제공 |
| 사용 사례 | Kubernetes 런타임 | 개발 및 컨테이너 관리 |
| 성능 | 경량, 빠른 실행 | 기능이 많아 상대적으로 무거움 |

**즉, Docker는 `containerd`를 포함하는 상위 개념**이고, `containerd`는 실제 컨테이너 실행을 담당하는 엔진이다.

---

## **6. Containerd를 Kubernetes에서 사용하는 방법**
Kubernetes에서는 `containerd`를 기본 컨테이너 런타임으로 사용할 수 있다.

✅ **Containerd 설치 및 설정**
1. **Containerd 설치**
```bash
sudo apt update && sudo apt install -y containerd
```

2. **Containerd 설정 (`config.toml`)**
```bash
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
```

3. **Kubernetes에서 Containerd 사용 설정**
```bash
cat <<EOF | sudo tee /etc/crictl.yaml
runtime-endpoint: unix:///run/containerd/containerd.sock
EOF
```

4. **Containerd 상태 확인**
```bash
sudo systemctl status containerd
```

✅ **Kubernetes에서 Container Runtime을 containerd로 설정**
```bash
kubeadm init --cri-socket unix:///run/containerd/containerd.sock
```

---

## **7. 정리**
| **개념** | **설명** |
|---------|---------|
| **Containerd** | 경량 컨테이너 런타임, Kubernetes에서 기본 컨테이너 런타임으로 사용됨 |
| **OCI** | 컨테이너의 표준화된 이미지, 런타임, 배포 규칙을 정의하는 재단 |
| **Docker vs Containerd** | Docker는 `containerd`를 포함하는 상위 개념, `containerd`는 컨테이너 실행 엔진 |
| **Containerd의 특징** | 가볍고 빠른 컨테이너 런타임, Kubernetes와 연동하여 사용 가능 |
| **Kubernetes에서 Containerd** | `kubeadm init --cri-socket` 옵션을 사용해 containerd를 CRI 런타임으로 설정 가능 |

결론적으로, `containerd`는 OCI 표준을 준수하는 **가벼운 컨테이너 런타임**이며, Kubernetes와 같은 클라우드 네이티브 환경에서 필수적인 요소로 자리 잡고 있다. 🚀