### **Kubernetes의 Taint란?**
`Taint`(테인트)는 Kubernetes 노드에 적용되는 속성으로, 특정 조건을 만족하지 않는 파드가 해당 노드에서 스케줄링되지 않도록 제한하는 기능입니다. 이는 클러스터 내에서 특정 노드를 격리하거나, 특정 용도의 노드에서만 특정 워크로드가 실행되도록 하기 위해 사용됩니다.

`Taint`는 노드에 적용되며, `Toleration`(톨러레이션)은 이를 무시하고 해당 노드에서 파드를 실행할 수 있도록 허용하는 설정입니다.

---

## **1. Taint의 기본 개념**
Taint는 **Key, Value, Effect**로 구성됩니다.

### **Taint의 형식**
```bash
kubectl taint nodes <노드이름> <키>=<값>:<Effect>
```

예시:
```bash
kubectl taint nodes node1 key1=value1:NoSchedule
```
위 명령어는 `node1`에 `key1=value1` 이라는 taint를 추가하고, `NoSchedule` 효과를 적용합니다.

### **Taint의 Effect(효과)**
| 효과 (Effect)  | 설명 |
|---------------|---------------------------------------------------------------|
| `NoSchedule`  | 이 taint를 허용하지 않는 파드는 이 노드에 배포될 수 없음 |
| `PreferNoSchedule` | 가능하면 해당 노드에 스케줄링되지 않지만, 강제하지 않음 |
| `NoExecute`   | 이 taint를 허용하지 않는 기존의 파드도 해당 노드에서 퇴출됨 |

---

## **2. Master 노드에 기본적으로 적용된 Taint**
Kubernetes의 `control-plane`(마스터) 노드는 기본적으로 다음과 같은 Taint가 설정되어 있습니다.

```bash
kubectl describe node <마스터 노드 이름> | grep Taints
```

결과 예시:
```plaintext
Taints: node-role.kubernetes.io/control-plane:NoSchedule
```

이 의미는 **마스터 노드에서 일반적인 파드는 실행될 수 없도록 설정**되어 있다는 것입니다.

---

## **3. Taint 제거 방법**
마스터 노드에서 모든 파드를 실행할 수 있도록 하려면 Taint를 제거하면 됩니다.

```bash
kubectl taint nodes <노드이름> node-role.kubernetes.io/control-plane:NoSchedule-
```

예시:
```bash
kubectl taint nodes localhost.localdomain node-role.kubernetes.io/control-plane:NoSchedule-
```
`-` 를 붙이면 해당 `Taint`가 제거됩니다.

---

## **4. 특정 파드만 실행하고 싶다면? (Toleration 사용)**
만약 특정 파드만 마스터 노드에서 실행되도록 하고 싶다면, 파드의 `tolerations` 설정을 추가해야 합니다.

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: example-pod
spec:
  tolerations:
  - key: "node-role.kubernetes.io/control-plane"
    operator: "Exists"
    effect: "NoSchedule"
  containers:
  - name: example-container
    image: nginx
```
이 설정이 적용된 파드는 `master` 노드에서도 실행될 수 있습니다.

---

## **5. 노드에 Taint 추가하는 방법**
특정 노드를 특정 워크로드 전용으로 사용하고 싶다면 `Taint`를 추가할 수 있습니다.

예를 들어, `node1`을 "GPU 전용 노드"로 만들고 싶다면 다음 명령을 실행합니다.

```bash
kubectl taint nodes node1 gpu=true:NoSchedule
```

이제 `gpu=true` taint가 설정된 노드는 `Toleration`이 있는 파드만 실행할 수 있습니다.

---

## **6. 적용된 Taint 확인 방법**
현재 클러스터에서 적용된 Taint를 확인하려면 다음 명령어를 사용합니다.

```bash
kubectl describe node <노드이름> | grep Taints
```

---

## **정리**
| 작업  | 명령어 |
|------|-------------------------|
| Taint 확인 | `kubectl describe node <노드명> | grep Taints` |
| Taint 추가 | `kubectl taint nodes <노드명> key=value:Effect` |
| Taint 제거 | `kubectl taint nodes <노드명> key=value:Effect-` |
| 특정 파드만 실행 | `tolerations` 설정 추가 |

Taint와 Toleration을 잘 활용하면 **노드 격리, 특정 워크로드 전용 노드 운영, 마스터 노드에서 파드 실행** 등을 효율적으로 관리할 수 있습니다.