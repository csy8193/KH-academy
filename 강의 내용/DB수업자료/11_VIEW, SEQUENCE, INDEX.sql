-- VIEW, SEQUENCE, INDEX

/*
    *** VIEW ***
    
    - SELECT문의 실행 결과(RESULT SET)을 저장하는 객체
    - 논리적 가상 테이블
        -> 테이블의 모양을 하고 있지만 실제 값을 저장하고 있진 않음
    
    ** VIEW 사용 목적
    
    1) 복잡한 SELECT 문의 쉬운 재사용을 위해서
    2) 테이블의 진짜 모습을 감출 수 있어 보안상 유리하다
    
    -- DDOS : 트래픽을 강제적으로 올려서 느리게 만듦
    -- SQL INJECTION : 통신 중 SQL 구문을 변경하는 것
    
    ** VIEW 사용 시 주의 사항
    1) ALTER 구문 사용 불가
    2) VIEW를 이용한 DML(INSERT, UPDATE, DELETE)가 가능은 하나
       제약이 많이 따르기 때문에 보통 조회(SELECT) 용도로만 사용한다.
*/

/* VIEW 생성 방법
CREATE [OR REPLACE] [FORCE | NOFORCE] VIEW 뷰이름 [(alias[,alias]...]
	AS subquery
	[WITH CHECK OPTION]
	[WITH READ ONLY];
*/
-- 1) OR REPLACE 옵션 : 기존에 동일한 뷰 이름이 존재하는 경우 덮어쓰고, 존재하지 않으면 새로 생성.
-- 2) FORCE / NOFORCE 옵션
--      FORCE : 서브쿼리에 사용된 테이블이 존재하지 않아도 뷰 생성
--      NOFORCE : 서브쿼리에 사용된 테이블이 존재해야만 뷰 생성(기본값)
-- 3) WITH CHECK OPTION 옵션 : 옵션을 설정한 컬럼의 값을 수정 불가능하게 함.
-- 4) WITH READ ONLY 옵션 : 뷰에 대해 조회만 가능(DML 수행 불가)


-- 모든 사원의 사번, 이름, 부서명, 직급명 조회
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE);


--> 위에 작성한 SELECT문을 이용하여 VIEW 생성
CREATE VIEW V_EMPLOYEE AS
SELECT EMP_ID, EMP_NAME, DEPT_TITLE, JOB_NAME
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_ID = DEPT_CODE)
JOIN JOB USING (JOB_CODE);
-- 01031. 00000 -  "insufficient privileges" (뷰 생성 권한이 없음)

-- 관리자계정
GRANT CREATE VIEW TO kh; --> 성공 후 kh 계정으로 접속하여 위 뷰 생성 구문 다시 실행

-- 생성된 V_EMPLOYEE를 이용하여 조회
SELECT * FROM V_EMPLOYEE;


-- * OR REPLACE 옵션 사용하기 + 별칭 지정
-- 모든 사원의 사번, 이름, 급여, 부서명, 직급명을 조회하는
-- SELECT문을 작성하여 V_EMPLOYEE 라는 VIEW로 생성하기
CREATE OR REPLACE VIEW V_EMPLOYEE AS
SELECT EMP_ID 사번, EMP_NAME 이름, SALARY 급여, DEPT_TITLE 부서명, JOB_NAME 직급명
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
JOIN JOB USING (JOB_CODE);

SELECT * FROM V_EMPLOYEE;

-- 급여가 300만 이상인 사람의 사번, 이름, 급여 조회
SELECT 사번, 이름, 급여
FROM V_EMPLOYEE
WHERE 급여 >= 3000000;

-- VIEW의 문제점 확인과 WITH READ ONLY 옵션 확인

CREATE TABLE DEPT_COPY2 AS
SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY2;

-- DEPT_COPY2 테이블에서 DEPT_ID, LOCATION_ID만 조회하는 VIEW 생성
CREATE VIEW V_DCOPY2 AS
SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2;

-- 생성 확인
SELECT * FROM V_DCOPY2;

-- V_DCOPY2 뷰를 이용해서 INSERT 진행하기
INSERT INTO V_DCOPY2 VALUES ('D0', 'L5');
--> VIEW를 이용해서 INSERT 가능

-- V_DCOPY2에서 삽입 확인
SELECT * FROM V_DCOPY2;
--> VIEW를 이용해 INSERT를 진행했기 때문에
-- VIEW에 삽입된걸로 생각할 수 있지만 아니다!
--> VIEW는 원본 테이블의 조회 결과를 저장하고, 보여주는 역할인 가상 테이블일 뿐
--  실제 데이터를 저장하지 못한다
--  삽입된 데이터는 VIEW가 아닌 원본 테이블에 삽입이 된다.

-- 원본 테이블인 DEPT_COPY2 확인
SELECT * FROM DEPT_COPY2;
--> 삽입은 확인 되지만 DEPT_TITLE이 NULL로 저장됨
--> 만약 NOT NULL 제약조건이 있었으면 오류 발생
--  + 데이터 무결성 침해


-- INSERT를 하지 못하도록 WITH READ ONLY 옵션 추가
ROLLBACK; -- D0 삭제

CREATE OR REPLACE VIEW V_DCOPY2 AS
SELECT DEPT_ID, LOCATION_ID FROM DEPT_COPY2
WITH READ ONLY
;

INSERT INTO V_DCOPY2 VALUES ('D0', 'L5');
-- ORA-42399: cannot perform a DML operation on a read-only view
--> INSERT(DML) 불가

-- VIEW 삭제
DROP VIEW V_EMPLOYEE;
DROP VIEW V_DCOPY2;


-----------------------------------------------------------------------

/*
    *** SEQUENCE(순서, 연속)
    - 순차적 번호 자동 발생기 역할의 객체
    
    ** SEQUENCE 사용 이유 : PRIMARY KEY 컬럼에 사용될 값으로써 주로 사용
*/

--  [작성법]
/*
  CREATE SEQUENCE 시퀀스이름
  [STRAT WITH 숫자] -- 처음 발생시킬 시작값 지정, 생략하면 자동 1이 기본
  [INCREMENT BY 숫자] -- 다음 값에 대한 증가치, 생략하면 자동 1이 기본
  [MAXVALUE 숫자 | NOMAXVALUE] -- 발생시킬 최대값 지정 (10의 27승, -1)
  [MINVALUE 숫자 | NOMINVALUE] -- 최소값 지정 (-10의 26승)
  [CYCLE | NOCYCLE] -- 값 순환 여부 지정
  [CACHE 바이트크기 | NOCACHE] -- 캐쉬메모리 기본값은 20바이트, 최소값은 2바이트
*/
-- 시퀀스의 캐시 메모리는 할당된 크기만큼 미리 다음 값들을 생성해 저장해둠
-- --> 시퀀스 호출 시 미리 저장되어진 값들을 가져와 반환하므로 
--     매번 시퀀스를 생성해서 반환하는 것보다 DB속도가 향상됨.

-- SEQUENCE 생성하기
CREATE SEQUENCE SEQ_EMP_ID -- 사번 생성용 시퀀스
START WITH 223 -- 223번 부터 시작
INCREMENT BY 2; -- 2씩 번호 증가

-- ** 시퀀스 사용 방법
-- 1) 시퀀스명.NEXTVAL : 다음 시퀀스 번호를 얻어옴
--                     단, 시퀀스 생성 후 첫 호출인 경우 START WITH 값을 얻어옴
SELECT SEQ_EMP_ID.NEXTVAL FROM DUAL; -- 실행할 때 마다 2씩 증가

-- 2) 시퀀스명.CURRVAL : 현재 시퀀스 번호를 얻어옴
SELECT SEQ_EMP_ID.CURRVAL FROM DUAL;

-- 실제 사용 방법 예시
CREATE TABLE EMPLOYEE_COPY4 AS
SELECT EMP_ID, EMP_NAME FROM EMPLOYEE;

SELECT * FROM EMPLOYEE_COPY4;

-- 복사한 테이블에 삽입
INSERT INTO EMPLOYEE_COPY4 VALUES (SEQ_EMP_ID.NEXTVAL, '홍길동');
SELECT * FROM EMPLOYEE_COPY4;

INSERT INTO EMPLOYEE_COPY4 VALUES (SEQ_EMP_ID.NEXTVAL, '고길동');
SELECT * FROM EMPLOYEE_COPY4;

INSERT INTO EMPLOYEE_COPY4 VALUES (SEQ_EMP_ID.NEXTVAL, '장길산');
SELECT * FROM EMPLOYEE_COPY4;

-- ** 시퀀스는 오류 또는 롤백 등과 관계 없이
--    NEXTVAL 구문이 수행되면 시퀀스 숫자는 무조건 증가한다

ROLLBACK;
SELECT * FROM EMPLOYEE_COPY4;

-- 현재 시퀀스 확인
SELECT SEQ_EMP_ID.CURRVAL FROM DUAL;
--> 롤백 후 INSERT 내용은 사라졌지만 시퀀스 번호는 계속 증가한 상태


-- SEQUENCE 변경

-- [표현식]
/*
    ALTER SEQUENCE 시퀀스이름
    [INCREMENT BY 숫자]
    [MAXVALUE 숫자 | NOMAXVALUE]
    [MINVALUE 숫자 | NOMINVALUE] 
    [CYCLE | NOCYCLE]
    [CACHE 바이트크기 | NOCACHE];
*/
-- START WITH는 변경 불가 
-- --> 재설정 필요 시 기존 시퀀스 DROP후 재생성

ALTER SEQUENCE SEQ_EMP_ID
INCREMENT BY 1;

SELECT SEQ_EMP_ID.NEXTVAL FROM DUAL;


-- 시퀀스 삭제
DROP SEQUENCE SEQ_EMP_ID;





-------------------------------------------------------------------------

-- INDEX

-- SQL 명령문 중 SELECT의 처리 속도를 향상시키기 위해서 컬럼에 대해 생성하는 객체
-- 인덱스 내부 구조는 B* 트리

-- 인덱스 장점
/*
    - 이진트리 형식으로 구성되어 자동 정렬 및, 검색 속도가 빨라짐
    - 시스템에 걸리는 부하를 줄여 시스템 전체 성능 향상
*/

-- 인덱스 단점
/*
    - 인덱스를 추가 하기위한 별도의 저장공간이 필요
    - 인덱스를 생성하는데 시간이 걸림
    - 데이터 변경작업(DML(INSERT/UPDATE/DELETE))이 빈번한 경우에는
      오히려 성능이 저하됨
*/



-- 인덱스 생성 방법
/*
    [표현식]
    CREATE [UNIQUE] INDEX 인덱스명
    ON 테이블명 (컬럼명, 컬럼명, ... | 함수명, 함수계산식);
    
    -- 인덱스가 자동으로 생성되는 경우
    --> PK 또는 UNIQUE 제약조건이 설정되는 경우
*/

SELECT * FROM EMPLOYEE_COPY4; --> 복사한 테이블이기 때문에 PK가 설정되지 않음
                              --> 인덱스 생성 X

-- 인덱스 생성 하기
CREATE INDEX ECOPY_PK_IDX
ON EMPLOYEE_COPY4(EMP_ID);

-- 인덱스 사용 방법
--> 인덱스를 추가했다고 해서 자동적으로 사용되는 것이 아니다!

-- WHERE절에 INDEX가 추가된 컬럼이 언급되는 것이 사용 방법
SELECT * FROM EMPLOYEE_COPY4
WHERE EMP_ID > 0; --> 데이터가 너무 적어서 확인 불가


-- 인덱스 확인용 테스트 테이블 생성
CREATE TABLE TB_IDX_TEST (
    TEST_NO NUMBER PRIMARY KEY, -- PK 지정 시 자동으로 인덱스 생성됨
    TEST_ID VARCHAR2(20) NOT NULL
);

-- TB_IDX_TEST 테이블에 샘플데이터 100만개 삽입(PL/SQL 활용)
BEGIN
    FOR I IN 1..1000000
    LOOP
        INSERT INTO TB_IDX_TEST VALUES ( I, 'TEST' || I );
    END LOOP;
    COMMIT;
END;
/

-- INSERT 100만개 확인
SELECT COUNT(*) FROM TB_IDX_TEST;

-- INDEX가 적용되지 않은 TEST_ID 컬럼에서 'TEST50000'조회하기
SELECT * FROM TB_IDX_TEST
WHERE TEST_ID = 'TEST50000';

-- INDEX가 적용된 TEST_NO 컬럼에서 50000 조회
SELECT * FROM TB_IDX_TEST
WHERE TEST_NO = 50000;


-- 자주 SELECT 조건으로 사용되는 컬럼이 있을 경우
-- INDEX를 생성해서 해당 컬럼을 지정해 주는 것이 좋다!!