## **🔹 DCL (Data Control Language) 이란?**
DCL은 **데이터베이스의 보안과 권한을 관리하는 SQL 문**을 의미해.  
즉, **사용자에게 특정 권한을 부여하거나 회수하는 역할**을 해! 🔒

---

## **✅ DCL의 주요 명령어**
DCL에는 **두 가지 주요 명령어**가 있어:

| 명령어 | 설명 |
|------|----------------------|
| `GRANT` | 특정 사용자에게 권한을 부여 |
| `REVOKE` | 특정 사용자에게 부여된 권한을 회수 |

---

## **✅ DCL 예제**
### **1️⃣ GRANT (권한 부여)**
```sql
GRANT SELECT, INSERT ON employees TO user1;
```
🔹 `user1`에게 `employees` 테이블에서 **조회(SELECT)와 삽입(INSERT) 권한**을 부여하는 명령어야.

```sql
GRANT ALL PRIVILEGES ON database_name.* TO 'user1'@'localhost';
```
🔹 `user1`에게 **database_name 데이터베이스의 모든 권한**을 부여하는 예제.

---

### **2️⃣ REVOKE (권한 회수)**
```sql
REVOKE INSERT ON employees FROM user1;
```
🔹 `user1`이 `employees` 테이블에서 **삽입(INSERT) 권한을 제거**하는 명령어야.

```sql
REVOKE ALL PRIVILEGES ON database_name.* FROM 'user1'@'localhost';
```
🔹 `user1`에게 부여된 **모든 권한을 제거**하는 예제.

---

## **✅ DCL을 사용하는 이유**
✅ **보안 강화** → 데이터 접근을 제한하여 정보 보호  
✅ **관리 용이** → 특정 사용자별로 권한을 세분화 가능  
✅ **데이터 무결성 유지** → 불필요한 변경 방지

---

## **📌 정리**
- **DCL (Data Control Language)** → **데이터베이스 보안 및 권한 관리** 역할
- `GRANT` → **사용자에게 권한 부여**
- `REVOKE` → **사용자의 권한 회수**
- 보안을 강화하고 데이터 접근을 효과적으로 제어할 수 있음! 🚀