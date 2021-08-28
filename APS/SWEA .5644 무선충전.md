# SWEA 무선 충전(모의 A형)

- 내가 푼 코드

```python
def bfs(b, a, c, d, e):
    for i in range(c+1):
        for j in range(c-i+1):
            nx = a + j
            ny = b + i
            if 1 <= nx < 11 and 1 <= ny < 11:
                arr[ny][nx][e] = d
        for j in range(c-i+1):
            nx = a - j
            ny = b - i
            if 1 <= nx < 11 and 1 <= ny < 11:
                arr[ny][nx][e] = d
        for j in range(c-i+1):
            nx = a + j
            ny = b - i
            if 1 <= nx < 11 and 1 <= ny < 11:
                arr[ny][nx][e] = d
        for j in range(c-i+1):
            nx = a - j
            ny = b + i
            if 1 <= nx < 11 and 1 <= ny < 11:
                arr[ny][nx][e] = d




T = int(input())
for tc in range(1, T+1):
    M, A = map(int, input().split())
    route_A = list(map(int, input().split()))
    route_B = list(map(int, input().split()))
    info_AP = [list(map(int, input().split())) for _ in range(A)]

    # print(info_AP)
    arr = [[[0] * A for _ in range(11)] for _ in range(11)]

    dx = [-1, 0, 1, 0]
    dy = [0, -1, 0, 1]

    for i in range(len(info_AP)):
        a = info_AP[i][0]
        b = info_AP[i][1]
        c = info_AP[i][2]
        d = info_AP[i][3]
        e = i
        arr[b][a][i] = d
        visited = [[0] * 11 for _ in range(11)]
        Q = []
        bfs(b, a, c, d, e)

    # for i in range(11):
    #     for j in range(11):
    #         print(arr[i][j], end=" ")
    #     print()
    # print()

    ans = 0
    ans += max(arr[1][1])
    ans += max(arr[10][10])
    user_A = [1, 1]
    user_B = [10, 10]
    dir = {0: [0, 0], 1: [-1, 0], 2: [0, 1], 3: [1, 0], 4: [0, -1]}
    for i in range(M):
        for j in range(2):
            user_A[j] += dir[route_A[i]][j]
            user_B[j] += dir[route_B[i]][j]
        max_A = 0
        max_B = 0
        idx_A = 99
        idx_B = 99
        for j in range(A):
            if arr[user_A[0]][user_A[1]][j] > max_A:
                max_A = arr[user_A[0]][user_A[1]][j]
                if max_A != 0:
                    idx_A = j
            if arr[user_B[0]][user_B[1]][j] > max_B:
                max_B = arr[user_B[0]][user_B[1]][j]
                if max_B != 0:
                    idx_B = j
        if idx_A != idx_B:
            ans += max_A
            ans += max_B
        else:
            max_A = 0
            max_B = 0
            for j in range(A):
                if j != idx_A and arr[user_A[0]][user_A[1]][j] > max_A:
                    max_A = arr[user_A[0]][user_A[1]][j]
                    # idx_A = j
                if j != idx_B and arr[user_B[0]][user_B[1]][j] > max_B:
                    max_B = arr[user_B[0]][user_B[1]][j]
                    # idx_B = j
            if max_A >= max_B:
                ans += max_A
                ans += max(arr[user_B[0]][user_B[1]])
            else:
                ans += max(arr[user_A[0]][user_A[1]])
                ans += max_B


    print('#{} {}'.format(tc, ans))
```

- 충전기의 범위를 먼저 표시한 후 이동시간에 따른 충전량을 더해줬다.
- 처음에는 BFS를 이용해서 충전기의 범위를 표시하려 했으나, 오류가 발생하여 for문을 이용해 접근하였음
