## CREATE
```sql
INSERT INTO 테이블명 (열1, 열2, ...) VALUES (값1, 값2, ...);
```
예제)
```sql
INSERT INTO users (username, email) VALUES ('user1', 'user1@example.com');
```
## READ
```sql
SELECT 열1, 열2, ... FROM 테이블명 WHERE 조건;
```
예제)
```sql
SELECT * FROM users;
```
## UPDATE
```sql
UPDATE 테이블명 SET 열1 = 값1, 열2 = 값2 WHERE 조건;
```
예제)
```sql
UPDATE users SET email = 'new_email@example.com' WHERE username = 'user1';
```
## DELETE
```sql
DELETE FROM 테이블명 WHERE 조건;
```
예제)
```sql
DELETE FROM users WHERE username = 'user1';
```