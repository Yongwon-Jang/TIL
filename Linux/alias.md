## alias

> alias는 별칭이라는 뜻으로 리눅스에서 alias는 사용자가 명령어를 다른 이름으로 바꿔서 사용할 수 있는 내부 명령어를 뜻한다.
>
> - 자주 사용하는 긴 명령어는 alias를 통해 간결하게 만들 수 있다.



####  alias 확인

```
# alias
```

- 현재 등록된 alias 리스트를 확인 할 수 있다.

![alias](images/alias.PNG)

- 이미 우리가 자주 사용하는 명령어들도 alias에 있는것을 확인할 수 있다.



#### alias 등록

- vi 편집기로 ~/.bash_profile에 들어가서 사용하고 싶은 alias를 입력하면 된다.
- `alias [별칭]='[명령어]'` 이런식으로 입력하고 저장해주면 된다.

```
# vi ~/.bash_profile
```

![aliasvi](images/aliasvi.PNG)

- 저장 후 다음 명령어를 입력하면 alias가 등록된다.

```
# source ~/.bash_profile
```

