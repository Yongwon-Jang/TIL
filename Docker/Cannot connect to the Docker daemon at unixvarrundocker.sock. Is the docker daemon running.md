## Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?

> 도커 설치 후 도커 명령어 실행 에러

```
Cannot connect to the Docker daemon at unix:///var/run/docker.sock. Is the docker daemon running?
```

- 위와 같은 명령어가 뜨면 docker service가 실행이 안되어 있는 것이다.

  ```
  # systemctl status docker
  도커 상태 확인 -> stop 혹은 disable 일것이다.
  ```

- docker service 실행

  ```
  # systemctl start docker
  # systemctl enable docker
  ```

- 위 명령어를 실행 후 다시 도커 명령어를 입력하면 정상적으로 작동한다.



