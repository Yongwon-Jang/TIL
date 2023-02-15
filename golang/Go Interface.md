##  Go Interface

> Golang에서 Interface는 구현화된 객체가 아닌 추상화된 상호 작용으로, 관계를 표현하는데 사용된다.

#### 선언

```go
type SampleInterface interface {
    SampleMethod()
}
```

- `type` 을 사용하여 인터페이스를 선언
- 인터페이스 안에는 구현이 없는 메서드(메서드명, 파라메터, 리턴 타입만 선언)를 선언
- 인터페이스도 하나의 타입이며 인터페이스를 변수로 선언할 수 있다.

```go
var s SampleInterface
fmt.Println(s)

# nil
```



#### 인터페이스 규칙

- 메서드는 반드시 메서드 명이 있어야 한다.
- 매개 변수와 반환이 다르더라도 이름이 같은 메서드는 있을 수 없다.
- 인터페이스에서는 메서드 구현을 포함하지 않는다.

```go
type SampleInterface interface {
  String() string
  String(a int) string // Error: duplicated method name
  _(x int) int         // Error: no name method
}
```



#### example

```go
package main

import (
    "fmt"
)

type Human interface {
    Walk() string
}

type Student struct {
    Name string
    Age int
}

func (s Student) Walk() string {
    return fmt.Sprintf("%s can walk", s.Name)
}

func (s Student) GetAge() int {
    return s.Age
}

func main() {
    s := Student{Name: "Jhon", Age: 20}
    var h Human
    
    h = s
    fmt.Println(h.Walk())
    // fmt.PrintLn(h.GetAge()) -> Error
    // Human 변수는 Walk라는 함수를 가지고 있으므로 Human 변수의 Walk 함수를 호출하는 것이 가능하지만, GetAge 함수를 호출 할 수는 없다.
}


결과
John can walk
```



#### Embedded interface

- 인터페이스는 다음과 같이 인터페이스를 포함 할 수 있다.

```go
type Reader interface {
  Read() (n int, err error)
  Close() error
}

type Writer interface {
  Write() (n int, err error)
  Close() error
}

type ReadWriter interface {
  Reader
  Writer
}
```





#### 참조

- https://dev-yakuza.posstree.com/ko/golang/interface/