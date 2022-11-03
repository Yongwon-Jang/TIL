## Go 정규표현식

> 정규표현식은 일정한 규칙을 가진 문자열을 표현하는 방법이다. 많은 문자열 속에서 특정한 규칙을 가진 문자열을 추출하거나, 문자열이 정해진 규칙에 맞는지 판별할 때 사용하다.

- Go 언어는 기본 패키지에서 정규표현식을 지원한다.

  - regexp 패키지에서 제공하는 정규표현식 검사 함수

  ```go
  func MatchString(pattern string, s string) (matched bool, err error)
  // 문자열이 정규표현식에 맞는지 검사
  ```

  

#### 예제

- 영어 및 숫자

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	matched, _ := regexp.MatchString("He", "Hello 100")
	fmt.Println(matched) // true: Hello 100에 He가 포함되므로 true

	matched, _ = regexp.MatchString("H.", "Hi")
	fmt.Println(matched) // true: H 뒤에 글자가 하나가 있으므로 true

	matched, _ = regexp.MatchString("[a-zA-Z0-9]+", "Hello 100")
	fmt.Println(matched) // true: Hello 100은 a부터 z까지, A부터 Z까지 0부터 9까지에 포함되므로 true

	matched, _ = regexp.MatchString("[a-zA-Z0-9]*", "")
	fmt.Println(matched) // true: *는 값이 하나도 안나와도 되므로 true

	matched, _ = regexp.MatchString("[0-9]+-[0-9]+", "1-1")
	fmt.Println(matched) // true: 1-1는 [0-9]+와 - 그리고 [0-9]+가 합쳐진 것이므로 true

	matched, _ = regexp.MatchString("[0-9]+-[0-9]+", "1-")
	fmt.Println(matched) // false: 1-는 [0-9]+와 -만 있으므로 false

	matched, _ = regexp.MatchString("[0-9]+/[0-9]*", "1/")
	fmt.Println(matched) // true: 1/는 [0-9]+와 /가 있음. *는 값이 없어도 되므로 true

	matched, _ = regexp.MatchString("[0-9]+\\+[0-9]*", "1+")
	fmt.Println(matched) // true: 1+는 [0-9]+와 +가 있음. *는 값이 없어도 되므로 true

	matched, _ = regexp.MatchString("[^A-Z]+", "hello")
	fmt.Println(matched) // true: hello는 A부터 Z까지에 포함되지 않으므로 true
}
```

- 한글

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	matched, _ := regexp.MatchString("[가-힣]+", "안녕하세요")
	fmt.Println(matched) // true

	matched, _ = regexp.MatchString("홍[가-힣]+동", "홍길동")
	fmt.Println(matched) // true

	matched, _ = regexp.MatchString("이재[홍-훈]", "이재홍")
	fmt.Println(matched) // true
}
```

- 특정 문자열이 맨 앞 혹은 맨 뒤에 오는지 확인
  - `^` 는 문자열이 맨 앞에 오는지 검사
  - `$` 는 문자열이 맨 뒤에 오는지 검사

```go
package main

import (
	"fmt"
	"regexp"
)

func main() {
	var matched, _ = regexp.MatchString("^Hello", "Hello, world!")
	fmt.Println(matched) // true: Hello, world!에서 Hello가 맨 앞에 오므로 true

	matched, _ = regexp.MatchString("^Hello", "Go Hello, world!")
	fmt.Println(matched) // false: Go Hello, world!에서 Hello가 맨 앞에 오지 않으므로 false

	matched, _ = regexp.MatchString("world!$", " Hello, world!")
	fmt.Println(matched) // true: Hello, world!에서 world!가 맨 뒤에 오므로 true

	matched, _ = regexp.MatchString("\\.[a-zA-Z]+\\([0-9]+\\)$", "Hello.SetValue(20)")
	fmt.Println(matched) // true: Hello.SetValue(20)는 .영문(숫자)이므로 true

	matched, _ = regexp.MatchString("\\.[a-zA-Z]+\\([0-9]+\\)$", "Hello.SetValue(20).x")
	fmt.Println(matched) // false: Hello.SetValue(20).x는 .영문(숫자)가 아니므로 false
}
```

