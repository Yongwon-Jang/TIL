## Go type 체크

- 함수 에서 interface 를 인자로 받으면 어떠한 타입이라도 매개변수로 받을 수있다. (유연하게 사용 가능)

```go
func test(arg interface{}) {
    
}
```

- 이런 식으로 빈 인터페이스는 어떠한 자료형도 전달 받을 수 있고, 응용하기 위해서는 type을 check 하는 함수가 있으면 좋다.

```go
func main() {
	// 실제 타입 검사 switch
	// 빈 인터페이스는 어떠한 자료형도 전달 받을 수 있으므로, 타입 체크를 통해 형 변환 후 사용 가능

	// 예제1
	checkType(true)
	checkType(1)
	checkType(22.542)
	checkType(nil)
	checkType("Hello World!")
}

func checkType(arg interface{}) {
	// arg.(type) 을 통해서 현재 데이터형 반환
	switch arg.(type) {
	case bool:
		fmt.Println("This os a bool", arg)
	case int, int8, int16, int32, int64:
		fmt.Println("This os a int", arg)
	case float64:
		fmt.Println("This os a float", arg)
	case string:
		fmt.Println("This os a string", arg)
	case nil:
		fmt.Println("This os a nil", arg)
	default:
		fmt.Println("What is this type?", arg)
	}
}
```

