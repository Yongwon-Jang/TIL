## rbd image 삭제

- test1이라는 이름의 pool 안에 test1이라는 image가 생성되어있다고 가정

```
## ceph Monitor Node
[root#] rbd -p {pool-name} rm {image-name}

## ex)
[root#] rbd -p test1 rm test1
```
