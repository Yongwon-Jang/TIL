## NFS

> NFS : Network File System
>
> - **공유된 원격 호스트의 파일을 로컬에서 사용할 수 있도록 개발된 파일 시스템을 네트워크 파일 시스템**

#### 설명

- 사용자 컴퓨터(client)가 원격 컴퓨터(server)에 있는 파일을 자기 것처럼 마음대로 검색, 수정, 저장할 수 있도록 해주는 응용프로그램
- 클라이언트가 네트워크 상의 파일을 직접 연결된 스토리지에 접근하는 방식
- 다른 서버의 파티션을 마치 내 로컬 영역인 것처럼 네트워크를 이용하여 사용할 수 있다.



- 장점
  - 접근이 좋다
- 단점
  - 보안에 취약



 ### NFS 마운트 (Centos 7)

- 준비 : VM 2대 (server 1대, client 1대)



#### Server 설정

1. nfs package 설치 확인

```
$ rpm -qa | grep nfs-utils
nfs-utils-2.3.3-51.el8.x86_64
```

2. 설치가 안되어 있다면 설치

```
$ yum install nfs-utils -y
```

3. 재실행

```
systemctl start nfs-server
systemctl enable nfs-server
systemctl enable rpcbind 
```

4. 마운트 할 디렉토리 생성

```
$ mkdir /test
```

5. 공유할 디렉토리 정의

```
$ vi /etc/exports

[공유할 디렉토리][허용할ip대역][권한설정]

ex) /test 192.168.0.*(rw,sync)
```

   5-1. 권한 설정 옵션

| 옵션           | 설명                                                         |
| -------------- | ------------------------------------------------------------ |
| rw             | 읽기, 쓰기 허용                                              |
| ro             | 읽기만 허용                                                  |
| secure         | 클라이언트 마운트 요청 시 포트를 1024 이하로 설정            |
| noaccess       | 액세스 거부                                                  |
| root_squach    | 클라이언트의 root가 서버의 root 권한 획득하는 것을 차단      |
| no_root_squash | 클라이언트의 root와 root를 동일하게 한다.                    |
| sync           | 파일 시스템이 변경되면 즉시 동기화                           |
| all_squach     | root를 제외하고 서버와 클라이언트 사용자를 동일한 권한으로 설정 |
| no_all_squach  | root를 제외하고 서버와 클라이언트의 사용자들을 하나의 권한을 가지도록 설정 |

   5-2. 권한 설정을 해줘도 nfs특성 때문인지 접근이 안될 때가 있다. 그때 권한을 chmod로 준다

```
$ chmod 707 /test
```

6. /etc/exports 수정 확인

```
$ exportfs -r   (수정한 export 내용 적용)
$ exportfs -v   (설정한 공유 확인)
/test       192.168.0.*(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
$ showmount -e (서버의 공유 가능한 디렉토리 정보 확인)
Export list for localhost.localdomain:
/test 192.168.0.*
```

7. 방화벽 허용

```
$ service firewalld stop
```



#### client 설정

1. nfs package 설치 확인

```
$ rpm -qa | grep nfs-utils
nfs-utils-2.3.3-51.el8.x86_64
```

2. 설치가 안되어 있다면 설치

```
$ yum install nfs-utils -y
```

3. 재실행

```
systemctl start nfs-server
systemctl enable nfs-server
systemctl enable rpcbind 
```

4. NFS 서버 마운트 확인

```
$ showmount -e 192.168.6.105
/test 192.168.0.*
```

5. 마운트 할 디렉토리 생성

```
$ mkdir /nfs
```

6.  연결 및 확인

```
$ mount -t nfs 192.168.0.39:/test /nfs
               [nfs서버 ip]:/[서버 디렉토리] /[cline 마운트 포인트]
               
$ df -hT
Filesystem              Type      Size  Used Avail Use% Mounted on
192.168.0.39:/test      nfs4      100G  2.8G   98G   3% /nfs
```

7. 부팅 시 자동으로 마운트 될 수 있도록 설정

```
$ vi /etc/fstab

192.168.0.39:/test /nfs                         nfs     default         0 0  
```





#### reboot 해도 마운트 설정 유지하기

- 위와 같이 nfs 마운트를 하고 클라이언트를 reboot 하게 되면 mount가 풀려있다. reboot 후에도 mount를 유지하기 위해서는 다음과 같은 설정이 필요하다.

```
[root]# vi /etc/fstab

## 마지막 줄에 다음과 같이 설정 추가
192.168.6.106:/home/nfs/test1 /home/nfs/tgt1 nfs defaults 0 0
[NFS 서버 IP]:[NFS 서버 공유 경로] [클라이언트 공유 경로] nfs defaults 0 0
```

