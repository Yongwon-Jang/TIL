## Goroutine

- Go 프로그램 안에서 동시에 독립적으로 실행되는 흐름의 단위로, 스레드와 비슷한 개념

- 다음과 같이 go 키워드로 함수를 실행하면 새 고루틴이 만들어진다.

  ```go
  go f(x, y)
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
      
      go long()
      go short()
       
      time.Sleep(5 * time.Second) // 5초 대기
      fmt.Println("main 함수 종료", time.Now())
  }
   
  func long() {
      fmt.Println("long 함수 시작", time.Now())
      time.Sleep(3 * time.Second) // 3초 대기
      fmt.Println("long 함수 종료", time.Now())
  }
   
  func short() {
      fmt.Println("short 함수 시작", time.Now())
      time.Sleep(1 * time.Second) // 1초 대기
      fmt.Println("short 함수 종료", time.Now())
  }
  
  
  실행 결과
  
  main 함수 시작 2009-11-10 23:00:00 +0000 UTC
  long 함수 시작 2009-11-10 23:00:00 +0000 UTC
  short 함수 시작 2009-11-10 23:00:00 +0000 UTC
  short 함수 종료 2009-11-10 23:00:01 +0000 UTC
  long 함수 종료 2009-11-10 23:00:03 +0000 UTC
  main 함수 종료 2009-11-10 23:00:05 +0000 UTC
  ```

- 사용시 주의사항

  - 실행 중인 고루틴이 있어도 메인 함수가 종료되면 프로그램이 종료된다.
    - 아직 실행 중인 고루틴이 있다면 메인 함수가 종료되지 않게 해야 한다.
    - 고루틴의 종료상황을 확인할 수 있는 채널을 만들고, 만든 채널을 통해 종료 메시지를 대기시키는 방법을 추천
