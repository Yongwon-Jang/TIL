## Pod가 Terminating 상태에서 멈춰있을 때

- pod를 delete했을 때 지워지지 않고 Terminating 상태에 머물러 있다면 수동으로 삭제 해야 한다

#### 수동 삭제 방법

```
# kubectl -n <namespace> delete pods --grace-period=0 --force <pod_name>
```



