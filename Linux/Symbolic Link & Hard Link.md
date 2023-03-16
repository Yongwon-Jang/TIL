## Symboilc Link & Hard Link

> 파일 시스템에서는 두 가지 종류의 링크가 존재 한다.
>
> - 하드 링크 (Hard link)
> - 심볼릭 링크 (Symbolic link)

링크는 파일 또는 디렉토리를 가리키는 포인터 이다. 링크를 사용하려면 `inode(index node)`를 가지고 있어야 한다.

### Inode

- 파일 시스템에서의 데이터 파일 구조로, 파일을 저장하는 공간.
- 사용자는 파일의 이름으로 파일을 식별하고, 시스템은 `inode`로 파일을 식별한다.
- 각 파일은 오직 하나의 `inode`를 가진다.

### Hard Link

- 하드 링크는 `inode`를 통해 파일을 직접 참조한다. 디렉토리에는 사용이 불가능 하다.
- 하드 링크는 원본과 같은 `inode`를 바라보기 때문에 같은 `inode`가 두개 존재하면 하드 링크라는 것을 알 수 있다.
- 원본 파일이 삭제되어도 링크된 파일은 파일의 내용을 보존한다.

#### 생성

```
# ln [source] [target] 
```

- source : 링크 할 파일
- target : 생성할 링크 파일

#### 삭제

```
# rm -rf [hardlink]
```

- 일반 파일 삭제와 동일



### Symbolic Link(symlink)

- 심볼릭 링크는 inode 값이 아닌 파일을 참조하는 포인터로 일종의 **바로가기** 이다. 디렉토리에도 사용 가능하다.

#### 생성

```
# ln -s [source] [target]
```

- source : 링크 할 파일
- target : 생성할 링크 파일

#### 삭제

```
# rm -rf [symbolic link]
```

- 일반 파일 삭제와 동일