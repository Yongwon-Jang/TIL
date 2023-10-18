## Ceph pool 지우는 법

1. 다음 명령어를 사용하여 `mon_allow_pool_delete` 옵션을 `true`로 설정합니다.

```
ceph config set mon mon_allow_pool_delete true
```

2. rbd 명령어로 pool을 삭제

```
ceph osd pool delete <pool_name> <pool_name> --yes-i-really-really-mean-it
```

