## PostgreSQL 설치 및 사용법

> Centos 7 기준으로 작성되었습니다.

### 설치

1. PostgreSQL 패키지 설치

```
# sudo yum install postgresql-server postgresql-contrib
```

2. PostgreSQL 초기화

```
# sudo postgresql-setup initdb
```

3. PostgreSQL 서비스 실행

```
sudo systemctl start postgresql
```

4. PostgreSQL 서비스 부팅 시 자동 시작 설정

```
sudo systemctl enable postgresql
```

5. PostgreSQL 사용자 계정 및 데이터베이스 생성

   - PostgreSQL은 root 계정으로의 접근을 허용하지 않는다. 대신, 자체적인 사용자 및 권한 관리 시스템을 가지고 있다. 
   - postges 사용자로 변경 후 접근 가능

   ```
   # sudo su - postgres
   ```

   - `psql` 명령어로 PostgreSQL 콘솔 접속

   ```
   # psql
   ```

   - 새로운 사용자 생성

   ```sql
   CREATE USER myuser WITH PASSWORD 'mypassword';
   ```

   - 새로운 데이터베이스 생성

   ```sql
   CREATE DATABASE mydatabase;
   ```

   - 생성한 사용자에게 데이터베이스 접근 권한 부여

   ```sql
   GRANT ALL PRIVILEGES ON DATABASE mydatabase TO myuser;
   ```

   - PostgreSQL 콘솔 종료

   ```sql
   \q
   ```

   - `postgres` 사용자에서 나가기

   ```bash
   exit
   ```

6. PostgreSQL 외부 접근 허용 (선택 사항):

   - `pg_hba.conf` 파일 수정:

     ```
     kotlinCopy code
     sudo vi /var/lib/pgsql/data/pg_hba.conf
     ```

   - 파일 내용 변경:

     ```
     pythonCopy code# IPv4 local connections:
     host    all             all             0.0.0.0/0               md5
     ```

   - PostgreSQL 서비스 재시작:

     ```
     Copy code
     sudo systemctl restart postgresql
     ```

### 테이블 생성 및 데이터 삽입

1. PostgreSQL에 접속

```php
psql -U <사용자이름> -d <데이터베이스이름>
```

2. 테이블 생성

```
CREATE TABLE <테이블이름> (
    <열1이름> <열1데이터타입>,
    <열2이름> <열2데이터타입>,
    ...
);
```

​	ex)

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    age INTEGER
);
```

3. 데이터 삽입

```
INSERT INTO <테이블이름> (<열1이름>, <열2이름>, ...)
VALUES (<값1>, <값2>, ...);
```

​	ex)

```sql
INSERT INTO users (name, age)
VALUES ('John', 25), ('Jane', 30);
```

- 조회

```sql
SELECT * FROM <테이블이름>;
```

