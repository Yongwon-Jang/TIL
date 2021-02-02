# CSS

- `스타일, 레이아웃 등을 표시하는 방법을 지정하는 언어`

- `적용방법`

  1. 인라인 방식 : 관리가 힘들다.
  2. 내부 참조 : `<style>` 태그 사이에 css 문법을 사용하는 방식. 모든 html에 적용할 수 없다.
  3. 외부 참조 : `<link>`태그에 css 파일 경로를 명시해서 사용하는 방식. 유지보수가 수월 
     - **외부 참조를 주로 사용한다.**

- `선택자`

  - 특정한 요소를 선택하기 위해서 필요

  - 기초 선택자

    - 전체 선택자(`*`), 요소선택자
    - 아이디 선택자, 클래스 선택자, 속성 선택자

  - 고급 선택자

    - 자손 선택자 :   띄워쓰기로 구분

      `article p { color: red; }

    - 자식 선택자 : `>`로 구분, 바로 아래의 요소

      `article > p { color: blue; }`

    - 형제 선택자: `~`로 구분, 같은 계층(레벨)에 있는 요소

      `p ~ section {color: green; }`

    - 인접형제 선택자: `+`로 구분, 바로 붙어있는 형제 요소

      `section + p {color: orange;}`

- `적용 순위`

  1. `!important` : 사용시 주의 하여야 한다. 코드의 순서를 뒤흔들 수 있다.
  2. inline style
  3. id 선택자 -> class 선택자 -> 요소 선택자 -> 코드 순서(마지막코드가 제일 높음)

- `CSS 상속`

  - 상속 되는것 : text 관련 요소(font, color, text-align), opacity, visibility
  - 상속되지 않는 것 : box model 관련 요소(w, h, p, m, boder, ) ,position 관련

- `CSS 단위`

  - px
  - %(기준 되는 사이즈에서의 배율)
  - em(상속받는 사이즈에서의 배율) / rem(root 사이즈의 배율  16px이 기본)
  - vh, vw 화면 사이즈에 따라
  - 색상 표현 단위
    - HEX(#000, #000000)
    - RGB / RGBA
    - 색상명
    - HSL(명도, 채도, 색조)

- `Box model`

  - margin : 바깥 여백
  - border : 테두리 영역
  - padding : 내부 여백
  - content : 글이나 이미지 요소

- `box-sizing `

  - content-box : 기본값, width의 너비는 content 영역을 기준으로 잡느다.
  - border-box : width의 너비를 테두리 기준으로 잡는다.

- `margin 상쇄`

  - 수직간의 형제 요소에서 주로 발생.
  - 큰 사이즈의 마진을 조정해준다.
  - padding을 이용한다.

- `DIsplay`

  - block : 가로폭 전체를 차지
    - div, ul, ol, p, hr, form
    - 수평 정렬 margin auto 사용
  - inline
    - 컨텐트의 너비 만큼 가로 폭을 차지
    - width, height, margin-top, margin-bottom 지정할 수 없다.
      - line-height로 위아래 간격 조정.
  - inline-block
  - none : 화면에서 완전히 없애버림.
    - visivility: hidden(보여주지만 않을 뿐 그곳에 자리잡고 있음)



### css position

##### 문서 상에서 요소를 배치하는 방법

- static : 디폴트 값
  - 기본적인 요소의 배치 순서에 따른다.(좌측 상단)
  - 부모 요소 내에서 배치될 때는 부모 요소의 위치를 기준으로 배치 된다.

- 아래는 좌표 프로퍼티를 사용하여 이동이 가능하다. (음수 값도 가능)
  - relative : static 위치를 기준으로 이동 (상대 위치)
  - absolute : static이 아닌 가장 가까이 있는 부모/조상 요소를 기준으로 이동(절대 위치) - 기준점을 잡고 하면 덜 헷걸린다. relative
  - fixde : 부모 요소와 관계 없이 브라우저를 기준으로 이동(고정 위치)
    - 스크롤시에도 항상 같은 곳에 위치
  - sticky : relative와 fixed를 합친 모양