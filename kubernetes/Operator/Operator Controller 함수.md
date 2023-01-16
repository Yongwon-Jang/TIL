## Operator Controller 함수

#### SetupWithManager

- `controllers/*_controller.go` 안에 있는 `SetupWithManager()` 함수는 `CR`과 다른 `resources`를 `controller`가 어떻게 감시할지 지정한다.

- ex)

  ```go
  func (r *MemcachedReconciler) SetupWithManager(mgr ctrl.Manager) error {
  	return ctrl.NewControllerManagedBy(mgr).
  		For(&cachev1alpha1.Memcached{}).
          Owns(&appsv1.Deployment{}).
          WithOptions(controller.Options{
              MaxConcurrentReconciles: 2,
          }).Complete(r)
  }	
  ```

  - `NewControllerManagedBy()`
    - 다양한 컨트롤러 구성을 허용하는 `controller builder`를 제공
  - `For(&cachev1alpha1.Memcached{})`
    - 컨트롤러가 관찰하기 위한 우선적인 리소스를 `Memcached` 타입으로 특정한다.
    - `Memcached` 타입의 `Add/Update/Delete` 이벤트에 대해 `Reconcil` 루프가 해당`Memcached` 개체에 대한 `Reconcil` 요청을 전송한다.
  - `Owns(&appsv1.Deployment{})`
    - 컨트롤러가 관찰하기 위한 추가 리소스로 `Deployments`를 지정한다.
    - 위 코드는 `Memcached Object`가 생성한 `Deployment`를 관찰하는 것을 의미한다.
  - `WithOptions`
    - `withOptions` 를 사용하면 Controller에 적용할 다양한 옵션을 추가할 수 있다.
    - 이 경우에는 `Reconcil`을 동시에 최대 2개 수행 한다는 것을 의미
  - 그 외 `Watches`, `WithEventFilter` 등 여러 함수들이`vendor/sigs.k8s.io/controller-runtime/pkg/builder/controller.go` 에 정의되어 있다.



#### Reconcile

- 시스템의 실제 상태`(actual state)`를 원하는 `CR` 상태로 적용하는 역할은 한다.
- CR 또는 resources에서 이벤트가 발생할 때마다 실행되며 해당 상태가 일치하는지 여부에 따라 일부 값을 반환한다.
- 모든 `Controller`는 `reconcile loop`를 실행하기 위해  `Reconcile()` Method 를 가진다.
  - ` reconcile loop`는 실제 상태를 CR 상태로 적용하기 위해 돌아가는 루프 정도로 이해하면 될 것같다.

- ex

  ```go
  func (r *MemcachedReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    // Lookup the Memcached instance for this reconcile request
    memcached := &cachev1alpha1.Memcached{}
    err := r.Get(ctx, req.NamespacedName, memcached)
    ...
  }
  ```

  - `r.Get`을 통해 기본 리소스 개체인 `Memcached`를 조회할 수 있다.

- return option

  - With the error

  ```go
  return ctrl.Result{}, err
  ```

  - Without an error

  ```go
  return ctrl.Result{Requeue: true}, nil
  ```

  - Therefore, to stop the Reconcile, use

  ```go
  return ctrl.Result{}, nil
  ```

  - Reconcile again after X time

  ```go
  return ctrl.Result{RequeueAfter: nextRun.Sub(r.Now())}, nil
  ```

  