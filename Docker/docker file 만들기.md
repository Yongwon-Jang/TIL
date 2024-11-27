## DockerFile 만들기
> 내 프로그램을 이미지로 만들어두면
> 아무 컴퓨터에서나 그걸 내려받아서 매우 쉽게 실행할 수 있다고 했습니다.



### 이미지 만들기
1. 코드짠거 근처에다가 Dockerfile을 하나 만들고
2. 이미지에 뭘 넣을지 작성하고
3. 그 다음에 같은 곳에서 터미널을 열어서 docker build 명령어를 입력하면 이미지가 하나 생성됩니다.



## Dockerfile에 넣을 수 있는 것들
- 어떤 OS를 설치할건지
- 어떤 프로그램을 설치할건지
- 어떤 터미널 명령어를 실행할건지
- 내 컴퓨터에 있던 파일을 어디에 집어넣을 것인지 

전부 작성가능합니다.

그래서 내 프로그램을 돌리고 싶으면 무슨 짓을 차례로 해야하는지 여기다가 전부 적어놓으면 되는 것임



그래서 예를 들어 저번에 만들어둔 Node.js 서버를 이미지에 담아서 실행하고 싶으면

- OS하나 설치하고

- nodejs설치하고

- npm install express 터미널에 입력하고

- 서버 코드 작성하고

- node server.js 터미널에 입력

이렇게 Dockerfile에 작성하고 터미널에서 docker build 입력하면 이미지가 하나 생성됩니다.

이제 그 이미지를 실행하면 서버가 돌아갑니다.


### 예시
```dockerfile
# 베이스 이미지 선택
FROM python:3.10-slim

# 작업 디렉토리 설정
WORKDIR /app

# 의존성 파일 복사 및 설치
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# 애플리케이션 소스 코드 복사
COPY . .

# Flask 애플리케이션 실행
CMD ["python", "app.py"]

# 컨테이너 실행 시 기본 포트 노출
EXPOSE 5000

```