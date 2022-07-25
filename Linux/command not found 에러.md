### $'make\r': command not found

- Linux에서 shell script 파일을 돌리다가 다음과 같은 에러를 발견 했다.

```bash
start.sh: line 2: $'make\r': command not found
```

이런 오류는 윈도우에서 작성 된 스크립트를 리눅스에서 실행하려 할 때 발생할 수 있다.

윈도우와 리눅스에서 사용하는 개행문자가 달라서 발생하는 오류

`윈도우 에서는 줄 바꿈을 \r\n 리눅스에서는 \n 을 사용해서 문제가 발생`



#### 해결법

- sed 명령어 사용

```bash
$ sed -i 's/\r$//' 파일명
```

위 명령어를 수행시 \r 이 전부 치환되어 스크립트가 정상 수행된다.