# FLEXBOX FROGGY

- display: flex; 를 선언 하고 사용!



### justify-content

- `flex-start`: 요소들을 컨테이너의 왼쪽으로 정렬합니다.
- `flex-end`: 요소들을 컨테이너의 오른쪽으로 정렬합니다.
- `center`: 요소들을 컨테이너의 가운데로 정렬합니다.
- `space-between`: 요소들 사이에 동일한 간격을 둡니다.
- `space-around`: 요소들 주위에 동일한 간격을 둡니다.



### align-items

- `flex-start`: 요소들을 컨테이너의 꼭대기로 정렬합니다.
- `flex-end`: 요소들을 컨테이너의 바닥으로 정렬합니다.
- `center`: 요소들을 컨테이너의 세로선 상의 가운데로 정렬합니다.
- `baseline`: 요소들을 컨테이너의 시작 위치에 정렬합니다.
- `stretch`: 요소들을 컨테이너에 맞도록 늘립니다.



### flex-direction

- `row`: 요소들을 텍스트의 방향과 동일하게 정렬합니다.
- `row-reverse`: 요소들을 텍스트의 반대 방향으로 정렬합니다.
- `column`: 요소들을 위에서 아래로 정렬합니다.
- `column-reverse`: 요소들을 아래에서 위로 정렬합니다.



### order

- 요소에 숫자를 지정해 순서를 정할 수 있다.
- 개별 요소에 적용한다.
- 기본 값을 0이며 양수나 음수로 바꿀 수 있다.  `order: 1`
- 값이 클 수 록 뒤로 배치된다.



### align-self

- 개별 요소에 적용할 수 있는 속성이며, `align-items` 가 사용하는 값들을 인자로 받으며, 그 값들은 지정한 요소에만 적용된다.



### flex-wrap

- `nowrap`: 모든 요소들을 한 줄에 정렬합니다.
- `wrap`: 요소들을 여러 줄에 걸쳐 정렬합니다.
- `wrap-reverse`: 요소들을 여러 줄에 걸쳐 반대로 정렬합니다.



### flex-flow

- `flex-direction`과 `flex-wrap` 이 같이 자주 사용되는데 이 둘을 한줄에 사용할 수 있다.

  ```html
  flex-flow: column wrap
  ```

  

### 총 복습

- `justify-content`
- `align-items`
- `flex-direction`
- `order`
- `align-self`
- `flex-wrap`
- `flex-flow`
- `align-content`