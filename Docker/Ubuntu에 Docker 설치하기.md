## Ubuntu에 Docker 설치하기

1. 저장소 업데이트

```
# sudo apt update
```

2. 패키지 설치

```
# sudo apt install apt-transport-https ca-certificates curl software-properties-common
```

3. GPG 키 추가

```
# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```

4. Docker 저장소 추가

```
# echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

5. 저장소 업데이트

```
# sudo apt update
```

6. Docker 설치

```
# sudo apt install docker-ce docker-ce-cli containerd.io
```

7. Docker 실행 및 활성화

```
# sudo systemctl start docker
# sudo systemctl enable docker
```

8. Docker 그룹에 사용자 추가 (선택, root 권한 없이 Docker 사용 가능)

```
# sudo usermod -aG docker $USER
```

- 설치 완료