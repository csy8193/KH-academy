-- 프로시져(PROCEDURE)
/*
    - PL/SQL문을 저장하는 객체
    - 필요할 때마다 복잡한 구문을 다시 입력할 필요 없이 
      간단하게 호출해서 실행 결과를 얻을 수 있음
    - 특정 로직을 처리하기만 하고 결과값을 반환하지 않음
    --> (조금 중요! FUNCTION과의 구분되는 점이기 때문에)
    
    (참고) 프로시져는 주로 분할된 업무 단위로 로직 구현 시 개별적인 단위 업무는 프로시져로 구현해 처리함.
    테이블에서 데이터를 추출해 필요에 맞게 조작하여, 그 결과를 다른 테이블에 저장/갱신 등의 일련의 처리를 할 때 주로 사용함.
    
    
    - 프로시져 생성 방법
    [표현식] 
    CREATE OR REPLACE PROCEDURE 프로시저명
        (매개변수명1 [IN | OUT | IN OUT] 데이터타입[:= DEFAULT값], 
         매개변수명2 [IN | OUT | IN OUT] 데이터타입[:= DEFAULT값],
         ...
        )       
    IS
        선언부
    BEGIN
        실행부    
    [EXCEPTION
        예외처리부]    
    END [프로시저명];
    
    - 프로시져 실행 방법
    EXECUTE(OR EXEC) 프로시저명;
*/
SET SERVEROUTPUT ON;


-- 프로시져 테스트용 테이블 2개 생성
CREATE TABLE TEST_EMP1
AS SELECT * FROM EMPLOYEE;

CREATE TABLE TEST_EMP2
AS SELECT * FROM EMPLOYEE;

SELECT * FROM TEST_EMP1;
SELECT * FROM TEST_EMP2;

-- TEST_EMP1, TEST_EMP2 두 테이블의 데이터를 모두 삭제하고 COMMIT하는 프로시져를 생성
CREATE OR REPLACE PROCEDURE DEL_EMP_ALL
IS -- 선언부 시작
BEGIN
    DELETE FROM TEST_EMP1;
    DELETE FROM TEST_EMP2;
    COMMIT;
END;
/

-- 프로시져 호출(실행)
EXECUTE DEL_EMP_ALL;
EXEC DEL_EMP_ALL;

-- 프로시져 실행 결과 확인
SELECT * FROM TEST_EMP1;
SELECT * FROM TEST_EMP2;
ROLLBACK;

-- 프로시져를 관리하는 데이터 딕셔너리(프로시져 작성 구문이 라인별로 구분되어 저장되어있음)
SELECT * FROM USER_SOURCE;


--------------------------------------------------------


-- 매개변수 있는 프로시져
CREATE TABLE TEST_EMP3
AS SELECT * FROM EMPLOYEE;

-- 프로시져 생성
CREATE OR REPLACE PROCEDURE DEL_EMP_ID(
    -- 매개변수 작성
    P_EMP_ID TEST_EMP3.EMP_ID%TYPE
)
IS -- 선언부 시작, 실행부에서 사용할 변수 선언하는 부분, 없으면 IS만 작성하고 건너뜀
BEGIN
    DELETE FROM TEST_EMP3
    WHERE EMP_ID = P_EMP_ID;
    
    COMMIT;
END;
/

-- 생성한 프로시져 실행
EXEC DEL_EMP_ID('200');

-- 200번 (선동일) 삭제 확인
SELECT * FROM TEST_EMP3
WHERE EMP_ID = '200';



--------------------------------------------------------


-- IN/OUT 매개변수 있는 프로시져

-- IN 매개변수 : 프로시저 내부에서 사용될 변수
-- OUT 매개변수 : 프로시저 외부(호출부)에서 사용될 변수




-- 프로시져 생성
-- 사번으로 사원의 이름, 급여, 보너스 조회 프로시져 생성
-- 1) 테스트용 테이블 생성
CREATE TABLE TEST_EMP4
AS SELECT * FROM EMPLOYEE;

-- 2) 프로시져 생성
CREATE OR REPLACE PROCEDURE SELECT_EMP_ID( 
    -- IN 매개변수 : 프로시져 내부에서 사용되는 변수. 기본적인 매개변수의 역할
    P_EMP_ID IN TEST_EMP4.EMP_ID%TYPE,
    
    -- OUT 매개변수 : 프로시져 외부로 결과를 내보내는 용도의 변수
    --> 내보내진 결과는 바로 표시되는 것이 아닌 바인드 변수라는 걸 활용해야 확인 가능
    P_EMP_NAME  OUT TEST_EMP4.EMP_NAME%TYPE,
    P_SALARY    OUT TEST_EMP4.SALARY%TYPE,
    P_BONUS     OUT TEST_EMP4.BONUS%TYPE

)
IS
BEGIN
    SELECT EMP_NAME, SALARY, NVL(BONUS, 0)
    INTO P_EMP_NAME, P_SALARY, P_BONUS -- OUT 매개변수
    FROM TEST_EMP4
    WHERE EMP_ID = P_EMP_ID; -- IN 매개변수
END;
/

--DROP PROCEDURE SELECT_EMP_ID;




-- 바인드 변수(VARIABLE or VAR)
-- SQL 문장을 실행할 때 SQL에 사용 값을 전달할 수 있는 통로 역할을 하는 변수
-- 위 프로시져 실행 시 조회 결과가 저장될 바인드 변수를 생성

-- 1) 바인드 변수 3개 생성
VARIABLE RESULT_NAME VARCHAR2(30);
VAR RESULT_SALARY NUMBER;
VAR RESULT_BONUS NUMBER;

-- 2) SELECT_EMP_ID 프로시저 실행
--> 전달되는 매개변수는 값을 적으면 되지만
--  결과로 나오는 매개변수 값을 저장할 변수가 필요하다
EXEC SELECT_EMP_ID('200', :RESULT_NAME, :RESULT_SALARY, :RESULT_BONUS);
--> 출력한다는 구문이 없기때문에 실행해도 결과가 안나옴
-- :변수명 == 결과로 얻어온 값을 바인드 변수에 대입
-- 바인드 변수는 ':변수명' 형태로 참조 가능


-- PRINT  : 해당 변수의 내용을 출력해주는 명령어
PRINT RESULT_NAME;
PRINT RESULT_SALARY;
PRINT RESULT_BONUS;



-- SET AUTOPRINT
-- 성공적인 PL/SQL 블록에서 사용되는 바인드 변수의 값을 자동으로 출력
-- 별도의 DBMS_OUTPUT.PUT_LINE() 필요 없이 프로시져 호출문 실행 시 바로 PRINT
SET AUTOPRINT ON;


-- 프로시져 실행 -> 사번 입력시 이름, 급여, 보너스가 AUTOPRINT 됨 
EXEC SELECT_EMP_ID('&사번', :RESULT_NAME, :RESULT_SALARY, :RESULT_BONUS);

--------------------------------------------------------------------------------------------------------------------


-- FUNCTION
/*
    - 프로시져와 사용 용도가 거의 비슷하지만
      프로시져와 다르게 OUT 매개변수를 사용하지 않아도 실행 결과를 되돌려 받을 수 있다.(RETURN)
      
      * PROCEDURE 와 FUNCTION의 차이 
      - 실행 후 반환값이 있을 수도, 없을 수도 있으면 PROCEDURE
      - 실행 후 반환값이 있다면 FUNCTION
      
    [표현식]
    CREATE OR REPLACE FUNCTION 함수명(매개변수1 매개변수타입, ... )
    RETURN 데이터타입
    IS
        선언부
    BEGIN
        실행부
        RETURN 반환값; -- 프로시져랑 다르게 RETURN 구문이 추가됨
    
    [EXCPTION
        예외처리부]
    END [함수명];
*/

-- 함수 생성
-- 사번을 입력받아 해당 사원의 연봉을 계산하고 리턴하는 함수 생성
CREATE OR REPLACE FUNCTION ANNUAL_SAL_CALC(
    P_EMP_ID EMPLOYEE.EMP_ID%TYPE
)
RETURN NUMBER -- 반환형
IS -- 선언부
    -- 조회 결과 및 계싼 결과를 저장할 변수 선언
    RESULT_SALARY EMPLOYEE.SALARY%TYPE;
    RESULT_BONUS EMPLOYEE.BONUS%TYPE;
    ANNUAL_SAL NUMBER;
    
BEGIN -- 실행부
    SELECT SALARY, NVL(BONUS, 0)
    INTO RESULT_SALARY, RESULT_BONUS -- 선언한 변수에 조회 결과 저장
    FROM EMPLOYEE
    WHERE EMP_ID = P_EMP_ID;
    
    -- 연봉 계산 == 급여 * (1 + BONUS) * 12
    ANNUAL_SAL := RESULT_SALARY * (1 + RESULT_BONUS) * 12;
    
    -- 반환값 지정
    RETURN ANNUAL_SAL;
END;
/

-- 함수 사용 방법


-- 바인드 변수 선언
VAR CALC_RESULT NUMBER;

-- 함수 호출(프로시져랑 비슷하지만 조금 다름)
EXEC :CALC_RESULT := ANNUAL_SAL_CALC('&사번');
    
-- 2) SQL문에서 단일함수, 그룹함수 처럼 사용하기
SELECT EMP_ID, EMP_NAME, ANNUAL_SAL_CALC(EMP_ID) 연봉
FROM EMPLOYEE;

-------------------------------------------------------------------------------------------------------------------- 


-- CURSOR(커서)
/*
    - SELECT문 처리 결과(처리 결과가 여러 행(ROW))를 담고있는 메모리 공간에 대한 포인터(참조)
    - 커서 사용 시 여러 ROW로 나타난 처리 결과에 순차적으로 접근 가능.
        --> SELECT 결과가 단일행일 경우 INTO절을 이용해 변수에 저장 가능하지만, 결과가 복수행인 경우 INTO절 처리 불가
            이런 복수행 결과를 CURSOR를 이용하면 행(ROW)단위로 처리가능함
    
    - 커서 사용 방법은 총 4단계로 이루어짐
        1) CURSOR -- 커서 선언
        2) OPEN   -- 커서 오픈
        3) FETCH  -- 커서에서 데이터 추출
        4) CLOSE  -- 커서 닫기      
*/


-- 커서 종류
-- 묵시적, 명시적 커서 두 종류가 있음


-- 묵시적 커서(IMPLICIT CURSOR)
/*
    - 오라클에서 자동으로 생성되어 사용하는 커서
    - PL/SQL 블록에서 실행하는 SQL문 실행 시 마다 자동으로 만들어져 사용됨
    - 사용자는 생성 유무를 알 수 없지만, 커서 속성을 활용하여 커서의 정보를 얻어 올 수 있음
*/


-- 커서 속성
/*
    (묵시적 커서 속성 정보 참조 시 커서명 = SQL)
    - 커서명%ROWCOUNT : SQL 처리 결과로 얻어온 ROW 수
                       0 시작, FETCH 시 마다 1씩 증가
    - 커서명%FOUND    : 커서 영역의 ROW 수가 한 개 이상일 경우 TRUE 아님 FALSE
    - 커서명%NOTFOUND : 커서 영역의 ROW 수가 없으면 TRUE, 아님 FALSE
    - 커서명%ISOPEN   : 커서가 OPEN 상태인 경우 TRUE(묵시적 커서는 항상 FALSE)
    
*/

-- 묵시적 커서 확인용 테이블 생성
CREATE TABLE TEST_EMP5
AS SELECT * FROM EMPLOYEE;

-- BONUS가 NULL인 사원의 BONUS를 0으로 UPDATE

UPDATE TEST_EMP5 SET BONUS = 0 WHERE BONUS IS NULL;
--> 14개 행이 수정된걸 어떻게 알까
-- UPDATE문 수행 시 오라클이 알아서 묵시적 커서를 생성하고
-- UPDATE 조건을 만족하는 행을 조회해서
-- (SELECT * FROM TEST_EMP5 WHERE BONUS IS NULL; )
-- 한 행 씩 이동하며 수정하고, 이 때 이동한 행의 개수를 카운트 (ROWCOUNT 속성)
-- 최종적으로 화면에 ROWCOUNT를 출력

-- PL/SLQ + 커서로 비슷한 동작 만들기
ROLLBACK;

BEGIN
    UPDATE TEST_EMP5 SET 
    BONUS = 0 
    WHERE BONUS IS NULL;
    --> UPDATE 수정 중 묵시적 커서가 생성되어 자동으로 사용되고 있음
    
    -- 묵시적 커서의 속성을 사용하여 내용 출력
    --> 묵시적 커서 참조 시 SQL이라는 단어를 사용
    DBMS_OUTPUT.PUT_LINE( SQL%ROWCOUNT || '행 수정 성공' );
END;
/




---------------------------------------------------------


-- 명시적 커서(EXPLICIT CURSOR)
/*
    - 사용자가 직접 선언해서 사용할 수 있는 이름있는 커서
    
    [표현법]
        CURSOR 커서명 IS [SELECT문]
        OPEN  커서명;     
        FECTH 커서명 INTO 변수;
        CLOSE 커서명;
*/

-- 급여가 3백만 이상인 사원의 사번, 이름, 급여를 출력
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE
WHERE SALARY >= 3000000;

DECLARE -- 선언부 시작
    
    -- 명시적 커서 생성
    CURSOR C1 IS
        SELECT EMP_ID, EMP_NAME, SALARY
        FROM EMPLOYEE
        WHERE SALARY >= 3000000;
        
    -- 변수 선언
    ID      EMPLOYEE.EMP_ID%TYPE;
    NAME    EMPLOYEE.EMP_NAME%TYPE;
    SAL     EMPLOYEE.SALARY%TYPE;
    
BEGIN -- 실행부 시작

    -- 커서 사용을 위한 OPEN 수행
    OPEN C1;
    
    LOOP -- 기본 반복문 활용 (무한 반복에 대한 종료 조건 필요)
        
        -- 현재 커서가 가리키고 있는 행 추출(FETCH) 후 변수에 저장
        FETCH C1 INTO ID, NAME, SAL;
        --> FETCH가 호출 될 때 마다 커서가 다음 행으로 이동한다.
        
        -- 종료 조건
        EXIT WHEN C1%NOTFOUND;
        -- %NOTFOUND : 커서로 부터 추출한 내용이 없으면 TRUE 있으면 FALSE
        
        DBMS_OUTPUT.PUT_LINE( ID || '/' || NAME || '/' || SAL);
        
    
    END LOOP;
    
    -- 사용 완료한 커서 CLOSE
    CLOSE C1;
END;
/


-- 부서별 부서코드, 부서명, 지역코드 출력 (프로시저로 생성)
CREATE OR REPLACE PROCEDURE PRINT_DEPT
IS -- 선언부
    CURSOR C2 IS
        SELECT DEPT_ID, DEPT_TITLE, LOCATION_ID
        FROM DEPARTMENT;
    
    -- 변수 선언
    DEPT DEPARTMENT%ROWTYPE;
    
BEGIN -- 실행부
    
    -- FOR문을 이용한 커서 사용 방법
    -- 장점 1: 커서를 자동으로 OPEN한다
    -- 장점 2: 매 반복마다 자동으로 FETCH(추출)을 진행한다.
    -- 장점 3: FOR문이 끝나면 자동으로 커서를 CLOSE한다.
    
    -- FOR I IN 1..5
    FOR DEPT IN C2
    LOOP
        DBMS_OUTPUT.PUT_LINE( '부서코드 : '|| DEPT.DEPT_ID ||  ', 부서명 : ' || DEPT.DEPT_TITLE ||  ', 지역 : ' || DEPT.LOCATION_ID );
    END LOOP;
END;
/

EXEC PRINT_DEPT;
    