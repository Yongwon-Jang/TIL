## Golang Socket

#### server.go

```go
package main

import (
	"io"
	"log"
	"net"
)

func Serve(c net.Conn) {
	recvBuf := make([]byte, 4096) // 배열 만들고
	for {
		n, err := c.Read(recvBuf) // client 가 값을 줄때까지 blocking 되어 대기하다가 값을 주면 읽는다.
		if err != nil {
			if io.EOF == err {
				log.Println(err)
				return
			}
			log.Println(err)
			return
		}
		if n > 0 {
			data := recvBuf[:n]
			log.Println(string(data))
			_, err = c.Write(data[:n])
			if err != nil {
				log.Println(err)
				return
			}
		}
	}
}

func main() {
	// net.Listen 함수로 8080번 포트로 "tcp" 서버를 개설
	l, err := net.Listen("tcp", ":8080")
	if nil != err {
		log.Println(err)
	}
	defer l.Close()

	for {
		c, err := l.Accept() // 사용자의 접속을 대기 -> 사용자가 접속하면 해당 커넥션을 고루틴 함수로 보낸다
		if err != nil {
			log.Println(err)
			continue
		}
		defer c.Close()
		go Serve(c)
	}
}
```



#### client.go

```go
package main

import (
	"log"
	"net"
	"os"
	"time"
)

func main() {
	c, err := net.Dial("tcp", ":8080") // 서버와 연결을 시도
	if err != nil {
		log.Println(err)
	}

	// 고루틴을 생성해 서버가 값을 던질때까지 기다렷다가 던지면 값을 출력
	go func() {
		data := make([]byte, 4096)

		for {
			n, err := c.Read(data)
			if err != nil {
				log.Println(err)
				return
			}

			log.Println("Server send: " + string(data[:n]))
			time.Sleep(time.Duration(3) * time.Second)
		}
	}()

	// 사용자의 입력이 들어올때까지 blocking 했다가 입력을 마치면 서버로 전송
	for {
		var s string
		fmt.Scanln(&s)
		c.Write([]byte(s))
		time.Sleep(time.Duration(3) * time.Second)
	}
}

```

다음은 위 예제에 사용된 함수들이다.

- `func Listen(net, laddr string) (Listener, error)` : 프로토콜, IP 주소, 포트 번호를 설정하여 네트워크 연결을 대기.
- `func (I *TCPListener) Accept() (Conn, error)` : 클라이언트가 연결되면 커넥션을 리턴.
- `func (I *TCPListener) Close() error` : TCP 연결 대기를 닫음.
- `func Dial(net, address string) (Conn, error)`: 프로토콜, IP 주소, 포트 번호를 설정하여 서버에 연결.
- `func (c *TCPConn) Close() error` : TCP 연결을 닫음.
- `func (c *TCPConn) Read(b []byte)(int, error)` : 받은 데이터를 읽음.
- `func (c *TCPConn) Write(b []byte)(int, error)` : 데이터를 보냄.







#### 참조

- https://codereader37.tistory.com/110
- https://kamang-it.tistory.com/entry/golanggotcpgo%EC%96%B8%EC%96%B4%EC%97%90%EC%84%9C-tcp%EC%86%8C%EC%BC%93%EC%9C%BC%EB%A1%9C-%ED%86%B5%EC%8B%A0%ED%95%98%EA%B8%B0
