## Go install in Centos7

1. wget 설치

```
# sudo yum install wget
```

2. Go 다운로드

```
# wget https://golang.org/dl/go1.19.3.linux-amd64.tar.gz
```

3. 다운로드한 Go 바이너리를 `/usr/local` 디렉토리에 압축 해제

```
# sudo tar -C /usr/local -xzf go1.19.3.linux-amd64.tar.gz
```

4. 환경변수 설정

```
# echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
```

5. 설정 적용

```
# source ~/.bashrc
```

6. Go 버전 확인

```
# go version

go version go1.19.3 linux/amd64
```

