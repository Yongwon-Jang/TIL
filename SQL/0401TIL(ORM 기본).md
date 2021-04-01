# ORM 기본

- 모든 user 레코드 조회

```python
User.objects.all()
```

- user 레코드 생성

```python
User.objects.create(last_name="김", first_name="아무개", age=19, 
                    country='SEOUL', phone="123-4567-8901",
                    balance=20000)
```

- 해당 레코드 조회

```python
User.objects.get(pk=1)
```

- 레코드 수정

```python
user = User.objects.get(pk=101)
user.last_name = '김'
user.save()
```

- 레코드 삭제

```python
user = User.objects.get(pk=101)
user.delete()
```

