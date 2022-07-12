## SELinux

### SELinux 란

> 관리자가 시스템 액세스 권한을 효과적으로 제어할 수 있게 하는 Lunux 시스템용 보안 아키텍처

####  SELinux 동작 모드

- enforcing
  - SELinux의 기본값으로 활성화 상태, 보안 정책이 실행되어 로그 기록과 보호를 모두 수행하는 상태
- permissive
  - SELinux가 보안정책에 대해서 로그는 기록하지만 실제 차단되지 않는 상태
- disabled
  - SELinux가 비활성화 되어 동작하지 않는 상태

#### SELinux 상태 확인

1. sestatus

```go
// disable
[root@localhost ~]# sestatus
SELinux status:                 disable

// enabled
[root@localhost ~]# sestatus
SELinux status:                 enabled
SELinuxfs mount:                /sys/fs/selinux
SELinux root directory:         /etc/selinux
Loaded policy name:             targeted
Current mode:                   enforcing
Mode from config file:          enforcing
Policy MLS status:              enabled
Policy deny_unknown status:     allowed
Memory protection checking:     actual (secure)
Max kernel policy version:      33

```

2. getenforce

```
[root@localhost ~]# getenforce
Disabled

[root@localhost ~]# getenforce
Enforcing
```



#### SELinux 끄기 (disabled)

```
[root@k8s1 ~]# vi /etc/selinux/config

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing     <-- disabled 로 변경
# SELINUXTYPE= can take one of three values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted

저장 후 reboot
```