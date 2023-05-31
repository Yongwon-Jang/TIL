## Operator-SDK

#### 설치

```
git clone https://github.com/operator-framework/operator-sdk
cd operator-sdk
git checkout master
make install

# 해당 명령어를 입력했을때 version이 출력되면 설치 완료입니다. 
operator-sdk version
```

SDK에는 Operator를 개발하는 데 사용할 수 있는 미리 빌드된 `Make` 명령이 포함되어 있습니다.

- **`make install`** -- 소스 코드를 실행 파일로 컴파일합니다.
- **`make manifests`** -- kubebuilder marker를 기반으로 YAML manifest 를 생성합니다.
- **`make generate`** -- Operator의 API 스키마를 기반으로 생성된 코드를 업데이트합니다.
- **`make docker-build`** -- Operator의 Docker 컨테이너 이미지를 빌드합니다.
- **`make docker-push`** -- Docker 이미지를 push 합니다.
- **`make deploy`** -- Operator의 모든 리소스를 클러스터에 배포합니다.
- **`make undeploy`** -- 클러스터에서 Operator의 배포된 리소스를 모두 삭제합니다.



#### 새 프로젝트 만들기

```
mkdir -p $HOME/projects/memcached-operator
cd $HOME/projects/memcached-operator
# we'll use a domain of example.com
# so all API groups will be <group>.example.com
operator-sdk init --domain example.com --repo github.com/example/memcached-operator
```

- `--domain example.com`: Operator의 도메인을 지정합니다. `<your-domain>` 자리에 실제 도메인을 입력합니다. 이 도메인은 Operator의 API 그룹 식별자로 사용됩니다. 예를 들어, `example.com` 도메인을 사용하면 Operator의 API 그룹은 `example.com`으로 식별됩니다.
- `--repo github.com/example/memcached-operator`: Operator 프로젝트의 저장소를 지정합니다. `<your-repo>` 자리에 실제 저장소의 경로를 입력합니다. 이 저장소 경로는 Operator의 소스 코드가 호스팅되는 장소를 나타냅니다. 예를 들어, `github.com/example/memcached-operator`는 GitHub의 `example` 조직의 `memcached-operator` 저장소를 나타냅니다.

#### 새 API 및 컨트롤러 만들기

> 진행 하기전 gcc가 설치 되어있는지 확인하고 설치를 미리 해줘야 정상적으로 생성할 수 있다.

```
$ operator-sdk create api --group cache --version v1alpha1 --kind Memcached --resource --controller
Writing scaffold for you to edit...
api/v1alpha1/memcached_types.go
controllers/memcached_controller.go
...
```



