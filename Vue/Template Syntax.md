# Template Syntax

- 렌더링 된 DOM을 기본 Vue 인스턴스의 데이터에 선언적으로 바인딩 할 수 있는 HTML 기반 템플릿 구문을 사용

### Interpolation

- Text

  ```
  {{ msg }}
  ```

  

- Raw HTML

  ```
  <span v-html="rawHtml"></span>
  ```

- Attributes

  ```
  <div v-bind:id="dynamicId"></div>
  ```

- JS 표현식

  ```
  {{ number + 1}}
  {{ msg.split('').reverse().join('') }}
  ```

  

### Directive

- v- 접두사가 있는 특수 속성

### v-text

### v-html

### v-show

### v-if, v-else-if, v-else

### v-for

### v-on

### v-bind

### v-model





