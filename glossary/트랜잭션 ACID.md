## 트랜잭션 ACID

> ACID는 데이터베이스 트랜잭션의 원자성(Atomicity), 일관성(Consistency), 고립성(Isolation), 지속성(Durability)이라는 네 가지 속성을 나타내는 약어입니다. 이 속성들은 데이터베이스에서 안정적이고 신뢰할 수 있는 트랜잭션 처리를 보장하기 위해 사용됩니다.

1. **원자성(Atomicity)**: 원자성은 트랜잭션이 "원자적"으로 처리되어야 함을 의미합니다. 트랜잭션은 작업의 모든 단계가 완전히 실행되거나 전혀 실행되지 않아야 합니다. 트랜잭션 내의 작업 중 하나라도 실패하면 모든 작업이 롤백되어 이전 상태로 복원됩니다. 성공한 경우에만 모든 작업이 커밋되어 영구적으로 적용됩니다.
2. **일관성(Consistency)**: 일관성은 트랜잭션이 데이터베이스의 일관된 상태를 유지해야 함을 의미합니다. 트랜잭션 전후에 데이터베이스는 미리 정의된 일관성 규칙을 준수해야 합니다. 예를 들어, 데이터베이스에 정의된 제약 조건을 위반하지 않고 데이터 무결성을 유지해야 합니다.
3. **고립성(Isolation)**: 고립성은 동시에 실행되는 여러 트랜잭션들이 서로에게 영향을 미치지 않고 각각 독립적으로 실행되어야 함을 의미합니다. 한 트랜잭션의 변경 내용은 다른 트랜잭션에게 보이지 않아야 합니다. 이를 통해 데이터베이스는 일관성과 격리성을 유지할 수 있습니다.
4. **지속성(Durability)**: 지속성은 트랜잭션이 성공적으로 완료된 후에는 해당 트랜잭션의 결과가 영구적으로 저장되어야 함을 의미합니다. 시스템 장애나 전원 손실과 같은 예상치 못한 상황이 발생해도 데이터의 지속성이 보장되어야 합니다. 이를 위해 트랜잭션의 변경 내용은 로그와 같은 지속적인 저장 매체에 기록되어야 합니다.

ACID 속성은 데이터베이스 트랜잭션 처리에 있어서 데이터의 일관성, 신뢰성 및 안정성을 보장하는 데 중요한 역할을 합니다. 이러한 속성은 데이터의 정확성과 신뢰성을 유지하며, 동시성 제어와 병행성 문제를 해결하여 데이터베이스 시스템의 신뢰성을 높이는 데 도움을 줍니다.