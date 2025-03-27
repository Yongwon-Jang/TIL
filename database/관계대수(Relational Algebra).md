# **📌 관계 대수(Relational Algebra)란?**
**관계형 데이터베이스(Relational Database)** 에서 **데이터를 조회하고 조작하는 방법**을 수학적으로 정의한 연산 집합이다.  
쉽게 말해, **데이터를 가져오고 가공하는 데 사용되는 연산자들**을 제공하는 개념이다.

💡 **SQL과 차이점?**
- SQL은 **절차적(Procedural) 언어가 아닌 선언적(Declarative) 언어**
- 관계 대수는 **절차적(Procedural) 언어** → **"어떻게 데이터를 검색할 것인가?"** 정의
- 관계 대수 연산을 통해 SQL을 표현할 수 있음

---

## **1️⃣ 관계 대수의 종류**
관계 대수는 크게 **순수 관계 연산(Pure Relational Operations)** 과 **집합 연산(Set Operations)** 으로 나뉜다.

### **🔹 (1) 순수 관계 연산 (기본 연산)**
> **관계형 데이터베이스의 핵심 연산자들**

| 연산 | 기호 | 설명 |
|------|------|------|
| **선택(Selection)** | `σ` | 특정 조건을 만족하는 **행(Row)만 선택** |
| **투영(Projection)** | `π` | 특정 컬럼(속성)만 선택 |
| **교차곱(Cartesian Product)** | `×` | 두 테이블의 모든 조합 생성 |
| **조인(Join)** | `⋈` | 두 테이블을 연결 (결합) |
| **나누기(Division)** | `/` | 특정 속성을 기준으로 데이터 필터링 |

---

### **🔹 (2) 집합 연산 (Set Operations)**
> **집합 이론을 기반으로 여러 개의 관계(테이블)에서 데이터를 가져오는 연산**

| 연산 | 기호 | 설명 |
|------|------|------|
| **합집합(Union)** | `∪` | 두 테이블에서 중복 없이 모든 행 가져오기 |
| **교집합(Intersection)** | `∩` | 두 테이블에서 공통된 행만 가져오기 |
| **차집합(Difference)** | `−` | 첫 번째 테이블에서 두 번째 테이블에 없는 행 가져오기 |

---

## **2️⃣ 관계 대수 연산 예제 (학생 테이블 활용)**
**🎯 예제 테이블: 학생(Student) 테이블**

| student_id | name  | department  | age |
|------------|-------|------------|----|
| 101        | Alice | CS         | 20 |
| 102        | Bob   | Math       | 22 |
| 103        | Charlie | CS      | 23 |
| 104        | David | Physics    | 21 |

---

### **✅ 1. 선택(Selection, σ)**
> 특정 조건을 만족하는 **행(Row)를 선택**하는 연산  
> `σ(조건)(테이블)`

**💡 예제**  
👉 **나이가 22 이상인 학생을 조회**
```
σ(age ≥ 22)(Student)
```
**📌 결과**
| student_id | name  | department | age |
|------------|-------|------------|----|
| 102        | Bob   | Math       | 22 |
| 103        | Charlie | CS      | 23 |

---

### **✅ 2. 투영(Projection, π)**
> 특정 **속성(컬럼)만 선택**하여 출력  
> `π(컬럼1, 컬럼2, ...)(테이블)`

**💡 예제**  
👉 **학생의 이름과 학과만 조회**
```
π(name, department)(Student)
```
**📌 결과**
| name  | department |
|-------|-----------|
| Alice | CS        |
| Bob   | Math      |
| Charlie | CS      |
| David | Physics   |

---

### **✅ 3. 교차곱(Cartesian Product, ×)**
> 두 개의 테이블에서 **모든 가능한 조합을 생성**  
> `R × S`

**💡 예제**  
👉 **학생 테이블(Student)과 동아리(Club) 테이블을 조합**
```
Student × Club
```
(Student의 모든 행 × Club의 모든 행을 조합하여 생성)

---

### **✅ 4. 조인(Join, ⋈)**
> **두 개의 테이블을 특정 공통 속성을 기준으로 연결**  
> `R ⋈ 조건 S`

**💡 예제**  
👉 **학생 테이블과 학과 테이블을 학과명으로 조인**
```
Student ⋈ Student.department = Department.department
```
(공통 속성인 `department`를 기준으로 두 테이블을 결합)

---

### **✅ 5. 나누기(Division, ÷)**
> 특정 속성을 가진 집합을 필터링할 때 사용

**💡 예제**  
👉 **모든 과목을 수강한 학생을 찾기**
- `Student(Course)` ÷ `Course(All Courses)`

---

## **3️⃣ 집합 연산 예제**
### **✅ 1. 합집합(Union, ∪)**
> **두 테이블에서 중복 없이 모든 행을 반환**  
> `R ∪ S`

**💡 예제**  
👉 **CS 학생과 Math 학생을 합쳐서 조회**
```
CS_Student ∪ Math_Student
```
---

### **✅ 2. 교집합(Intersection, ∩)**
> **두 테이블에서 공통된 행만 반환**  
> `R ∩ S`

**💡 예제**  
👉 **동시에 CS와 Math 과목을 수강한 학생 찾기**
```
CS_Student ∩ Math_Student
```
---

### **✅ 3. 차집합(Difference, -)**
> **첫 번째 테이블에서 두 번째 테이블에 없는 행을 반환**  
> `R - S`

**💡 예제**  
👉 **CS 과목을 수강했지만, Math 과목은 수강하지 않은 학생 찾기**
```
CS_Student - Math_Student
```

---

## **🔹 관계 대수 vs SQL**
| 개념 | 관계 대수 | SQL |
|------|----------|-----|
| 데이터 검색 | `σ(condition)(Table)` | `SELECT * FROM Table WHERE condition;` |
| 특정 컬럼 선택 | `π(column1, column2)(Table)` | `SELECT column1, column2 FROM Table;` |
| 조인 | `R ⋈ condition S` | `SELECT * FROM R JOIN S ON condition;` |
| 합집합 | `R ∪ S` | `SELECT * FROM R UNION SELECT * FROM S;` |
| 차집합 | `R - S` | `SELECT * FROM R EXCEPT SELECT * FROM S;` |

---

## **📌 정리**
✅ **관계 대수(Relational Algebra)** 는 **데이터베이스에서 데이터를 조회하고 가공하는 연산을 정의하는 수학적 개념**  
✅ SQL이 실행되는 원리를 이해하는 데 도움이 됨  
✅ 순수 관계 연산(선택, 투영, 조인)과 집합 연산(합집합, 교집합, 차집합)이 존재  
✅ SQL과 1:1 매핑되는 개념이 많음! 🚀