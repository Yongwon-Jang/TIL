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

- ex)

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

  















```go
func (r *MyController) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&corev1alpha1.MyCustomResource{}).
		Complete(r)
}
```

- MyController가 MyCustomResource를 reconcile 하기 위해 hook 되어있다는 것을 쉽게 알 수 있다.



```
Let’s take a look at theFor keyword. If you had asked me when I read this method first time, I would have easily guessed that the MyControlleris being hooked to reconcile against the MyCustomResource{} type. So, any create/update/delete happening with a MyCustomResource object in the cluster would trigger the Reconcile() method of MyController
```

- MyCustomResource 에서 create/update/delete 가 발생하면 reconcile. 방법이 트리거 된다.



```
But what if MyController is not thaatt simple. What if it’s one heck of a complicated controller which is creating and owning other resources like Pods and trying to watch and reconcile them as well.
```



```
Let’s consider our sweet MyController . This controller is special and a bit crazy. What it does is that whenever aMyCustomResource object is created in the cluster, it creates annginx:latest pod with the labels foo: bar . But this controller is very nitpicky. It doesn’t want any add/update/delete happening to the labels of this pod.
```



```
You might be noticing a ton of flaws here like missing finalizers resolution, missing status reporting, etc. I won’t be focusing on that stuff for this blog as the purpose of this blog is around just digging into the aspects of For() , Owns() and Watches()
```



```
The above Reconcile()method will be triggered whenever a create/update/delete would happen with a MyCustomResource
```



```
Someone goes into the cluster and manually removes or updates the foo: bar label. Our beloved MyController wouldn’t want that and would rather expect to be instantly triggered again and undergo through a reconciliation to bring the desired state of the pod back with the desired labels foo: bar
```





```go
  // set MyCustomResource as the owner of the above pod
  if err := controllerutil.SetControllerReference(&myCustomResource, &desiredPod, r.Scheme); err != nil {
      return ctrl.Result{}, err
  }
```

- child pod도 감시하기 위한 코드?



```go
func (r *MyController) SetupWithManager(mgr ctrl.Manager) error {
	return ctrl.NewControllerManagedBy(mgr).
		For(&corev1alpha1.MyCustomResource{}).
		Owns(&corev1.Pod{}).  // trigger the r.Reconcile whenever an Own-ed pod is created/updated/deleted
		Complete(r)
}
```

- Owns() 로 Reconcile 함수에 MyCustomResource 뿐만 아니라 Pod





```go
func (r *MyController) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
  // Get the MyCustomResource being reconciled here
  myCustomResource := corev1alpha1.MyCustomResource{}
  if err := r.Get(ctx, req.NamespacedName, &mycustomResource); err != nil {
    // ignore the error if it corresponds to MyCustomResource not found. 
    return ctrl.Result{}, client.IgnoreNotFound(err)
  }
  
  // fetch the name and namespace of MyCustomResource
  name, namespace := myCustomResource.Name, myCustomResource.Namespace
  labels := map[string]string{
    "foo": "bar",
  }
  
  // desired pod to end up in the cluster
  desiredPod := corev1.Pod{
    ObjectMeta: metav1.ObjectMeta{
      Name: name,
      Namespace: namespace,
      Labels: labels,
    },
    Spec: corev1.PodSpec{
      Containers: []corev1.Container{
        {
          Image: "nginx:latest",
          Name: "nginx-container",
        },
      },
    },
  }
  
  // first let's check if it already exists
  foundPod := &corev1.Pod{}
  if err := r.Get(ctx, client.ObjectKeyFromObject(&desiredPod), &foundPod); err != nil {
    // create the desired pod if the pod doesn't exist already
    if errors.IsNotFound(err) {
      return ctrl.Result{}, r.Create(ctx, &desiredPod)
    }
    return ctrl.Result{}, err
  }
  
  // pod was found
  // validate the labels of the found pod
  expectedLabels := map[string]string{
    "foo": "bar",
  }
  foundLabels := foundPod.Labels
  // if the foundLabels match the expectedLabels, no need to do anything: just exit peacefully
  if reflect.DeepEqual(expectedLabels, foundLabels) {
    return ctrl.Result{}, nil
  }
  
  // else, update the foundPod with expectedLabels
  foundPod.Labels = expectedLabels
  return ctrl.Result{}, r.Update(ctx, foundPod)
}
```

- Reconcile 전체 코드





- `For(<ownerType>)` — Tells the manager to trigger the `Reconcile(...)` whenever any object of <ownerType> is created/updated/deleted
- `Owns(<childType>)` — Tells the manager to trigger the `Reconcile(...)` whenever any object of <childType> having an ownerReference to <ownerType> is created/updated/deleted.