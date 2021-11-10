/*
    DCL(Data Control Language) : 데이터 제어 언어
    
    - 데이터베이스, 데이터베이스 내의 객체에 대한
      접근 권한을 제어(부여, 회수)하는 언어
      
    - GRANT : 권한 부여
    - REVOKE : 권한 회수
    
    -- 조작 : EX) 시험 성적 조작 (점수라는 데이터를 바꿈)
    -- 제어 : EX) 자동차 제어 (자동차라는 물체의 움직임을 바꿈)  
*/

-- 시스템 권한 부여
-- 사용자에게 시스템 권한을 부여할 때 사용

-- [표기법]
--    GRANT 권한1, 권한2, ... 
--    TO 사용자 이름;

-- REVOKE SELECT ON kh.EMPLOYEE FROM sample;


-- 권한 종류 
/*
CRETAE SESSION   : 데이터베이스 접속 권한
CREATE TABLE     : 테이블 생성 권한
CREATE VIEW      : 뷰 생성 권한
CREATE SEQUENCE  : 시퀀스 생성 권한
CREATE PROCEDURE : 함수(프로시져) 생성 권한
CREATE USER      : 사용자(계정) 생성 권한
DROP USER        : 사용자(계정) 삭제 권한
DROP ANY TABLE   : 임의 테이블 삭제 권한

*/

/* 계정의 종류
관리자 계정 : 데이터베이스의 생성과 관리를 담당하는 계정이며 모든 권한과 책임을 가지는 계정
 ex) sys, system
 
사용자 계정 : 데이터베이스에 대하여 질의, 갱신, 보고서 작성 등의 작업을 수행할 수 있는 계정으로 
업무에 필요한 최소한의 권한만 가지는 것을 원칙으로 한다.
 ex) kh
*/

-- 사용자 계정 SAMPLE 생성 - 관리자 계정
CREATE USER sample IDENTIFIED BY sample1234;

-- 생성된 계정 접속 확인 - sample 계정
--> SQLPLUS를 이용해서 동시 진행

-- sample 계정에 데이터베이스 접속 권한 부여 - 관리자 계정
GRANT CREATE SESSION TO sample;
--> 다시 SQLPLUS에서 로그인 시도 --> 접속 성공!


-- sample 계정으로 테이블 생성 시도 (sqlplus)
CREATE TABLE TB_TEST(
COL_PK NUMBER PRIMARY KEY,
TEMP CHAR(10)
);
-- ORA-01031: insufficient privileges
--> 테이블 생성 권한이 없음


-- sample 계정에 테이블 생성 권한 부여 - 관리자 계정
GRANT CREATE TABLE TO sample;

-- 다시 sample 계정으로 테이블 생성 시도 - sample
--> ORA-01950: no privileges on tablespace 'SYSTEM'
--> DB에 테이블을 만들 수 있는 공간을 받지 못함

-- sample 계정에 테이블 스페이스를 부여 - 관리자 계정
ALTER USER sample QUOTA 20M ON SYSTEM;

-- 또 다시 sample 계정으로 테이블 생성 시도 - sample
--> 테이블 생성 성공

-- 만약에 sample 계정에 더 많은 객체생성 권한을 부여하고 싶은 경우 - 관리자 계정
GRANT CREATE TRIGGER, CREATE SEQUENCE, CREATE PROCEDURE TO sample;
--> 한 번에 여러 권한 부여 가능

------------------------------------------------------------------------------

-- ROLE : 권한의 묶음
--> 여러 가지 관련된 권한들을 묶어서 한번에 부여, 회수 하는 용도로 사용

-- 1) CONNECT : 데이터베이스 접속 권한 (== CREATE SESSION)
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'CONNECT'; -- CONNECT 롤에 포함된 권한 모두 조회

-- 2) RESOURCE : 데이터베이스를 사용하기 위한 기본 객체 생성 권한을 묶어둔 롤
SELECT * FROM ROLE_SYS_PRIVS
WHERE ROLE = 'RESOURCE'; -- TABLE 외 7가지 생성 권한 + 테이블 스페이스를 기본값으로 자동부여

-- 롤을 이용하여 sample2 사용자 계정 생성 및 권한 부여 - 관리자 계정
CREATE USER sample2 IDENTIFIED BY sample1234;
GRANT CONNECT, RESOURCE TO sample2;

-- sample2 접속 방법을 추가하고 접속하기


-----------------------------------------------------------------------------

-- 객체 권한
-- 특정 객체를 조작할 수 있는 권한을 부여

-- [표기법]
/*
    GRANT 권한 종류 [(컬럼명)] | ALL
    ON 객체명 | ROLE 이름 | PUBLIC
    TO 사용자 이름;
*/

-- 권한 종류         설정 객체
/*    SELECT              TABLE, VIEW, SEQUENCE
    INSERT              TABLE, VIEW
    UPDATE              TABLE, VIEW
    DELETE              TABLE, VIEW
    ALTER               TABLE, SEQUENCE
    REFERENCES          TABLE
    INDEX               TABLE
    EXECUTE             PROCEDURE*/

-- sample 계정으로 kh 계정의 EMPLOYEE 테이블 조회 - sample 계정
SELECT * FROM kh.EMPLOYEE;
--ORA-00942: table or view does not exist

-- kh 계정으로 접속하여 sample 계정에 EMPLOYEE 테이블 SELECT 권한 부여 - kh 계정
GRANT SELECT ON EMPLOYEE TO sample;

-- 다시 한번 sample 계정으로 kh.EMPLOYEE 테이블 조회 - sample 계정
--> 조회 성공

-- sample 에게 부여했던 SELECT 권한 회수 - kh계정
REVOKE SELECT ON EMPLOYEE FROM sample;


-- 권한 회수 확인 - sample 계정




/* DDL / DCL 연습문제
1) 계정 생성

- 사용자 계정명 : testuser
- 비밀번호 : test1234

- 부여 권한 : 데이터베이스 접속 권한, 
              기본 객체 생성 권한, 
              kh 계정 EMPLOYEE 테이블 조회 권한


2) 생성된 사용자 testuser로 접속

3) kh계정의 EMPLOYEE 테이블을 복사한 TEST_EMP 테이블을 생성

4) 복사한 TEST_EMP 테이블의 EMP_ID 컬럼에 PRIMARY KEY 제약조건 추가

*/

CREATE USER testuser IDENTIFIED BY test1234;

GRANT CONNECT, RESOURCE TO testuser;


-- sqlplus 로그인

-- 권한주기
GRANT SELECT ON EMPLOYEE TO testuser;

CREATE TABLE TEST_EMP AS
SELECT * FROM kh.EMPLOYEE;

ALTER TABLE TEST_EMP
MODIFY EMP_ID PRIMARY KEY;