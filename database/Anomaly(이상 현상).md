## Anomaly (이상 현상)
데이터베이스에서 **Anomaly(이상 현상)** 는 데이터의 **일관성(consistency)** 과 **무결성(integrity)** 을 해치는 예기치 않은 문제를 의미합니다. 주로 **정규화(Normalization)** 가 부족하거나 적절하지 않을 때 발생하며, 대표적으로 **삽입 이상(Insertion Anomaly), 삭제 이상(Deletion Anomaly), 갱신 이상(Update Anomaly)** 이 있습니다.

---

### 1. **삽입 이상 (Insertion Anomaly)**
새로운 데이터를 삽입할 때 불필요한 데이터도 함께 입력해야 하거나, 필요한 데이터를 삽입할 수 없는 문제

#### ❌ 예시:
학생이 수강하는 과목을 저장하는 `Student_Course` 테이블이 있다고 가정  
| Student_ID | Student_Name | Course_ID | Course_Name |
|------------|--------------|------------|--------------|
| 101        | Alice        | C001       | Database     |

- 새로운 학생(102)을 추가하려면 **Course_ID, Course_Name** 도 입력해야 함 → 강의를 듣지 않는 학생은 등록 불가능
- 과목 없이 학생 정보만 저장할 수 없어 문제가 발생

✅ **해결 방법**:  
**학생 테이블(Student)과 과목 테이블(Course)로 분리**
- `Student(Student_ID, Student_Name)`
- `Course(Course_ID, Course_Name)`
- `Enrollment(Student_ID, Course_ID)`

---

### 2. **삭제 이상 (Deletion Anomaly)**
특정 데이터를 삭제할 때 **의도하지 않은 데이터까지 함께 삭제되는 문제**

#### ❌ 예시:
| Student_ID | Student_Name | Course_ID | Course_Name |
|------------|--------------|------------|--------------|
| 101        | Alice        | C001       | Database     |
| 102        | Bob          | C002       | Algorithm    |

- 학생 Bob이 수강을 취소하면 **Bob의 정보 자체가 삭제됨**
- 즉, 특정 과목을 삭제하면 해당 과목을 수강하는 학생 정보도 함께 삭제될 가능성이 있음

✅ **해결 방법**:  
**데이터를 개별 엔터티로 나눠 관리(정규화)**
- 학생(Student), 과목(Course), 수강 내역(Enrollment)을 분리

---

### 3. **갱신 이상 (Update Anomaly)**
데이터를 변경할 때 일부만 수정되어 **불일치(Inconsistency)** 가 발생하는 문제

#### ❌ 예시:
| Student_ID | Student_Name | Course_ID | Course_Name | Professor |
|------------|--------------|------------|--------------|------------|
| 101        | Alice        | C001       | Database     | Prof. Kim  |
| 102        | Bob          | C001       | Database     | Prof. Kim  |

- 교수님이 변경되어 `Prof. Kim → Prof. Lee` 로 바꿔야 할 때, **모든 행을 수정해야 함**
- 일부 데이터만 수정하면 데이터 불일치 발생 (어떤 행에는 Prof. Kim, 어떤 행에는 Prof. Lee)

✅ **해결 방법**:  
**교수(Professor) 정보를 별도의 테이블로 분리**
- `Professor(Prof_ID, Prof_Name)`
- `Course(Course_ID, Course_Name, Prof_ID)`
- `Enrollment(Student_ID, Course_ID)`

---

### 🚀 **해결 방법: 정규화(Normalization)**
이러한 이상 현상을 방지하기 위해 **정규화(Normalization)** 를 수행하며, 주로 **제1정규형(1NF) → 제2정규형(2NF) → 제3정규형(3NF)** 으로 나누어 테이블을 분리하고, 데이터 중복을 최소화하여 이상 현상을 제거합니다.

필요에 따라 일부 정규화를 해제(반정규화)하여 성능을 개선할 수도 있습니다.

---

### ✅ **정리**
| 유형 | 발생 원인 | 해결 방법 |
|------|---------|------------|
| **삽입 이상** | 불필요한 데이터를 입력해야 하거나, 일부 데이터만 삽입 불가능 | 데이터 분리(정규화) |
| **삭제 이상** | 데이터를 삭제하면 의도하지 않은 정보까지 함께 삭제됨 | 개별 엔터티로 분리 |
| **갱신 이상** | 일부 데이터만 수정하면 불일치 발생 | 중복 제거 및 정규화 |

이상 현상은 **비정규화된 테이블에서 발생하는 대표적인 문제**이며, 이를 해결하기 위해 적절한 정규화를 수행하는 것이 중요합니다! 🚀