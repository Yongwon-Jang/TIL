## Ubuntu 패키징 (deb)

> 데비안 계열은 rpm 패키지가 아닌 독자적인 deb 패키징 시스템을 가지고 있다. Ubuntu 도 당연히 deb 패키징 시스템을 사용하고 이번 포스팅에서 deb 패키징을 하는 방법을 알아보자



### 패키지 디렉토리 생성

- 패키징이 될 디렉토리를 생성한다. 여기서는 `pkg` 라는 디렉토리를 생성하자

```
# mkdir pkg
```

- 그리고 두 개의 하위 디렉토리를 만든다. 하나의 이름은 무조건 `DEBIAN` 으로 만들고 나머지 하나는 패키지를 설치 했을때 생성 될 디렉토리의 이름으로 만든다
  - `DEBIAN` 디렉토리 안에는 `control` 파일과 설치,삭제 시 실행시킬 스크립트를 함께 넣어준다
    - `control` : 의존성, 버전, 이름, 설명 등 패키지의 **전반적인 정보**를 담고 있는 파일
    - `preinst` : 패키지 내에 포함된 파일을 **설치하기 전**에 **실행**되는 스크립트
    - `postinst` : 패키지 내에 포함된 파일을 **설치한 후**에 **실행**되는 스크립트
    - `prerm` : 패키지 **삭제 이전**에 실행되는 스크립트
    - `postrm` : 패키지  **삭제 이후**에 실행되는 스크립트
- 디렉토리 구조

```
pkg
├── DEBIAN
    ├── control
    ├── preinst
    ├── postinst
    ├── prerm
    └── postrm
└── home # 이 패키지를 설치하면 /home/test 가 생성된다.
    └── test
```

#### cotrol 파일

##### 예시

```
Package: replica
Version: 1.0.0
Maintainer: Your Name <dev@example.com>
Description: My package
Homepage: http://abc.com
Architecture: all
Section:non-free
Priority:optiona
Depends: git, tomcat(>=10.0.1)
```

- Package 
  - 패키지 이름, 소문자로만 작성, `_` 대신 `-` 사용
- Version
  - 패키지 버전을 명시
- Architecture
  - amd64/i386 으로 구분되는데, amd64 를 사용하면 된다.\
- Depends
  - 생성할 패키지가 가지는 의존성을 기록

#### 자세한 내용은 아래 링크 참조

https://www.debian.org/doc/debian-policy/ch-controlfields.html#source-package-control-files-debian-control



### 패키징

- `dpkg` 를 이용하여 패키징 대상 디렉토리의 이름을 인자로 넘기면 패키징이 된다

```
# dpkg -b pkg

# ls
pkg pkg.deb
```



### 설치

```
# apt-get update
# apt-get install gdebi-core
# gdebi pkg.deb
```

- 위 순서대로 실행하면 패키지 설치가 완료된다.





### 에러 처리

`apt-get install gdebi-core`를 했을 때 `Unable to locate package gdebi-core` 이런 에러가 발생하였다. 

- 시스템 패키지 목록이 오래되어 있어서 발생했을 가능성이 높음
- `apt-update` 후 재설치
- 그래도 같은 에러가 나오면 `sudo add-apt-repository universe` 후 update 하고 재설치
