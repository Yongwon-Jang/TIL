## Golang 파일 쓰기

```go
import (
    "fmt"
    "os"
)

func errCheck1(e error) {
    if e != nil {
        fmt.Println(error)
    }
}

func main() {
    // 파일 쓰기 예제
    file, err := os.Create("test_write.txt")
    errCheck1(err)
    // 리소스 해제
    defer file.Close()
    
    // 쓰기 예제1
    s1 := []byte{777, 778, 779, 780, 781}
    nq, err := file.Write([]byte(s1)) // 문자열 -> byte 슬라이스 형으로 변환 후 쓰기
    
    
}
```

