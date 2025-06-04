물론입니다! 아래는 **Rocky Linux 등 CentOS 계열에서 `kubeadm`으로 Kubernetes 클러스터를 설치하는 전체 절차**를 문제 해결 포함하여 **정리한 가이드**입니다.

---

# 🚀 Kubernetes 설치 가이드 with `kubeadm` (단일 노드, Flannel 네트워크 기준)

---

## ✅ 1. 시스템 준비

```bash
sudo setenforce 0
sudo sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/selinux/config

sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab
```

---

## ✅ 2. 필요한 패키지 설치

```bash
sudo yum install -y yum-utils device-mapper-persistent-data lvm2 curl
```

---

## ✅ 3. Docker 또는 containerd 설치

### 📦 containerd 설치 권장 (Docker보다 간단)

```bash
sudo yum install -y containerd

# 기본 설정 생성
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml

# Systemd cgroup 설정 변경
sudo sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml

# containerd 활성화
sudo systemctl enable --now containerd
```

---

## ✅ 4. iptables 및 커널 파라미터 설정

```bash
cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

sudo modprobe overlay
sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
net.bridge.bridge-nf-call-ip6tables = 1
EOF

sudo sysctl --system
```

---

## ✅ 5. Kubernetes 저장소 설정

```bash
cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/
enabled=1
gpgcheck=1
gpgkey=https://pkgs.k8s.io/core:/stable:/v1.29/rpm/repodata/repomd.xml.key
EOF
```

---

## ✅ 6. Kubernetes 패키지 설치

```bash
sudo yum install -y kubelet kubeadm kubectl
sudo systemctl enable --now kubelet
```

---

## ✅ 7. 클러스터 초기화 (마스터 노드)

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
```

> ⚠️ 문제 발생 시:

* containerd가 실행 중인지 확인: `systemctl status containerd`
* IP 포워딩 확인: `sudo sysctl net.ipv4.ip_forward` 값이 1인지

---

## ✅ 8. kubectl 설정

```bash
mkdir -p $HOME/.kube
sudo cp /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

---

## ✅ 9. CNI 플러그인 설치 (Flannel)

```bash
kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/master/Documentation/kube-flannel.yml
```

---

## ✅ 10. (옵션) 단일 노드에서 Pod 실행 허용

> 마스터 노드에서도 Pod을 띄우려면 taint 제거 필요

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
```

---

## 🎯 확인

```bash
kubectl get nodes
kubectl get pods -A
```

---

## 🔁 요약 체크리스트

| 항목                                 | 상태 |
| ---------------------------------- | -- |
| containerd 설치 및 활성화                | ✅  |
| ip\_forward=1 설정                   | ✅  |
| SELinux permissive, swap 비활성화      | ✅  |
| `kubelet`, `kubeadm`, `kubectl` 설치 | ✅  |
| `kubeadm init` 성공                  | ✅  |
| Flannel CNI 설치                     | ✅  |
| (옵션) 마스터 taint 제거                  | ✅  |

---

필요하시면 Calico CNI, 고가용성(HA) 클러스터, 워커 노드 조인 등도 추가로 도와드릴 수 있습니다.
이제 다음으로 무엇을 하시려 하나요? (예: 워커 노드 조인, 테스트 앱 배포 등)


---
네! `kubeadm join` 명령어는 워커 노드를 기존 마스터(컨트롤 플레인) 클러스터에 연결할 때 사용하는 명령입니다.

---

## `kubeadm join` 명령어 구성과 설명

```bash
kubeadm join <마스터IP:포트> --token <토큰> --discovery-token-ca-cert-hash <해시>
```

* **`192.168.1.100:6443`**

    * 마스터 노드의 API 서버 IP와 포트
    * 워커 노드가 이 주소로 클러스터와 통신해서 연결 요청을 보냅니다.

* **`--token abcdef...`**

    * 마스터가 생성한 **일회용 인증 토큰**
    * 워커 노드가 인증을 위해 필요
    * 토큰은 `kubeadm init` 후 자동 생성되며, `kubeadm token create` 로 새로 만들 수도 있습니다.

* **`--discovery-token-ca-cert-hash sha256:xxxxxxxx`**

    * API 서버의 CA 인증서 해시값
    * 워커 노드가 연결할 마스터 서버의 신뢰성을 검증하기 위한 값입니다.
    * 보안을 위해 꼭 필요합니다.

---

## 워커 노드를 클러스터에 연결하는 과정

1. 마스터에서 `kubeadm init` 할 때 토큰이 생성됩니다.
2. 토큰과 CA 해시값을 워커 노드에 전달합니다.
3. 워커 노드에서 `kubeadm join` 명령어를 실행하면, 마스터와 연결되어 클러스터의 워커 노드로 등록됩니다.
4. 연결된 워커 노드는 마스터가 관리하는 Pod를 실행할 수 있습니다.

---

## 토큰 및 CA 해시 값 조회 방법

* 토큰 확인:

```bash
kubeadm token list
```

* CA 인증서 해시 구하기:

```bash
openssl x509 -pubkey -in /etc/kubernetes/pki/ca.crt | \
openssl rsa -pubin -outform der 2>/dev/null | \
sha256sum | awk '{print $1}'
```

---

## 정리

* **`kubeadm join` 명령은 워커 노드를 클러스터에 연결하는 공식 명령어**
* 추후 언제든 워커 노드를 추가 가능
* 보안 토큰과 CA 인증서 해시를 통해 안전하게 연결됨

---

필요하면 워커 노드에서 실제로 `kubeadm join` 실행하는 방법도 자세히 알려드릴게요!
추가 질문 있나요?
