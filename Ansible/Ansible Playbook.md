## Ansible Playbook

> 계획된 작업을 순서대로 실행하기 위해 작성하는 `yml, yaml` 파일

#### 예시

```yaml
- name: open iptables
  hosts: test1 
  tasks:
          - name : insert ip port
            lineinfile:
              path: /etc/sysconfig/iptables
              line: -A INPUT -p tcp -m multiport --dports 61000:61999 -m comment --comment "delta_replicator" -j ACCEPT
              insertbefore: 'COMMIT'

- name: restart systemctl
  hosts: test1 
  tasks:
          - name: restart cmd
            systemd:
              name: iptables
              state: restarted
              enabled: yes
            become: yes
            become_user: root
```

- name : 어떤 play인지 설명하는 부분(제목)
- hosts : inventory 에서 대괄호`[ ]` 안에 정의한 이름을 적는다. 그 이름에 해당하는 노드에 task를 실행
- tasks : 무슨 작업을 할지 적는 부분
  - 옵션
    - `lineinfile` : path에 해당하는 파일을 찾아서 입력하고 싶은 명령어를 입력할 수 있다.
    - `command`: 해당 노드에 원하는 명령어를 입력 가능
- ansible-play 북 실행하면 yaml 파일에 있는 순서대로 task를 진행한다.

#### command  옵션 사용법

##### ex)

```yaml
- name: open iptables
  hosts: test1
  tasks:
          - name : insert ip port
            command : iptables -I INPUT -p tcp -m multiport --dports 61000:61999 -m comment --comment "ip_test" -j ACCEPT

- name: save iptables
  hosts: test1
  tasks:
          - name : save iptables
            command : /usr/libexec/iptables/iptables.init save # iptables 에 저장
```

