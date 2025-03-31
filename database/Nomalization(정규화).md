### **정규화(Normalization)란?**
정규화는 **데이터베이스에서 이상 현상(Anomaly)을 방지하고 데이터 무결성(Integrity)과 일관성(Consistency)을 유지하기 위해 데이터를 구조화하는 과정**입니다.

주요 목표는 **중복을 최소화하고 데이터 일관성을 보장하는 것**이며, 이를 위해 테이블을 적절히 분할하고 관계(Relationship)를 정의합니다.

---

## **📌 정규화의 필요성**
비정규화된 테이블에서는 다음과 같은 문제(이상 현상)가 발생할 수 있습니다.

1. **삽입 이상(Insertion Anomaly)**: 일부 데이터를 추가하기 위해 불필요한 정보를 함께 삽입해야 하는 문제
2. **삭제 이상(Deletion Anomaly)**: 특정 데이터를 삭제할 때 의도하지 않은 정보까지 함께 삭제되는 문제
3. **갱신 이상(Update Anomaly)**: 일부 데이터만 변경하면 데이터 불일치(Inconsistency)가 발생하는 문제

정규화를 통해 이러한 이상 현상을 방지할 수 있습니다.

---

## **📌 정규화의 단계**
정규화는 **제1정규형(1NF) → 제2정규형(2NF) → 제3정규형(3NF) → BCNF → 제4정규형(4NF) → 제5정규형(5NF)** 의 순서로 진행됩니다.

### 🔹 **제1정규형 (1NF) – 원자성(Atomicity) 보장**
- **모든 속성(컬럼)이 원자값(Atomic Value)을 가져야 한다.**
- 즉, 하나의 셀(필드)에는 하나의 값만 저장해야 한다.  
  ✅ **중복된 컬럼을 제거하고, 하나의 속성(컬럼)에 여러 값이 들어가지 않도록 함**

#### ❌ 비정규형 테이블 (1NF 위반)
| Student_ID | Student_Name | Courses  |  
|------------|--------------|------------|  
| 101        | Alice        | DB, AI     |  
| 102        | Bob          | Algo, OS   |  

→ `Courses` 컬럼에 **여러 개의 값**(DB, AI 등)이 들어감

#### ✅ 1NF 적용 후
| Student_ID | Student_Name | Course  |  
|------------|--------------|--------|  
| 101        | Alice        | DB     |  
| 101        | Alice        | AI     |  
| 102        | Bob          | Algo   |  
| 102        | Bob          | OS     |  

---

### 🔹 **제2정규형 (2NF) – 부분 함수 종속 제거**
- **제1정규형(1NF)을 만족하면서, 기본 키(Primary Key)의 일부 속성에만 종속된 속성을 제거한다.**
- 즉, **완전 함수 종속(Full Functional Dependency)** 을 만족해야 함.

#### ❌ 1NF 위반 예제
| Student_ID | Course_ID | Student_Name | Course_Name |  
|------------|------------|--------------|--------------|  
| 101        | C001       | Alice        | Database     |  
| 102        | C002       | Bob          | Algorithm    |  

- **Student_Name** 은 `Student_ID` 에만 종속됨
- **Course_Name** 은 `Course_ID` 에만 종속됨
- 하지만 기본 키(Primary Key)는 `(Student_ID, Course_ID)` 의 복합 키 → 일부 속성(Student_Name, Course_Name)이 **부분적으로만 종속됨** (위반!)

#### ✅ 2NF 적용 후
**테이블 분리 (Student, Course, Enrollment)**
1. `Student(Student_ID, Student_Name)`
2. `Course(Course_ID, Course_Name)`
3. `Enrollment(Student_ID, Course_ID)`

---

### 🔹 **제3정규형 (3NF) – 이행적 함수 종속 제거**
- **제2정규형(2NF)을 만족하면서, 기본 키가 아닌 속성이 다른 속성에 종속되는 경우 제거해야 한다.**
- 즉, **이행적 함수 종속(Transitive Dependency)이 존재하면 안 된다.**

#### ❌ 2NF 위반 예제
| Student_ID | Student_Name | Major | Major_Office |  
|------------|--------------|--------|--------------|  
| 101        | Alice        | CS     | Room 101     |  
| 102        | Bob          | EE     | Room 202     |  

- `Major_Office` 는 `Major` 에 종속
- 하지만 `Major` 는 기본 키(`Student_ID`) 에 종속 → **이행적 종속 발생!**

#### ✅ 3NF 적용 후
**테이블 분리 (Student, Major)**
1. `Student(Student_ID, Student_Name, Major_ID)`
2. `Major(Major_ID, Major_Name, Major_Office)`

---

### 🔹 **BCNF (Boyce-Codd Normal Form) – 모든 결정자가 후보 키가 되어야 함**
- 제3정규형(3NF)을 만족하면서, **모든 결정자(Determinant)가 후보 키(Candidate Key) 여야 한다.**
- 즉, **함수 종속 관계를 더 철저히 분리하여 이상 현상을 완전히 제거**

#### ❌ 3NF 위반 예제
| Professor_ID | Course_ID | Professor_Name |  
|-------------|-----------|----------------|  
| P001        | C001      | Dr. Kim        |  
| P002        | C002      | Dr. Lee        |  

- `Professor_Name` 은 `Professor_ID` 에 종속 (문제 없음)
- 하지만 **`Course_ID` 도 `Professor_ID` 를 결정할 수 있음**
- 즉, `Course_ID → Professor_ID → Professor_Name` (BCNF 위반!)

#### ✅ BCNF 적용 후
1. `Professor(Professor_ID, Professor_Name)`
2. `Course(Course_ID, Professor_ID)`

---

### 🔹 **제4정규형 (4NF) – 다치 종속(Multi-Valued Dependency) 제거**
- 하나의 속성이 기본 키에 **다중 종속(Multi-Valued Dependency, MVD)** 되지 않아야 함
- 즉, **하나의 키가 여러 속성에 독립적으로 영향을 미치는 경우 테이블을 분리**

#### ❌ 4NF 위반 예제
| Student_ID | Club | Hobby |  
|------------|------|-------|  
| 101        | Chess | Guitar |  
| 101        | Chess | Soccer |  
| 101        | Music | Guitar |  
| 101        | Music | Soccer |  

- `Student_ID` → `Club`
- `Student_ID` → `Hobby`
- **두 속성이 독립적으로 종속되므로 테이블 분리 필요!**

#### ✅ 4NF 적용 후
1. `Student_Club(Student_ID, Club)`
2. `Student_Hobby(Student_ID, Hobby)`

---

## **🚀 정리: 정규화 과정 요약**
| 정규형 | 주요 내용 | 해결하는 문제 |
|--------|---------|-------------|
| **1NF** | 원자성(Atomicity) 보장 | 중첩된 속성(중복값 포함) 제거 |
| **2NF** | 부분 함수 종속 제거 | 기본 키 일부에 종속된 속성 제거 |
| **3NF** | 이행적 함수 종속 제거 | 기본 키가 아닌 속성 간의 종속성 제거 |
| **BCNF** | 결정자가 후보 키가 되도록 보장 | 모든 결정자가 후보 키인지 확인 |
| **4NF** | 다치 종속 제거 | 한 키가 여러 속성에 독립적으로 영향을 미칠 경우 테이블 분리 |

정규화를 통해 **데이터 무결성을 유지하고, 중복을 최소화하며, 이상 현상을 방지**할 수 있습니다.  
하지만 **반정규화(Denormalization)** 를 통해 성능을 개선하는 경우도 있으므로, **정규화와 반정규화를 적절히 조합하여 최적의 설계를 하는 것이 중요합니다!** 🚀