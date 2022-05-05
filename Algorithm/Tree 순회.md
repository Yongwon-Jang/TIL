# Tree 순회

- 전위 순회

```python
def preorder(n):
    global cnt
    if n != 0:
        cnt += 1
        preorder(tree[n][0])
        preorder(tree[n][1])
```

- 중위 순회

```python
def inorder(n):
    global cnt
    if n != 0:
        preorder(tree[n][0])
        cnt += 1
        preorder(tree[n][1])
```

- 후위 순회

```python
def postorder(n):
    global cnt
    if n != 0:
        preorder(tree[n][0])
        preorder(tree[n][1])
        cnt += 1
```