# SWEA .5644 무선충전

- 미완

```
import sys
sys.stdin = open('무선 충전_input.txt')

def bfs(y, x, c, d, e):
    check = 0
    visited[y][x] = 1
    Q.append([y, x])
    while Q:
        t = Q.pop(-1)
        for i in range(4):
            ny = t[0] + dy[i]
            nx = t[1] + dx[i]
            if 1 <= ny < 11 and 1 <= nx < 11 and visited[ny][nx] == 0:
                arr[ny][nx][e] = d
                visited[ny][nx] = visited[t[0]][t[1]] + 1
                check = visited[ny][nx]
                if check < c+1:
                    Q.append([ny, nx])


T = int(input())
for tc in range(1, T+1):
    M, A = map(int, input().split())
    route_A = list(map(int, input().split()))
    route_B = list(map(int, input().split()))
    info_AP = [list(map(int, input().split())) for _ in range(A)]

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



    for i in range(11):
        for j in range(11):
            print(arr[i][j], end=" ")
        print()
    print()

    # ans = 0
    # ans += max(arr[1][1])
    # ans += max(arr[10][10])
    # user_A = [1, 1]
    # user_B = [10, 10]
    # dir = { 0 : [0, 0], 1 : [-1, 0], 2 : [0, 1], 3 : [1, 0], 4 : [0, -1]}
    # for i in range(M):
    #     for j in range(2):
    #         user_A[j] += dir[route_A[i]][j]
    #         user_B[j] += dir[route_B[i]][j]
    #     max_A = 0
    #     max_B = 0
    #     idx_A = 0
    #     idx_B = 0
    #     for j in range(A):
    #         if arr[user_A[0]][user_A[1]][j] > max_A:
    #             max_A = arr[user_A[0]][user_A[1]][j]
    #             idx_A = j
    #         if arr[user_B[0]][user_B[1]][j] > max_B:
    #             max_B = arr[user_B[0]][user_B[1]][j]
    #             idx_B = j
    #     if idx_A != idx_B:
    #         ans += max_A
    #         ans += max_B
    #     else:
    #         max_A = 0
    #         max_B = 0
    #         for j in range(A):
    #             if j != idx_A and arr[user_A[0]][user_A[1]][j] > max_A:
    #                 max_A = arr[user_A[0]][user_A[1]][j]
    #                 # idx_A = j
    #             if j != idx_B and arr[user_B[0]][user_B[1]][j] > max_B:
    #                 max_B = arr[user_B[0]][user_B[1]][j]
    #                 # idx_B = j
    #         if max_A >= max_B:
    #             ans += max_A
    #             ans += max(arr[user_B[0]][user_B[1]])
    #         else:
    #             ans += max(arr[user_A[0]][user_A[1]])
    #             ans += max_B



        # if max(arr[user_A[0]][user_A[1]]) != max(arr[user_B[0]][user_B[1]]):
        #     ans += max(arr[user_A[0]][user_A[1]])
        #     ans += max(arr[user_B[0]][user_B[1]])
        # else:


    # print(ans)
```