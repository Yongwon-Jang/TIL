## ✅ **Go의 메서드 체이닝 (Method Chaining)**

### 🔹 **메서드 체이닝이란?**
메서드 체이닝(Method Chaining)은 **객체의 메서드를 연속적으로 호출하는 방식**입니다.  
**각 메서드가 자기 자신(객체)을 반환하면** 여러 메서드를 이어서 호출할 수 있습니다.

📌 **장점**  
✔ 코드가 간결해짐  
✔ 직관적인 인터페이스 제공  
✔ 연속적인 연산을 쉽게 표현

---

## 🔹 **Go에서 메서드 체이닝 구현**
Go는 **클래스가 없는 대신 구조체(struct)와 메서드(receiver)를 사용**하여 체이닝을 구현합니다.

### 📝 **예제 1: 기본적인 메서드 체이닝**
```go
package main

import "fmt"

type Counter struct {
    value int
}

// 메서드 체이닝을 위해 *Counter 반환
func (c *Counter) Increment() *Counter {
    c.value++
    return c
}

func (c *Counter) Add(n int) *Counter {
    c.value += n
    return c
}

func (c *Counter) Print() *Counter {
    fmt.Println("현재 값:", c.value)
    return c
}

func main() {
    c := &Counter{} // 초기화

    // 체이닝을 이용해 연속 호출
    c.Increment().Add(10).Print().Increment().Print()
}
```
🔹 **출력 결과**
```
현재 값: 11
현재 값: 12
```

✔ `Increment()` → `Add(10)` → `Print()` → `Increment()` → `Print()` 순서로 실행됨  
✔ **각 메서드가 `*Counter`를 반환하므로 연속 호출 가능**

---

## 🔹 **메서드 체이닝의 장점**
### ✅ **1️⃣ 코드의 가독성을 높임**
```go
// 체이닝 없이 사용할 경우
c.Increment()
c.Add(10)
c.Print()
c.Increment()
c.Print()
```
✔ 위처럼 **메서드를 여러 줄에 걸쳐 호출하는 것보다 체이닝이 더 직관적**임

---

### ✅ **2️⃣ 불필요한 변수 생성을 줄일 수 있음**
```go
// 변수 없이 직접 메서드 호출 가능
NewCounter().Increment().Add(5).Print()
```
✔ 새로운 변수를 할당하지 않고 바로 연산 수행 가능

---

### ✅ **3️⃣ 객체의 상태 변경을 직관적으로 표현 가능**
```go
user.SetName("Alice").SetAge(25).SetEmail("alice@example.com")
```
✔ **객체의 필드를 변경하는 연산을 깔끔하게 표현 가능**

---

## 🔹 **메서드 체이닝을 사용할 때 주의할 점**
### ❌ **1️⃣ 값 리시버(복사본 사용)로 구현하면 체이닝이 안됨**
```go
type Counter struct {
    value int
}

// 잘못된 코드: 값 리시버 사용 (복사본을 반환)
func (c Counter) Increment() Counter {
    c.value++  // 값이 증가하지만, 복사본이므로 원본에는 영향 없음
    return c   // 새로운 복사본이 반환됨
}
```
📌 **해결 방법**: 포인터 리시버(`*Counter`) 사용  
✅ 포인터 리시버를 사용하면 원본을 수정 가능!

---

### ❌ **2️⃣ 에러 처리를 고려해야 함**
체이닝 도중 에러가 발생할 경우,  
**Go에서는 에러를 명확히 처리하기 어렵기 때문에 체이닝 패턴을 조정해야 함**

✔ **해결 방법**: `error` 반환을 포함하는 체이닝 패턴 사용
### 📝 **예제 2: 체이닝에서 에러 처리**
```go
package main

import (
    "errors"
    "fmt"
)

type Account struct {
    balance int
}

// 체이닝에서 에러를 반환하는 패턴
func (a *Account) Deposit(amount int) (*Account, error) {
    if amount <= 0 {
        return a, errors.New("입금 금액은 0보다 커야 합니다")
    }
    a.balance += amount
    return a, nil
}

func (a *Account) Withdraw(amount int) (*Account, error) {
    if amount > a.balance {
        return a, errors.New("잔액이 부족합니다")
    }
    a.balance -= amount
    return a, nil
}

func (a *Account) Print() *Account {
    fmt.Println("현재 잔액:", a.balance)
    return a
}

func main() {
    account := &Account{}

    // 체이닝 중간에 에러 발생 시 처리
    if _, err := account.Deposit(100).Withdraw(200); err != nil {
        fmt.Println("에러 발생:", err) // 에러 발생: 잔액이 부족합니다
    }
}
```
✔ **에러가 발생하면 체이닝을 중단하고 오류 메시지를 출력할 수 있도록 구현**

---

## 🔥 **정리: Go에서 메서드 체이닝이란?**
| **항목** | **설명** |
|------|------|
| **메서드 체이닝** | 객체의 메서드를 연속적으로 호출하는 방식 |
| **장점** | 코드 간결화, 가독성 증가, 불필요한 변수 제거 |
| **필수 조건** | 포인터 리시버(`*struct`)를 사용해야 원본 값 유지 |
| **에러 처리** | `error` 반환을 포함하는 체이닝 패턴 사용 가능 |

---

## 🎯 **결론**
- 메서드 체이닝은 **Go에서 객체 지향적인 스타일로 코드를 작성할 때 매우 유용**
- **포인터 리시버를 사용해야 값이 유지되므로 주의**
- **에러 처리를 적절히 설계해야 안정적인 코드 작성 가능**