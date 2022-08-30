## cp 명령 시 omitting directory 에러

- cp 명령시 아래와 같은 에러가 뜰 때가 있다.

```
# cp: omitting directory `/root/kemod/'
```

해당 디렉토리가 사용중일 때 주리 이런 에러가 발생한다.



#### 해결

- `-r` 옵션을 사용한다

```
# cp -r [복사 원본] [복사할 위치]
```

