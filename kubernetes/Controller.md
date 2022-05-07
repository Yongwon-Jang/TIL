# Controller

### Controller란

- Pod의 개수를 보장



### Controller 종류

#### ReplicationController (가장 basic)

- 요구하는 Pod의 개수를 보장하며 파드 집합의 실행을 항상 안정적으로 유지하는 것을 목표
  - 요구하는 Pod의 개수가 부족하면 template를 이용해 pod를 추가
  - 요구하는 Pod의 수보다 많으면 최근에 생성된 Pod를 삭제
- 기본 구성
  - selector
    - key : value 에 해당하는 label을 가지고 있는 pod 개수가 많으면 죽이고 적으면 template을 보고 생성
  - replicas
    - 배포 갯수
  - template
    - 컨테이너 템플릿



### ReplicaSet

- ReplicationController와 성격이 비슷하다
- 풍부한 selector를 지원해준다.

- 