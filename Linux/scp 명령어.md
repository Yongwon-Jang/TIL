## scp명령어

>scp 란
>
>- Secure Copy 의 약자로 ssh 프로토콜을 기반으로 파일이나 디렉토리를 전송하거나 가져올 때 사용한다.



- Local(로컬) -> Remote(원격지)
  -  `모든 명령어는 로컬 서버에서 입력한다`



#### 명령어

- 단일 파일 전송

```bash
$ scp [옵션] [파일명] [원격지 계정]@[원격지 IP]:[파일이 저장 될 경로]
ex) scp -rp ./start.sh root@192.168.0.10:/root/transactionTest/
```



#### 옵션

| 구분 | 설명                              |
| ---- | --------------------------------- |
| r    | 디렉토리 및 하위 모든 파일을 복사 |
| p    | 원본 속성값 복사                  |
| P    | 포트 번호 지정 복사               |
| c    | 압축하여 복사                     |
| v    | 복사 과정을 출력                  |
| a    | 아카이브 모드로 복사              |

