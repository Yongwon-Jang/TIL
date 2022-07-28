## Golang 실행 시간 측정

>  프로그램의 성능을 확인하기 위해 실행시간을 측정해야 할 때가 있다. 이번에는 Golang에서 코드가 실행되는데 걸리는 시간을 측정하는 방법을 알아보자.

#### time 패키지 사용

```go
import (
    "time"
)
```

- time 패키지는 시간을 표현하기 위한 Time 타입을 제공한다. 나노초 단위의 정밀도를 가진 구조체인데 세가지의 프로퍼티를 가진다

```go
type Time struct {
	wall uint64
    ext int64
    loc *Location
}
```

- 위 세가지의 프로퍼티의 정확한 쓰임새를 이해하지는 못했지만 time 패키지를 사용하는데는 아무런 문제가 없다.



#### 2. 시간 측정

- time 패키지는 많은 기능을 제공해주지만 실행 시간 측정을 위해서는 다음 2가지만 알면 된다
  - `time.Now()`, `time.Since()`
  - `time.Now()` 부터 `time.Since()`까지의 시간을 측정할 수 있다.
- 예시

```go
package main

import (
	"fmt"
	"time"
)

func main() {
	// 여기서 부터 시간 측정 시작
	start := time.Now()

	for i := 1; i <= 15; i++ {
		time.Sleep(1)
	}

	// end 까지 걸린 시간을 측정
	end := time.Since(start)
	fmt.Printf("실행시간 : %s\n", end)
}
```



### Goroutine 시간 측정

- goroutine을 사용하면 위의 방법으로 시간을 측정할 수 없다.
  - 고루틴 함수가 진행되는 도중에 end가 측정되버리기 때문

#### sync 패키지 사용

```go
import (
    "time"
    "sync"
)
```

- sync 패키지를 사용하면 고루틴이 끝날때 까지 기다린 후 시간을 측정할 수 있다.
  - `sync.WaitGroup`를 사용
  - 고루틴이 시작 될 때 `wg.Add(1)`로 WaitGroup에 진행중인 고루틴 갯수를 추가하고 고루틴이 끝날때 마다 `wg.Done()`로 WaitGroup에 진행중인 고루틴 갯수를 하나씩 줄인다. `wg.Wait()`를 이용해 WaitGroup에서 모든 고루틴이 끝날때 까지 기다렸다가 시간측정을 한다.
- 예시

```go
package main

import (
	"fmt"
	"time"
    "sync"
)

// WaitGroup
var wg sync.WaitGroup

func main() {
	// 여기서 부터 시간 측정 시작
	start := time.Now()
    
	// wg.Add : WaitGroup 에 대기 중인 고루틴 갯수 추가
    for i := 0; i < 10; i++ {
         wg.Add(1)
    	go func(idx int) {
        // 고루틴 함수가 한번 끝날 때 마다 WaitGroup 에 대기 중인 고루틴 갯수를 하나씩 뺀다.
            defer wg.Done()
            for j := 0; j <= 100; j++ {
                fmt.Println(j)
            }
        }()
    }
    
    // 모든 고루틴이 종료될 때까지 기다렸다가
    wg.Wait()   
	// end 까지 걸린 시간을 측정
	end := time.Since(start)
	fmt.Printf("실행시간 : %s\n", end)
}
```



