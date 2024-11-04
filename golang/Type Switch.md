## Type Switch
> 타입 스위치는 Go에서 인터페이스 값의 구체적인 타입을 확인하고, 그 타입에 맞게 다른 코드를 실핼할 수 있게 해주는 강력한 구문
> 타입 어서션(Type Assertion)의 확장 형태로, 여러 타입에 대해 한 번에 처리할 수 있는 방법을 제공

### 기본 구문
```go
switch v := i.(type) {
case T1:
    // i가 T1 타입일 때 실행될 코드
case T2:
    // i가 T2 타입일 때 실행될 코드
default:
    // i가 위에 나열된 타입이 아닐 때 실행될 코드
}
```
- `i.(type)`: 이 구문은 인터페이스 i의 실제 구체적인 타입을 확인합니다. 타입 스위치에서만 type 키워드를 사용할 수 있습니다.
- `v` := i.(type): 타입이 확인되면 그 값을 해당 타입으로 변환하여 v에 할당합니다.
- `case T1`, `case T2`: 각각 T1, T2 타입과 일치할 때 실행되는 코드입니다.
- `default`: i의 타입이 나열된 케이스들과 일치하지 않을 때 실행될 코드를 정의합니다.

### 예시
1. 기본 예시
```go
func describe(i interface{}) {
    switch v := i.(type) {
    case int:
        fmt.Printf("i는 정수입니다: %d\n", v)
    case string:
        fmt.Printf("i는 문자열입니다: %s\n", v)
    case bool:
        fmt.Printf("i는 불리언입니다: %t\n", v)
    default:
        fmt.Printf("i는 알 수 없는 타입입니다.\n")
    }
}

func main() {
    describe(42)         // 출력: i는 정수입니다: 42
    describe("hello")    // 출력: i는 문자열입니다: hello
    describe(true)       // 출력: i는 불리언입니다: true
    describe(3.14)       // 출력: i는 알 수 없는 타입입니다.
}
```
- 이 예시에서 describe 함수는 인터페이스 i의 타입을 확인한 후, 그에 맞는 메시지를 출력합니다. 정수(int), 문자열(string), 불리언(bool)일 때는 해당 타입의 값을 출력하고, 그 외의 경우에는 default 문이 실행됩니다.

2. 여러 케이스 처리
```go
func describe(i interface{}) {
    switch v := i.(type) {
    case int, float64:
        fmt.Printf("i는 숫자입니다: %v\n", v)
    case string:
        fmt.Printf("i는 문자열입니다: %s\n", v)
    default:
        fmt.Printf("i는 알 수 없는 타입입니다.\n")
    }
}

func main() {
    describe(42)         // 출력: i는 숫자입니다: 42
    describe(3.14)       // 출력: i는 숫자입니다: 3.14
    describe("hello")    // 출력: i는 문자열입니다: hello
}
```
- 여기서는 int와 float64 타입을 하나의 케이스로 처리하고 있습니다. 타입이 int이거나 float64이면 같은 로직이 실행됩니다

3. 타입이 구조체일 때
```go
type Dog struct {
    Name string
}

type Cat struct {
    Name string
}

func describeAnimal(i interface{}) {
    switch v := i.(type) {
    case Dog:
        fmt.Printf("이것은 개입니다. 이름: %s\n", v.Name)
    case Cat:
        fmt.Printf("이것은 고양이입니다. 이름: %s\n", v.Name)
    default:
        fmt.Println("알 수 없는 동물입니다.")
    }
}

func main() {
    describeAnimal(Dog{Name: "Buddy"}) // 출력: 이것은 개입니다. 이름: Buddy
    describeAnimal(Cat{Name: "Whiskers"}) // 출력: 이것은 고양이입니다. 이름: Whiskers
    describeAnimal("사자") // 출력: 알 수 없는 동물입니다.
}
```
- 여기서는 Dog와 Cat이라는 구조체 타입을 구별하고, 그에 따라 다른 출력을 합니다. 타입 스위치를 통해 특정 타입에 대해 맞춤형 처리가 가능하다는 것을 보여줍니다.

### 타입 스위치의 특징과 동작 방식
1. v := i.(type): 변수를 선언하며 사용
   - 타입 스위치에서는 i.(type)을 통해 구체적인 타입을 알아내고, 그 값을 해당 타입으로 자동으로 변환한 값을 v에 할당할 수 있습니다. 따라서, 각 케이스 내에서 타입에 맞는 변수를 직접 사용할 수 있습니다.
2. 타입 어서션과 비교
   - 타입 어서션은 하나의 타입만 검사할 수 있지만, 타입 스위치는 여러 타입을 한 번에 검사할 수 있습니다. 또한, 타입 어서션을 사용하는 방식보다 가독성과 유지보수성이 좋습니다.
3. 모든 인터페이스 값에 적용 가능
   - Go에서는 모든 값이 interface{}로 변환될 수 있습니다. 즉, interface{}를 인수로 받는 함수는 어떤 값이든 처리할 수 있으며, 타입 스위치를 사용하여 그 값의 구체적인 타입을 확인하고 맞는 처리를 할 수 있습니다.
4. 타입 스위치 내에서 모든 타입을 확인 가능
   - 타입 스위치는 Go의 컴파일 타임 타입 정보와 런타임 타입 정보가 결합된 구조 덕분에, 코드가 런타임 중 실제 값의 타입을 안전하게 확인할 수 있습니다.
5. 구체적인 타입과 인터페이스 타입 모두 검사 가능
   - 타입 스위치에서는 구체적인 타입뿐만 아니라 인터페이스 타입도 검사할 수 있습니다.
```go
type Animal interface {
    Speak() string
}

type Dog struct {}
func (d Dog) Speak() string { return "Woof!" }

type Cat struct {}
func (c Cat) Speak() string { return "Meow!" }

func describe(i interface{}) {
    switch v := i.(type) {
    case Animal:
        fmt.Println(v.Speak())
    case string:
        fmt.Printf("i는 문자열입니다: %s\n", v)
    default:
        fmt.Printf("i는 알 수 없는 타입입니다.\n")
    }
}

func main() {
    describe(Dog{})       // 출력: Woof!
    describe(Cat{})       // 출력: Meow!
    describe("hello")     // 출력: i는 문자열입니다: hello
}
```
- 여기서 Animal 인터페이스를 검사하여, Dog 또는 Cat 타입의 값이 들어오면 Speak() 메서드를 호출합니다.


### 결론
타입 스위치는 Go에서 인터페이스 값의 구체적인 타입을 확인하고, 각 타입에 맞는 동작을 정의할 때 매우 유용한 도구입니다. 여러 타입을 한 번에 처리할 수 있으며, 안전하게 런타임 타입 검사와 타입 변환을 지원합니다. Go 언어의 타입 시스템과 다형성을 활용하여 유연한 코드를 작성하는 데 매우 중요한 역할을 합니다.