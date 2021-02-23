# Stack

### 특성

- 물건을 쌓아 올리듯 자료를 올린 형태
- 선형구조
  - 자료 간의 관계가 1대1
- 후입선출



### 연산

- 삽입 : push
- 삭제 : pop -> 항상 비었는지 확인해야 한다.
- 공백인지 아닌지 : isEmpty
- 스태의 top에 있는 item을 반환 : peek



### 문제

SWEA.4873 반복문자 지우기

- 설명 : 주어진 문자열 중 반복문자를 지운 후 남은 문자열의 길이를 출력하는 문제

- 내가 푼 코드

  ```python
  T = int(input())
  for tc in range(1, T+1):
      s = input()
      stack = [s[0]]
  
      for i in range(1, len(s)):
          if len(stack) != 0:
              if s[i] != stack[-1]:
                  stack.append(s[i])
              else:
                  if len(stack) == 0:
                      continue
                  else:
                      stack.pop()
          else:
              stack.append(s[i])
      print("#{} {}".format(tc, len(stack)))
  ```

- 풀이

  - 스택의 개념을 이해해야 풀 수 있는 문제이다.
  - 문자열을 하나씩 돌면서 만약 그 문자열이 stack에 없으면 push 있으면 pop을 해나가면서 풀어야 한다.
  - 주의해야 할 점은 pop을 하기전에 Empty 체크를 해야 한다. 아니면 에러가 날 수 있음