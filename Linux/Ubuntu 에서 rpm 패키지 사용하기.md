### Ubuntu 에서 rpm 패키지 사용하기

> 우분투는 Debian Linux 기반이기 때문에 RedHat 기반의 패키지 rpm을 그냥 사용 할 수 없다. 그래서 Alien 을 이용하여 rpm을 deb파일로 변환 시켜줘야 한다.



#### Alien 설치

- 설치 전 universe 저장소가 활성화 되어있는지 확인

```
# add-apt-repository universe
```

- 저장소 활성화 후 업데이트 및 설치

```
# apt update
# apt install alien
```



#### rpm 패키지 변환 및 설치

- rpm 을 deb 형식으로 변환

```
# alien [package_name.rpm]
```

- `package_name.deb` 파일이 생성된다.

- deb 파일 실행

```
# dpkg -i [packge_name.deb]
```





#### rpm 패키지를 직접 설치하는 방법

- 패키지를 변환하지 않고 `alien` `[i]`옵션을 통해 직접 실행 시킬 수 있다.

```
# alien -i [package_name.rpm]
```

