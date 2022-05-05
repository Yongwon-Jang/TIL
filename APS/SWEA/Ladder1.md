## SWEA 1210. Ladder1

사다리 문제 : 몇 번째 자리에서 출발해야 2에 도착하는지를 찾는 문제

```python
T = 10
N = 100
for tc in range(1, T + 1):
    t = int(input())
    arr = [list(map(int, input().split())) for _ in range(N)]

    dx = [-1, 1, 0]
    dy = [0, 0, -1]


    for i in range(N):
        for j in range(N):
            if arr[i][j] == 2:
                a = i
                b = j
                break

    while a > 0:
        for i in range(3):
            if b == 0 and i == 0:
                continue
            if b == 99 and i == 1:
                continue
            if arr[a + dy[i]][b + dx[i]] == 1:
                a = a + dy[i]
                b = b + dx[i]
                arr[a][b] = 0
                break
    print("#{} {}".format(t, b))
```

풀이

1. 이중 for문을 통해 2가 있는 위치의 좌표를 구한다.
2. 델타를 이용해 1이 있는 방향으로 이동하며 맨 위로 올라간다.
3. y좌표가 0이 되는 지점의 x좌표를 구한다.

문제 풀면서 어려웠던 점

1. 델타를 사용하는 것이 아직 익숙하지 않다. 여러 문제를 풀면서 좀 더 익힐 필요가 있음
2. 문제를 풀 때 다양한 상황에 대해서 생각하지 않고 코드를 적다 보니 에러가 많이 나왔고, 코드가 복잡해 질 수록 스스로 해석할 수가 없어서 어디서 틀렸는지를 찾기 힘들었다 > 복잡한 문제를 풀 때는 다양한 상황에 대해서 생각을 더 할 필요가 있고 가능하다면 공책에 미리 적어보는게 좋다.. 하지만 말처럼 잘 안됨.
3. 델타를 좌, 우, 상 순서로 작성 했는데 우로 이동 했을 때 다음 칸에서 다시 좌로 이동하는 경우가 발생.. 이동한 지점을 0으로 만들어 해결