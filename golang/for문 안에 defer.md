## For문 안에 Defer 가 있으면 어떻게 동작할까?

- `defer` 를 익명 함수 안에 캡슐화하거나 루프 내에서 한 번 호출하면, defer가 루프 반복마다 실행된다.
- 루프 내에서 defer를 사용하되 **익명 함수 없이 단순히 defer file.Close()** 를 사용하면, 파일 핸들은 함수의 종료 시점에 모두 닫힌다. 

### 예제
```go
package main

import (
	"fmt"
	"os"
)

func main() {
	// 샘플 파일 생성
	for i := 1; i <= 5; i++ {
		fileName := fmt.Sprintf("test_file_%d.txt", i)
		err := os.WriteFile(fileName, []byte("Test content"), 0644)
		if err != nil {
			fmt.Printf("Error creating file %s: %v\n", fileName, err)
		}
	}

	fmt.Println("=== Using defer inside the loop (unsafe) ===")
	testDeferUnsafe()

	fmt.Println("\n=== Using defer with immediate closure (safe) ===")
	testDeferSafe()

	// 테스트 후 파일 삭제
	for i := 1; i <= 5; i++ {
		fileName := fmt.Sprintf("test_file_%d.txt", i)
		_ = os.Remove(fileName)
	}
}

// 함수 종료 시 닫힘: 파일이 닫히는 시점 확인
func testDeferUnsafe() {
	for i := 1; i <= 5; i++ {
		fileName := fmt.Sprintf("test_file_%d.txt", i)

		// 파일 열기
		file, err := os.Open(fileName)
		if err != nil {
			fmt.Printf("Error opening file %s: %v\n", fileName, err)
			continue
		}

		// defer로 파일 닫기 예약
		defer func(f *os.File) {
			fmt.Printf("Closing file (unsafe): %s\n", f.Name())
			f.Close()
		}(file)

		// 파일 사용
		fmt.Printf("Processing file (unsafe): %s\n", fileName)
	}
}

// 즉시 닫힘: 파일이 닫히는 시점 확인
func testDeferSafe() {
	for i := 1; i <= 5; i++ {
		fileName := fmt.Sprintf("test_file_%d.txt", i)

		// 파일 열기
		file, err := os.Open(fileName)
		if err != nil {
			fmt.Printf("Error opening file %s: %v\n", fileName, err)
			continue
		}

		// defer로 즉시 닫기
		func(f *os.File) {
			defer func() {
				fmt.Printf("Closing file (safe): %s\n", f.Name())
			}()
			// 파일 사용
			fmt.Printf("Processing file (safe): %s\n", fileName)
		}(file)
	}
}

```
#### 출력
```
=== Using defer inside the loop (unsafe) ===
Processing file (unsafe): test_file_1.txt
Processing file (unsafe): test_file_2.txt
Processing file (unsafe): test_file_3.txt
Processing file (unsafe): test_file_4.txt
Processing file (unsafe): test_file_5.txt
Closing file (unsafe): test_file_5.txt
Closing file (unsafe): test_file_4.txt
Closing file (unsafe): test_file_3.txt
Closing file (unsafe): test_file_2.txt
Closing file (unsafe): test_file_1.txt

=== Using defer with immediate closure (safe) ===
Processing file (safe): test_file_1.txt
Closing file (safe): test_file_1.txt
Processing file (safe): test_file_2.txt
Closing file (safe): test_file_2.txt
Processing file (safe): test_file_3.txt
Closing file (safe): test_file_3.txt
Processing file (safe): test_file_4.txt
Closing file (safe): test_file_4.txt
Processing file (safe): test_file_5.txt
Closing file (safe): test_file_5.txt

```