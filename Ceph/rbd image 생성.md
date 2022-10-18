## rbd image 생성

- kubernetes라는 이름의 pool이 생성되어 있다고 가정

```
## ceph Monitor Node
[root#] rbd create --size {megabytes} {pool-name}/{image-name}

## ex)
[root#] rbd create --size 1024 kubernetes/img1
```



- image 확인

```
## ceph Monitor Node
[root#] rbd -l ls {pool-name}

## ex)
[root#] rbd -l ls kubernetes
NAME       SIZE PARENT FMT PROT LOCK
img1       1GiB          2
```

