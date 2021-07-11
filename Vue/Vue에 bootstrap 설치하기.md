# Vue에 bootstrap 설치하기

### 1. cdn 이용하는 방법

부트스트랩 홈페이지에서 CSS, JS를 복사해서 public 폴더에 있는 index.html에 붙인다.

- CSS : head에 붙임

```html
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous">
```

- JS : body 맨 밑에 붙임

```html
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-MrcW6ZMFYlzcLA8Nl+NtUVF0sA7MsXsP1UyJoMp4YLEuNSfAP+JcXn/tWtIaxVXM" crossorigin="anonymous"></script>
```

끝 -

홈페이지 상황에 따라 느리거나 작동이 안될 수 있다.

### 2. npm으로 설치하는 방법

- 터미널에 입력

```bash
npm install bootstrap@next @popperjs/core
```

- main.js에 복붙

```js
import 'bootstrap'
import 'bootstrap/dist/css/bootstrap.min.css'
```