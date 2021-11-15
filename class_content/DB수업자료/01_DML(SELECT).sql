-- SQL 맛보기
-- EMPLOYEE 테이블에 있는 모든 사원 정보 조회
SELECT * FROM EMPLOYEE;

---------------------------------------

-- SELECT (DML 또는 DQL) : 조회

-- SELECT문을 이용하여 데이터를 조회하는 경우
-- 알맞은 조회 결과의 묶음인 RESULT SET이 반환된다.

-- EMPLOYEE 테이블에 있는 모든 사원 정보 조회
-- * : ALL, 모든을 뜻하는 기호
SELECT * FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 모든 사원의 이름, 이메일 조회
SELECT EMP_NAME, EMAIL FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사원의 사번, 이름, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 이름, 이메일, 전화번호, 고용일 조회
SELECT EMP_NAME, EMAIL, PHONE, HIRE_DATE FROM EMPLOYEE;

-- JOB 테이블에서 직급명 조회
SELECT JOB_NAME FROM JOB;
                    --> JOB이라는 예약어가 있지만 테이블명 작성 자리에 있으므로
                    --  예약어가 아닌 테이블명으로 인식
                    
-----------------------------------------------------------------

-- 컬럼 값 산술 연산
-- 컬럼 값 : 테이블의 한 셀(한 칸)에 작성된 값

-- SELECT 시 컬럼명에 숫자, 연산자를 작성하면
-- 조회되는 결과에 해당 연산이 반영된다.

-- EMPLOYEE 테이블에서 사원의 이름, 급여, 연봉(급여 * 12)를 조회
SELECT EMP_NAME, SALARY, SALARY*12 FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 이름, 급여, 급여 * 보너스 조회
SELECT EMP_ID, EMP_NAME, SALARY, SALARY*BONUS FROM EMPLOYEE;
--> (중요) 연산 시 사용되는 값은 해당 행의 값들로 이루어져 있다.

-- (중요) 오늘 날짜 조회
SELECT SYSDATE FROM DUAL;

-- SYSDATE : 시스템상 현재 시간(년, 월, 일, 시, 분, 초까지 표현되지만, 디벨로퍼 표현이 년/월/일 까지만임)
-- DUAL(DUMMY TABLE) : 가상 테이블(임시 테이블, 단순 조회용으로 사용)

-- * 날짜끼리의 +,- 연산이 가능하다 (일 단위)
-- 시간은 미래를 표현할수록 수가 점점 커짐

-- 오늘 날짜, 1주일 후 날짜 조회
SELECT SYSDATE, SYSDATE + 7 FROM DUAL;

-- EMPLOYEE 테이블에서 이름, 입사일, 입사일 부터 오늘까지 며칠인지 조회
SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE FROM EMPLOYEE;

-----------------------------------------------------------------

-- 컬럼 별칭 지정
-- SELECT 조회 결과인 RESULT SET의 컬럼명을 지정

-- 1) 컬럼명 AS 별칭     : 띄어쓰기 없이 문자만 별칭 지정 가능(특수문자 X)

-- 2) 컬럼명 별칭        : 1) 방법에서 AS 생략

-- 3) 컬럼명 AS "별칭"   : 제한 없이 어떤 문자, 특수문자, 띄어쓰기가 별칭으로 작성 가능

-- 4) 컬럼명 "별칭"      : 3) 방법에서 AS 생략

SELECT EMP_NAME, HIRE_DATE, SYSDATE - HIRE_DATE AS "근무 일수" FROM EMPLOYEE;

---------------------------------------------------------------------------

-- 리터럴 : 값 자체
-- 임의로 지정한 값을기존 테이블에 존재하는 값 처럼 사용

-- ''(홑따옴표) : 문자열 리터럴 표기법

-- EMPLOYEE 테이블에서 사번, 이름, 급여, 단위(값 : 원) 조회
SELECT EMP_ID, EMP_NAME, SALARY, '원' AS "단위" FROM EMPLOYEE;

-----------------------------------------------------------------------
-- DISTINCT : 컬럼에 포함된 중복 값을 한 번만 표시할 때 사용
-- 주의사항
-- 1) DISTINCT는 SELECT문에서 딱 한번만 작성할 수 있다.
-- 2) DISTINCT는 SELECT의 컬럼명 가장 앞에 작성해야 한다.

-- EMPLOYEE 테이블에서 직급 코드 조회
SELECT DISTINCT JOB_CODE FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 중복없이 직급코드, 부서코드 조회
SELECT DISTINCT JOB_CODE, DEPT_CODE FROM EMPLOYEE;
--> 컬럼이 여러 개일 경우 모든 컬럼 값이 중복되는 행을 표시하지 않음

-----------------------------------------------------------------------

-- WHERE 절
-- 테이블에서 조건을 충족하는 값을 가진 행만 조회할 때
-- 조건을 작성하는 부분
-- (자바의 IF문과 비슷)

-- 조건식 : 연산 결과가 TRUE, FALSE인 것
--> 비교 연산자, 논리 연산자

-- 비교 연산자 : >, <. >=, <=, =(같다), !=, <>

-- EMPLOYEE 테이블에서
-- 급여가 3백만 초과인 사원의
-- 사번, 이름, 급여, 부서코드를 조회
SELECT EMP_ID, EMP_NAME, SALARY, DEPT_CODE 
FROM EMPLOYEE 
WHERE SALARY > 3000000;


-- EMPLOYEE 테이블에서
-- 부서코드가 'D9'인 사원의
-- 이름, 급여, 전화번호, 부서코드 조회
SELECT EMP_NAME, SALARY, PHONE, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D9';

------------------------------------------------------------------------------

-- 논리 연산자(AND, OR)

-- EMPLOYEE 테이블에서 부서코드가 'D6'이고
-- 급여가 2백만 이상인 사원의
-- 이름, 부서코드, 급여 조회
SELECT EMP_NAME, DEPT_CODE, SALARY 
FROM EMPLOYEE 
WHERE DEPT_CODE='D6' AND SALARY>=2000000;

-- EMPLOYEE 테이블에서
-- 급여가 300만 이상, 500만 이하인 사원의
-- 사번, 이름, 급여 조회
SELECT EMP_ID, EMP_NAME, SALARY 
FROM EMPLOYEE 
WHERE SALARY >= 3000000 AND SALARY <= 5000000;


-- EMPLOYEE 테이블에서
-- 부서코드 'D6' 또는 'D9'인 사원의
-- 사번, 이름, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE='D6' OR DEPT_CODE='D9';


-- 컬럼명 BETWEEN A AND B : A이상 B이하
SELECT EMP_ID, EMP_NAME, SALARY 
FROM EMPLOYEE 
WHERE SALARY BETWEEN 3000000 AND 5000000;


-- 컬럼명 NOT BETWEEN A AND B : A미만 B초과 (A이상 B이하가 아니다)
SELECT EMP_ID, EMP_NAME, SALARY 
FROM EMPLOYEE 
WHERE SALARY NOT BETWEEN 3000000 AND 5000000;


-- 날짜도 비교 가능 
-- EMPLOYEE 테이블에서
-- 입사일이 90/01/01 ~ 99/12/31 사이인 사원의
-- 이름, 입사일 조회
SELECT EMP_NAME, HIRE_DATE 
FROM EMPLOYEE 
WHERE HIRE_DATE BETWEEN '90/01/01' AND '99/12/31';
-- '90/01/01' 문자열로 작성해도 날짜 형식의 문자열이기 때문에
-- DATE 타입과 연산 시 DATE로 변환됨

-------------------------------------------------------------------

-- LIKE
-- 비교하려는 값이 지정한 특정 패턴을 만족 시킬 때 조회

-- [작성법]
-- WHERE 컬럼명 LIKE '문자 패턴'

-- LIKE 문자 패턴 : '%' , '_' ('와일드카드' 라고 부름)

-- '%'
-- 'A%' : 문자열이 A로 시작하는 모든 컬럼 값
-- '%A' : 문자열이 A로 끝나는 모든 컬럼 값
-- '%A%' : 문자열에 A가 포함된 모든 컬럼 값

-- '_'
-- 'A_' : A뒤에 아무거나 한 글자
-- '___A' : A앞에 아무거나 세 글자

-- EMPLOYEE 테이블에서 성이 '전'씨인 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME 
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '전%';

-- 이름에 '하'가 포함된 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE EMP_NAME LIKE '%하%';

-- 전화번호가 010으로 시작하는 사원의 사번, 이름, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE 
FROM EMPLOYEE 
WHERE PHONE LIKE '010%';

-- 전화번호가 010으로 시작하지 않는 사원의 사번, 이름, 전화번호 조회
SELECT EMP_ID, EMP_NAME, PHONE 
FROM EMPLOYEE 
WHERE PHONE NOT LIKE '010%';

-- 이메일에 _ 앞 글자가 세 글자인 이메일 주소를 가진 사원의
-- 이름, 이메일 조회
SELECT EMP_NAME, EMAIL 
FROM EMPLOYEE 
WHERE EMAIL LIKE '____%';

-- 문제점 : 와일드 카드 문자 '_'와 패턴에 사용되는 일반문자 '_'가 모양이 같음
--> ESCAPE 옵션으로 일반 문자로 처리할 '_', '%' 앞에 아무 특수문자를 붙임
SELECT EMP_NAME, EMAIL 
FROM EMPLOYEE 
WHERE EMAIL LIKE '___$_%' ESCAPE '$';


-- 연습문제
-- 1. EMPLOYEE 테이블에서 이름 끝이 '연'으로 끝나는 사원의 이름 조회
SELECT EMP_NAME 
FROM EMPLOYEE 
WHERE EMP_NAME LIKE '%연';

-- 2. EMPLOYEE 테이블에서 전화번호 처음 3자리가 010이 아닌 사원의 이름, 전화번호를 조회
SELECT EMP_NAME, PHONE 
FROM EMPLOYEE 
WHERE PHONE NOT LIKE '010%';

-- 3. EMPLOYEE 테이블에서 메일주소 '_'의 앞이 4자 이면서 DEPT_CODE가 D9 또는 D6이고
--    고용일이 90/01/01 ~ 00/12/01이고, 급여가 270만 이상인 사원의 전체를 조회
SELECT * 
FROM EMPLOYEE 
WHERE (EMAIL LIKE '____@_%' ESCAPE '@') 
AND (DEPT_CODE = 'D9' OR DEPT_CODE='D6')
AND (HIRE_DATE BETWEEN '90/01/01' AND '00/12/01') 
AND SALARY >= 2700000;

-- AND 연산자가 OR 연산자 보다 우선 순위가 높음

-- 연산자 우선순위
/*
1. 산술연산자
2. 연결연산자
3. 비교연산자
4. IS NULL / IS NOT NULL, LIKE, IN / NOT IN
5. BETWEEN AND / NOT BETWEEN AND
6. NOT(논리연산자)
7. AND(논리연산자)
8. OR(논리연산자)
*/


--------------------------------------------------------------------------

-- IN 연산자
-- 비교하려는 값과 목록에 작성된 값 중 일치하는 것이 있으면 조회하는 연산자
-- == OR 연산을 연달아 진행 하는 것과 같음

-- [작성법]
-- 컬럼명 IN (목록1, 목록2, 목록3, ...)

-- EMPLOYEE 테이블에서 부서코드가 'D1' 또는 'D6' 또는 'D9'인 사원의
-- 사번, 이름, 부서코드 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE = 'D1' OR DEPT_CODE = 'D6' OR DEPT_CODE = 'D9';

SELECT EMP_ID, EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE IN ('D1', 'D6', 'D9');

-- [부정] D1, D6 ,D9 제외 --> NOT IN
SELECT EMP_ID, EMP_NAME, DEPT_CODE 
FROM EMPLOYEE 
WHERE DEPT_CODE NOT IN ('D1', 'D6', 'D9');

-----------------------------------------------------------------------------

-- 연결 연산자( || )
-- 여러 컬럼 값 또는 문자열을 연결하는 연산자
-- (자바의 문자열 + 문자열 연산 (이어쓰기)과 같음
SELECT EMP_ID || EMP_NAME || SALARY
FROM EMPLOYEE;

SELECT EMP_NAME || '의 급여는 ' || SALARY || '원 입니다.' AS "결과 문자열" 
FROM EMPLOYEE;

-----------------------------------------------------------------------

-- 자바에서 NULL : 참조하는 객체(주소)가 없음
-- DB에서 NULL : 컬럼값이 없음

-- IS NULL : 컬럼 값이 NULL인 경우 조회
-- IS NOT NULL : 컬럼 값이 NULL이 아닌 경우 조회

-- [작성법]
-- 컬럼명 IS NULL

-- EMPLOYEE 테이블에서 보너스 받지 않는 사원의
-- 이름, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS 
FROM EMPLOYEE 
WHERE BONUS IS NULL;

-- EMPLOYEE 테이블에서 보너스 받는 사원의
-- 이름, 급여, 보너스 조회
SELECT EMP_NAME, SALARY, BONUS 
FROM EMPLOYEE 
WHERE BONUS IS NOT NULL;

-------------------------------------------------------------------

-- EMPLOYEE 테이블에서
-- 급여가 200만 이상인 사원의 사번, 이름 급여
SELECT EMP_ID, EMP_NAME, SALARY FROM EMPLOYEE WHERE SALARY >= 2000000;


-- ORDER BY 절
-- SELECT의 결과 집합(RESULT SET)
-- * SELECT 구문 제일 마지막에 작성하며
--   해석도 제일 마지막으로 해석됨.

/* [작성법 및 해석 순서]
3 : SELECT 컬럼명
1 : FROM 테이블명
2 : WHERE 조건
4 : ORDER BY 컬럼명 | 별칭 | 컬럼순서 정렬방식 [NULLS FIRST | LAST]

| : 또는
[] : 생략가능
*/

-- EMPLOYEE 테이블에서
-- 급여가 200만 이상인 사원의 사번, 이름 급여
-- 급여를 오름차순으로 조회
SELECT EMP_ID, EMP_NAME, SALARY 
FROM EMPLOYEE 
WHERE SALARY >= 2000000 
ORDER BY SALARY /*ASC*/; -- 정렬 시 오름 차순이 기본값이기 때문에 ASC 생략 가능

-- 내림차순으로 변경(DESC)
SELECT EMP_ID, EMP_NAME, SALARY 
FROM EMPLOYEE 
WHERE SALARY >= 2000000 
ORDER BY SALARY DESC;

-- 컬럼 순서를 이용하여 정렬
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE 
WHERE SALARY >= 2000000 
ORDER BY 3 DESC; -- SELECT절에 작성된 컬럼 순서를 이용하여 정렬


-- EMPLOYEE 테이블에서
-- 급여가 200만 이상인 사원의
-- 사번, 이름, 급여를 이름 오름차순으로 조회

-- 문자열 오름차순 : 유니코드 순서대로 정렬
-- A-Z, a-z, 가-하, 0-9 순서대로 유니코드 표에 작성되어 있음
SELECT EMP_ID, EMP_NAME, SALARY
FROM EMPLOYEE 
WHERE SALARY >= 2000000 
ORDER BY EMP_NAME;


-- EMPLOYEE 테이블에서
-- 사원의 이름, 입사일을 빠른 입사일 순서대로 조회
SELECT EMP_NAME, HIRE_DATE
FROM EMPLOYEE
ORDER BY HIRE_DATE;


-- 정렬 시 NULL의 순서 : NULLS FIRST | LAST

-- EMPLOYEE 테이블에서
-- 사번, 이름, 보너스를
-- 보너스 오름차순 순서로 정렬
SELECT EMP_ID, EMP_NAME, BONUS
FROM EMPLOYEE
ORDER BY BONUS DESC NULLS LAST;

-- 오름 차순일 때 : NULLS LAST 기본값
-- 내림 차순일 때 : NULLS FIRST 기본값

-- 정렬 시 별칭 사용
--> SELECT절이 먼저 해석되기 때문에
-- ORDER BY절에서 해석된 별칭 사용 가능
SELECT EMP_ID, EMP_NAME, SALARY AS "급여"
FROM EMPLOYEE
ORDER BY "급여";


-- 아래 SQL구문은 별칭 해석 전
-- WHERE절에 별칭을 사용했기 때문에 수행이 안된다.

SELECT EMP_ID, EMP_NAME, SALARY AS "급여"
FROM EMPLOYEE
WHERE "급여" >= 2000000
ORDER BY "급여";