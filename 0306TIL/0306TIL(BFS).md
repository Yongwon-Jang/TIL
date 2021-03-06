## BFS(너비 우선 탐색)

- DFS(깊이 우선 탐색)와는 다르게 탐색 시작점의 인접한 정점들을 모두 차례로 방문한 후에, 방문했던 정점을 시작점으로 하여 다시 인접한 정점들을 차례로 방문하는 방식
- 선입선출 형태의 자료구조인 큐를 활용한다.
- DFS에서는 재귀를 사용했던 것과 다르게 BFS에서는 반복문(주로 while 문)을 이용하여 구현한다.

#### BFS 알고리즘

```python
def bfs(v):
    Q.append(v)
    visited[v] = 1
    print(v, end=" ")
    while Q:
        t = Q.pop(0)
        # t에 인접한 모든 정점 w에 대해서, w: 자식
        for w in range(1, V+1):
            # w가 not visited 이면
            if adj[t][w] == 1 and visited[w] == 0:
                Q.append(w)
                visited[w] = 1
                print(w, end=" ")

V, E = map(int, input().split()) # 정점, 간선
temp = list(map(int, input().split()))
adj = [[0] * (V+1) for _ in range((V+1))] # 인접행렬
Q = []
visited = [0] * (V+1)
# 인접행렬 입력
for i in range(E):
    s, e = temp[2*i], temp[2*i+1] # 한 쌍씩 가져온다
    # 무향 그래프
    adj[s][e] = 1
    adj[e][s] = 1
```

- 코드는 list를 이용한 Queue를 이용했지만, 선형큐, 원형큐, Deque 등을 이용해서 구현하는 방법도 연습해볼 필요가 있다.