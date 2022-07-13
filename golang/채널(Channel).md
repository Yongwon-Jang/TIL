## 채널(Channel)

- 고루틴끼리 정보를 교환하고 실행의 흐름을 동기화하기 위해 사용한다.

- 채널 선언

  - 채널 변수 선언 후 make() 함수로 채널 생성
  - 채널을 정의할 때는 chan 키워드로 채널을 통해 주고받을 데이터의 타임을 지정해주어야 한다.

  ```go
  // 채널 변수 선언 후 make() 함수로 채널 생성
  var ch chan string
  ch = make(chan string)
  
  // make() 함수로 채널 생성 후 바로 변수에 할당
  done := make(chan bool)
  ```

- 타입에 상관 없이 데이터를 주고 받으려면

  ```go
  chan interface{}
  
  // 채널의 타입을 interface{}로 지정하면 된다.
  ```

- 채널로 값을 주고받을 때는 <- 연산자 사용

  ```go
  ch <- “msg” // ch 채널에 “msg” 전송
  m := <- ch  // ch 채널로부터 메시지 수신
  ```

- 예제

  ```go
  package main
   
  import (
      "fmt"
      "time"
  )
   
  func main() {
      fmt.Println("main 함수 시작", time.Now())
     
      done := make(chan bool)
      go long(done)
      go short(done)
     
      <-done
      <-done
      fmt.Println("main 함수 종료", time.Now())
  }
   
  func long(done chan bool) {
      fmt.Println("long 함수 시작", time.Now())
      time.Sleep(3 * time.Second) // 3초 대기
      fmt.Println("long 함수 종료", time.Now())
      done <- true
  }
   
  func short(done chan bool) {
      fmt.Println("short 함수 시작", time.Now())
      time.Sleep(1 * time.Second) // 1초 대기
      fmt.Println("short 함수 종료", time.Now())
      done <- true
  }
  
  
  
  // 실행 결과
  main 함수 시작 2009-11-10 23:00:00 +0000 UTC
  long 함수 시작 2009-11-10 23:00:00 +0000 UTC
  short 함수 시작 2009-11-10 23:00:00 +0000 UTC
  short 함수 종료 2009-11-10 23:00:01 +0000 UTC
  long 함수 종료 2009-11-10 23:00:03 +0000 UTC
  main 함수 종료 2009-11-10 23:00:03 +0000 UTC
  ```

- 채널 사용 시 주의사항

  - 함수와 마찬가지로 채널도 값에 의한 호출 방식으로 값을 전달한다. 즉, 실제 값이 복사되어 전달되므로 bool, int, float64 등의 값을 전달하는 것은 안전하다. Go에서는 문자열과 배열도 변하지 않는 값이므로 채널의 값으로 사용해도 안전하다.
  - 포인터 변수나 참조 값(슬라이스, 맵)을 채널로 전달할 때는 주소 값이 전달되므로 값을 보내는 고루틴과 값을 받는 고루틴에서 값을 동시에 수정하면 예상치 못한 결과가 발생할 수 있다.
  - 그래서 포인터나 참조 값을 채널로 전달할 때는 여러 고루틴에서 값을 동시에 수정하지 않게 해야 한다. 가장 간단한 방법은 여러 고루틴에서 참조 값에 동시에 접근할 수 없게 뮤텍스로 제한하는 것이다.

- 버퍼드 채널

  - 채널을 생성할 때 버퍼의 크기를 정할 수 있다.

    ```go
    ch := make(chan int, 100)
    ```

- close 

  - 채널에 더 이상 전송할 값이 없으면 채널을 닫을 수 있다.

  - 채널을 닫은 후에 메시지를 전송하면 에러가 난다

  - 채널의 수신자는 채널에서 값을 읽을 때 채널이 닫힌 상태인지 아닌지 두 번째 매개변수로 확인할 수 있다.

    ```go
    v, ok := <-ch
    ```

    - ok 값이 false면 채널이 닫힌 상태

- range

  ```go
  for i := range c
  ```

  - 채널 c가 닫힐 때까지 반복하며 채널로부터 수신을 시도한다.

- select

  - 하나의 고루틴이 여러 채널과 통신할 때 사용

  ```go
  package main
   
  import “fmt”
   
  func fibonacci(c, quit chan int) {
      x, y := 0, 1
      for {
          select {
          case c <- x:
              x, y = y, x+y
          case <-quit:
              fmt.Println(“quit”)
              return
          }
      }
  }
   
  func main() {
      c := make(chan int)
      quit := make(chan int)
      go func() {
          for i := 0; i < 10; i++ {
              fmt.Println(<-c)
          }
          quit <- 0
      }()
      fibonacci(c, quit)
  }
  ```

  - select문에서 default 케이스를 지정하면 case애 지정된 모든 채널이 사용 가능 상태가 아닐 때 default 케이스를 수행한다.
  - default 케이스는 select 문에서 case의 채널들이 사용 가능 상태가 아닐 경우, 대기(block)하지 않고 바로 무언가를 처리해야 할 때 사용한다.