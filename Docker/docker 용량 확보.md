## docker 용량 확보

> docker image 를 과도하게 빌드를 하다보면  `No space left on device` 가 발생
>
> - 용량 부족이 원인



#### docker prune 명령어로 용량 확보

- option
  - `docker volume prune` : 미사용 볼륨 제거
  - `docker container prune` : 미사용 컨테이너 제거
  - `docker image prune` : 미사용 이미지 제거
  - `docker system prune` : 미사용 중인 이미지, 컨테이너, 볼륨 모두 제거