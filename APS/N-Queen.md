# N-Queen

- 내가 푼 풀이

```python
def dfs(y, x, arr):
    global cnt
    if y == N:
        cnt += 1
        return
    else:
        for i in range(0, N-y):
            arr[y+i][x] += 1
            if 0 <= y+i < N and 0 <= x+i < N:
                arr[y+i][x+i] += 1
            if 0 <= y+i < N and 0 <= x-i < N:
                arr[y+i][x-i] += 1
        if 0 <= y+1 < N:
            for i in range(N):
                if arr[y+1][i] == 0:
                    dfs(y+1, i, arr)
        elif y+1 == N:
            dfs(y+1, x, arr)

        for i in range(0, N-y):
            arr[y+i][x] -= 1
            if 0 <= y+i < N and 0 <= x+i < N:
                arr[y+i][x+i] -= 1
            if 0 <= y+i < N and 0 <= x-i < N:
                arr[y+i][x-i] -= 1

N = int(input())

arr = [[0] * N for _ in range(N)]
cnt = 0
visited = [0] * N
# dfs(0, 0, arr)
for i in range(N):
    dfs(0, i, arr)

print(cnt)
```



- 정석 풀이

```python
N=int(input())
ans=0
col=[0]*(N+1)

def check(i,col):
    k=1
    while (k<i):
        if (col[i]==col[k] or abs(col[i]-col[k])==(i-k)):
            return False
        k+=1
    return True

def queen(i, col):
    global ans
    n=len(col)-1
    if check(i,col):
        if (i==n):
            ans+=1
        else:
            for j in range(1,n+1):
                col[i+1]=j
                queen(i+1, col)

queen(0,col)

print(ans)
```

