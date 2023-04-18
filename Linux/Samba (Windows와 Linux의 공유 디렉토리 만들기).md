## Samba (Windows와 Linux의 공유 디렉토리 만들기)

> `Windows` 환경에서 `Linux` 개발을 하려면 번거로움이 참 많다. 이런 번거로움을 조금이라도 덜어보고자 `Samba`를 통해 `Windows`와 `Linux`가 **공유**해서 사용하는 **디렉토리**를 만들어서 거기서 작업을 하기로 했다.

* Windows10, Centos7 을 기준으로 작성하였습니다.

#### Samba 설치

1. 패키지 설치(`Centos7`)

```
# sudo yum install samba samba-client samba-common -y
```

2. Windows에서 공유할 폴더 선택 혹은 생성
   - ex) `C:\Shared`
3. Samba 구성 파일 편집(`Centos7`)

```
# sudo vi /etc/samba/smb.conf
```

- 맨 아래에 다음을 추가
  - 공유할 디렉토리 생성 `mkdir /home/user/Shared`

```
[shared]
   comment = Shared Folder
   path = /home/user/Shared
   read only = no
   browseable = yes
```

4. Samba 서비스 시작 및 부팅 시 자동 시작 설정(`Centos7`)

```
# sudo systemctl start smb
# sudo systemctl enable smb
```

5. Samba Passwd 설정(`Centos7`)

```
# sudo smbpasswd -a root
```

6. Windows 에서 Samba 연결 설정

   - 폴더 주소 표시줄에 `\\<Vm의 IP 주소>` 입력

   ```
   ex) \\192.168.0.10
   ```

   - 비밀번호 입력