## Golang make() 함수를 이용한 슬라이스 선언

- `make(슬라이스 타입, 슬라이스 길이, 슬라이스 용량)`형태로 선언 할 수 있다.

  - 이 때 용량(Capacity)은 생략해서 선언할 수 있다.
  - 용량을 생략한다면, 슬라이스 길이와 똑같은 값으로 선언

- 슬라이스 길이와 용량

  > 슬라이스는 배열의 길이가 동적으로 늘어날 수 있기 때문에 길이와 용량을 구분한다.

  - 길이
    - 초기화된 슬라이스 요소 갯수
    - 슬라이스에 5개 값이 초기화 된다면 길이는 5가 된다.
    - 그 후에 값을 추가하거나 삭제하면 그만큼 길이가 바뀐다.
  - 용량
    - 예를들어 야유회를 가기위해 125명이 모이고 25인승 버스를 대절했다고 치면 여기서 모인 인원 125명은 **길이**이고 버스가 한번에 태울 수 있는 승객은 **용량** 이다.
    - 선언한 슬라이스의 용량이 25인데 101개의 값을 초기화 하기 위해서는 125의 용량이 필요한다.

#### 슬라이스 추가, 병합, 복사

##### `append()` 함수를 이용해 슬라이스에 데이터를 추가 할 수 있다.

- 예시

```go
package main
 
import "fmt"
 
func main() {
    sliceA := []int{1, 2, 3}
    sliceB := []int{4, 5, 6}
 
    sliceA = append(sliceA, sliceB...)
    //sliceA = append(sliceA, 4, 5, 6)
 
    fmt.Println(sliceA) // [1 2 3 4 5 6] 출력
}
```

##### `copy()`  함수를 이용해 한 슬라이스를 다른 슬라이스로 복사 할 수 있다.

- 예시

```go
package main

import "fmt"

func main() {
	sliceA := []int{0, 1, 2}
	sliceB := make([]int, len(sliceA), cap(sliceA)*2) //sliceA에 2배 용량인 슬라이스 선언

	copy(sliceB, sliceA)                              //A를 B에 붙여넣는다

	fmt.Println(sliceB)                               // [0 1 2 ] 출력
	println(len(sliceB), cap(sliceB))                 // 3, 6 출력
}
```

##### `:=`를 이용하면 슬라이스의 부분만 잘라서 복사 할 수 있다.

- 예시

```go
package main

import "fmt"

func main() {
	c := make([]int, 0, 3) //용량이 3이고 길이가0인 정수형 슬라이스 선언
	c = append(c, 1, 2, 3, 4, 5, 6, 7)
	fmt.Println(len(c), cap(c))

	l := c[1:3] //인덱스 1요소부터 2요소까지 복사
	fmt.Println(l)

	l = c[2:] //인덱스 2요소부터 끝까지 복사
	fmt.Println(l)

	l[0] = 6

	fmt.Println(c) //슬라이스 l의 값을 바꿨는데 c의 값도 바뀜
	//값을 복사해온 것이 아니라 기존 슬라이스 주솟값을 참조
}
```





#### 참조

- https://edu.goorm.io/learn/lecture/2010/%ED%95%9C-%EB%88%88%EC%97%90-%EB%81%9D%EB%82%B4%EB%8A%94-%EA%B3%A0%EB%9E%AD-%EA%B8%B0%EC%B4%88/lesson/81406/%EC%8A%AC%EB%9D%BC%EC%9D%B4%EC%8A%A4-slice