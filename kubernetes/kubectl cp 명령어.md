## kubectl cp 명령어

> kubectl cp 명령어는 local 과 Pod 간의 파일 복사를 수행한다. Pod 에서 Pod 로 복사는 불가능 하다.

#### 명령어 형식

```
# kubectl cp <원본 경로> <파드 이름>:<대상 경로>
# kubectl cp <파드 이름>:<원본 경로> <대상 경로>
```



#### 예시

```
# kubectl cp localfile.txt <파드 이름>:/data
```

혹은

```
# kubectl cp <파드 이름>:/data/remotefile.txt /home/user
```



#### 옵션

`kubectl cp` 명령어는 다음과 같은 옵션을 지원한다.

- `-c, --container`: 복사할 컨테이너 이름 지정
- `--no-preserve`: 파일 소유권, 퍼미션 정보 등을 유지하지 않고 복사
- `-p, --preserve`: 파일 소유권, 퍼미션 정보 등을 유지하고 복사
- `-R, --recursive`: 디렉토리를 재귀적으로 복사
- `-v, --verbose`: 자세한 출력 정보 제공