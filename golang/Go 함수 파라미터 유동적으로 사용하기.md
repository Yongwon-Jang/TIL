## Go 함수 파라미터 유동적으로 사용하기

#### 1. 가변 파라미터(variable parameter)

- 함수의 마지막 파라미터를 `[]interface{}` 형태로 선언하여, 여러 개의 값을 전달할 수 있도록 한다.

```go
func sum(a, b int, c ...int) int {
    // c는 가변 파라미터
    for _, v := range c {
        a += v
    }
    return a + b
}

// 사용 예시
fmt.Println(sum(1, 2, 3, 4, 5)) // 15
fmt.Println(sum(1, 2, 3)) // 6
```



#### 2. 슬라이트 파라미터(slice)

- 함수의 마지막 파라미터를 `[]int` 형태로 선언하여, 여러 개의 값을 전달할 수 있도록 한다.

```go
func sum(a, b int, c []int) int {
    for _, v := range c {
        a += v
    }
    return a + b
}

// 사용 예시
fmt.Println(sum(1, 2, []int{3, 4, 5})) // 15
fmt.Println(sum(1, 2, []int{3})) // 6
```



#### 3. 맵 파라미터(map)

- 함수의 마지막 파라미터를 `map[string]int` 형태로 선언하여, 여러 개의 값을 전달할 수 있도록 한다.

```go
func sum(a, b int, c map[string]int) int {
    for _, v := range c {
        a += v
    }
    return a + b
}

// 사용 예시
fmt.Println(sum(1, 2, map[string]int{"c": 3, "d": 4, "e": 5})) // 15
fmt.Println(sum(1, 2, map[string]int{"c": 3})) // 6
```

