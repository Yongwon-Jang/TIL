##  Ansible 이란

> - 스토리지, 서버 및 네트워킹을 자동화하는 구성 관리 플랫폼
>
> - Ansible을 사용하여 이러한 구성요소를 구성하면 어려운 수동 반복 작업을 자동화 할 수 있고 오류에 덜 취약해진다.
> - 동시에 많은 서버에 동일한 환경을 배포하는 상황에 유용하게 사용할 수 있다.

#### Ansible의 특징

- Agentless
  - 타겟 대상들에 Agent설치를 하지 않고 push 방식으로 동작하기 때문에 기술적, 지리적 제한이 상대적으로 넓다
- Idempotency
  - 어떠한 연산이 여러번 수행되어도 그 결과가 달라지지 않는 성질
  - 같은 모듈을 반복해서 실행해도 결과가 동일하게 출력된다.

#### Ansible 구조

- Control Node
  - 중앙 제어 노드로, Ansible이 설치가 되는 노드
- Managed Node
  - Ansible Control Node에 관리가 되는 대상 서버. 
  - ansible host에 등록된 대상

- Inventory
  - Managed Node가 등록되어 있는 목록.
  - IP, Group로 관리 할 수 있으며, default로 /etc/ansible/hosts 파일을 사용한다.
- Modulles
  - Ansible에서 제공하는 실행 단위 모듈
- Tasks
  - Modules의 집합으로 작업 단위이다.
- Playbooks
  - 계획된 작업을 순서대로 실행하기 위해 작성하는 `yml` 파일
- Ansible Control Node 에서 ssh 통해서 Managed Node에 배포한다.



#### Ansible의 장단점

- 장점
  - ssh를 통한 구성으로 Agentless 방식
  - yaml 언어 사용으로 높은 접근성
  - 쉽고 단순한 구조
  - 변수 기능 사용으로 인한 재사용성 증가
  - 다른 도구보다 간소화 되어있음
  - 다양한 플랫폼 지원
- 단점
  - 다른 도구에 비해 강력하지 않다.
  - DSL을 통한 로직 수행
  - 변수 사용으로 인한 복잡성 증가
  - 변수 값 확인 어려움
  - 입력/출력/구성파일 간의 형식 일관성이 없음
  - 때때로 성능 속도가 저하됨