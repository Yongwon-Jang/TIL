## Operator란?

> CRD(Custom Resource Definitions)와 상호작용하는 정교한 Reconcil 과정을 나타내며, 이를 통해  Operator는 복잡한 어플리케이션 도메인 로직을 캡슐화하여 관리할 수 있다.
>
> k8s Operator는 CR(Custom Resource)의 Controller로 이해하면 쉬울 것 같다.

#### controller란?

- 간단하게 말하면 k8s에서 resource의 상태를 감시하며 원하는 Spec으로 만들어 주는 것을 말한다.



#### Why Operator?

- 기본적으로 k8s에서 제공되는 Controller의 기능 이외에 더 복잡한 어플리케이션 관리 로직이 필요한 경우가 분명 존재한다. 이 때 필요한 것이 Operator이다.



#### Workflow 비교

- **kubernetes**

![1](images/1.png)

- **Operator**

![2](images/2.png)



#### Operator Tools

- Operator-SDK를 주로 사용한다.

#### 참고

- https://sphong0417.tistory.com/3