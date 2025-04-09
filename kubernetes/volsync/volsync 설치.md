## VolSync 설치 (Helm 이용)

VolSync는 `Helm`을 사용하는 게 가장 간단하고 일반적인 방법입니다.

### 1-1. Helm 저장소 추가

```bash
helm repo add backube https://backube.github.io/helm-charts
helm repo update
```

### 1-2. VolSync 설치

```bash
kubectl create ns backube
helm install volsync backube/volsync -n backube
```
