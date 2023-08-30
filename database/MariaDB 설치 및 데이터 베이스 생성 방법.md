## MariaDB 설치 및 데이터 베이스 생성 방법

> Centos7 기준으로 설명하겠습니다.

### 설치

1. MariaDB 패키지 설치

```
# sudo yum install mariadb-server -y
```

2. MariaDB 서비스 시작

```
# sudo systemctl start mariadb
```

3. MariaDB 부팅 시 자동으로 시작하도록 설정

```
# sudo systemctl enable mariadb
```

4. 보안 설정 실행 -> root 암호 설정

```
# sudo mysql_secure_installation
```

- 다음의 단계를 따른다
  - Enter current password for root (enter for none): [비밀번호 입력]
  - Set root password? [Y/n]: Y
  - New password: [새로운 비밀번호 입력]
  - Re-enter new password: [새로운 비밀번호 재입력]
  - Remove anonymous users? [Y/n]: Y
  - Disallow root login remotely? [Y/n]: Y
  - Remove test database and access to it? [Y/n]: Y
  - Reload privilege tables now? [Y/n]: Y

5. 정상 접속 확인

```
# mysql -u root -p
```



- 설치가 완료 되면 `/var/lib/mysql` 디렉터리가 생긴다.

```
# ll /var/lib/mysql
합계 28700
-rw-rw---- 1 mysql mysql    16384  5월 16 11:36 aria_log.00000001
-rw-rw---- 1 mysql mysql       52  5월 16 11:36 aria_log_control
-rw-rw---- 1 mysql mysql  5242880  5월 16 11:36 ib_logfile0
-rw-rw---- 1 mysql mysql  5242880  5월 16 11:36 ib_logfile1
-rw-rw---- 1 mysql mysql 18874368  5월 16 11:36 ibdata1
drwx------ 2 mysql mysql     4096  5월 16 11:36 mysql
srwxrwxrwx 1 mysql mysql        0  5월 16 11:36 mysql.sock
drwx------ 2 mysql mysql     4096  5월 16 11:36 performance_schema
```



### 데이터 베이스 생성

1. 데이터 베이스에 접속

```
# mysql -u root -p
```

- 비밀번호 입력 하면 들어가진다.

2. 데이터 베이스 생성

```
MariaDB [(none)]> CREATE DATABASE [데이터베이스이름];
```

3. 데이터 베이스 선택

```
MariaDB [(none)]> USE [데이터베이스이름];
```



### 테이블 생성 및 데이터 삽입/조회

- CREATE TABLE 문을 사용하여 테이블 생성

```sql
CREATE TABLE users (
    id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT
);
```

- DESCRIBE 문으로 테이블 구조 확인

```
DESCRIBE users;
+-------+-------------+------+-----+---------+-------+
| Field | Type        | Null | Key | Default | Extra |
+-------+-------------+------+-----+---------+-------+
| id    | int(11)     | NO   | PRI | NULL    |       |
| name  | varchar(50) | YES  |     | NULL    |       |
| age   | int(11)     | YES  |     | NULL    |       |
+-------+-------------+------+-----+---------+-------+

```

- 작업할 데이터베이스로 이동해서 INSERT INTO 로 데이터를 테이블에 삽입

```
INSERT INTO users (id, name, age) VALUES (1, 'John', 30);
```

- 데이터 조회

```
SELECT * FROM users;
```



