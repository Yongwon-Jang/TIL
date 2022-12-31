## PV - PVC Reclaiming(반환)

> 사용이 끝난 PVC는 삭제되고 PVC를 사용하던 PV를 초기화(reclaim)하는 과정을 거친다. 이를 Reclaiming이라고 한다.

#### Reclaiming 종류

- Retain
- Delete
- Recycle

#### Retain

- PV를 그대로 보존.
- PVC가 삭제되면 사용중이던 PV는 해제(released) 상태여서 다른 PVC가 재사용 할 수 없다.
- 단순 해제 상태이기 떄문에 PV 안의 데이터는 그대로 있다.
- PV를 재사용하려면 다음 순서대로 직접 초기화 해야 한다.
  1. PV 삭제
  2. 스토리지에 남은 데이터 직접 정리
  3. 남은 스토리지의 볼륨을 삭제 or 재사용하려면 해당 볼륨을 이용하는 PV 재생성

#### Delete

- PV를 삭제하고 연결된 외부 스토리지 쪽의 볼륨도 삭제

#### Recycle

- PV의 데이터들을 삭제하고 다시 새로운 PVC에서 PV를 사용할 수 있도록 한다.