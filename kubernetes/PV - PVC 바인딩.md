## PV - PVC 바인딩

### PV , PVC yaml 예시 

- pv.yaml

```yaml
apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv-nohost
  labels:
    type: local
spec:
  claimRef:
    name: pvc
    namespace: default
  storageClassName: manual
  capacity:
    storage: 10Gi
  accessModes:
    - ReadWriteOnce
  
  hostPath:
    path: "/mnt/data"
```

- pvc.yaml

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc-nohost
spec:
  storageClassName: manual
  volumeName: pv-nohost
  accessModes:
    - ReadWriteOnly
  resources:
    requests:
      storage: 3Gi
```

### Binding

- Binding은 프로비저닝으로 만든 PV와 PVC를 연결하는 단계이다.
- PV와 PVC 매핑은 1:1 관계, 즉 PVC 하나가 여러개의 PV에 할당될 수는 없다.
- PVC에서 원하는 스토리지의 용량(capacity)과 접근방법(accessModes), storageClassName 을 명시해서 요청하면 거기에 맞는 PV가 할당 된다.
  - storageClassName을 명시하지 않으면 default값으로 설정된다.	
    - 특정 스토리지 클래스가 있는 PV는 해당 스토리지 클래스에 맞는 PVC만 연결 된다.
  - accessModes 종류는 세 가지
    - ReadWriteOnce : 노드 하나에만 볼륨을 읽기/쓰기하도록 마운트 할 수 있음
    - ReadOnlyMany : 여러 개 노드에서 읽기 전용으로 마운트 할 수 있음
    - ReadWriteMany : 여러 개 노드에서 읽기/쓰기 가능하도록 마운트 할 수 있음

