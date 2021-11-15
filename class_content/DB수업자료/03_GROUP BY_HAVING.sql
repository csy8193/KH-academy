/*
SELECT문 해석 순서
5: SELECT 컬럼명 | 계산식 | 함수 AS 별칭
1: FROM 참조할 테이블명
2: WHERE 컬럼명 | 함수식 비교연산자 비교값
3: GROUP BY 그룹으로 묶을 컬럼명
4: HAVING 그룹함수식 비교연산자 비교값
6: ORDER BY 컬럼명 | 별칭 | 컬럼순서 [ASC / DESC] [NULLS FIRST | LAST]
*/



----------------------------------------------------------------
-- GROUP BY절

-- 같은 값들이 여러 개 기록된 컬럼을 가지고 
-- 같은 값들을 하나의 그룹으로 묶는 방법

-- [작성법]
-- GROUP BY 컬럼명 | 함수식 [, 컬럼명 | 함수식 .... ]
-- GROUP BY가 포함된 SELECT문의 SELECT절에는
-- GROUP BY에 작성된 컬럼명 + 그룹 함수만을 작성할 수 있다.


-- EMPLOY 테이블에서 DEPT_CODE가 같은 사원들 끼리의 급여 합
SELECT DEPT_CODE, SUM(SALARY) FROM EMPLOYEE;

SELECT DEPT_CODE, SUM(SALARY) FROM EMPLOYEE GROUP BY DEPT_CODE;

-- EMPLOYEE 테이블에서 직급 코드가 같은 사원 끼리의 급여 합
SELECT JOB_CODE, SUM(SALARY) FROM EMPLOYEE GROUP BY JOB_CODE;

-- EMPLOYEE 테이블에서
-- 부서별 급여합, 급여 평균(소수점 아래 둘째 자리 반올림), 인원 수를
-- 부서코드 오름차순으로 조회
SELECT SUM(SALARY) "급여 합", 
    ROUND(AVG(SALARY), 1) "급여 평균", 
    COUNT(*) "인원 수"
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;


-- EMPLYEE 테이블에서
-- 각 성별 별로 인원 수, 급여 합, 급여 평균을 인원수 내림 차순으로 조회

SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별,
COUNT(*) "인원 수", SUM(SALARY) "급여 합", FLOOR(AVG(SALARY)) "급여 평균"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여')
ORDER BY "인원 수" DESC;

-- EMPLOYEE 테이블에서 부서 코드가 'D5', 'D6' 인 부서의 인원 수, 평균 급여(소수점 내림) 조회
SELECT DEPT_CODE, COUNT(*) "인원 수", FLOOR(AVG(SALARY)) "평균 급여" FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6')
GROUP BY DEPT_CODE;
---> ******
-- SELECT절에 단일행, 그룹함수가 혼용되어 있는 경우
-- 단일행 부분을 모두 GROUP BY절에 그대로 작성해야 한다.

-- 직급 코드별 2000년도 이후 입사자들의 인원 수, 급여 합 조회(직급 코드 오름차순)
SELECT JOB_CODE, COUNT(*) "인원 수", SUM(SALARY) "급여 합" FROM EMPLOYEE 
WHERE EXTRACT(YEAR FROM HIRE_DATE) >= 2000
GROUP BY JOB_CODE
ORDER BY JOB_CODE;

/* 자바 같은 프로그래밍 언어에서는 시간 관련 데이터를 다루는것이 쉽지 않음
    정렬도 자바에 구현되어있는 정렬보다, DBMS를 이용한 정렬(ORDER BY)가 쉽고 효율적임
    
    추후 JAVA + DB 구현 시, 시간/정렬 부분은 DB에서
    복잡한 로직은 JAVA에서 처리
*/

-----------------------------------------------------------------------

-- EMPLYEE 테이블에서 부서별로 같은 직급 코드를 가진 사원의
-- 부서코드, 직급코드, 급여합을 조회(부서코드 오름 차순, 직급코드 내림 차순)
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY) FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- DEPT_CODE로 그룹을 묶고 내부에서 JOB_CODE로 그룹을 또 나눔
ORDER BY DEPT_CODE, JOB_CODE DESC;


----------------------------------------------------------------------------

-- HAVING : 그룹함수로 구해올 그룹에 대한 조건을 설정할 때 사용
-- [작성법]
-- HAVING 컬럼명 | 그룹함수식 비교연산자 비교값

-- EX) 부서 코드가 'D5', 'D6'인 사원들의 부서별 급여 합
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IN ('D5', 'D6')
GROUP BY DEPT_CODE;

-- EX) 부서별 급여 합이 천만원 이상인 부서
SELECT DEPT_CODE, SUM(SALARY) 
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING SUM(SALARY) >= 10000000;


-- 부서별 급여 평균이 3백만 이상인 부서를 조회하여
-- 부서코드 오름차순으로 정렬
SELECT DEPT_CODE, FLOOR(AVG(SALARY))
FROM EMPLOYEE
GROUP BY DEPT_CODE
HAVING FLOOR(AVG(SALARY)) >= 3000000
ORDER BY DEPT_CODE;

------ 연습 문제 ------

-- 1. EMPLOYEE 테이블에서 각 부서별 가장 높은 급여, 가장 낮은 급여를 조회하여
-- 부서 코드 오름차순으로 정렬하세요.
SELECT DEPT_CODE, MAX(SALARY), MIN(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY DEPT_CODE;


-- 2.EMPLOYEE 테이블에서 각 직급별 보너스를 받는 사원의 수를 조회하여
-- 직급코드 오름차순으로 정렬하세요
SELECT JOB_CODE, COUNT(BONUS)
FROM EMPLOYEE
GROUP BY JOB_CODE
ORDER BY JOB_CODE;



-- 3.EMPLOYEE 테이블에서 
-- 부서별 70년대생의 급여 평균이 300만 이상인 부서를 조회하여
-- 부서 코드 오름차순으로 정렬하세요
SELECT DEPT_CODE, AVG(SALARY)
FROM EMPLOYEE
WHERE EMP_NO LIKE '7%'
--WHERE SUBSTR(EMP_NO, 1, 1) = '7'
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000
ORDER BY DEPT_CODE;

----------------------------------------------------------------

-- 집계함수(ROLLUP, CUBE)
-- 그룹 별로 산출한 결과 값의 집계를 처리하는 함수


-- ROLLUP 함수 : 그룹별로 중간 집계를 처리하는 함수
--> 그룹별로 묶여진 값에 대한 중간집계와 총 집계를 계산하여 자동으로 추가함
-- 각 부서에 소속된 직급별 급여 합,
-- 부서별 급여 합
-- 전체 급여합 조회

SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP( DEPT_CODE, JOB_CODE)
ORDER BY 1;


-- CUBE 함수 : 그룹별 산출 결과를 집계하는 함수
-- 그룹으로 지정된 모든 그룹에 대한 중간 집계와, 총집계를 구함
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE( DEPT_CODE, JOB_CODE)
ORDER BY 1;


-------------------------------------------------------------------------
-------------------------------------------------------------------------

/*
- 집합 연산자 (SET OPERATOR)
여러 SELECT의 결과(RESULT SET)을 하나의 RESULT SET으로 합치는 연산자
(주의사항) 집합 연산에 사용되는 SELECT문의 SELECT절은 모두 동일해야 한다.
*/

-- UNION(합집합) : 여러 SELECT문의 결과를 하나로 합치는 연산자
-- 중복되는 영역의 값은 한번만 조회

-- 부서코드가 'D5'이거나 급여 코드가 300만 초과인 직원의
-- 사번, 이름, 부서코드, 급여 조회



-- 부서코드가 'D5'
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION

-- 급여가 300만 초과
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;


-- INTERSECT(교집합) : SELECT 조회 결과에서 공통된 부분만 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

INTERSECT

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;


-- UNION ALL(합집합 + 교집합) : 여러 SELECT 결과를 하나로 합침(중복 영역도 모두 포함)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

UNION ALL

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;


-- MINUS(차집합) : SELECT 결과에서 중복되는 부분을 제거하여 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'

MINUS

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000;








