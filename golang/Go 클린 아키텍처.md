Go에서의 **클린 아키텍처(Clean Architecture)**는 소프트웨어를 **책임에 따라 계층화**하고, **의존성 방향을 안쪽으로만 향하게** 하여 유지보수성과 테스트 용이성을 극대화하는 아키텍처 패턴입니다. 이 개념은 로버트 C. 마틴(aka Uncle Bob)의 클린 아키텍처 원칙에 기반하고 있으며, Go의 간결한 특성과 잘 어울립니다.

---

## ✅ 클린 아키텍처의 핵심 개념

### 🎯 목적
- **비즈니스 로직과 외부 의존성 분리**
- **테스트 용이성 확보**
- **유지보수성 강화**
- **의존성 역전 원칙(DIP)** 실현

---

## 🧱 계층 구조 (안쪽으로 갈수록 순수한 비즈니스 로직)

```
+----------------------+
|      Interfaces      | ← 외부 인터페이스 (HTTP, gRPC 등)
+----------------------+
|      Use Cases       | ← 애플리케이션 규칙
+----------------------+
|   Domain/Entities    | ← 핵심 비즈니스 규칙 (순수 Go)
+----------------------+
```

> ⚠️ 의존성은 **항상 바깥 계층이 안쪽 계층을 참조**하고, 반대는 절대 금지!

---

## 🔍 각 계층 설명

### 1. **Entities (Domain)**
- 핵심 비즈니스 로직, 규칙, 구조체
- 외부 기술에 의존하지 않는 **순수 Go 코드**
- 테스트가 가장 쉬운 계층

```go
type User struct {
    ID    int
    Name  string
    Email string
}

func (u *User) IsValid() bool {
    return u.Email != ""
}
```

---

### 2. **Use Cases (Application Layer)**
- 비즈니스 규칙의 조합을 통해 **유스케이스 구현**
- 도메인 로직을 orchestrate
- 외부에 의존하지 않음 (interface를 통해 주입만 받음)

```go
type UserRepository interface {
    GetByID(id int) (*User, error)
    Save(user *User) error
}

type UserUseCase struct {
    repo UserRepository
}

func (uc *UserUseCase) Register(user *User) error {
    if !user.IsValid() {
        return errors.New("invalid user")
    }
    return uc.repo.Save(user)
}
```

---

### 3. **Interfaces (Delivery / Infrastructure)**
- 외부와 연결되는 모든 부분 (HTTP API, CLI, DB, etc.)
- 이 계층에서 외부 기술을 캡슐화하고, 내부에 영향 못 미치게 함
- 유즈케이스를 호출하는 역할만 수행

```go
type UserHandler struct {
    uc *UserUseCase
}

func (h *UserHandler) RegisterHandler(c *gin.Context) {
    var user User
    c.BindJSON(&user)
    err := h.uc.Register(&user)
    if err != nil {
        c.JSON(400, gin.H{"error": err.Error()})
        return
    }
    c.JSON(200, gin.H{"message": "user registered"})
}
```

---

## 🔁 의존성 주입

- 외부에서 인프라(예: DB) 구현체를 주입하여 내부 로직은 interface만 의존하게 함.
- Go에서는 보통 **생성자 함수**를 이용한 수동 의존성 주입 방식 사용.

---

## 🔄 디렉토리 구조 예시

```
/project
│
├── /cmd                ← 진입점(main)
├── /internal
│   ├── /domain         ← Entity 계층
│   ├── /usecase        ← UseCase 계층
│   ├── /interface
│   │   ├── /controller ← HTTP 핸들러 등
│   │   └── /repo       ← DB 접근 등
│   └── /infrastructure ← 외부 시스템 연동 (DB, API)
└── go.mod
```

---

## ✨ 장점 요약

| 장점                 | 설명 |
|----------------------|------|
| 유지보수성          | 각 계층 분리로 변경 영향 최소화 |
| 테스트 용이         | 의존성 역전으로 테스트 쉽게 작성 가능 |
| 기술 독립           | DB, 프레임워크, UI 등에 종속되지 않음 |
| 유연한 확장         | 변경이 필요한 부분만 확장 가능 |

---

## ❗ Go에서 주의할 점
- Go는 구조가 간결하므로 **과도한 계층화**는 피해야 함.
- "클린 아키텍처는 지켜야 할 철칙이 아니라 **가이드라인**이다."
- 작은 프로젝트에서는 단순한 구조도 충분히 좋음.