## ✅ GORM에서 조회 시 주소값이 필요한 이유

### 1. GORM은 내부적으로 `reflect`를 사용해 데이터를 할당함
- Go의 `reflect` 패키지는 **값을 변경하려면 반드시 주소값(pointer)** 을 요구합니다.
- 즉, `reflect.Value.Set()`은 **주소가 없는 값에는 데이터를 할당할 수 없음** → panic 발생 가능성 있음.

---

## ✅ 어떤 조회 함수에서 주소값이 필요한가?

| 함수 | 주소값 필요 여부 | 예시 |
|------|------------------|------|
| `Find()` | ✅ 필요 | `db.Find(&users)` |
| `First()` / `Last()` | ✅ 필요 | `db.First(&user)` |
| `Take()` | ✅ 필요 | `db.Take(&user)` |
| `Scan()` | ✅ 필요 | `db.Raw(...).Scan(&user)` |
| `Select().Scan()` | ✅ 필요 | `db.Select("name").Scan(&names)` |

---

## ✅ 예시

### 🔹 올바른 사용 (✅)
```go
var users []User
db.Find(&users)

var user User
db.First(&user)

var result []MyStruct
db.Raw("SELECT ...").Scan(&result)
```

### 🔸 잘못된 사용 (❌ panic: reflect.Value.Set using unaddressable value)
```go
var users []User
db.Find(users) // ❌ 주소값이 아님

var user User
db.First(user) // ❌ 주소값이 아님

var result []MyStruct
db.Raw("SELECT ...").Scan(result) // ❌ 주소값이 아님
```

---

## ✅ 정리

- GORM의 **모든 조회 함수**(`Find`, `First`, `Scan`, `Take` 등)는  
  ➤ **조회 대상에 반드시 `&` 주소값을 넘겨야 한다**
- 그렇지 않으면 → **panic** 또는 **조회 결과가 비어 있음**

---

좋아요! 앞서 **조회(Select)** 시 주소값이 필요한 이유를 설명드렸는데, 이번엔 **Create/Update/Delete와의 차이점**을 정리해드릴게요.

---

## ✅ GORM의 Create / Update / Delete vs. Select

| 동작      | 주소값 필요 여부 | 설명 |
|-----------|------------------|------|
| `Create()` | ❌ (주소 없어도 가능) | 값을 읽기만 하면 되므로 값 복사로 처리 가능 |
| `Save()`   | ❌ (주소 없어도 가능) | `Create()`처럼 동작하지만 기존 레코드가 있으면 업데이트 |
| `Update()` | ✅ (주소 or Where 조건 필요) | 구조체 필드 기반 업데이트시 주소 또는 Where 필요 |
| `Delete()` | ✅ (주소 or Where 조건 필요) | 삭제할 엔티티 지정 시 주소 필요 |
| `Find()` / `First()` / `Scan()` | ✅ 주소 필요 | 값을 **Set**해야 하므로 반드시 주소 필요 |

---

## ✅ 예시로 비교

### 🔹 Create – 주소 없어도 OK
```go
user := User{Name: "Alice"}
db.Create(user) // ✅ OK
// 또는
db.Create(&user) // ✅ OK (더 안전하고 일반적으로 권장)
```

### 🔹 Update – 필드만 지정하면 주소 불필요, 그렇지 않으면 필요
```go
// 필드 지정 업데이트 (주소 불필요)
db.Model(&user).Update("name", "Bob") // ✅ OK

// 구조체 기반 업데이트 (주소 필요)
db.Model(&user).Updates(User{Name: "Bob", Age: 30}) // ✅ OK

// Where 조건 없이 값만 넣으면 실패할 수도 있음
db.Updates(User{Name: "Charlie"}) // ❌ 권장하지 않음
```

### 🔹 Delete – 주소 or Where 필요
```go
db.Delete(&user) // ✅ OK
// 또는
db.Where("name = ?", "Bob").Delete(&User{}) // ✅ OK
```

---

## ✅ 왜 Create/Update는 주소가 없어도 될까?

- GORM은 **Create/Update 시 reflect를 이용해 값을 읽기만 함**
- 즉, **값을 메모리에 할당하는 작업(Set)이 아닌, 읽는(Get) 작업만 수행**
- 그래서 주소값이 없어도 내부 필드를 복사해서 SQL 생성 가능

하지만...

> 👀 **주소값을 넣는 것이 더 안전하고 관례적으로 권장됩니다.**
> - 예: Hook 동작, 자동 채움(created_at 등), ID 필드 설정 등에서 반영되기 때문

---

## ✅ 결론

| 구분     | 주소 필요 | 이유 |
|----------|-----------|------|
| 조회     | ✅ 필요    | 데이터를 구조체에 Set 해야 하므로 |
| Create   | ❌ (가능)  | 값 복사로 처리 (읽기만 함) |
| Update   | ✅ (권장)  | 구조체 업데이트 시 주소 필요 |
| Delete   | ✅ (권장)  | 삭제 대상 명확히 하기 위해 |