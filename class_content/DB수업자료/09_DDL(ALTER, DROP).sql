-- DDL(DATA DEFINITION LANGUAGE) : 데이터 정의 언어

-- 객체(OBJECT)를 만들고(CREATE), 수정(ALTER)하고, 삭제(DROP)하는 구문

-- ALTER(바꾸다, 변조하다)

-- 객체를 수정하는 구문

-- [표현식]
-- 테이블 객체 수정 : ALTER TABLE 테이블명 수정할 내용;

-- 수정할 내용 
-- 컬럼 추가/수정/삭제, 제약조건 추가/삭제
-- 컬럼 자료형 변경, DEFAULT값 변경
-- 테이블명 변경, 컬럼명, 제약조건 이름 변경


--------------------------------------------------------------------------------------------------------------------


-- 1. 컬럼 추가, 수정, 삭제


-- DEPARTMENT 테이블을 복사한 DEPT_COPY 테이블 생성
CREATE TABLE DEPT_COPY AS SELECT * FROM DEPARTMENT;


-- 1) 컬럼 추가(ADD (컬럼명 데이터 타입) )
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY 
ADD (CNAME VARCHAR2(20));

SELECT * FROM DEPT_COPY;
DESC DEPT_COPY;
--> 새로운 컬럼 CNAME이 추가되었고 컬럼값이 모두 NULL


-- 컬럼 추가 시 DEFAULT값 지정
-- ( ADD (컬럼명 데이터타입 DEFAULT 기본값) )
ALTER TABLE DEPT_COPY
ADD ( LNAME VARCHAR2(20) DEFAULT '한국');

SELECT * FROM DEPT_COPY;


-- 2) 컬럼 수정(MODIFY)
-- 데이터 타입, 기본값 수정
ALTER TABLE DEPT_COPY
MODIFY DEPT_ID VARCHAR(3);

DESC DEPT_COPY;


-- 컬럼의 크기를 줄일 경우에는 기록된 값이
-- 변경하려는 크기를 초과하는 값이 없을 때에만 변경할 수 있다.
ALTER TABLE DEPT_COPY
MODIFY (DEPT_TITLE VARCHAR2(10));

-- 컬럼 DEFAULT 값 변경하기
-- ( MODIFY 컬럼명 DEFAULT 기본값 )

-- LNAME의 기본값을 '미국'으로 변경
ALTER TABLE DEPT_COPY
MODIFY (LNAME DEFAULT '미국');

SELECT * FROM DEPT_COPY;


-- 여러 컬럼 한번에 수정하기

-- DEPT_COPY 테이블에서
-- DEPT_TITLE 컬럼의 데이터타입을 VARCHAR2(50)
-- LNAME의 기본값을 '한국'
ALTER TABLE DEPT_COPY
MODIFY (DEPT_TITLE VARCHAR2(50),
        LNAME DEFAULT '한국');
        
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR2(50)
MODIFY LNAME DEFAULT '한국';

DESC DEPT_COPY;


-- 3) 컬럼 삭제(DROP COLUMN || DROP (삭제할 컬럼명))
-- 데이터가 기록 되어 있어도 삭제 됨
-- 삭제된 컬럼은 복구 안됨
-- 테이블에는 최소 한 개의 컬럼이 존재해야 함 : 모든 컬럼 삭제 불가


-- DEPT_COPY 테이블을 복사한 DEPT_COPY2 테이블 생성
CREATE TABLE DEPT_COPY2 AS
SELECT * FROM DEPT_COPY;

-- DEPT_ID 컬럼 삭제
ALTER TABLE DEPT_COPY2
DROP COLUMN DEPT_ID;



-- 지우려는 테이블에 최소 한개 이상의 컬럼이 남아있어야 함
--> 확인을 위해 모든 컬럼 삭제
DESC DEPT_COPY2;

ALTER TABLE DEPT_COPY2 DROP (DEPT_TITLE);
ALTER TABLE DEPT_COPY2 DROP (LOCATION_ID);
ALTER TABLE DEPT_COPY2 DROP (CNAME);

DESC DEPT_COPY2;

ALTER TABLE DEPT_COPY2 DROP (LNAME);
--> 테이블에 있는 모든 컬럼 삭제 불가(최소 1개 이상)

ROLLBACK;
DESC DEPT_COPY2; --> DDL은 COMMIT, ROLLBACK 불가





-- ** 제약조건이 설정되어있는 컬럼 삭제 시 주의 사항과 삭제 방법
--> FK 제약조건으로 인해 참조 당하고 있는 부모 테이블 컬럼
CREATE TABLE TB1(
    TB1_PK NUMBER PRIMARY KEY,
    TB1_COL NUMBER
);

CREATE TABLE TB2(
    TB2_PK NUMBER PRIMARY KEY,
    TB2_COL NUMBER REFERENCES TB1(TB1_PK)
);

-- 부모 테이블(TB1)의 PK 컬럼 제거
ALTER TABLE TB1
DROP (TB1_PK);
--ORA-12992: cannot drop parent key column

INSERT INTO TB1 VALUES(1, 10);
INSERT INTO TB2 VALUES(200, 1);
SELECT * FROM TB1;
SELECT * FROM TB2;

-- CASCADE CONSTRAINTS 옵션 : FK 제약조건을 무시하고 컬럼을 삭제하는 옵션
ALTER TABLE TB1
DROP (TB1_PK) CASCADE CONSTRAINTS;
SELECT * FROM TB1;
SELECT * FROM TB2;


--------------------------------------------------------------------------------------------------------------------

-- 2.제약 조건 추가, 삭제

-- 제약 조건 추가 :  ADD CONSTRAINT 제약조건명 제약조건(컬럼명)
-- 제약 조건 삭제 : DROP CONSTRAINT 제약조건명
-- 제약 조건을 수정하는 구문은 없음.


-- DEPT_COPY 테이블에 제약조건 추가 / 삭제
SELECT * FROM DEPT_COPY;

-- PK 제약조건 추가
ALTER TABLE DEPT_COPY
ADD PRIMARY KEY(DEPT_ID); -- 제약조건명이 무작위로 지정됨

-- UNIQUE 제약조건 추가
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DEPT_COPY_U UNIQUE(DEPT_TITLE); -- 제약조건명 지정

-- CHECK 제약조건 추가
ALTER TABLE DEPT_COPY
ADD CONSTRAINT LNAME_CHECK CHECK(LNAME IN ('한국', '미국', '중국'));

-- NOT NULL 제약 조건 추가(잘 구분해서 알아둘 것!)
ALTER TABLE DEPT_COPY
--ADD DEPT_TITLE NOT NULL; --> 컬럼 추가 구문으로 인식됨
MODIFY DEPT_TITLE NOT NULL;



-- 제약조건 삭제 (DROP CONSTRAINT 제약조건명)
ALTER TABLE DEPT_COPY
DROP CONSTRAINT LNAME_CHECK;

-- NOT NULL 제약조건 삭제
ALTER TABLE DEPT_COPY
DROP CONSTRAINT SYS_C007148;

-- NOT NULL 제약조건 삭제 방법2
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE CONSTRAINT SYS_C007149 NULL;


--------------------------------------------------------------------------------------------------------------------

-- 3. 컬럼, 제약조건, 테이블 이름 변경

-- 1)컬럼 이름 변경(RENAME COLUMN 컬럼명 TO 변경명)
ALTER TABLE DEPT_COPY
RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

DESC DEPT_COPY;


-- 2) 제약조건 이름 변경(RENAME CONSTRAINT 제약조건명 TO 변경명)
ALTER TABLE DEPT_COPY
RENAME CONSTRAINT SYS_C007145 TO DEPT_COPY_PK;



-- 3) 테이블명 변경(RENAME [테이블명] TO 변경명)
SELECT * FROM DEPT_COPY2;

ALTER TABLE DEPT_COPY2
RENAME TO DEPT_TEST;

SELECT * FROM DEPT_TEST;




--------------------------------------------------------------------------------------------------------------------

-- 4. 테이블 삭제( DROP TABLE 테이블명 [CASCADE CONSTRAINTS]; )
DROP TABLE TB1;
DROP TABLE TB2;

-- ****** 참조 관계에서 부모테이블 삭제 시 발생하는 문제 및 해결방법
CREATE TABLE TB1(
    TB1_PK NUMBER PRIMARY KEY,
    TB1_COL NUMBER
);

CREATE TABLE TB2(
    TB2_PK NUMBER PRIMARY KEY,
    TB2_COL NUMBER REFERENCES TB1
);

DROP TABLE TB1;

-- 해결 방법 1 : 자식 -> 부모 테이블 순서로 삭제하기
DROP TABLE TB2;

-- 해결 방법 2 : CASCADE CONSTRAINTS 옵션 사용
DROP TABLE TB1 CASCADE CONSTRAINTS;
