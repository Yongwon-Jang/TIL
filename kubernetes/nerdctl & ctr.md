## nerdctl & ctr

> nerdctl과 ctr은 containerd를 조작하는데 사용되는 명령어들이다.

- crictl 명령어를 이용해서 image 를 save 할 방법이 없어서 이런 저런 방법을 찾다가 `nerdctl`, `ctr` 을 찾아서 사용해보았고, CRI-O image를 save 및 load 할 수 있었다.

#### nerdctl 명령어

- nerdctl 명령어는 기본적으로 docker 명령어와 유사하다. 이 글에서는 save, load 에 대해서만 알아보겠다.
- save 명령어 : 이미지를 로컬 파일로 저장

```
# nerdctl save [OPTIONS] IMAGE[:TAG] [IMAGE[:TAG]...] -o FILE
예시)
# nerdctl save -o my-nginx-image.tar nginx:latest
```

- load 명령어 : 이미지 파일을 로컬 이미지로 사용할 수 있도록 만든다.

```
# nerdctl load -i FILE
예시)
# nerdctl load -i my-nginx-image.tar
```

#### ctr 명령어

- ctr 명령어는 낮은 수준의 도구로서, containerd에 대한 직접적인 조작을 가능하게 한다. 다만 docker를 사용하던 사람에게는 익숙하지 않다.
- export 명령어

```
# ctr images export --compress IMAGE.tar IMAGE[:TAG]
예시)
# ctr images export --compress nginx.tar docker.io/library/nginx:latest
```

- import 명령어

```
# ctr images import IMAGE.tar
예시)
# ctr images import nginx.tar
```



#### 주의

ctr 명령을 사용하면 다음과 같은 문구가 뜬다.

```
DESCRIPTION:

ctr is an unsupported debug and administrative client for interacting
with the containerd daemon. Because it is unsupported, the commands,
options, and operations are not guaranteed to be backward compatible or
stable from release to release of the containerd project.
```

- 해석하면

```
이 메시지는 ctr를 사용할 때 containerd 프로젝트의 컨테이너 데몬과 상호 작용하는 데 사용되는 비공식적인 디버그 및 관리 클라이언트임을 설명하고 있습니다. 이 문구에서 "지원되지 않음(unsupported)"이라는 것은 ctr는 공식적으로 지원되지 않는 도구이기 때문에, 명령어, 옵션 및 작업이 프로젝트의 각 버전 간에 안정적이거나 하위 호환성을 보장하지 않는다는 것을 의미합니다.

간단히 말해, ctr는 containerd 데몬과 상호 작용하도록 설계된 도구이지만, 비공식적이기 때문에 사용시 주의가 필요하며, 프로젝트의 변동사항으로 인해 작동이 불안정할 수 있다는 것을 알리고 있습니다. 따라서 프로덕션 환경이나 향후 버전의 호환성을 기대하는 사용자에게는 권장되지 않습니다. ctr 대신 사용자가 겪는 문제에 대해 공식지원을 받을 수 있는 대체 도구를 찾는 것이 좋습니다. 예를 들면, 이미 nerdctl이 언급된 대로 Docker 사용자들에게 친숙한 명령어를 제공합니다.
```

- 따라서 사용 시 주의가 요구된다.