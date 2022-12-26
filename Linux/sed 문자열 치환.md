## sed 문자열 치환

> sed는 stream editor 의 줄인말로 스트림 편집기를 의미한다. 주로 문자열을 치환하거나 삭제할 때 유용하게 사용할 수 있는 명령어이다.



#### sed 명령어 사용법

```
# sed -i 's/원본문자열/바꿀문자열/gi' 파일명
```

- `-i` 는 원본파일을 수정하기 위한 옵션
- `s`는 치환을 하겠다는 subcommand
- `g` 는 전체 문자열을 대상으로 진행하겠다는 의미
  - `gi` 는 대소문자 구분없이 치환 할 수 있다.

- 치환하여 새로운 파일로 저장하고 싶으면

  ```
  # sed 's/원본문자열/바꿀문자열/gi' 파일명 >> 새로운 파일명
  ```

  

#### 예시

```
# cat text.txt
Good Morning Man!
see you soon
good bye man
```

- `sed -i 's/man/bro/gi' text.txt`

```
# cat text.txt
Good Morning Man!
see you soon
good bye man
```

- 치환 하여 새로운 파일로 저장

```
# sed 's/man/bro/gi' text.txt > new-text
```