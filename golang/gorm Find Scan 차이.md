## Find vs Scan
## ✅ 기본 개념

| 메서드      | 주요 용도 | 특징 |
|-------------|-----------|------|
| `Find`      | GORM 모델 기반 조회 | 자동으로 바인딩 및 테이블 매핑 |
| `Scan`      | 커스텀 구조체나 복잡한 SQL 결과 매핑 | raw 쿼리나 Select 결과를 임의 구조체에 바인딩 가능 |

---

## ✅ `Find`

- 모델(테이블 매핑된 구조체)에 데이터를 조회할 때 사용
- GORM이 자동으로 `SELECT * FROM <table>` 형태로 SQL을 생성
- Where, Joins, Order 등과 조합 가능

```go
var users []User
err := db.Where("age > ?", 20).Find(&users).Error
```

- 사용 조건: **반드시 주소값으로 전달 (`&users`)**

---

## ✅ `Scan`

- `Select()`로 지정한 컬럼 결과를 **커스텀 구조체** 또는 **일반 필드**에 바인딩할 때 사용
- GORM 모델 구조체가 아니어도 사용 가능

### 🔹 예: 커스텀 DTO에 바인딩

```go
type UserSummary struct {
    Name string
    Age  int
}

var summaries []UserSummary
db.Model(&User{}).Select("name, age").Where("age > ?", 20).Scan(&summaries)
```

- 주로 **통계, 집계, 일부 필드만 조회할 때** 유용

---

## ✅ `Select().Scan()` 활용

- **`Scan`은 반드시 `Select` 또는 Raw SQL 과 함께 써야 한다는 점**을 기억하세요.
- 구조체 전체가 아니라 **일부 필드만 가져오고 싶을 때**, 혹은 **다른 구조체에 매핑하고 싶을 때** 사용

### 🔹 예: Count 조회

```go
var count int64
db.Model(&User{}).Where("age > ?", 20).Select("COUNT(*)").Scan(&count)
```

### 🔹 예: 조인 결과를 다른 구조체에 매핑

```go
type UserOrder struct {
    UserName string
    OrderID  uint
}

var results []UserOrder
db.Table("users").
    Select("users.name AS user_name, orders.id AS order_id").
    Joins("JOIN orders ON users.id = orders.user_id").
    Scan(&results)
```

---

## ✅ `Find` vs `Scan` 요약 비교

| 항목        | `Find`                                      | `Scan` |
|-------------|---------------------------------------------|--------|
| 바인딩 대상 | GORM 모델 구조체                             | 아무 구조체 (커스텀 DTO, 일부 필드 등) |
| 컬럼 지정   | `Select()` 생략 가능 (전체 조회)             | `Select()` 또는 쿼리 필수 |
| 필드 매핑   | 자동으로 테이블 매핑                          | 수동으로 컬럼 지정 필요 |
| Raw SQL     | 잘 지원 안 함                                | `Raw()` 또는 `Select()`와 잘 어울림 |
| 유즈케이스   | 전체 모델 조회                               | 일부 필드, 조인 결과, 집계, DTO 매핑 등 |

---

## ✅ 실무 팁

- **모델 기반 조회는 `Find`**
- **뷰, 통계, 조인 결과 등 자유도가 필요한 경우는 `Scan`**
- DTO(전용 응답 구조체)가 있다면 `Scan` 적극 활용