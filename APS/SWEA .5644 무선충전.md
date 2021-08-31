# SWEA 무선 충전(모의 A형)

### 문제 요약

- 10*10 영역의 지도에 충전기가 임의로 배치되어있는데, 2명의 사용자가 M 시간 동안 지도를 이동하면서 충전할 수 있는 충전량의 합의 최대값을 구하라
- 두 사람이 같은 시간에 사용할 수 있는 충전기가 겹치면 충전 되는 양은 반으로 줄어들고, 한 위치에서 두개 이상의 충전기를 사용할 수 있다면 선택해서 사용할 수 있다.

### 나의 문제 접근 방법

1. 지도에 충전기를 먼저 나타냈다. 충전을 할 수 있는 모든 곳에 충전할 수 있는 양을 기입했다.
2. 충전기가 2개 이상이기 때문에 3차원 배열을 이용하여, 모든 충전기가 지도에 입력 될 수 있도록 했다.
3. 사용자가 이동할 때마다 그 시간에 충전 할 수 있는 최대값을 더해주었다.

### 내가 푼 코드

```python
def battery(b, a, c, d, e):
    for i in range(c+1):
        # 중심을 기준으로 오른쪽 아래를 채운다.
        for j in range(c-i+1):
            nx = a + j
            ny = b + i
            if 1 <= nx < 11 and 1 <= ny < 11:
                arr[ny][nx][e] = d
        # 중심을 기준으로 왼쪽 위를 채운다.
        for j in range(c-i+1):
            nx = a - j
            ny = b - i
            if 1 <= nx < 11 and 1 <= ny < 11:
                arr[ny][nx][e] = d
        # 중심을 기준으로 오른쪽 위를 채운다.
        for j in range(c-i+1):
            nx = a + j
            ny = b - i
            if 1 <= nx < 11 and 1 <= ny < 11:
                arr[ny][nx][e] = d
        # 중심을 기준으로 왼쪽 아래를 채운다.
        for j in range(c-i+1):
            nx = a - j
            ny = b + i
            if 1 <= nx < 11 and 1 <= ny < 11:
                arr[ny][nx][e] = d




T = int(input())
for tc in range(1, T+1):
    M, A = map(int, input().split())
    route_A = list(map(int, input().split()))  # 사용자 A의 이동 정보
    route_B = list(map(int, input().split()))  # 사용자 B의 이동 정보
    info_AP = [list(map(int, input().split())) for _ in range(A)] # AP의 정보

    # 10*10 2차원 지도에 충전기의 갯수를 추가 해서 3차원 리스트를 만들었다.
    arr = [[[0] * A for _ in range(11)] for _ in range(11)]
	
    # 혹시 몰라서 만들었는데 필요가 없었음
    dx = [-1, 0, 1, 0]
    dy = [0, -1, 0, 1]
	
    
    
    for i in range(len(info_AP)):
        a = info_AP[i][0] # x좌표
        b = info_AP[i][1] # y좌표
        c = info_AP[i][2] # 배터리의 범위
        d = info_AP[i][3] # 충전량
        e = i # 몇번 째 충전기인지 확인
        arr[b][a][i] = d # 충전기 중심부 // 지도의 (b, a)에서 i번째 배터리를 이용해 충전하였고 충전량은 d이다.
        bttery(b, a, c, d, e) # 지도를 모두 채워준다.
	
    
    #### 지도를 시각적으로 보면서 어떤 부분이 잘못되었는지 수시로 확인하였다.
    # for i in range(11):
    #     for j in range(11):
    #         print(arr[i][j], end=" ")
    #     print()
    # print()
	
    
    #### 여기서 부터는 이동 시간에 따라 최대 충전량을 더해준다.
    ans = 0
    ans += max(arr[1][1]) # 사용자 A의 시작점
    ans += max(arr[10][10]) # 사용자 B의 시작점
    user_A = [1, 1]
    user_B = [10, 10]
    dir = {0: [0, 0], 1: [-1, 0], 2: [0, 1], 3: [1, 0], 4: [0, -1]} # 이동 방향
    for i in range(M):
        for j in range(2):
            # 이동 방향에 따른 유저의 위치
            user_A[j] += dir[route_A[i]][j]
            user_B[j] += dir[route_B[i]][j]
        max_A = 0
        max_B = 0
        idx_A = 99
        idx_B = 99
        for j in range(A):
            # A의 최댓값
            if arr[user_A[0]][user_A[1]][j] > max_A:
                max_A = arr[user_A[0]][user_A[1]][j]
                if max_A != 0:
                    idx_A = j
            # B의 최댓값
            if arr[user_B[0]][user_B[1]][j] > max_B:
                max_B = arr[user_B[0]][user_B[1]][j]
                if max_B != 0:
                    idx_B = j
        # 최댓값을 idx가 같으면 같은 충전기를 사용한다는 뜻
        if idx_A != idx_B:
            ans += max_A
            ans += max_B
        else:
            max_A = 0
            max_B = 0
            # 최댓값 제외하고 사용할 수 있는 나머지 충전기의 값이 더 큰 쪽을 사용 
            for j in range(A):
                if j != idx_A and arr[user_A[0]][user_A[1]][j] > max_A:
                    max_A = arr[user_A[0]][user_A[1]][j]
                if j != idx_B and arr[user_B[0]][user_B[1]][j] > max_B:
                    max_B = arr[user_B[0]][user_B[1]][j]
            if max_A >= max_B:
                ans += max_A
                ans += max(arr[user_B[0]][user_B[1]])
            else:
                ans += max(arr[user_A[0]][user_A[1]])
                ans += max_B


    print('#{} {}'.format(tc, ans))
```

### 어려웠던 점

쉽게 생각하면 쉬울 수 있는 문제인데, 충전기를 입력시키는데 어렵게 접근을 했다. 처음에 BFS로 입력을 시켰는데 만드는데 까지 너무 오랜시간이 걸렸고, 정확하게 입력이 되지 않았다.

생각을 바꿔 반복문을 통해 더 간단하게 입력을 시킬 수 있었고, 충전기만 지도에 잘 입력되면 시간은 좀 걸리지만 어렵지 않게 답을 구할 수 있었음

물론 문제를 푸는데 여러 방법이 있겠지만 시간이 한정되어있기 때문에 최선의 방법으로 접근하는 연습을 해야한다.

- 충전기의 범위를 먼저 표시한 후 이동시간에 따른 충전량을 더해줬다.
- 처음에는 BFS를 이용해서 충전기의 범위를 표시하려 했으나, 오류가 발생하여 for문을 이용해 접근하였음
