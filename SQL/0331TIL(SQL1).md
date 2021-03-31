## SQL1

### 1. DDL : Data Definition Language

- 데이터를 효율적으로 사용할 수 있도록 컴퓨터 안에 데이터를 저장하고 조직화 하는 방법을 구체화 하는 언어

1. CREATE : create table (테이블 명) (컬럼, 컬럼, );

   - **테이블을 구성하는 각 속성의 이름, 데이터 타입, 기본적인 제약 사항을 정의**한다.

2. ALTER

   - 테이블 변경 ( 속성 추가 / 삭제, 제약조건 추가 / 삭제)

3. DROP

   - 테이블 삭제

   

### 2. DML : Data Manipulation Language

- 유저들이 데이터를 입력, 수정, 삭제, 병합 하려고 할 때 사용하는 언어

1. SELETE

   - 테이블에서 원하는 데이터를 검색하기 위해 사용

   ```
   SELECT [ ALL|DISTINCT ] 속성_리스트
   FROM 테이블_리스트;
   ```

   - LIKE 이용 : 부분적 일치하는 데이터를 검색하고 싶을 때 사용
     - LIKE 'A%' : A로 시작하는 문자열(길이 상관 없음)
     - LIKE 'A_' : A로 시작하는 문자열 (한 글자)



### TCL : Transaction Control Language

- dml 작업을 확정하거나 취소할 때 사용.