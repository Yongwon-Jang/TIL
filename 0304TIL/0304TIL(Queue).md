## 큐(Queue)

- 특성

  - 뒤에서 삽입하고, 앞에서 삭제가 이루어짐
  - 선입 선출 구조(FIFO)

- 연산

  - enQueue : 큐의 뒤쪽에 원소를 삽입
  - deQueue : 큐의 앞쪽에서 원소를 삭제 및 반환
  - createQueue() : 공백 상태의 큐를 생성
  - isEmpty : 큐가 공백상태인지를 확인
  - isFull : 큐가 포화상태인지를 확인
  - Qpeek : 큐의 앞쪽에서 원소를 삭제 없이 반환

- 큐의 구현

  - 선형 큐

  ```python
  SIZE = 100
  Q = [0] * SIZE
  front, rear = -1, -1
  def isFULL():
      return rear == len(Q) - 1
  
  def isEmpty():
      return front == rear
  
  def enQueue(item):
      global rear
      if isFULL():
          print("Queue Full")
      else:
          rear += 1
          Q[rear] = item
  
  
  def deQueue():
      global front
      if isEmpty():
          print('Queue Empty')
      else:
          front += 1
          return Q[front]
  
  def Qpeek():
      if isEmpty():
          print('Queue Empty')
      else:
          return Q[front+1]
  ```

  - 원형 큐

  ```python
  SIZE = 4
  Q = [0] * SIZE
  front, rear = 0, 0
  def isFULL():
      return (rear+1) % SIZE == front
  def isEmpty():
      return front == rear
  
  def enQueue(item):
      global rear
      if isFULL():
          print("Queue Full")
      else:
          rear = (rear +1) % SIZE
          Q[rear] = item
  
  
  def deQueue():
      global front
      if isEmpty():
          print('Queue Empty')
      else:
          front = (front + 1) % SIZE
          return Q[front]
  
  def Qpeek():
      if isEmpty():
          print('Queue Empty')
      else:
          return Q[(front+1) % SIZE]
  ```

  