## Memcached 오퍼레이터 예제 이해하기

> Operator의 이해를 위해 Memecached 예제를 따라 하면서 코드와 동작과정을 이해해보기 위해 작성하였습니다.

- 예제 코드 : https://github.com/operator-framework/operator-sdk/blob/latest/testdata/go/v3/memcached-operator/controllers/memcached_controller.go
- 진행 과정 : https://sdk.operatorframework.io/docs/building-operators/golang/tutorial/

#### 오퍼레이터 설치

```
git clone https://github.com/operator-framework/operator-sdk
cd operator-sdk
git checkout master
make install

# 해당 명령어를 입력했을때 version이 출력되면 설치 완료입니다. 
operator-sdk version
```



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

- 이 과정을 거치면 `memcached-operator` 경로에 프로젝트가 생성된다.

- `namespace` 설정

  - `Operator`가 특정 `namespace` 만 관리하도록 설정하게 하려면 `main.go` 파일에 있는 `mgr, err := ctrl.NewManager(ctrl.GetConfigOrDie(), ctrl.Options{}` 에 원하는 `namespace`를 입력해주면 된다.

  ```go
  mgr, err := ctrl.NewManager(cfg, manager.Options{
      Namespace: "my-namespace",
      // 다른 옵션들...
  })
  ```

#### 새 API 및 컨트롤러 만들기

```
$ operator-sdk create api --group cache --version v1alpha1 --kind Memcached --resource --controller
Writing scaffold for you to edit...
api/v1alpha1/memcached_types.go
controllers/memcached_controller.go
...
```

- 이 과정을 진행할 때 에러가 발생했는데 `gcc`가 설치되어 있지 않아서 발생한것으로 판단. gcc 설치 이후 정상적으로 `컨트롤러`가 생성되었다.
- 이 과정을 거치면 `memcached-operator`경로 안에 `api/v1alpha1/memcached_types.go`(Memcached resource API) 경로와 `controllers/memcached_controller.go` (controller) 경로가 생성된다.



#### API 정의

- `CRD` 및 `CR` 에 대한 API 정의를 작성하는 단계이다. 이 단계에서는 새로운 `CR` 유형을 생성하고, 해당 `CR`에 대한 필드, 상태 및 메서드를 정의한다.
- Memcached 구조체 정의

```go
//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// Memcached is the Schema for the memcacheds API
type Memcached struct {
	metav1.TypeMeta   `json:",inline"`
	metav1.ObjectMeta `json:"metadata,omitempty"`

	Spec   MemcachedSpec   `json:"spec,omitempty"`
	Status MemcachedStatus `json:"status,omitempty"`
}
```

- `Memcached` 구조체는 `memcacheds` API의 스키마를 정의하는 역할을 합니다. 이 구조체는 Memcached 리소스의 스펙(spec)과 상태(status)를 포함합니다.

- spec과 status 도 정의 할 수 있다.

  ```go
  type MemcachedSpec struct {
      Size       int32  `json:"size"`
      Replicas   int32  `json:"replicas"`
      Port       int32  `json:"port"`
      Image      string `json:"image"`
  }	
  ```

  - `Memcached` 리소스의 `spec`에는 메모리 용량, 레플리카 수, 포트 번호 등과 같은 설정 값들이 포함될 수 있다.
  - `MemcachedSpec` 구조체는 사용자가 `Memcached` 리소스의 스펙을 정의할 수 있는 틀을 제공한다.

  ```go
  // MemcachedStatus defines the observed state of Memcached
  type MemcachedStatus struct {
  	// INSERT ADDITIONAL STATUS FIELD - define observed state of cluster
  	// Important: Run "make" to regenerate code after modifying this file
  	Conditions []metav1.Condition `json:"conditions,omitempty" patchStrategy:"merge" patchMergeKey:"type" protobuf:"bytes,1,rep,name=conditions"`
  	Nodes      []string           `json:"nodes"`
  	Phase      string             `json:"phase"`
  }
  ```

- `Spec` 과 `Status` 구조체를 정의 하고 `make manifests` 명령(아마 컨트롤러를 구현 한 이후에 해야 할 듯)을 하면 CRD 파일이 생성되고 적용된다.

  - `config/crd/bases/{group}.{domain}_{plural}.yaml`파일에 적용
  - 그 외에도 RBAC, Manager, Kustomization 등에 적용된다고 한다. (아직 세부 내용은 파악하지 못하였음.)

#### 컨트롤러 구현

- [memcached_controller.go](https://github.com/operator-framework/operator-sdk/blob/latest/testdata/go/v3/memcached-operator/controllers/memcached_controller.go) 코드로 실습

- SetupWithManager 함수

  - 컨트롤러가 관리할 리소스와 관련된 설정을 지정하는 함수

  ```go
  import (
  	...
  	appsv1 "k8s.io/api/apps/v1"
  	...
  )
  
  func (r *MemcachedReconciler) SetupWithManager(mgr ctrl.Manager) error {
  	return ctrl.NewControllerManagedBy(mgr).
  		For(&cachev1alpha1.Memcached{}).
  		Owns(&appsv1.Deployment{}).
          WithOptions(controller.Options{MaxConcurrentReconciles: 2}).
  		Complete(r)
  }
  ```

  - `For` : 컨트롤러가 관리해야 하는 주요 리소스를 지정, 주로 `CR` 타입을 지정하며 해당 `CR` 타입에 대한 변경사항을 감지하고 저장하는 역할
  - `Owns` : 여기서는 컨트롤러가 `Memecached` CR 에 대한 Reconcile 작업 중에 자동으로 `Deployment` 오브젝트를 생성하고 관리할 수 있도록 해준다.
  - `WithOptions(controller.Options{MaxConcurrentReconciles: 2})` : 동시에 실행되는 조정 작업의 최대 개수를 2로 설정. 이를 통해 동시에 실행되는 작업 수를 제한할 수 있음.
  - `Complete(r)` : 컨트롤러의 설정을 완료 한다. `r` 은 `MemcachedReconciler` 구조체의 인스턴스
  - `For` 메서드와 `Owns` 메서드의 차이
    - `For` 은 컨트롤러가 관리해야 하는 **주 리소스**를 지정, `Owns`는 컨트롤러가 **생성 또는 소유**해야 하는 **종속 리소스**를 지정한다.
    - **주 리소스**는  컨트롤러의 주요 작업 대상이 되는 리소스, **종속 리소스**는 주 리소스의 생성, 업데이트 또는 삭제에 의존적인 리소스이다.
    - 예를 들어 `Owns(&appsv1.Deployment{})` 는 `&appsv1.Deployment` 리소스가 주 리소스에 종속되어야 하며, 컨트롤러는 이를 관리하고 유지하도록 설정




- Reconcile 함수

  ```go
  import (
  	ctrl "sigs.k8s.io/controller-runtime"
  
  	cachev1alpha1 "github.com/example/memcached-operator/api/v1alpha1"
  	...
  )
  
  func (r *MemcachedReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    // Lookup the Memcached instance for this reconcile request
    memcached := &cachev1alpha1.Memcached{}
    err := r.Get(ctx, req.NamespacedName, memcached)
    ...
  }
  ```

  - `Reconcile` 함수는 시스템의 실제 상태에서 원하는 CR 상태를 적용하는 역할을 한다.

  - 감시된 CR 혹은 리소스에서 이벤트가 발생할 때마가 실행되며 해당 상태가 일치하는지 여부에 따라 일부 값을 반환한다.

  - **코드를 하나씩 분석 해보자**

    ```go
    memcached := &cachev1alpha1.Memcached{}
    err := r.Get(ctx, req.NamespacedName, memcached)
    ```

    - `err := r.Get(ctx, req.NamespacedName, memcached)` : 쿠버네티스 클라이언트를 사용하여 지정된 네임스페이스로 `memcached` 리소스를 조회한다.

    ```go
    if memcached.Status.Conditions == nil || len(memcached.Status.Conditions) == 0 {
    	meta.SetStatusCondition(&memcached.Status.Conditions, metav1.Condition{Type: typeAvailableMemcached, Status: metav1.ConditionUnknown, Reason: "Reconciling", Message: "Starting reconciliation"})
    	if err = r.Status().Update(ctx, memcached); err != nil {
    		log.Error(err, "Failed to update Memcached status")
    		return ctrl.Result{}, err
    		}
    	if err := r.Get(ctx, req.NamespacedName, memcached); err != nil {
    		log.Error(err, "Failed to re-fetch memcached")
    		return ctrl.Result{}, err
    		}
    	}
    ```

    - `memcached` 리소스의 상태가 없을 경우, 상태를 `Unknown`으로 설정하고 상태를 업데이트 한다.
    - 업데이트 후 `r.Get` 을 통해 `memcached` 리소스를 다시 조회 해 최신 상태를 가져온다.\
    - 이 코드는 상태를 업데이트하고 최신 상태를 확보하는 과정을 거친 후, 이후의 조정 작업에서 최신 상태를 기준으로 동작할 수 있도록 보장한다.

    ```go
    if !controllerutil.ContainsFinalizer(memcached, memcachedFinalizer) {
    	log.Info("Adding Finalizer for Memcached")
    	if ok := controllerutil.AddFinalizer(memcached, memcachedFinalizer); !ok {
    		log.Error(err, "Failed to add finalizer into the custom resource")
    		return ctrl.Result{Requeue: true}, nil
    	}
    		if err = r.Update(ctx, memcached); err != nil {
    		log.Error(err, "Failed to update custom resource to add finalizer")
    		return ctrl.Result{}, err
    	}
    }
    ```

    - 이 부분은 `memcached` 리소스에 `Finalizer` 를 추가하고 클러스터에 반영하는 역할
      - `Finalizer` 가 등록되어 있으면 리소스가 삭제 될 때 `Finalizer`에 등록된 작업이 완료되면 리소스가 실제로 삭제된다.

    ```go
    isMemcachedMarkedToBeDeleted := memcached.GetDeletionTimestamp() != nil
    if isMemcachedMarkedToBeDeleted {
    	if controllerutil.ContainsFinalizer(memcached, memcachedFinalizer) {
    		log.Info("Performing Finalizer Operations for Memcached before delete CR")
    		meta.SetStatusCondition(&memcached.Status.Conditions,metav1.Condition{Type: typeDegradedMemcached,
    			Status: metav1.ConditionUnknown, Reason: "Finalizing",
    			Message: fmt.Sprintf("Performing finalizer operations for the custom resource: %s ", memcached.Name)})
    
    		if err := r.Status().Update(ctx, memcached); err != nil {
    			log.Error(err, "Failed to update Memcached status")
    			return ctrl.Result{}, err
    		}
    		r.doFinalizerOperationsForMemcached(memcached)
    		if err := r.Get(ctx, req.NamespacedName, memcached); err != nil {
    			log.Error(err, "Failed to re-fetch memcached")
    			return ctrl.Result{}, err
    		}
    			meta.SetStatusCondition(&memcached.Status.Conditions, metav1.Condition{Type: typeDegradedMemcached,
    			Status: metav1.ConditionTrue, Reason: "Finalizing",
    			Message: fmt.Sprintf("Finalizer operations for custom resource %s name were successfully accomplished", memcached.Name)})
    
    		if err := r.Status().Update(ctx, memcached); err != nil {
    			log.Error(err, "Failed to update Memcached status")
    			return ctrl.Result{}, err
    		}
    
    		log.Info("Removing Finalizer for Memcached after successfully perform the operations")
    		if ok := controllerutil.RemoveFinalizer(memcached, memcachedFinalizer); !ok {
    			log.Error(err, "Failed to remove finalizer for Memcached")
    			return ctrl.Result{Requeue: true}, nil
    		}
    
    		if err := r.Update(ctx, memcached); err != nil {
    			log.Error(err, "Failed to remove finalizer for Memcached")
    			return ctrl.Result{}, err
    		}
    	}
    	return ctrl.Result{}, nil
    }
    ```

    - `isMemcachedMarkedToBeDeleted` 변수로 리소스가 삭제 되기로 표시되었는지 확인 후 `Finalizer` 가 리소스에 포함되어 있는지 확인한다.
      - `Finalizer`가 없으면 이미 삭제 완료 되었음
    - `r.doFinalizerOperationsForMemcached(memcached)` 함수를 통해서 `Finalizer` 가 해야 할 일을 정의한다.
      - 리소스 삭제 전에 수행해야 할 모든 작업을 수행
    - 상태를 `Downgrade` 로 수정하고 업데이트 한다.
      - `Downgrade` 상태는 리소스가 삭제되기 전에 종료 프로세스를 시작했음을 나타내기 위해 설정됨.
      - 리소스 삭제 작업의 중간상태를 나타냄.
    - 작업이 완료되면 `Finalizer` 삭제 후 상태 업데이트

    ```go
    found := &appsv1.Deployment{}
    err = r.Get(ctx, types.NamespacedName{Name: memcached.Name, Namespace: memcached.Namespace}, found)
    if err != nil && apierrors.IsNotFound(err) {
    	// Define a new deployment
    	dep, err := r.deploymentForMemcached(memcached)
    	if err != nil {
    		log.Error(err, "Failed to define new Deployment resource for Memcached")
    
            meta.SetStatusCondition(&memcached.Status.Conditions, metav1.Condition{Type: typeAvailableMemcached,
    			Status: metav1.ConditionFalse, Reason: "Reconciling",
    			Message: fmt.Sprintf("Failed to create Deployment for the custom resource (%s): (%s)", memcached.Name, err)})
    
    		if err := r.Status().Update(ctx, memcached); err != nil {
    			log.Error(err, "Failed to update Memcached status")
    			return ctrl.Result{}, err
    		}
    
    		return ctrl.Result{}, err
    	}
    
    	log.Info("Creating a new Deployment",
    		"Deployment.Namespace", dep.Namespace, "Deployment.Name", dep.Name)
    	if err = r.Create(ctx, dep); err != nil {
    		log.Error(err, "Failed to create new Deployment",
    			"Deployment.Namespace", dep.Namespace, "Deployment.Name", dep.Name)
    		return ctrl.Result{}, err
    	}
    	return ctrl.Result{RequeueAfter: time.Minute}, nil
    } else if err != nil {
    	log.Error(err, "Failed to get Deployment")
    	return ctrl.Result{}, err
    }
    ```

    - 위 코드는 ` Memcached 리소스에 대한 Deployment 리소스` 상태를 확인하고, 필요에 따라 `Deployment`를 새로 생성한다.

    ```go
    size := memcached.Spec.Size
    if *found.Spec.Replicas != size {
    	found.Spec.Replicas = &size
    	if err = r.Update(ctx, found); err != nil {
    		log.Error(err, "Failed to update Deployment",
    			"Deployment.Namespace", found.Namespace, "Deployment.Name", found.Name)
    
    		if err := r.Get(ctx, req.NamespacedName, memcached); err != nil {
    			log.Error(err, "Failed to re-fetch memcached")
    			return ctrl.Result{}, err
    		}
    
    		// The following implementation will update the status
    		meta.SetStatusCondition(&memcached.Status.Conditions, metav1.Condition{Type: typeAvailableMemcached,
    			Status: metav1.ConditionFalse, Reason: "Resizing",
    			Message: fmt.Sprintf("Failed to update the size for the custom resource (%s): (%s)", memcached.Name, err)})
    
    		if err := r.Status().Update(ctx, memcached); err != nil {
    			log.Error(err, "Failed to update Memcached status")
    			return ctrl.Result{}, err
    		}
    
    		return ctrl.Result{}, err
    	}
    	return ctrl.Result{Requeue: true}, nil
    }
    ```

    - `Memcached` 리소스의 `Spec`에 있는 `Size` 값을 기준으로 `Deployment` 의 `Replicas` 값을 조정하는 역할을 하는 코드이다.

    ```go
    // The following implementation will update the status
    meta.SetStatusCondition(&memcached.Status.Conditions, metav1.Condition{Type: typeAvailableMemcached,
    	Status: metav1.ConditionTrue, Reason: "Reconciling",
    	Message: fmt.Sprintf("Deployment for custom resource (%s) with %d replicas created successfully", memcached.Name, size)})
    
    if err := r.Status().Update(ctx, memcached); err != nil {
    	log.Error(err, "Failed to update Memcached status")
    	return ctrl.Result{}, err
    }
    
    return ctrl.Result{}, nil
    ```

    - `meta.SetStatusCondition` 함수를 사용하여 상태를 설정
      - `Status`를 `True`로, `Reason`을 `Reconciling`으로
    - 마지막으로, `ctrl.Result{}`를 반환하여 리콘실리에이션을 완료하고 성공적으로 처리되었음을 나타낸다.

  - `Reconciler` return 옵션

    - `return ctrl.Result{}, err`
      - `Reconliation` 작업 중 오류가 발생
    - `return ctrl.Result{Requeue: true}, nil`
      - `Reconliation` 을 완료 했지만, 다시 `Reconliation`  하기 위해 `Requeue` 한다.
      - 리소스나 환경의 변경으로 인해 추가적인 조치가 필요한 경우 사용
    - `return ctrl.Result{}, nil`
      - `Reconliation` 을 성공적으로 완료하고 추가적인 작업이 필요하지 않을 때 사용된다.
    - ` return ctrl.Result{RequeueAfter: nextRun.Sub(r.Now())}, nil`
      - 주기적으로 리소스 상태를 갱신하거나 외부 API로부터 데이터를 가져와야 할때, `Requeue`를 설정하여 일정한 주기로 작업을 실행하도록 한다.

- 권한 지정 및 RBAC 매니페스트 생성

  - 컨트롤러가 관리하는 리소스와 상호 작용하려면 특정 RBAC 권한이 필요하다. RBAC 마커를 통해 지정할 수 있다.

  ```go
  //+kubebuilder:rbac:groups=cache.example.com,resources=memcacheds,verbs=get;list;watch;create;update;patch;delete
  //+kubebuilder:rbac:groups=cache.example.com,resources=memcacheds/status,verbs=get;update;patch
  //+kubebuilder:rbac:groups=cache.example.com,resources=memcacheds/finalizers,verbs=update
  //+kubebuilder:rbac:groups=core,resources=events,verbs=create;patch
  //+kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;create;update;patch;delete
  //+kubebuilder:rbac:groups=core,resources=pods,verbs=get;list;watch
  
  func (r *MemcachedReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    ...
  }
  ```

  - 구성

  ```go
  //+kubebuilder:rbac:groups=<API 그룹>,resources=<리소스>,verbs=<동작>
  ```

  - 각 주석 라인은 특정 그룹 및 리소스에 대한 RBAC 권한을 정의한다. 아래 코드를 예를 들어 설명해보면

  ```go
  //+kubebuilder:rbac:groups=cache.example.com,resources=memcacheds,verbs=get;list;watch;create;update;patch;delete
  ```

  - `cache.example.com` 그룹의 `memcacheds` 리소스에 대해 다양한 동작(예: get, list, watch ... 등) 에대한 권한을 설정하는 주석이다.
  - 이러한 주석은 `Kuberbuilder`가 자동으로 생성한 RBAC 매니페스트 파일을 생성할 때 사용된다.





#### 오퍼레이터 이미지 레지스트리 구성

- **Test 단계에서는 이미지 Build 및 Push를 안해도 된다.**

#### [TODO]

- operator-sdk init 할 때 `domain`을 `cdm.datacommand.co.kr `로 해줘야 한다.

- 코드를 모두 작성 해서 `make manifests` 까지 했다면, Operator 이미지를 빌드하고 레지스트리에 푸시

  



### TEST

- `make deploy`

  - `make deploy`를 해주면 `controller`가 `kubernetes 클러스터`에 배포된다.

  ```
  # kubectl get crd
  
  NAME                                             CREATED AT
  '''
  memcacheds.cache.example.com                     2023-06-01T06:33:35Z
  '''
  ```

  - CRD가 등록되어 있어야 CR 매니페스트를 정의해서 apply 할 수 있다.

  

- 이후 CR ymal 파일을 작성해 apply 해주면 된다.

  - yaml 파일 예시

  ```yaml
  apiVersion: cache.example.com/v1alpha1
  kind: Memcached
  metadata:
    name: memcached-sample
  spec:
    size: 3
    containerPort: 11211
  ```

  - `apiVersion` : CRD의 API 버전을 나타낸다. 일반적으로 `group/version` 형식을 따른다.
  - `kind` : CRD에서 지정한 리소스의 이름
  - `kubectl get crd <crd-name> -o yaml` 명령어를 통해 crd의 매니페스트를 확인할 수 있다.

  

