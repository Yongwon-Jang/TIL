## Command Line Argument

> - Go 프로그램의 main() 함수는 다른 언어 처럼 argument 파라미터를 가지고 있지 않아서 os.Args를 사용해야 한다.
>
> - os.Args 는 문자열 슬라이스로 정의되어 있고, Args는 프로그램의 Command Line 정보를 프로그램 명부터 순서대로 담고 있다.
> - 프로그램이 2개의 agrument를 가진다고 가정했을 때, os.Args[0:1]는 실행되는 Go 프로그램 이름을 가지며, os.Args[1:2]는 첫번째 argument os.Args[2:3]는 두번째 argument를 가진다.



- example

```go
package main
 
import ("fmt";  "os")
 
func main() {
    fmt.Println("args : ", os.Args[0:1])
	fmt.Println("args : ", os.Args[1:2])
    
  	mode1 := os.Args[1]
    mode2 := os.Args[2]

    if mode1 == "0" {
		if mode2 == "1" {
			start := time.Now()
			for i := 1; i <= cnt; i++ {
				id := uint64(i)
				err = Add(id, mode2, db)
			}
			end := time.Since(start)
			fmt.Println("Add 시간 : ", end)
		} else if mode2 == "2" {
			start := time.Now()
			for i := 1; i <= cnt; i++ {
				id := uint64(i)
				if err = Add2(db, func(*gorm.DB) error {
					err = Add(id, 0, db)
					return err
				}); err != nil {
					return
				}
			}
			end := time.Since(start)
			fmt.Println("Add(cdm) 시간 : ", end)
		}
	}
```