# Container PID 조회법

### 목적
- k8s 클러스터 내에서 Pod를 식별해서 Pod에 속한 컨테이너(프로세스)들의 PID를 얻어내는 것
- 얻어낸 PID를 통해 어떤 container 에서 생긴 시스템콜인지 파악한다.

### Container PID 직접 조회 방법
1. 감시해야 될 Pod의 Manifest 조회 (container)
  - [root]# kubectl get pod -n <namespace> <pod-name> -o yaml | grep containerID
    ```yaml
      - containerID: docker://7187a64d9128709a0dd068cfad9d95d8f732e2a410d43df6332e06d6d0adf1f2
    ```
    - 주의사항 : `lastState` 안에도 `containerID`가 있을 수 있는데 종료된 containerID 이다. `containerStatuses` 에 있는 containerID 가 진짜다.
2. 해당 Pod가 실행되고 있는 노드의 프로세스 전체 목록 조회
  - [root]# ls /proc
    ```
    1        11083    1133343  1447     20     22871   2615     2881     3217333  3662     4042     4242  494   622  701  789   826   9039    9890         fb           mdstat        sys
    10       11104    1133395  15       2003   2350    2642     2926     3297     3674     4054     43    4941  633  718  7898  8535  905     9953         filesystems  meminfo       sysrq-trigger
    1014     11126    1133417  15861    2014   2369    2643     2952     33       37       4082     44    495   634  723  7917  8554  9074    9973         fs           misc          sysvipc
    1015     11146    1133492  1586162  2048   2381    2683     2961008  3327     3705     41       4498  496   635  726  7939  8574  9163    acpi         interrupts   modules       thread-self
    1016     11202    1133512  16       2056   2402    2685     2972     3347     3788723  4168173  45    497   637  
    ```
3. 각 프로세스 디렉터리의 CGroup을 조회
   - Pod Manifest에서 조회한 Container ID값과 각 프로세스의 CGroup ID값을 매칭시켜 컨테이너의 PID를 식별
    ```
    [root]# cat 8554/cgroup
    12:pids:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-podfbb6f80b_c058_4010_82e9_a9aca972087f.slice/7187a64d9128709a0dd068cfad9d95d8f732e2a410d43df6332e06d6d0adf1f2
    11:devices:/kubepods.slice/kubepods-besteffort.slice/kubepods-besteffort-podfbb6f80b_c058_4010_82e9_a9aca972087f.slice/7187a64d9128709a0dd068cfad9d95d8f732e2a410d43df6332e06d6d0adf1f2
    ...
    ```
   - 이런식으로 containerID 와 일치하는 값이 있는 cgroup 을 조회할 수 있다.
   - 일치하는 프로세스가 여러개인 경우 최상위 부모 프로세스의 PID(컨테이너의 메인 프로세스의 PID)를 식별하여 CDM-Replicator로 전달

