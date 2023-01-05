## Docker Local Registry 만들기

> docker images를 push 할 수 있는 Registry를 Local에 구축하는 방법을 다룬다.



#### 1. Docker registry Images 가져오기

- registry image pull

```
[root]# docker pull registry:latest
```

- image 생성 확인

```
[root]# docker images registry
REPOSITORY   TAG       IMAGE ID       CREATED       SIZE
registry     latest    81c944c2288b   7 weeks ago   24.1MB
```

#### 2. Registry 컨테이너 실행

```
[root#] mkdir /mnt/registry
[root#] docker run -d \
-p 5000:5000 \
--restart=always \
--name registry \
-v /mnt/registry:/var/lib/registry \
registry
bb485f2f11b32fbf4386795e4da555b960aeee9663cbc08144d76b0a6e594a91
```

- 컨테이너 작동 확인

```
[root]# docker ps
CONTAINER ID   IMAGE      COMMAND                  CREATED          STATUS          PORTS                                       NAMES
ad45ea9d3da0   registry   "/entrypoint.sh /etc…"   43 minutes ago   Up 24 minutes   0.0.0.0:5000->5000/tcp, :::5000->5000/tcp   registry

[root]# netstat -anp | grep 5000 | grep LISTEN
tcp        0      0 0.0.0.0:5000            0.0.0.0:*               LISTEN      1582/docker-proxy
tcp6       0      0 :::5000                 :::*                    LISTEN      1617/docker-proxy
```



#### 3. insecure-registries 설정

```
[root#] vi /etc/docker/daemon.json
  
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2",
    "insecure-registries" :[
            "localhost:5000"
    ]
}
```

- 여기까지 했으면 Registry 구축 완료



#### 4. image 파일 push

- images 이름 변경

  - image의 이름을 `localhost:5000`으로 시작하도록 변경해줘야 한다. 다른이름으로 사용했을 경우 push 할 때 `https`가 자동으로 붙으면서 private registry 를 찾아가려고 시도한다.

  ```
  [root#] docker tag registry.datacommand.co.kr/cdm-cloud-etcd:HEAD localhost:5000/cdm-cloud-etcd:HEAD
  ```

- image push

  ```
  [root#] docker push localhost:5000/cdm-cloud-cockroach:HEAD
  ```

- push를 하면 local registry에 있는 image를 사용할 수 있다.