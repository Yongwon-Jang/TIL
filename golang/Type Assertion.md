## Type Assertion
> 인터페이스 값을 특정 구체적인 타입으로 변환하려 할 때 사용하는 문법


### 기본 문법
```go
value := i.(T)
```
- i: 인터페이스 값입니다. 여기에는 어떤 값이든 들어갈 수 있습니다.
- T: 타입 어서션에서 확인하고자 하는 구체적인 타입입니다.
- value: i가 T 타입일 때, 그 값을 반환합니다.

- 안전한 방식
```go
value, ok := i.(T)
```
- value: i가 T 타입이면 그 값을 반환합니다. 그렇지 않으면 T 타입의 제로 값이 반환됩니다.
- ok: 타입 어서션이 성공했는지를 나타내는 bool 값입니다. 성공하면 true, 실패하면 false입니다.

### 예시

```go
var i interface{} = "hello"

s, ok := i.(string)
if ok {
    fmt.Println(s)  // 타입 어서션이 성공하면 출력: hello
} else {
    fmt.Println("타입 변환 실패")
}

n, ok := i.(int)
if !ok {
    fmt.Println("타입 변환 실패")  // i는 int가 아니므로 실패: 출력: 타입 변환 실패
}
```
- 이 경우 i가 string이므로 첫 번째 타입 어서션에서는 성공하고 ok가 true가 됩니다. 두 번째 경우는 i가 int가 아니므로 ok는 false가 됩니다.

- 패닉 발생하는 경우
```go
var i interface{} = "hello"
n := i.(int)  // 패닉 발생: 인터페이스는 int가 아님
fmt.Println(n)

```
- 타입 어서션을 사용할 경우, 타입이 일치하지 않으면 패닉이 발생합니다.
- 위 코드에서 i는 실제로 string 타입인데 int로 타입 어서션을 시도하면 패닉이 발생하여 프로그램이 강제로 종료됩니다.
- 이런 이유로 안전한 방식(즉, ok 값을 함께 사용하는 방식)이 더 많이 사용됩니다.


### 타입 어서션이 필요한 경우
- Go는 인터페이스가 매우 강력하고 유연하게 설계된 언어입니다. 인터페이스는 특정 메서드 집합을 만족하는 타입이라면 그 타입이 무엇이든 저장할 수 있지만, 인터페이스에 저장된 값은 구체적인 타입 정보가 숨겨져 있기 때문에, 해당 값을 다시 구체적인 타입으로 사용하려면 타입 어서션이 필요합니다.

```go
type MyInterface interface {
    DoSomething()
}

type MyStruct struct{}

func (m MyStruct) DoSomething() {
    fmt.Println("Doing something!")
}

var i MyInterface = MyStruct{}

s, ok := i.(MyStruct)  // 타입 어서션을 통해 구체적인 타입으로 변환
if ok {
    s.DoSomething()    // MyStruct 타입으로 변환되었기 때문에 메서드 호출 가능
}
```
- 이 예에서 i는 MyInterface 타입이지만 실제로는 MyStruct를 담고 있습니다. 타입 어서션을 통해 i가 MyStruct라는 것을 확인하고 변환한 후, MyStruct에 정의된 메서드를 호출할 수 있습니다.
- 타입 어서션과 함께 많이 사용되는 기능은 **타입 스위치(Type Switch 입니다.)**