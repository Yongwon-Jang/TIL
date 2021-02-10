# 카운팅 정렬(Counting Sort)

- 항목들의 순서를 결정하기 위해 집합에 각 항목이 몇 개씩 있는지 세는 작업을 함.
- 선형 시간에 정렬하는 효율적인 알고리즘
- 제한사항
  - 정수나 정수로 표현할 수 있는 자료에 대해서만 정렬이 가능
  - 카운트를 하기 위해 집합 내의 가장 큰 정수를 알아야 한다
- 시간 복잡도
  - O(n + k)

```python
def Counting_Sort(A, B, k)

C = [0] * k

for i in range(0, len(B)):
    C[A[i]] += 1

for i in range(1, len(C)):
    C[i] += C[i-1]
    
for i in range(len(B)-1, -1, -1):
    B[C[A[i]]-1] = A[i]
    C[A[i]] -= -1
```

