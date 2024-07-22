## rsync
> - rsync는 파일 및 디렉터리의 동기화와 전송을 효율적으로 수행하는 도구입니다. 
> - 로컬 파일 간, 로컬과 원격 시스템 간, 또는 원격 시스템 간의 파일 전송을 지원합니다.

- 기본 사용법
```shell
rsync [OPTIONS] SOURCE DESTINATION
```

- 주요 옵션
  - `-a (archive mode)`: 파일을 아카이브 모드로 전송하여, 디렉터리와 하위 디렉터리를 포함하여 파일의 모든 속성을 유지합니다. 
  - `-v (verbose)`: 전송 중인 파일에 대한 자세한 정보를 출력합니다.
  - `-z (compress)`: 전송 중 데이터를 압축하여 네트워크 대역폭을 절약합니다.
  - `-r (recursive)`: 디렉터리와 그 안의 모든 파일을 재귀적으로 전송합니다.
  - `-P (progress)`: 전송 진행 상황을 표시하고, 중단된 전송을 재개할 수 있게 합니다.
  - `--delete`: 목적지에서 원본에 없는 파일을 삭제합니다.
  - `-e ssh`: SSH를 사용하여 데이터를 전송합니다.

#### 예제
```shell
# 로컬에서 로컬로 파일 복사
rsync -av /home/user/source/ /home/user/destination/

# 로컬에서 원격 서버로 파일 전송
rsync -avz -e ssh /home/user/source/ user@192.168.0.169:/home/user/destination/

# 원격 서버에서 로컬로 파일 복사
rsync -avz -e ssh user@192.168.0.169:/home/user/source/ /home/user/destination/

# 특정 파일 패턴을 제외하고 동기화
rsync -av --exclude '*.log' /home/user/source/ /home/user/destination/

# 전송 중 진행 상황 표시
rsync -avP /home/user/source/ /home/user/destination/
```