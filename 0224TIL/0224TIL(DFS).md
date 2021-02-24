# DFS (깊이 우선 탐색)

- 비선형구조인 그래프 구조는 그래프로 표현된 모든 자료를 빠짐없이 검색하는 것이 중요
- 두 가지 방법
  - 깊이 우선 탐색(DFS)
  - 너비 우선 탐색 
- 갈 수 있는 경로가 있는 곳까지 깊이 탐색해 가다가 더 이상 갈 곳이 없게 되면, 가장 마지막에 만났던 갈림길 이 있는 정점으로 되돌아와서 다른 방향의 정점으로 탐색을 계속 반복함. 결국 모든 정점을 방문하는 순회
- 후입선출 구조의 스택 사용





### 관련 문제

- SWEA. 그래프 경로

- 내가 푼 코드 : stack과 visited를 활용하여 DFS 함수를 구현하였다.

  ```python
  import sys
  sys.stdin = open('input.txt')
  
  def dfs(v):
      stack.append(v)
      while stack:
          visited[v] = 1
          if v == G:
              return 1
          else:
              for w in range(1, V+1):
                  if adj[v][w] == 1 and visited[w] == 0:
                      v = w
                      cnt = 1
                      break
                  cnt = 0
              if cnt == 1:
                  stack.append(v)
              else:
                  if len(stack) != 0:
                      stack.pop()
                      v = stack[-1]
      return 0
  	
      
      # 원래는 재귀로 dfs 함수를 호출하려고 했으나 stack overflow가 떠서 실패하였음..
      
      # if v == G:
      #     return 1
      # else:
      #     visited[v] = 1
      #     stack.append(v)
      #
      # for w in range(1, V+1):
      #     if adj[v][w] == 1 and visited[w] == 0:
      #         dfs(w)
      #
      #
      # if not len(stack):
      #     return 0
      # else:
      #     stack.pop()
      #     dfs(stack[-1])
  
  
  
  
  T = int(input())
  cnt = 0
  for tc in range(1, T+1):
      V, E = map(int, input().split())
      arr = [list(map(int, input().split())) for _ in range(E)]
      S, G = map(int, input().split())
  
      adj = [[0] * (V+1) for _ in range(V+1)]
      visited = [0] * (V+1)
      stack = []
  
  
      for i in range(E):
          adj[arr[i][0]][arr[i][1]] = 1
          # adj[arr[i][1]][arr[i][0]] = 1
  
      # print(adj)
  
  
      print("#{} {}".format(tc, dfs(S)))
  
  ```

  - DFS의 개념 자체는 이해하였다. 반복문을 써서 비슷한 유형의 문제를 충분히 풀 수 있을 것 같다
  - 재귀로 푸는 방법도 머리로는 이해하였지만 코드로 구현해보니 에러가 남. 연습할 필요가 있음



