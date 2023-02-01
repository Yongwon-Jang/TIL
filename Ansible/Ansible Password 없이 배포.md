### Ansible Password 없이 배포

> 이 포스트는 `ansible`을 사용해서 배포할 때 `/etc/ansible/hosts`  파일에 password를 입력해줘야 하는데 배포하는 노드들의 `password`가 다르거나 `password`를 입력할 수 없는 상황 일때 `ansible` 배포하는 법에 대해서 다룹니다.



- 배포하는 모든 노드들이 ssh 연결 되어있다고 가정하에 진행합니다.

1. hosts 파일 작성

```
'''
[deployment]
192.168.1.101
192.168.1.102
192.168.1.103

'''
```



2. key.yaml 파일 생성 및 실행

```yaml
- name: ssh-keygen
  hosts: deployment
  gather_facts: no

  tasks:
    - name: create key
      connection: local
      command: "ssh-keygen -b 2048 -t rsa -f ~/.ssh/id_rsa -q -N ''"
      ignore_errors: yes
      run_once: true

    - name: input key
      authorized_key:
        user: root
        state: present
        key: "{{ lookup('file', '~/.ssh/id_rsa.pub') }}"
```

```
[root]# ansible-playbook /root/key.yaml
```

- 이 과정을 통해 hosts에 설정한 노드에 key가 생성되었습니다. key 생성 이후에는 password 없이도 playbook을 통해 배포가 가능합니다.