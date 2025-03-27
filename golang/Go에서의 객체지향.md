### **객체지향 프로그래밍(OOP, Object-Oriented Programming)**
객체지향 프로그래밍은 **객체(Object)** 를 중심으로 소프트웨어를 설계하고 개발하는 프로그래밍 패러다임이다.  
객체는 **데이터(속성, 필드)와 해당 데이터를 조작하는 함수(메서드)** 를 함께 포함하는 독립적인 단위이다.

---

## **📌 객체지향의 4가지 핵심 개념**
1. **캡슐화(Encapsulation)**
    - 데이터를 외부에서 직접 접근하지 못하도록 보호하고, 필요한 인터페이스만 제공하는 개념
    - `private`, `public`, `protected` 등의 접근 제어자를 사용

2. **상속(Inheritance)**
    - 기존 클래스를 확장하여 새로운 클래스를 만들 수 있는 기능
    - 코드 재사용성을 높이고 유지보수를 용이하게 함

3. **다형성(Polymorphism)**
    - 같은 인터페이스나 메서드를 여러 방식으로 구현할 수 있는 개념
    - 오버라이딩(메서드 재정의)과 오버로딩(메서드 다중 정의)이 있음

4. **추상화(Abstraction)**
    - 객체의 핵심적인 부분만 노출하고, 불필요한 부분은 숨기는 개념
    - 인터페이스와 추상 클래스를 통해 구현

---

## **📌 OOP의 대표적인 예제 (Go 언어)**
Go는 클래스를 지원하지 않지만 **구조체(struct)와 메서드** 를 사용하여 객체지향 프로그래밍을 할 수 있다.

### **1️⃣ 캡슐화 (Encapsulation)**
```go
package main

import "fmt"

// Person 구조체 정의
type Person struct {
	name string
	age  int
}

// 메서드를 통해 private 속성 접근 (Getter)
func (p *Person) GetName() string {
	return p.name
}

// 메서드를 통해 private 속성 수정 (Setter)
func (p *Person) SetName(newName string) {
	p.name = newName
}

func main() {
	p := Person{name: "Alice", age: 25}
	fmt.Println("Before:", p.GetName())

	p.SetName("Bob")
	fmt.Println("After:", p.GetName()) // Bob
}
```
✅ **접근제한**
- `name`, `age` 필드는 소문자로 시작하여 **패키지 외부에서 접근 불가**
- `GetName()`, `SetName()` 메서드 제공하여 데이터 보호

---

### **2️⃣ 상속 (Inheritance)**
Go에는 직접적인 `class` 상속이 없지만, **구조체를 포함(embedding)** 하는 방식으로 상속을 구현할 수 있다.
```go
package main

import "fmt"

// 부모 구조체 (Base)
type Animal struct {
	Name string
}

// 부모 메서드
func (a *Animal) Speak() {
	fmt.Println(a.Name, "makes a sound")
}

// 자식 구조체 (Dog) → Animal을 포함 (구조체 임베딩)
type Dog struct {
	Animal
	Breed string
}

// 메서드 오버라이딩 (재정의)
func (d *Dog) Speak() {
	fmt.Println(d.Name, "barks!")
}

func main() {
	// 부모 객체
	animal := Animal{Name: "Some Animal"}
	animal.Speak()

	// 자식 객체
	dog := Dog{Animal: Animal{Name: "Buddy"}, Breed: "Golden Retriever"}
	dog.Speak()
}
```
✅ **결과**
```
Some Animal makes a sound
Buddy barks!
```
- `Dog` 구조체는 `Animal`을 포함하고 있어서 **Animal의 필드와 메서드를 상속** 받을 수 있음
- `Speak()` 메서드를 오버라이딩하여 `Dog`만의 동작을 정의

---

### **3️⃣ 다형성 (Polymorphism)**
Go에서는 **인터페이스(interface)** 를 사용하여 다형성을 구현할 수 있다.
```go
package main

import "fmt"

// 인터페이스 정의
type Speaker interface {
	Speak()
}

// 구조체 1
type Cat struct {
	Name string
}

func (c Cat) Speak() {
	fmt.Println(c.Name, "meows!")
}

// 구조체 2
type Dog struct {
	Name string
}

func (d Dog) Speak() {
	fmt.Println(d.Name, "barks!")
}

// 다형성을 활용한 함수
func MakeSound(s Speaker) {
	s.Speak()
}

func main() {
	cat := Cat{Name: "Whiskers"}
	dog := Dog{Name: "Fido"}

	MakeSound(cat) // Whiskers meows!
	MakeSound(dog) // Fido barks!
}
```
✅ **결과**
```
Whiskers meows!
Fido barks!
```
- `Cat`와 `Dog`가 `Speaker` 인터페이스를 구현
- `MakeSound()` 함수는 `Speaker` 인터페이스를 받아 다형성을 적용

---

### **4️⃣ 추상화 (Abstraction)**
추상화를 통해 **불필요한 내부 구현을 숨기고, 핵심 기능만 제공** 한다.
```go
package main

import "fmt"

// 인터페이스 정의 (추상화)
type Shape interface {
	Area() float64
}

// 구조체 1 (Rectangle)
type Rectangle struct {
	Width, Height float64
}

func (r Rectangle) Area() float64 {
	return r.Width * r.Height
}

// 구조체 2 (Circle)
type Circle struct {
	Radius float64
}

func (c Circle) Area() float64 {
	return 3.14 * c.Radius * c.Radius
}

// 추상화된 함수
func PrintArea(s Shape) {
	fmt.Println("Area:", s.Area())
}

func main() {
	rect := Rectangle{Width: 10, Height: 5}
	circle := Circle{Radius: 7}

	PrintArea(rect)   // Area: 50
	PrintArea(circle) // Area: 153.86
}
```
✅ **핵심 포인트**
- `Shape` 인터페이스를 사용해 다양한 도형(`Rectangle`, `Circle`)을 추상화
- `PrintArea()` 함수는 `Shape` 인터페이스를 받아 다형성을 제공

---

## **📌 OOP 정리**
| 개념       | 설명 | Go 예제 |
|------------|---------------------------|----------------------------|
| **캡슐화** | 데이터 보호, Getter/Setter 사용 | `private` 필드와 메서드 |
| **상속** | 구조체 임베딩(Embedding) | `struct 포함` 방식 |
| **다형성** | 같은 메서드를 여러 방식으로 사용 | `interface` 활용 |
| **추상화** | 불필요한 내부 구현 숨김 | `interface + 메서드` |

✅ **Go에서는 클래스를 사용하지 않지만, `struct`, `interface`, `method`를 활용하여 OOP를 구현할 수 있음!** 🚀