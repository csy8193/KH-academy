-- PL/SQL (Procedural Language extension to SQL)
/*    
    - 오라클 자체에 내장되어있는 절차적 언어(Procedual Language)
    - SQL 문장 내에서 변수의 정의, 조건처리(IF), 반복처리(LOOP, FOR, WHILE)등을 지원하여 
      SQL의 단점을 보완
*/

-- PL/SQL 구조
/*
    - 선언부(DECLARE SECTION) : DECLARE로 시작, 변수나 상수를 선언하는 부분
    - 실행부(EXECUTABLE SECTION) : BEGIN으로 시작, 제어문, 반복문, 함수 정의등 로직 기술
    - 예외처리부(EXCEOTION SECTIOIN) : EXCEPTION으로 시작, 예외사항 발생 시 해결하기 위한 문장 기술
*/


-- PL/SQL의 장점
/*
    - PL/SQL문은 BLOCK 구조로 다수의 SQL문을 한번에 ORACLE DB로 보내 처리하므로 수행 속도 향상
    - PL/SQL의 모든 요소는 하나 또는 두 개 이상의 블록으로 구성하여 모듈화 가능
    - 단순, 복잡한 데이터 형태의 변수 및 데이블의 데이터 구조와 컬럼명의 준하여 동적으로 변수 선언 가능
    - EXCEPTION 루틴을 이용하여 ORACLE SERVER ERROR 처리 가능
      + 사용자 정의 에러 선언 및 처리도 가능
*/



-- PL/SQL 작성 예시


-- ** 프로시저 사용 시 출력하는 내용을 화면에 보여주도록 설정하는 환경변수를 ON으로 변경(기본값 OFF)
SET SERVEROUTPUT ON;


-- 화면에 'HELLO WOLRD' 출력
BEGIN
    DBMS_OUTPUT.PUT_LINE('HELLO WORLD');
END;
/



-- DBMS_OUTPUT 패키지에 포함되있는 PUT_LINE이라는 프로시저를 이용하여 출력
-- END 뒤 '/' 기호는 PL/SQL 블록을 종결시킨다는 의미


--------------------------------------------------------------------------------------------------------------------


-- 타입 변수 선언
    --> 타입 변수 = 오라클 데이터 타입의 변수
-- 변수의 선언 및 초기화, 변수값 출력
DECLARE -- 선언부 시작
    EMP_ID NUMBER; -- NUMBER 타입의 변수 EMP_ID 선언
    EMP_NAME VARCHAR2(30); -- VARCHAR2(30) 타입의 변수 EMP_NAME 선언
    
    DEPT_TITLE VARCHAR2(30) := '총무부';
    -- 대입 연산자 ( := )
    
    PI CONSTANT NUMBER := 3.141592;
    -- CONSTANT : 상수
    
BEGIN -- 선언부 종료, 실행부 시작
    EMP_ID := 999; -- 선언부에서 선언한 EMP_ID 변수에 값 대입
    EMP_NAME := '최승엽';
    
    -- 변수에 저장된 값을 아래와 같이 출력
    -- 사번 : 999
    -- 이름 : 최승엽
    -- 부서 : 총무부
    -- PI : 3.141592
    
    -- System.out.println("사번 : " + emp_id);
    -- DB 연결 연산자 (||)
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('부서 : ' || DEPT_TITLE);
    DBMS_OUTPUT.PUT_LINE('PI : ' || PI);
END;
/


--------------------------------------------------------

 -- 레퍼런스 변수 : 변수의 데이터 타입을 테이블 또는 뷰의 컬럼을 참조하여 지정하는 변수
-- %TYPE, %ROWTYPE 두 종류가 있음.

-- %TYPE : 해당 컬럼의 데이터 타입을 얻음.
DECLARE -- 선언부 시작
    ID EMPLOYEE.EMP_ID%TYPE; -- EMPLOYEE 테이블의 EMP_ID 컬럼의 자료형을 참조하여 변수 선언
    --> VARCHAR2(3)
    NAME EMPLOYEE.EMP_NAME%TYPE;
    --> VARCHAR2(20)
BEGIN -- 선언부 종료, 실행부 시작
    --ID := 'AAA';
    --NAME := '홍길동';
    
    SELECT EMP_ID, EMP_NAME
    INTO ID, NAME --> SELECT 조회 결과 컬럼 EMP_ID, EMP_NMAME을 선언한 변수 ID, NAME에 대입
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    --> 입력 기호 (&), 사번 == 입력 화면에 출력되는 글자
    
    DBMS_OUTPUT.PUT_LINE(ID);
    DBMS_OUTPUT.PUT_LINE(NAME);
END;
/

-- 레퍼런스 변수 선언, 초기화 예제
/*
    레퍼런스 변수로 EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY를 선언하고
    EMPLOYEE 테이블에서 사번, 이름, 직급코드, 부서코드, 급여를 조회하고
    선언한 레퍼런스 변수에 담아 출력하시오
    단, 입력받은 이름과 일치하는 조건의 직원을 조회하세요.
*/
DECLARE
    ID EMPLOYEE.EMP_ID%TYPE;
    NAME EMPLOYEE.EMP_NAME%TYPE;
    DCODE EMPLOYEE.DEPT_CODE%TYPE;
    JCODE EMPLOYEE.JOB_CODE%TYPE;
    SAL EMPLOYEE.SALARY%TYPE;
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE, SALARY
    INTO ID, NAME, DCODE, JCODE, SAL
    FROM EMPLOYEE
    WHERE EMP_NAME = '&이름';
    
    DBMS_OUTPUT.PUT_LINE('ID : ' || ID);
    DBMS_OUTPUT.PUT_LINE('NAME : ' || NAME);
    DBMS_OUTPUT.PUT_LINE('DCODE : ' || DCODE);
    DBMS_OUTPUT.PUT_LINE('JCODE : ' || JCODE);
    DBMS_OUTPUT.PUT_LINE('SAL : ' || SAL);
END;
/



--------------------------------------------------------



-- %ROWTYPE : 한 행에 있는 모든 컬럼의 데이터 타입을 얻음.

DECLARE
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT * 
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    DBMS_OUTPUT.PUT_LINE('EMP_ID : ' || EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('EMP_NAME : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('EMP_NO : ' || EMP.EMP_NO);
    DBMS_OUTPUT.PUT_LINE('SALARY : ' || EMP.SALARY);
END;
/



--------------------------------------------------------------------------------------------------------------------


-- 선택문(조건문)


-- IF ~ THEN ~ END IF (단일 IF문)

-- EMP_ID를 입력받아 해당 사원의 사번, 이름, 급여, 보너스율 출력
-- 단, 보너스를 받지 않는 사원은 보너스율 출력 전 '보너스를 지급받지 않는 사원입니다.' 출력 
DECLARE
    EMP EMPLOYEE%ROWTYPE;
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE('사번 : ' || EMP.EMP_ID);
    DBMS_OUTPUT.PUT_LINE('이름 : ' || EMP.EMP_NAME);
    DBMS_OUTPUT.PUT_LINE('급여 : ' || EMP.SALARY);
    DBMS_OUTPUT.PUT_LINE('보너스율 : ' || EMP.BONUS);
    --> NULL은 빈칸으로 출력됨
    
    IF (EMP.BONUS IS NULL)
    THEN
        DBMS_OUTPUT.PUT_LINE('보너스를 지급받지 않는 사원입니다.');
    END IF;
    
END;
/



--------------------------------------------------------


-- IF ~ THEN ~ ELSE ~ END IF (IF ~ ESLE문)

-- EMP_ID를 입력받아 해당 사원의 사번, 이름, 부서명, 소속 출력하시오.
-- TEAM 변수를 만들어 소속이 'KO'인 사원은 '국내팀' 아닌 사원은 '해외팀'으로 저장
DECLARE
    ID EMPLOYEE.EMP_ID%TYPE;
    NAME EMPLOYEE.EMP_NAME%TYPE;
    DTITLE DEPARTMENT.DEPT_TITLE%TYPE;
    CODE LOCATION.NATIONAL_CODE%TYPE;
    
    TEAM VARCHAR2(20);
BEGIN
    SELECT EMP_ID, EMP_NAME, DEPT_TITLE, NATIONAL_CODE
    INTO ID, NAME, DTITLE, CODE
    FROM EMPLOYEE
    JOIN DEPARTMENT ON (DEPT_CODE = DEPT_ID)
    JOIN LOCATION ON (LOCATION_ID = LOCAL_CODE)
    WHERE EMP_ID = '&EMP_ID';
    
    DBMS_OUTPUT.PUT_LINE(ID);
    DBMS_OUTPUT.PUT_LINE(NAME);
    DBMS_OUTPUT.PUT_LINE(DTITLE);
    IF(CODE = 'KO')
    THEN
        DBMS_OUTPUT.PUT_LINE('국내팀');
    ELSE
        DBMS_OUTPUT.PUT_LINE('해외팀');
    END IF;
END;
/

-- 사원의 연봉을 구하는 PL/SQL 블럭 작성
-- 보너스가 있는 사원은 보너스도 포함하여 계산

DECLARE
    EMP EMPLOYEE%ROWTYPE;
    ANNUAL_SAL NUMBER;
BEGIN
    SELECT * 
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&EMP_ID';
    
    IF(EMP.BONUS IS NULL)
        THEN ANNUAL_SAL := EMP.SALARY * 12;
    ELSE ANNUAL_SAL := EMP.SALARY * (1 + EMP.BONUS) * 12;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE(EMP.SALARY || ' ' || EMP.EMP_NAME || 
                        TO_CHAR(ANNUAL_SAL, 'L999,999,999'));
END;
/





--------------------------------------------------------


-- IF ~ THEN ~ ELSIF ~ ELSE ~ END IF (IF ~ ESLE IF ~ ELSE문)

-- 점수를 입력받아 SCORE변수에 저장하고
-- 90점 이상은 'A', 80점 이상은 'B', 70점 이상은 'C'
-- 60점 이상은 'D' 60점 미만은 'F'로 조건 처리하여
-- GRADE 변수에 저장하여
-- '당신의 점수는 90점이고, 학점은 A 학점입니다' 형태로 출력하세요
DECLARE
    SCORE NUMBER;
    GRADE CHAR(1);
BEGIN
    SCORE := '&점수';
    
    IF(SCORE >= 90) THEN GRADE := 'A';
    ELSIF (SCORE >= 80) THEN GRADE := 'B';
    ELSIF (SCORE >= 70) THEN GRADE := 'C';
    ELSIF (SCORE >= 60) THEN GRADE := 'D';
    ELSE GRADE := 'F';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('당신의 점수는 ' || SCORE || '점이고, 학점은 ' || GRADE || '입니다.');
END;
/
    



--------------------------------------------------------


-- CASE ~ WHEN ~ THEN ~ END(SWITCH ~ CASE 문)


-- 사원 번호를 입력하여 해당 사원의 사번, 이름, 부서명 출력


-- IF END IF 사용 시

DECLARE
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(20);
BEGIN
    SELECT *
    INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';
    
    IF EMP.DEPT_CODE = 'D1' THEN DNAME := '인사관리부';
    END IF;
    IF EMP.DEPT_CODE = 'D2' THEN DNAME := '회계관리부';
    END IF;
    IF EMP.DEPT_CODE = 'D3' THEN DNAME := '마케팅부';
    END IF;
    IF EMP.DEPT_CODE = 'D4' THEN DNAME := '국내영업부';
    END IF; 
    IF EMP.DEPT_CODE = 'D5' THEN DNAME := '해외영업1부';
    END IF;
    IF EMP.DEPT_CODE = 'D6' THEN DNAME := '해외영업2부';
    END IF;
    IF EMP.DEPT_CODE = 'D7' THEN DNAME := '해외영업3부';
    END IF;
    IF EMP.DEPT_CODE = 'D8' THEN DNAME := '기술지원부';
    END IF;
    IF EMP.DEPT_CODE = 'D9' THEN DNAME := '총무부';
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('사번  이름   부서명'); 
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_ID || ' ' || EMP.EMP_NAME || ' ' || DNAME);
END;
/


-- CASE WHEN THRN END사용 시

DECLARE 
    EMP EMPLOYEE%ROWTYPE;
    DNAME VARCHAR2(20);
BEGIN
    SELECT * INTO EMP
    FROM EMPLOYEE
    WHERE EMP_ID = '&사번';

    DNAME := CASE EMP.DEPT_CODE
                WHEN 'D1' THEN '인사관리부'
                WHEN 'D2' THEN '회계관리부'
                WHEN 'D3' THEN '마케팅부'
                WHEN 'D4' THEN '국내영업부'
                WHEN 'D5' THEN '해외영업1부'
                WHEN 'D6' THEN '해외영업2부'
                WHEN 'D7' THEN '해외영업3부'
                WHEN 'D8' THEN '기술지원부'
                WHEN 'D9' THEN '총무부'
            END;
            
    DBMS_OUTPUT.PUT_LINE('사번  이름  부서명'); 
    DBMS_OUTPUT.PUT_LINE(EMP.EMP_ID || ' ' || EMP.EMP_NAME || ' ' || DNAME);
END;
/



--------------------------------------------------------------------------------------------------------------------



-- 반복문


--  BASIC LOOP
/*
    - 내부에 처리문을 작성하고 마지막에 LOOP를 벗어날 조건을 명시
    
    [표현식]
    LOOP 
        처리문
        조건문
    END LOOP; 
    
    - 조건문
     -- IF 조건식 THEN EXIT END IF;
     -- EXIT WHEN 조건식;
*/


-- 1~5까지 순차적으로 출력
DECLARE
    N NUMBER := 1; -- 반복 제어용 변수 선언
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(N);
        
        -- 1) 종료 조건 작성법 1
        --IF(N = 5) THEN EXIT;
        --END IF;
        
        -- 2) 종료 조건 작성법 2
        EXIT WHEN N = 5;
        
        N := N+1; -- N 1 증가
    
    END LOOP;
END;
/





--------------------------------------------------------

-- FOR LOOP 

/*
    FOR 인덱스 IN [REVERSE] 초기값..최종값
    LOOP
        처리문
    END LOOP;
*/

-- 1 ~ 5까지 순서대로 출력
BEGIN
    FOR I IN 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/



-- 1 ~ 5까지 거꾸로 출력
BEGIN
    -- FOR I IN 5..1 -- (X) FOR문은 무조건 1씩 증가만 함
    FOR I IN REVERSE 1..5
    LOOP
        DBMS_OUTPUT.PUT_LINE(I);
    END LOOP;
END;
/



-- 반복문을 이용한 데이터 삽입
-- 테이블 생성 후 순서대로 데이터 삽입
CREATE TABLE TEST1(
    NUM NUMBER(3),
    STR VARCHAR2(20),
    DT DATE
);

BEGIN
    FOR I IN 1..10
    LOOP
        INSERT INTO TEST1 VALUES(I, '문자열' || I, SYSDATE + I);
    END LOOP;
END;
/

SELECT * FROM TEST1;

    
--------------------------------------------------------------------------------------------------------------------


-- 예외처리
-- 예외(Exception) : 런타임 중 로직 처리간 발생하는 오류

-- 시스템 예외(미리 정의 되어있는 예외)
/*
    - 오라클 내부에 미리 정의되어있는 예외 (Predefined Oracle Server, 약 20개 존재)
    - 따로 선언할 필요 없이 발생 시 예외절에 자동 트랩됨.
    - 대표적인 시스템 예외
        -- NO_DATA_FOUND :  SELECT문이 아무런 데이터 행을 반환하지 못할 때
        -- TOO_MANY_ROWS : 하나만 리턴해야하는 SELECT문이 하나 이상의 행을 반환할 때
        -- INVALID_CURSOR : 잘못된 커서 연산
        -- ZERO_DIVIDE : 0으로 나눌 때
        -- DUP_VAL_ON_INDEX : UNIQUE 제약을 갖는 컬럼에 중복되는 데이터가 INSERT될 때 
*/


-- 예외 처리 구문 (CASE문 구조와 비슷함)
/*
    [표현식]
    EXCEPTION WHEN 예외명1 TEHN 예외처리구문1
    WHEN 예외명2 THEN 예외처리구문2
    ...
    WHEN OTHERS THEN 예외처리 구문N;
*/

-- 숫자를 0으로 나눌경우 예외처리
DECLARE
    NUM NUMBER := 0;
BEGIN
    NUM := 10/0;
    DBMS_OUTPUT.PUT_LINE('SUCCESS');
EXCEPTION 
    WHEN ZERO_DIVIDE THEN DBMS_OUTPUT.PUT_LINE('ZERO_DIVIDE EXCEPTION 발생');
END;
/


-- 사번이 200번이 사원의 사번을 이미 존재하는 사번으로 수정하려는 경우
-- UNIQUE 제약조건 위배 시
BEGIN
    UPDATE EMPLOYEE
    SET EMP_ID = '&사번'
    WHERE EMP_ID = 200;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX 
        THEN    DBMS_OUTPUT.PUT_LINE('이미 존재하는 사번입니다.');
END;
/