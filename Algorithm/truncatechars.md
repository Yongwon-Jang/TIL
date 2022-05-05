# Djang 원하는 글자 수만 표현한는 법

### |truncatechars:글자 수

#### ex) 코드

```python
<p class="card-text">{{ movie.overview|truncatechars:100 }}</p>
```

{{ 변수 }} 안에 `truncatechars:글자 수` 를 같이 넣어주면 원한는 글자 수 만큼만 표시되고 나머지는 ...으로 표시됨. ...도 한글자로 적용됨.

