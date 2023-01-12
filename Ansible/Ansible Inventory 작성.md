## Ansible Inventory 작성

> - Inventory에는 Managed Node가 등록 되어 있다.

#### Inventory 작성 및 사용법

**Inventory 예시**

- /etc/ansible/hosts 파일

```yaml
//호스트 네임과 IP주소로 설정 가능

[webservers]
192.168.0.5
192.168.0.6

[dbservers]
one.example.com
two.example.com
three.example.com

[nossh]
nossh.example.com:5050	//기본 ssh포트를 사용하지 않는다면 이런식으로도 설정 가능

[webservers2]
www[01:50].example.com	//저런식으로 for문 처리를 통해 01 ~ 50 번까지의 이름을 묶을 수 있다.

[databases2]
db-[a:f].example.com	//알파벳 또한 가능
```



- Inventory는 확장자 명이 따로 없다.

- default로 /etc/ansible/hosts 파일을 사용하지만 따로 만들어서 사용해도 된다.

  - 따로 사용할 경우 playbook을 실행할 때 `-i` 옵션을 사용해서 inventory를 지정해줘야 한다.

  ```
  ex)
  [root#] ansible-playbook -i replicator/ansible/ansible_hosts install.yml
  ```

  