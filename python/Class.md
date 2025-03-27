# **📌 Python의 클래스(Class)**
Python에서 **클래스(Class)** 는 **객체(Object)를 생성하기 위한 설계도** 역할을 한다.  
클래스를 이용하면 **데이터(속성)와 해당 데이터를 조작하는 함수(메서드)** 를 하나의 단위로 묶어 관리할 수 있다.

---

## **1️⃣ 클래스 기본 구조**
클래스는 `class` 키워드를 사용하여 정의하며, 객체를 생성하려면 `__init__()` 생성자를 활용한다.

```python
class Person:
    # 생성자 (객체 초기화)
    def __init__(self, name, age):
        self.name = name  # 인스턴스 변수
        self.age = age

    # 메서드 (객체의 동작)
    def introduce(self):
        print(f"안녕하세요, 제 이름은 {self.name}이고 {self.age}살입니다.")

# 객체 생성
p1 = Person("Alice", 25)
p1.introduce()  # 안녕하세요, 제 이름은 Alice이고 25살입니다.
```
✅ **핵심 개념**
- `__init__()` : 객체가 생성될 때 자동 실행되는 생성자 (객체의 속성 초기화)
- `self` : 인스턴스 자신을 가리키는 키워드 (객체 내부에서 속성이나 메서드에 접근할 때 사용)
- `p1 = Person("Alice", 25)` : `Person` 클래스를 이용해 `p1` 객체 생성
- `p1.introduce()` : `Person` 클래스의 `introduce()` 메서드 실행

---

## **2️⃣ 클래스와 객체**
Python에서 클래스와 객체의 관계는 **붕어빵 틀(클래스)과 붕어빵(객체)** 의 관계로 이해하면 쉽다.

```python
class Car:
    def __init__(self, brand, color):
        self.brand = brand
        self.color = color

    def drive(self):
        print(f"{self.color} 색상의 {self.brand} 자동차가 주행 중입니다.")

# 객체 생성
car1 = Car("Hyundai", "Red")
car2 = Car("BMW", "Black")

car1.drive()  # Red 색상의 Hyundai 자동차가 주행 중입니다.
car2.drive()  # Black 색상의 BMW 자동차가 주행 중입니다.
```
✅ **객체의 특징**
- 같은 `Car` 클래스로부터 `car1`, `car2` 객체를 생성할 수 있음
- 각 객체는 독립적인 **속성(brand, color)** 값을 가짐

---

## **3️⃣ 클래스 변수 vs 인스턴스 변수**
클래스 변수는 **모든 객체가 공유**, 인스턴스 변수는 **각 객체마다 독립적** 이다.

```python
class Dog:
    species = "Canine"  # 클래스 변수 (모든 객체가 공유)

    def __init__(self, name, age):
        self.name = name  # 인스턴스 변수 (객체마다 다름)
        self.age = age

# 객체 생성
dog1 = Dog("Buddy", 3)
dog2 = Dog("Charlie", 5)

print(dog1.species)  # Canine
print(dog2.species)  # Canine
print(dog1.name)     # Buddy
print(dog2.name)     # Charlie
```
✅ **차이점**
- `species`는 클래스 변수로 모든 객체가 공유
- `name`, `age`는 인스턴스 변수로 객체마다 다름

---

## **4️⃣ 클래스 메서드 & 정적 메서드**
클래스 내부에서 메서드는 **인스턴스 메서드**, **클래스 메서드**, **정적 메서드** 로 나뉜다.

```python
class MathUtils:
    # 클래스 변수
    pi = 3.14  

    # 클래스 메서드 (클래스 변수를 다룸)
    @classmethod
    def circle_area(cls, radius):
        return cls.pi * radius * radius

    # 정적 메서드 (클래스, 인스턴스와 관계없이 독립적)
    @staticmethod
    def add(a, b):
        return a + b

# 클래스 메서드 호출
print(MathUtils.circle_area(5))  # 78.5

# 정적 메서드 호출
print(MathUtils.add(3, 7))  # 10
```
✅ **메서드 종류**
- **인스턴스 메서드** : `self` 사용, 인스턴스 변수 조작
- **클래스 메서드** : `@classmethod` 사용, `cls` 통해 클래스 변수 접근
- **정적 메서드** : `@staticmethod` 사용, 클래스 및 인스턴스와 무관

---

## **5️⃣ 상속(Inheritance)**
부모 클래스의 기능을 자식 클래스가 물려받아 확장할 수 있다.

```python
class Animal:
    def __init__(self, name):
        self.name = name

    def speak(self):
        return "소리를 낼 수 있어요."

# Dog 클래스가 Animal 클래스를 상속받음
class Dog(Animal):
    def speak(self):
        return "멍멍!"

# Cat 클래스도 Animal 클래스를 상속받음
class Cat(Animal):
    def speak(self):
        return "야옹!"

# 객체 생성
dog = Dog("Buddy")
cat = Cat("Whiskers")

print(dog.name, ":", dog.speak())  # Buddy : 멍멍!
print(cat.name, ":", cat.speak())  # Whiskers : 야옹!
```
✅ **상속 특징**
- `Dog`, `Cat` 클래스가 `Animal` 클래스를 상속받아 기본 속성(`name`)을 가짐
- `speak()` 메서드를 각 클래스에서 **오버라이딩(재정의)** 가능

---

## **6️⃣ 다형성(Polymorphism)**
다양한 클래스에서 같은 인터페이스(메서드)를 제공하는 개념

```python
class Bird:
    def fly(self):
        return "날 수 있어요!"

class Penguin(Bird):
    def fly(self):
        return "펭귄은 날지 못해요."

def make_it_fly(animal):
    print(animal.fly())

# 객체 생성
sparrow = Bird()
penguin = Penguin()

make_it_fly(sparrow)  # 날 수 있어요!
make_it_fly(penguin)  # 펭귄은 날지 못해요.
```
✅ **다형성 특징**
- `Bird`와 `Penguin` 클래스는 같은 `fly()` 메서드를 제공
- `make_it_fly()` 함수는 클래스 종류에 상관없이 `fly()` 호출 가능

---

## **7️⃣ 캡슐화(Encapsulation)**
객체 내부 데이터를 외부에서 직접 접근하지 못하도록 보호하고, `getter`와 `setter` 메서드를 사용

```python
class BankAccount:
    def __init__(self, balance):
        self.__balance = balance  # private 변수 (외부 접근 불가)

    def deposit(self, amount):
        self.__balance += amount

    def withdraw(self, amount):
        if amount <= self.__balance:
            self.__balance -= amount
        else:
            print("잔액 부족!")

    def get_balance(self):
        return self.__balance

# 객체 생성
account = BankAccount(1000)

account.deposit(500)
print(account.get_balance())  # 1500

account.withdraw(2000)  # 잔액 부족!
print(account.get_balance())  # 1500

# 직접 접근 시도 (에러 발생)
# print(account.__balance)  # AttributeError
```
✅ **캡슐화 특징**
- `__balance` 는 `private` 변수로 직접 접근 불가 (`__변수명` 사용)
- `get_balance()`, `deposit()`, `withdraw()` 메서드를 통해 접근 가능

---

## **🔹 Python 클래스 정리**
| 개념         | 설명 | 예제 |
|-------------|----------------|----------------|
| **클래스** | 객체의 설계도 | `class` 키워드 사용 |
| **객체** | 클래스를 기반으로 생성된 실체 | `obj = ClassName()` |
| **인스턴스 변수** | 객체마다 독립적인 속성 | `self.name = value` |
| **클래스 변수** | 모든 객체가 공유하는 변수 | `class_variable = value` |
| **메서드** | 클래스 내부 함수 | `def method(self):` |
| **상속** | 기존 클래스를 확장 | `class SubClass(ParentClass):` |
| **다형성** | 같은 메서드를 여러 클래스에서 다르게 구현 | `def method():` (오버라이딩) |
| **캡슐화** | 내부 데이터 보호 | `__private_variable` |

🚀 **Python의 객체지향 개념을 활용하면 유지보수성이 높고 재사용이 쉬운 코드를 작성할 수 있다!**