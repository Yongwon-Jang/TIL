- ### 조건문의 종류와 특징

  - if statement

    - 조건 표현식의 결과값을 Boolean 타입으로 변환 후 참/거짓 판단

    ```javascript
    if (condition) {
        // do something
    } else if (condition) {
        // do something
    } else {
        // do something
    }
    ```

    

  - switch statement

    - 조건 표현식의 결과값이 어느 값(case)에 해당하는지 판별

    ```javascript
    switch(expression) {
        case 'first value':{
            // do someting
            [break]
        }
        case 'second value' : {
            // do something
            [break]
        }
        [default: {
    	  // do something
         }]
    }
    ```

    

  동등 비교 연산자 (==) *잘 사용하지 않음*

  일치 비교 연산자 (===)

  논리 연산자

  ```
  and -> &&
  or -> ||
  not -> !
  ```

  단축 평가

  - false && true => false
  - true || false => true

  삼항 연산자

  - 세 개의 피연산자를 사용하여 조건에 따라 값을 반환하는 연산자
  - 가장 왼쪽의 조건식이 참이면 콜론(:) 앞의 값을 사용하고 그렇지 않으면 콜론 뒤의 값을 사용

  

  

  반복문 (for)

  ```javascript
  for (초기값 ; 조건 ; 증감) {
      코드
  }
  
  ```

  for ... in 객체 순회 적합

  ```javascript
  for (variable in object) {
  	// do something
  }
  ```

  for ... of 배열 원소 순회

  ```
  
  ```

  

  ### 함수

  - 선언식
    - 선언식으로 선언한 함수는 var 처럼 hoistiong 발생

  ```javascript
  function add (num1, num2) {
      return num1 + num2
  }
  
  add(2, 7)
  ```

  

  - 표현식
    - 표현식 : 어떤 하나의 값으로 결정되는 코드의 단위
    - 익명함수는 함수 표현식에서만 사용 가능

  ```javascript
  const sub = function (num1, num2) {
      return num1 - num2
  }
  
  sub(7, 2)
  ```

  

  - 선언식 함수와 표현식 함수 모두 타입은 function

  

  ### Arrow Function

  - function 키워드 생략 가능
  - 함수의 매개변수가 단 하나 뿐이라면, `()`도 생략 가능
  - 함수 바디가 표현식 하나라면 `{}`과 `return`도 생략 가능

  ```javascript
  const arrow = function (name) {
      return `hello ${name}`
  }
  
  // 1. function 키워드 삭제
  const arrow = (name) => {return `hello! ${name}`}
  
  // 2. () 생략
  const arrow = name => {return `hello! ${name}`}
  
  // 2. {} & return 생략
  const arrow = name => `hello! ${name}`
  ```

  

  ### 배열

  - 파이썬에서의 list라고 생각하면 된다.
  - 순서를 보장
  - 키와 속성들을 담고 있는 참조 타입의 객체
  - 주로 대괄호를 이용해서 생성, 0을 포함한 양의 정수 인덱스로 특정 값에 접근 가능
  - 배열의 길이는 `array.length` 형태로 접근

  - method
    - reverse : 원본 배열을 반대로
    - push & pop : 배열의 마지막 요소를 추가 또는 제거
    - unshift & shift : 배열의 가장 앞 요소를 추가 또는 제거
    - includes : 배열에 특정 값이 존재하면 참, 아니면 거짓
    - indexOf : 배열의 특정 값이 존재하는지 판별 후 인덱스 반환, 없으면 -1
    - join : 배열의 모든 요소를 구분자를 이용하여 연결, 구분자 생략 시 쉼표

  

  ### 배열 심화

  - 주요 메서드 : 메서드 호출 시 인자로 callback함수를 받는 것이 특징
    - forEach : 배열의 각 요소에 대해 콜백 함수를 한 번씩 실행, 반환 값 없음
    - map : 콜백 함수의 반환 값을 요소로 하는 새로운 배열 반환
    - filter : 콜백 함수의 반환 값이 참인 요소들만 모아서 새로운 배열을 반환
    - reduce : 콜백 함수의 반환 값들을 하나의 값(acc)에 누적 후 반환
    - find : 콜백 함수의 반환 값이 참이면 해당 요소를 반환
    - some : 배열의 요소 중 하나라도 판별 함수를 통과하면 참을 반환
    - every : 배열의 모든 요소가 판별 함수를 통과하면 참을 반환

  

  ### 객체 관련 ES6 문법

  - 속성명 축약 : key와 value의 이름이 같으면 축약 가능
  - 메서드명 축약 : 메서드 선언 시 function 키워드 생략 가능
  - 계산된 속성 : 객체를 정의할 때 key의 이름을 표현식을 이용하여 동적으로 생성 가능( 대괄호[] 안에서)
  - 구조 분해 할당 : 배열 또는 객체를 분해하여 속성을 변수에 쉽게 할당할 수 있는 문법



#### spread 문법

```javascript
const a = [1, 2, 3, 4, 5]
const b = ['a', 'b', 'c']

let c = a.concat(b)
c => [1, 2, 3, 4, 5, 'a', 'b', 'c']

c = a + b (사용 불가)

// 스프레드
c = [ ...a, ...b]    // a를 풀어서 놓고, b를 풀어서 놓는 느낌
c => [1, 2, 3, 4, 5, 'a', 'b', 'c']

딕셔너리도 사용 가능
```



#### destructuring

```javascript
const a = {
    b: 2,
    c: 3
}

const b = a.b
b => 2

// 하지만 변수가 많아지면?
const test = {
    a:1, b:2, c:3, d:4, e: 5
}

let { a, b, d } = test

=> 밑의 식과 동일한 의미
let a = test.a
let b = test.b
let c = test.c
```

