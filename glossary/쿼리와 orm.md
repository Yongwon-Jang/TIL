### 쿼리(Query)

**쿼리(Query)**는 데이터베이스나 정보 시스템에서 데이터를 검색하고 조작하기 위해 사용되는 명령이나 질의(statement)입니다. 데이터베이스와의 상호 작용을 가능하게 하며, 데이터를 추가, 수정, 삭제, 검색할 수 있게 합니다.

#### 주요 개념과 예시

1. **SQL 쿼리**:
    - SQL(Structured Query Language)은 관계형 데이터베이스 관리 시스템에서 데이터를 관리하기 위해 사용되는 언어입니다.
    - SQL 쿼리는 데이터베이스에서 데이터를 검색하고 조작하는 데 사용됩니다.

##### SQL 쿼리의 주요 유형:

- **SELECT**: 데이터 검색
    ```sql
    SELECT * FROM employees WHERE department = 'Sales';
    ```
- **INSERT**: 데이터 삽입
    ```sql
    INSERT INTO employees (name, department, salary) VALUES ('John Doe', 'Sales', 50000);
    ```
- **UPDATE**: 데이터 수정
    ```sql
    UPDATE employees SET salary = 60000 WHERE name = 'John Doe';
    ```
- **DELETE**: 데이터 삭제
    ```sql
    DELETE FROM employees WHERE name = 'John Doe';
    ```

2. **NoSQL 쿼리**:
    - NoSQL 데이터베이스는 관계형 데이터베이스와는 다른 방식으로 데이터를 저장하고 관리합니다.
    - MongoDB와 같은 NoSQL 데이터베이스에서는 BSON 형식의 문서로 데이터를 저장하며, JavaScript 기반의 쿼리 언어를 사용합니다.

##### MongoDB 쿼리의 주요 유형:

- **데이터 검색**
    ```javascript
    db.employees.find({ department: 'Sales' });
    ```
- **데이터 삽입**
    ```javascript
    db.employees.insertOne({ name: 'John Doe', department: 'Sales', salary: 50000 });
    ```
- **데이터 수정**
    ```javascript
    db.employees.updateOne({ name: 'John Doe' }, { $set: { salary: 60000 } });
    ```
- **데이터 삭제**
    ```javascript
    db.employees.deleteOne({ name: 'John Doe' });
    ```

### ORM(Object-Relational Mapping)

**ORM(Object-Relational Mapping)**은 객체 지향 프로그래밍 언어를 사용하여 데이터베이스의 데이터를 다루기 위한 기술입니다. ORM을 사용하면 데이터베이스의 데이터를 객체 지향 방식으로 다룰 수 있으며, SQL 쿼리를 직접 작성하지 않고도 데이터베이스와 상호 작용할 수 있습니다.

#### 주요 특징

- **객체 지향**: 데이터베이스의 테이블을 객체로 매핑하여, 객체 지향 언어의 특성을 활용할 수 있습니다.
- **자동화**: 데이터베이스와의 매핑, 쿼리 생성, 데이터 변환 등의 작업을 자동화하여 개발자의 부담을 줄입니다.
- **유지보수성**: 코드의 가독성과 유지보수성을 높이며, 데이터베이스와의 상호 작용을 더 직관적으로 만듭니다.

#### ORM의 주요 기능

- **CRUD 작업**: ORM은 Create, Read, Update, Delete 작업을 간단한 메소드 호출로 처리할 수 있습니다.
- **데이터베이스 매핑**: 데이터베이스 테이블과 객체 클래스 간의 매핑을 설정하여, 객체를 통해 데이터베이스를 조작할 수 있습니다.
- **관계 매핑**: 테이블 간의 관계를 객체 간의 관계로 매핑하여, 복잡한 JOIN 쿼리 등을 객체 지향적으로 처리할 수 있습니다.

#### 예시 (Go의 GORM)

GORM은 Go 언어에서 널리 사용되는 ORM 라이브러리입니다.

1. **모델 정의**:
    ```go
    type User struct {
        ID        uint   `gorm:"primaryKey"`
        Name      string
        Email     string
    }
    ```

2. **데이터베이스 연결 및 자동 마이그레이션**:
    ```go
    package main

    import (
        "gorm.io/driver/sqlite"
        "gorm.io/gorm"
    )

    func main() {
        db, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
        if err != nil {
            panic("failed to connect database")
        }

        // 자동 마이그레이션을 통해 모델을 기반으로 테이블 생성
        db.AutoMigrate(&User{})
    }
    ```

3. **CRUD 작업**:
    ```go
    package main

    import (
        "gorm.io/driver/sqlite"
        "gorm.io/gorm"
    )

    type User struct {
        ID    uint   `gorm:"primaryKey"`
        Name  string
        Email string
    }

    func main() {
        db, err := gorm.Open(sqlite.Open("test.db"), &gorm.Config{})
        if err != nil {
            panic("failed to connect database")
        }

        // 자동 마이그레이션을 통해 모델을 기반으로 테이블 생성
        db.AutoMigrate(&User{})

        // 데이터 삽입
        db.Create(&User{Name: "John Doe", Email: "john@example.com"})

        // 데이터 검색
        var user User
        db.First(&user, 1) // 기본 키가 1인 유저 검색
        db.First(&user, "email = ?", "john@example.com") // 이메일이 일치하는 유저 검색

        // 데이터 수정
        db.Model(&user).Update("Name", "Jane Doe")

        // 데이터 삭제
        db.Delete(&user)
    }
    ```

### 결론

- **쿼리**: 데이터베이스와 상호 작용하기 위해 사용되는 명령어. SQL 또는 NoSQL 쿼리를 통해 데이터를 검색하고 조작.
- **ORM**: 객체 지향 프로그래밍 언어를 사용하여 데이터베이스의 데이터를 다루는 기술. 객체와 데이터베이스 간의 매핑을 통해 쿼리를 직접 작성하지 않고도 데이터베이스와 상호 작용.

ORM을 사용하면 데이터베이스와의 상호 작용이 더 직관적이고 간단해지며, 유지보수성이 향상됩니다. 그러나 ORM의 사용이 항상 최적의 성능을 보장하는 것은 아니므로, 복잡한 쿼리나 성능이 중요한 경우에는 직접 쿼리를 작성하는 것이 좋을 수 있습니다.