# Dijkstra

```python
def dijkstra(start):
    # 시작점 0으로 세팅
    u = start     # 시작점을 0으로 설정
    D[u] = 0

    # 정점을 V개 선택
    for i in range(V):
        # 가중치가 최소인 정점을 찾기
        min = 987654321
        for v in range(V):
            if visited[v] == 0 and min > D[v]:
                min = D[v]
                u = v  # 최고값

        # 방문처리
        visited[u] = 1

        # 인접한 정점들의 가중치 업데이트
        for v in range(V):  # u정점의 인접한 v정점들
            if adj[u][v] != 0 and visited[v] == 0 and D[v] > D[u] + adj[u][v]:
                D[v] = D[u] + adj[u][v]
```

