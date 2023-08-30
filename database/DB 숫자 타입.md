## DB 숫자 타입

> Database 에서는 다양한 숫자 타입이 사용된다. 데이터 숫자 타입은 저장하려는 **크기와 정밀도**에 따라 선택될 수 있다.



1. **INTEGER (INT)**:
   - 일반적인 정수 데이터를 저장하는 데 사용됨.
   - 보통 4바이트 크기로, 대부분의 범위 내 정수 값을 저장할 수 있음.
   - 예: MySQL의 `INT`, PostgreSQL의 `INTEGER`
2. **SMALLINT**:
   - 작은 크기의 정수 값을 저장하는 데 사용됨.
   - 보통 2바이트 크기로, 제한된 범위 내 정수 값을 저장할 수 있음.
   - 예: PostgreSQL의 `SMALLINT`
3. **TINYINT**:
   - 매우 작은 크기의 정수 값을 저장하는 데 사용됨.
   - 보통 1바이트 크기로, 제한된 범위 내 정수 값을 저장할 수 있음.
   - 예: MySQL의 `TINYINT`
4. **BIGINT**:
   - 큰 정수 값을 저장하는 데 사용됨.
   - 보통 8바이트 크기로, 매우 넓은 범위 내 정수 값을 저장할 수 있음.
   - 예: PostgreSQL의 `BIGINT`
5. **NUMERIC/DECIMAL**:
   - 고정 소수점 수를 저장하는 데 사용됨.
   - 정밀도와 소수점 위치를 지정하여 사용 가능.
   - 예: PostgreSQL의 `NUMERIC`, MySQL의 `DECIMAL`
6. **REAL/FLOAT**:
   - 부동 소수점 수를 저장하는 데 사용됨.
   - 보통 4바이트 크기로, 근사치 값을 저장함.
   - 예: PostgreSQL의 `REAL`, MySQL의 `FLOAT`
7. **DOUBLE PRECISION/DOUBLE**:
   - 더 높은 정밀도의 부동 소수점 수를 저장하는 데 사용됨.
   - 보통 8바이트 크기로, 더 정교한 근사치 값을 저장함.
   - 예: PostgreSQL의 `DOUBLE PRECISION`, MySQL의 `DOUBLE`
8. **BOOLEAN/BOOL**:
   - 논리적인 참과 거짓을 나타내는 데 사용됨.
   - 대부분의 데이터베이스 시스템에서 1바이트 크기로 저장됨.
   - 예: PostgreSQL의 `BOOLEAN`, MySQL의 `BOOL`
9. **SERIAL/AUTOINCREMENT**:
   - 일련번호 또는 자동 증가 값으로 사용되는 특별한 숫자 타입.
   - 각 레코드가 추가될 때마다 자동으로 값이 증가함.
   - 예: PostgreSQL의 `SERIAL`, MySQL의 `AUTO_INCREMENT`