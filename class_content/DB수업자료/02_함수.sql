-- 함수 : 컬럼의 값을 읽어서 계산한 결과를 반환

-- 단일행 함수(SINGLE ROW) : 컬럼에 기록된 N개의 값을 읽어 N개의 결과를 반환
-- 그룹 함수(GROUP) : 컬럼에 기록된 N개의 값을 읽어 1개의 결과를 반환

-- 함수가 적용될 수 있는 위치
-- SELECT절, WHERE절, ORDER BY 절, GROUP BY절, HAVING절


-- <단일행 함수>

-- 1. 문자 관련 함수

-- LENGTH : 문자의 길이(글자 수) 반환
-- LENGTH('문자열' | 컬럼명)

SELECT '오라클!!!', LENGTH('오라클!!!') FROM DUAL;

-- EMPLOYEE 테이블에서
-- 이름, 이메일, 이메일 글자 수를 조회
SELECT EMP_NAME, EMAIL, LENGTH(EMAIL) FROM EMPLOYEE;


-- EMPLOYEE 테이블에서
-- 이름, 이메일, 이메일 글자 수를 조회
-- 단, 이메일 글자 수가 16자인 행만 조회
SELECT EMP_NAME, EMAIL, LENGTH(EMAIL) 
FROM EMPLOYEE 
WHERE LENGTH(EMAIL)=16;

---------------------------------------------------------------------

-- INSTR('문자열' | 컬럼명, '찾을문자', [찾을 위치 시작위치, [순번]])
-- 지정한 위치부터 지정한 순번째로 검색되는 문자의 시작 위치를 반환

-- AABAACAABBAA 문자열에서 처음 나오는 B 위치 검색
SELECT INSTR('AABAACAABBAA', 'B') FROM DUAL;

-- 1번 문자부터 검색해서 처음 나오는 B의 위치
SELECT INSTR('AABAACAABBAA', 'B', 1) FROM DUAL;

-- 4번 문자부터 검색해서 처음 나오는 B 위치
SELECT INSTR('AABAACAABBAA', 'B', 4) FROM DUAL;

-- 4번 문자부터 검색해서 두번째 나오는 B 위치
SELECT INSTR('AABAACAABBAA', 'B', 4, 2) FROM DUAL;

-- 뒤쪽 1번(-1) 문자부터 검색해서 처음 나오는 B 위치
SELECT INSTR('AABAACAABBAA', 'B', -1) FROM DUAL;

-- EMPLOYEE 테이블에서
-- 사원의 이메일과, 이메일 중 @의 위치 조회
SELECT EMAIL, INSTR(EMAIL, '@') FROM EMPLOYEE;

------------------------------------------------------------------------

-- SUBSTR('문자열' | 컬럼명, 잘라내기 시작할 위치 [, 잘라낼 길이] )
-- 컬럼이나 문자열에서 지정한 위치부터 지정된 길이만큼 문자열을 잘라내서 반환
--> 잘라낼 길이 생략 시 끝까지 잘라냄


SELECT SUBSTR('SHOWMETHEMONEY', 5) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 5, 2) FROM DUAL;
SELECT SUBSTR('SHOWMETHEMONEY', 1, 4) FROM DUAL;

-- EMPLOYEE 테이블에서
-- 사원의 이름, 이메일, 이메일에 @ 앞 까지(아이디)만 조회
SELECT EMP_NAME, EMAIL, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@')-1) AS 아이디 FROM EMPLOYEE;

-------------------------------------------------------------------------

-- TRIM([옵션] '문자열' | 컬럼명 [FROM '문자열'| 컬럼명] )
-- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자를 제거
--> (보통 양쪽 공백 제거에 많이 사용)

-- 옵션 : LEADING(앞쪽만), TRAILING(뒤쪽만), BOTH(양쪽, 기본값) 

SELECT '   KH   ', TRIM('   KH   ') FROM DUAL; -- 양쪽 공백 제거

SELECT TRIM(BOTH '-' FROM '---KH---') FROM DUAL;

-- LTRIM, RTRIM 존재

---------------------------------------------------------------------------

-- 연습문제

-- 주민등록번호를 이용하여 성별을 나타내는 부분만 잘라서 조회
SELECT EMP_NAME, EMP_NO, SUBSTR(EMP_NO, 8, 1)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 성별이 여성인 사원의 이름, 성별 조회
SELECT EMP_NAME, '여성' AS 성별
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) IN ('2', '4');

-- 사원의 이름, 생년월일을 년, 월, 일로 나누어 조회
SELECT EMP_NAME, SUBSTR(EMP_NO, 1, 2) || '년' ||
SUBSTR(EMP_NO, 3, 2) || '월' ||
SUBSTR(EMP_NO, 5, 2) || '일' AS 생년월일
FROM EMPLOYEE;

-------------------------------------------------------------------------

-- LPAD, RPAD('문자열' | 컬럼명, 반환할 문자 길이 [, 덧붙이려는 문자열] )
-- 주어진 컬럼이나 문자열에 임의의 문자열을 왼쪽 또는 오른쪽에 덧붙여 반환

SELECT RPAD(EMAIL, 20) -- EMAIL + 오른쪽 공백을 추가하여 20칸을 만듦
FROM EMPLOYEE;

SELECT LPAD(EMAIL, 20) -- EMAIL + 왼쪽 공백을 추가하여 20칸을 만듦
FROM EMPLOYEE;

SELECT RPAD(EMAIL, 20, '*') -- EMAIL + 오른쪽 공백을 추가하여 20칸을 만듦
FROM EMPLOYEE;

-- 주민등록번호 뒷자리 감추기
SELECT EMP_NAME,
RPAD( SUBSTR(EMP_NO, 1, 8), LENGTH(EMP_NO), '*' )
FROM EMPLOYEE;

SELECT EMP_NAME,
SUBSTR(EMP_NO, 1, 8) || '*******'
FROM EMPLOYEE;

------------------------------------------------------------------

-- LOWER | UPPER | INITCAP('문자열' | 컬럼)
-- 소문자 | 대문자 | 앞글자만 대문자로 변경하는 함수
SELECT 'Hello World', LOWER('Hello World'), UPPER('Hello World')
FROM DUAL;

SELECT INITCAP('hello world')
FROM DUAL;

----------------------------------------------------------------------

-- 2. 숫자 처리 함수

-- ABS(숫자 | 컬럼명) : 절대값 반환
SELECT ABS(10), ABS(-10) FROM DUAL;

------------------------------------------------------------------------------

-- MOD(숫자 | 컬럼명, 숫자 | 컬럼명)
-- 두 수를 나누어 나머지를 반환
SELECT MOD(10, 3) FROM DUAL;
SELECT MOD(10.9, 3) FROM DUAL;
--> 나머지 연산은 정수 부분까지만 수행

------------------------------------------------------------------------------

-- ROUND(숫자 | 컬럼명 [, 소수점위치]) : 반올림
SELECT ROUND(123.456) FROM DUAL; -- 소수점 첫째 자리에서 반올림 == 정수 부분까지 반올림
SELECT ROUND(123.456, 1) FROM DUAL;
SELECT ROUND(123.456, 2) FROM DUAL;

SELECT ROUND(123.456, -1) FROM DUAL; -- 120
--> 1의 자리에서 반올림 처리
SELECT ROUND(123.456, -2) FROM DUAL; -- 100

----------------------------------------------------------------------------

-- CEIL(숫자 | 컬럼명) : 올림
-- FLOOR(숫자 | 컬럼명) : 내림
-- 소수점 위치 지정 불가!!

SELECT CEIL(123.5), FLOOR(123.5) FROM DUAL;

-----------------------------------------------------------------------------

-- TRUNC(숫자 | 컬럼 [, 위치]) : 버림(절삭)
SELECT TRUNC(123.456), TRUNC(123.456, 1)
FROM DUAL;

-- 내림 버림의 차이 -> 음수일 때 확인 가능
SELECT FLOOR(-123.5), TRUNC(-123.5) FROM DUAL;



------------------------------------------------------------------------
------------------------------------------------------------------------

-- 3. 날짜 처리 함수
-- SYSDATE, MONTHS_BETWEEN, ADD_MONTHS, NEXT_DAY, LAST_DAY, EXTRACT

-- SYSDATE : 시스템에 저장되어있는 날짜(년, 월, 일, 시, 분, 초)를 반환 함수 (현재시간)
SELECT SYSDATE FROM DUAL;

-- SYSTIMESTAMP : SYSDATE + 밀리세컨드
SELECT SYSTIMESTAMP FROM DUAL;

--------------------------------------------------------------------

-- MONTHS_BETWEEN(날짜, 날짜) : 두 날짜의 개월 수 차이를 반환
SELECT ROUND(MONTHS_BETWEEN('22/01/01', SYSDATE), 1) || '개월' AS 결과
FROM DUAL;

-- EMPLOYEE 테이블에서
-- 사원의 이름, 입사일, 근무 개월 수를 
-- 근무 개월 수 내림차순으로 조회
SELECT EMP_NAME, HIRE_DATE, ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE), 1) "근무 개월 수",
ROUND(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)/12, 1) "근무 햇수"
FROM EMPLOYEE ORDER BY 3 DESC;


---------------------------------------------------------------------------

-- ADD_MONTHS(날짜, 숫자) : 날짜에 더해진 수 만큼 개월을 추가
SELECT ADD_MONTHS(SYSDATE, 3) FROM DUAL;
SELECT SYSDATE + 90 FROM DUAL; -- 날짜에 일을 더하면 정확하게 날짜 파악이 불가능할 때도 있다

--------------------------------------------------------------------------

-- LAST_DAY(날짜) : 해당 월의 마지막 날짜를 반환
SELECT LAST_DAY(ADD_MONTHS(SYSDATE,1)) FROM DUAL;

--------------------------------------------------------------------------

-- EXTRACT : 날짜 데이터(DATE)에서 년, 월, 일 정보를 추출하는 함수

-- EXTRACT(YEAR | MONTH | DAY FROM 날짜)

-- 올해 연도
SELECT EXTRACT(YEAR FROM SYSDATE) FROM DUAL;

-- EMPLOYEE 테이블에서 사원의 이름, 입사 년도, 입사 월, 입사 일 조회
SELECT EMP_NAME, 
EXTRACT(YEAR FROM HIRE_DATE) AS "입사 년도", 
EXTRACT(MONTH FROM HIRE_DATE) AS "입사 월", 
EXTRACT(DAY FROM HIRE_DATE) AS "입사 일"
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서 각 사원의 연차(1년차, 2년차, ...) 조회
SELECT EMP_NAME, EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) + 1 AS 연차
FROM EMPLOYEE;


---------------------------- 연습문제 ----------------------------

-- 1. EMPLOYEE 테이블에서 사원명, 입사일-오늘, 오늘-입사일 조회
-- 단, 입사일-오늘의 별칭은 "근무일수1", 
-- 오늘-입사일의 별칭은 "근무일수2"로 하고
-- 모두 정수(내림)처리, 양수가 되도록 처리
SELECT EMP_NAME, ABS( FLOOR(HIRE_DATE - SYSDATE) ) "근무일수1",
ABS( FLOOR(SYSDATE - HIRE_DATE) ) "근무일수2"
FROM EMPLOYEE;

-- 2. EMPLOYEE 테이블에서 사번이 홀수인 직원들의 정보 모두 조회
SELECT * FROM EMPLOYEE WHERE MOD(EMP_ID, 2) = 1;


-- 3. EMPLOYEE 테이블에서 근무 햇수가 20년 이상인 직원 정보 조회
SELECT * FROM EMPLOYEE 
WHERE EXTRACT(YEAR FROM SYSDATE) - EXTRACT(YEAR FROM HIRE_DATE) + 1 >= 20;

SELECT * FROM EMPLOYEE
WHERE ADD_MONTHS(HIRE_DATE, 240) <= SYSDATE;

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------


-- 4. 형변환 함수
-- CHAR(문자열), NUMBER(숫자), DATE(날짜) 끼리의 형변환

-- TO_CHAR(숫자 [, 포맷]) : 숫자 데이터를 지정된 포맷의 문자열로 변경
-- TO_CHAR(날짜 [, 포맷]) : 날짜 데이터를 지정된 포맷의 문자열로 변경



SELECT 1234, '1234', TO_CHAR(1234) FROM DUAL;
    -- 숫자   문자열     숫자 -> 문자열
    
SELECT TO_CHAR(1234, '99999') FROM DUAL;
-- '9' : 하나당 0~9사이 숫자 한칸, 숫자 없으면 빈칸, 오른쪽 정렬

SELECT TO_CHAR(1234, '00000') FROM DUAL;

-- 001 002 ~ 010 011 ~ 100 101

SELECT TO_CHAR(1000000, 'L9999999') FROM DUAL;
-- 'L' : 현재 시스템상에 설정된 나라의 화폐 기호
--> 화폐 기호를 바꾸는 방법 : 1. 시스템의 설정 나라 변경, 2. L대신 화폐 기호를 직접 작성

SELECT TO_CHAR(1000000, '$9999999') FROM DUAL;

SELECT TO_CHAR(1000000, 'L9,999,999') FROM DUAL;
-- 자릿수 구분 콤마(,) 사용 가능

SELECT TO_CHAR(1000000, 'L9999') FROM DUAL;
-- (주의사항) 포맷에 지정된 칸 수가 숫자보다 적을경우 '#'으로 출력됨


-- EMPLOYEE 테이블에서
-- 각 사원의 이름, 급여 (\1,000,000 형식) 으로 조회
SELECT EMP_NAME, TO_CHAR(SALARY, 'L999,999,999') AS SALARY
FROM EMPLOYEE;


--------------------------------------------------------------

-- 날짜 데이터의 포맷을 TO_CHAR를 이용해서 지정할 수 있다.
/*
YYYY : 연도(4자리), YY : 연도(2자리)
MM : 월
DD : 일
AM | PM : 오전/오후 중 알맞은 것을 표시
HH24 : 시간(24시간)
HH : 시간(12시간)
MI : 분
SS : 초
DAY : 요일, DY : 요일 약어
*/
SELECT SYSDATE FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'HH24:MI:SS') FROM DUAL;
SELECT TO_CHAR(SYSDATE, 'PM HH:MI:SS') FROM DUAL;

-- 현재 시간을 2021년 09월 15일 2시 22분 30초 형식으로 조회
SELECT TO_CHAR(SYSDATE, 'YY"년" MM"월" DD"일" HH24"시" MI"분" SS"초"') FROM DUAL;
--> 지정되지 않은 포맷을 사용할 경우 ""(쌍따옴포)로 감싸준다

SELECT TO_CHAR(SYSDATE, 'YEAR') FROM DUAL;
--> 연도 영어 표기

---------------------------------------------------------------------

-- TO_DATE : 날짜 형태의 문자열을 날짜 데이터(DATE)로 변환

-- TO_DATE('문자열' | 컬럼 [, 포맷]) : 문자열을 날짜로 변환
-- TO_DATE('숫자' | 컬럼 [, 포맷]) : 숫자를 날짜로 변환

SELECT '20210916', TO_DATE('20210916') FROM DUAL;
SELECT 20210916, TO_DATE(20210916) FROM DUAL;

SELECT '20210915143720', TO_DATE('20210915143720') FROM DUAL;
SELECT '2021-09-15', TO_DATE('2021-09-15') FROM DUAL;
SELECT '2021/09/15', TO_DATE('2021/09/15') FROM DUAL;
SELECT '2021.09.15', TO_DATE('2021.09.15') FROM DUAL;
--> 기본적으로 많이 사용되는 날짜 표기 문자열은 자동으로 DATE 타입으로 변환된다

SELECT '2021년 09월 15일', TO_DATE('2021년09월15일') FROM DUAL;
--> 년, 월, 일 같이 패턴에 포함되지 않는 문자열이 있을경우 DATE 변환 불가

SELECT TO_DATE('2021년 09월 15일 14시 25분 32초', 'YYYY"년" MM"월" DD"일" HH24"시" MI"분" SS"초"')
FROM DUAL;

-- ***** 연도 표기 포맷 R, Y의 차이점 *****
-- Y : 현재 세기(21세기 == 2000년대) 적용
-- R : 변환하는 숫자가 50 이상이면 이전 세기 (1900)
--     반환하는 숫자가 50 미만이면 현재 세기 (2000)

SELECT TO_DATE('210915', 'YYMMDD') FROM DUAL; --> 문제 없어 보임

SELECT TO_DATE('990915', 'YYMMDD') FROM DUAL; --> 2099-09-15
SELECT TO_DATE('990915', 'RRMMDD') FROM DUAL; --> 1999-09-15

-- EMPLOYEE 테이블에서 2000년도 이후에 입사한 사원의
-- 이름, 급여, 입사일 조회
SELECT EMP_NAME, SALARY, HIRE_DATE
FROM EMPLOYEE
WHERE HIRE_DATE >= TO_DATE(20000101);

-------------------------------------------------------------------

-- TO_NUMBER( '문자열' | 컬럼 [, 포맷] ) : 문자열을 숫자로 변환
-- == Integer.parseInt("100"), Double.parseDouble("3.124");

SELECT TO_NUMBER('1000000') FROM DUAL; --> 조회 결과는 숫자 데이터임
SELECT TO_NUMBER('1,000,000') FROM DUAL; -- ORA-01722: invalid number(유효하지 않은 숫자)

SELECT TO_NUMBER('1,000,000', '9,999,999') FROM DUAL;
SELECT TO_CHAR(1000000, '9,999,999') FROM DUAL;

----------------------------------------------------------------

-- 5. NULL 처리 함수
-- DB에서 NULL은 컬럼 값이 없음(비어있다)

-- 사원의 이름, 급여, 급여 * 보너스 조회
SELECT EMP_NAME, SALARY, BONUS, SALARY * BONUS
FROM EMPLOYEE;


-- NVL(컬럼명, NULL일 때 변경할 값) : 컬럼 값이 NULL일 경우 다른 값으로 변경
-- 사원의 이름, 급여, 급여 * 보너스 조회
-- BONUS가 NULL인 경우 0으로 계산
SELECT EMP_NAME, SALARY, NVL(BONUS, 0), SALARY * NVL(BONUS, 0)
FROM EMPLOYEE;

-- NVL2(컬럼명, NULL이 아닐때 변경할 값, NULL일때 변경할 값)

-- 회사에 대박이 났다
-- 모든 사원들에게 보너스 지급하려고 한다.
-- 보너스는 0.2씩 증가한 만큼 지급
SELECT EMP_NAME, 
    NVL2(BONUS, BONUS + 0.2, 0.2), 
    SALARY * NVL2(BONUS, BONUS + 0.2, 0.2) 
FROM EMPLOYEE;


-- NULLIF(비교대상1, 비교대상2)
-- 두 비교대상의 값이 동일하면 NULL, 아니면 비교대상1 반환
-- 서브쿼리, 프로시저와 함께 많이 사용되는 함수

SELECT NULLIF(100, 100) FROM DUAL; -- NULL
SELECT NULLIF(100, 200) FROM DUAL; -- 100


--------------------------------------------------------------------------

-- 6. 선택 함수
-- 여러 경우(조건)에 따라 원하는 값을 선택하는 기능을 가진 함수

-- DECODE( 계산식 | 컬럼명, 조건1, 값1, 조건2, 값2, ......, 아무것도 아닐 경우의 값)

-- 계산식 또는 컬럼의 값이 조건과 같으면 해당 값을 반환
-- 자바의 SWITCH문과 비슷


-- EMPLOYEE 테이블에서 사원의 이름, 성별(남,여)를 조회
SELECT EMP_NAME, DECODE( SUBSTR(EMP_NO, 8, 1), 1, '남', 2, '여' ) AS 성별 
FROM EMPLOYEE;

-- 직원들의 급여 인상을 하고자 한다.
-- 직급 코드가 'J7'인 직원은 10%인상
-- 직급 코드가 'J6'인 직원은 15%인상
-- 직급 코드가 'J5'인 직원은 20%인상
-- 그 외 직급은 5% 인상
-- EMPLOYEE 테이블에서 사원의 이름, 직급코드, 인상 전 급여, 인상 후 급여를 조회
SELECT EMP_NAME, SALARY "인상 전 급여", 
SALARY * DECODE(JOB_CODE, 'J7', 1.1, 'J6', 1.15, 'J5', 1.2, 1.05) "인상 후 급여"
FROM EMPLOYEE;


-- CASE 선택 함수
-- 자바의 IF = ELSE IF - ELSE 와 비슷
/* [작성법]
CASE
    WHEN 조건식 THEN 결과값
    WHEN 조건식 THEN 결과값
    WHEN 조건식 THEN 결과값
    ELSE 결과값
END
*/

-- EMPLOYEE 테이블에서 이름, 성별(남,여) 조회
SELECT EMP_NAME,
    CASE
        WHEN SUBSTR(EMP_NO, 8, 1) IN ('1', '3') THEN '남'
        WHEN SUBSTR(EMP_NO, 8, 1) IN ('2', '4') THEN '여'
    END AS 성별
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번, 사원명, 급여를 조회
-- 급여가 500만원 이상이면 '고급'
-- 급여가 300~500만원이면 '중급'
-- 그 미만은 '초급'으로 출력처리하고 별칭은 '구분'으로 한다.
-- 부서코드가 'D6'인 직원만 조회
-- 직급코드 오름차순 정렬
SELECT EMP_ID, EMP_NAME, SALARY,
CASE
    WHEN SALARY >= 5000000 THEN '고급'
    WHEN SALARY >= 3000000 THEN '중급'
    ELSE '초급'
END AS "구분"
FROM EMPLOYEE WHERE DEPT_CODE = 'D6'
ORDER BY JOB_CODE;


--------------------------------------------------------------------------
--------------------------------------------------------------------------

-- < 그룹 함수 >
-- 하나 이상의 행을 그룹으로 묶어 하나의 결과만을 반환하는 함수
--> 합계(SUM), 평균(AVG), 최대값(MAX), 최소값(MIN), 개수(COUNT)

-- SUM(숫자가 기록된 컬럼) : 합계를 구하여 반환

-- EMPLOYEE 테이블에서 전 사원의 급여 총합 조회
SELECT SUM(SALARY) AS "급여 총합"
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서 부서코드가 'D5'인 사원의 급여 총합
SELECT SUM(SALARY) FROM EMPLOYEE WHERE DEPT_CODE = 'D5';


-- EMPLOYEE 테이블에서 성별이 여성인 사원의 연봉 합 조회
SELECT SUM(SALARY*12) FROM EMPLOYEE WHERE SUBSTR(EMP_NO, 8, 1) = '2';


--------------------------------------------------------------------------

-- AVG(숫자가 기록된 컬럼) : 평균 값 반환
SELECT AVG(SALARY) FROM EMPLOYEE;

-- 전 사원의 급여 평균을 999,999,999 형식으로 조회
-- (소수점 반올림)
SELECT TO_CHAR(ROUND(AVG(SALARY)), 'L999,999,999') AS "평균 급여" FROM EMPLOYEE;


-- 전 사원의 보너스 평균 조회 (소수점 셋 째자리에서 반올림)
SELECT ROUND(AVG(NVL(BONUS, 0)), 2) FROM EMPLOYEE;

--> 평균 계산 시 NULL 값은 제외

----------------------------------------------------------------------------

-- MAX(컬럼명) : 최대값, 가장 미래, 문자 순서 뒤쪽
-- MIN(컬럼명) : 최소값, 가장 과거, 문자 순서 앞쪽

-- 가장 높은 급여
SELECT MAX(SALARY), MIN(SALARY) FROM EMPLOYEE;

-- 사원중 이름 순서가 가장 빠른 사원의 이름
-- 입사일이 가장 빠른 사원의 입사일
SELECT MIN(EMP_NAME), MIN(HIRE_DATE) FROM EMPLOYEE;

-- 부서코드가 D6인 부서의 급여가 가장 높은 급여, 가장 낮은 급여
SELECT MAX( SALARY), MIN(SALARY) FROM EMPLOYEE
WHERE DEPT_CODE = 'D6';

---------------------------------------------------------------------

-- COUNT( * | [DISTINCT] 컬럼명 ) : RESULT SET에 포함되는 행의 개수 반환

-- COUNT(*) : 조회되는 행 중 NULL값이 있으면 NULL 포함한 전체 행 개수를 반환
-- COUNT(컬럼명) : 특정 컬럼에서 NULL을 제외한 행의 개수를 반환
-- COUNT(DISTINCT 컬럼명) : 특정 컬럼에서 NULL + 중복을 제외한 행의 개수를 반환

SELECT * FROM EMPLOYEE;

-- 전체 사원 수 조회
SELECT COUNT(*) FROM EMPLOYEE;

-- DEPT_CODE가 있는 사원 수 조회
SELECT COUNT(*) FROM EMPLOYEE WHERE DEPT_CODE IS NOT NULL;

SELECT COUNT(DEPT_CODE) FROM EMPLOYEE;

-- DEPT_CODE가 있는 사원수 조회(중복 카운트X)
SELECT COUNT(DISTINCT DEPT_CODE) FROM EMPLOYEE;


-- 남자 / 여자 사원 수 조회
-- 남자
SELECT COUNT(*) FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1)='1';
-- 여자
SELECT COUNT(*) FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1)='2';


-- ***********************
SELECT COUNT(*) "전체 사원 수",
    COUNT(DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남')) "남자 사원 수",
    COUNT(DECODE(SUBSTR(EMP_NO, 8, 1), '2', '여')) "여자 사원 수"
FROM EMPLOYEE;

SELECT COUNT(DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남'))
FROM EMPLOYEE;