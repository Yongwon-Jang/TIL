## Groups, Versions, Kinds, Resources in k8s

> kubernetes API를 이해하기 위해 필요한 용어들을 정리해보았다.

#### Resources

- api resources 는 pod, services, jobs 등과 같이 kubernetes에서 사용하는 resources를 의미한다.



#### Groups

- api resources 들을 묶어놓은  group를 의미한다.
- 보통 yaml 파일에 맨 처음 들어가는 apiVersion에 명시된다.

```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: replica-pvc
spec: ...
```

- 여기서 `apps`가 api group에 해당
- pod, service 등과 같은 `core api`에 해당하는 resources들은 group을 작성하지 않아도 된다.

```yaml
apiVersion: v1
kind: pod
```

- core api 종류로는 pod, service, pv, pvc, node, namespace, configmap, endpoint 등이 있다.
- `kubectl api-resources -o wide` 명령어를 통해 현재 클러스터의 모든 resources에 대한 api groups을 확인할 수 있다.



#### Kind

- 각 group-version 에는 Kinds라고 하는 하나 이상의 API 유형이 포함되어 있다.

