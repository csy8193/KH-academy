-- TRIGGER(트리거)
/*
     테이블이나 뷰가 INSERT, UPDATE, DELETE 등의 DML문에 의해 변경될 경우(테이블 이벤트 발생 시)
      자동으로(묵시적으로) 실행될 내용을 정의하여 저장하는 객체(PROCEDURE)  
*/


-- 트리거 종류
/*
    - SQL문의 실행 시기에 따른 분류
        BEFORE TRIGGER : SQL문 실행 전 트리거 실행
        AFTER TRIGGER  : SQL문 실해 후 트리거 실행
        
    - SQL문의 의해 영향을 받는 각 ROW에 따른 분류
        ROW TRIGGER    : SQL문 각 ROW에 대해 한번씩 실행
                         트리거 생성 시 FOR EACH ROW 옵션 작성 
                         :OLD   : 참조 전 열의 값(INSERT: 입력 전 자료, UPDATE : 수정 전 자료, DELETE : 삭제할 자료)
                         :NEW   : 참조 후 열의 값(INSERT : 입력 할 자료, UPDATE : 수정 할 자료)
        STATMENT TRIGGER : SQL문에 대해 한번만 실행(DEFAULT TRIGGER)


(참고)        
 문장 트리거
   트리거가 설정된 테이블에 트리거 이벤트가 발생하면 많은 행에 대해 변경 작업이 발생하더라도 오직 한번만 트리거를 발생시키는 방법
  Insert, Update, Delete 한 번만 실행 된다. 컬럼값이 변화가 생길 때마다 스스로 알아서 실행 된다.
  (FOR EACH ROW 옵션이 사용되지 않음)
  예를 들어 "UPDETE emp SET 급여 = 급여 * 1.1;" 문장이 실행되면 여러 행에 대하여 자료가 변경 되더라도 한번만 트리거가 실행된다.

 행 트리거
   조건을 만족하는 여러 개의 행에 대해 트리거를 반복적으로 여러 번 수행하는 방법으로 [FOR EACH ROW WHEN 조건]절 정의된다.
  컬럼의 데이터 행이 변화가 오면 실행된다. 변경 후의 행은 OLD, NEW 사용하여 가저올 수 있다. 
  (FOR EACH ROW 옵션이 됨)

*/


-------------------------------------------------------------------------------------------------------------------- 


-- 트리거 생성
/*
    [표현식]
    CREATE [OR REPLACE] TRIGGER 트리거명
    BEFORE | AFTER 
    INSERT | UPDATE | DELETE
    ON 테이블명
    [FOR EACH ROW] -- ROW TRIGGER 옵션
    [WHEN  조건]
    
    DECLARE
        -- 선언부
    BEGIN
        -- 실행부
    [EXCEPTION]
    END;
    /
*/


-- EMPLOYEE 테이블에 INSERT가 수행되는 경우
-- '새로운 사원이 입사하였습니다.' 문장 출력

CREATE OR REPLACE TRIGGER TRG1
AFTER INSERT -- INSERT가 진행된 이후에 수행
ON EMPLOYEE

BEGIN
    DBMS_OUTPUT.PUT_LINE('새로운 사원이 입사하였습니다.');
END;
/

INSERT INTO EMPLOYEE
VALUES(905,'길성춘','690512-1151432','gil_sj@kh.or.kr','01035464455',
       'D5','J3','S5',3000000,0.1,200,SYSDATE,NULL,DEFAULT);
       
ROLLBACK;

---------------------------------------------------------------------------

-- 트리거 테스트용 테이블, 시퀀스 생성

-- 상품 정보 테이블
CREATE TABLE PRODUCT(
    PCODE NUMBER PRIMARY KEY, -- 상품 코드
    PNAME VARCHAR2(200) NOT NULL, -- 상품명
    BRAND VARCHAR2(60) NOT NULL, -- 제조사 브랜드
    PRICE NUMBER NOT NULL, -- 가격
    STOCK NUMBER DEFAULT 0 -- 재고
);

-- 상품 입출고 내역 테이블
CREATE TABLE PRO_DETAIL (
    DCODE NUMBER PRIMARY KEY, -- 각 행을 구분하는 식별자 역할 번호
    PDATE DATE DEFAULT SYSDATE, -- 상품 입/출고일
    AMOUNT NUMBER NOT NULL, -- 입/출고 개수
    STATUS CHAR(6) CHECK(STATUS IN ('입고', '출고')), -- 입/출고 상태
    PCODE NUMBER REFERENCES PRODUCT -- 상품 코드 (상품 정보 테이블과 관계 형성)
);

CREATE SEQUENCE SEQ_PCODE; -- 상품 번호 생성 시퀀스
CREATE SEQUENCE SEQ_DCODE; -- 상품 입출고내역 구분 번호 생성 시퀀스


-- 상품 정보 테이블(PRODUCT)에 샘플데이터 3개 추가
INSERT INTO PRODUCT
VALUES (SEQ_PCODE.NEXTVAL, '삼성 Z플립3', '삼성', 1200000, DEFAULT);

INSERT INTO PRODUCT
VALUES (SEQ_PCODE.NEXTVAL, 'IPHONE 13', 'APPLE', 1300000, DEFAULT);    

INSERT INTO PRODUCT
VALUES (SEQ_PCODE.NEXTVAL, '피처폰', '금성', 100000, DEFAULT);
COMMIT;

SELECT * FROM PRODUCT;
SELECT * FROM PRO_DETAIL;

-- PRO_DETAIL 테이블에 데이터 삽입 시 마다
-- PRODUCT 테이블의 STOCK 컬럼 값을 UPDATE하는 트리거 생성

CREATE OR REPLACE TRIGGER STOCK_TRG
AFTER INSERT ON PRO_DETAIL -- PRO_DETAIL 테이블에 INSERT 된 후
FOR EACH ROW -- ROW TRIGGER 옵션

BEGIN
    IF (:NEW.STATUS = '입고') -- :NEW == 새로 INSERT된 행을 가리키는 바인드 변수 == 새로 INSERT된 내용
    THEN
        -- PRODUCT 테이블에서 PCODE(상품번호)가 같은 행의 값을 증가
        UPDATE PRODUCT SET
        STOCK = STOCK + :NEW.AMOUNT -- 기존 재고에 새로 입고된 물량을 추가
        WHERE PCODE = :NEW.PCODE;
        
    ELSE -- 출고
        -- PRODUCT 테이블에서 PCODE(상품번호)가 같은 행의 값을 감소
        UPDATE PRODUCT SET
        STOCK = STOCK - :NEW.AMOUNT -- 기존 재고에 새로 입고된 물량을 감소
        WHERE PCODE = :NEW.PCODE;
    END IF;
END;
/


INSERT INTO PRO_DETAIL
VALUES( SEQ_DCODE.NEXTVAL, DEFAULT, 100, '입고', 1);

SELECT * FROM PRO_DETAIL;
SELECT * FROM PRODUCT;

INSERT INTO PRO_DETAIL
VALUES( SEQ_DCODE.NEXTVAL, DEFAULT, 200, '입고', 2);

INSERT INTO PRO_DETAIL
VALUES( SEQ_DCODE.NEXTVAL, DEFAULT, 30, '입고', 3);

INSERT INTO PRO_DETAIL
VALUES( SEQ_DCODE.NEXTVAL, DEFAULT, 1000, '입고', 1);

-- 출고
INSERT INTO PRO_DETAIL
VALUES( SEQ_DCODE.NEXTVAL, DEFAULT, 900, '출고', 1);


-- 트리거는 지정된 동작을 알아서 수행
--> 테이블을 수정하거나 데이터 수정 시 원치 않게 동작하는 경우들이 있음.