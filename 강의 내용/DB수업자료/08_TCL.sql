-- TCL(TRANSACTION CONTROL LANGUAGE) : 트랜잭션 관리(제어) 언어

/*
    TRANSACTION 이란?
    
    - 데이터베이스의 논리적 연산 단위
    - 데이터의 변경 사항을 묶어 하나의 트랜잭션에 담아 처리한다
    - 트랜잭션에 담겨지는 대상이 되는 SQL : INSERT, UPDATE, DELETE (DML)
    
    
    1) COMMIT : 메모리 버퍼에 임시 저장된 데이터 변경 사항 (INSERT, UPDATE, DELETE)을
                DB에 실제로 반영함.
    
    
    2) ROLLBACK : 메모리 버퍼에 임시 저장된 데이터 변경 사항을
                  삭제하고 마지막 COMMIT 상태로 돌아가는 것.
    
    
    3) SAVEPOINT : 저장 지점을 정의하여 ROLLBACK 시 트랜잭션 전체의 내용을 삭제하는 것이 아닌
                   저장된 지점까지만 삭제할 수 있도록 하는 것.
    [SAVEPOINT 작성법]
    SAVEPOINT 포인트명1;
    SAVEPOINT 포인트명1;

    ROLLBACK TO 포인트명1; -- 포인트1 지점까지만 롤백
*/

SELECT * FROM MEMBER;
COMMIT; -- 현재 메모리 임시 버퍼(트랜잭션)를 DB에 반영

DELETE FROM MEMBER
WHERE MEMBER_ID = 'MEM04'; -- 삭제 내용이 트랜잭션에 임시 저장됨

SELECT * FROM MEMBER; -- MEM04 삭제 확인

ROLLBACK; -- 트랜잭션 내용을 삭제하고 마지막 커밋 상태로 돌아감

SELECT * FROM MEMBER; -- MEM04 복구 확인


-- SAVEPOINT 확인
DELETE FROM MEMBER WHERE MEMBER_ID = 'MEM04';
SELECT * FROM MEMBER;

SAVEPOINT SP1; -- MEM04 삭제된 상태까지의 트랜잭션을 임시저장

DELETE FROM MEMBER WHERE MEMBER_ID = 'MEM03';
SELECT * FROM MEMBER;

-- MEM03만 복구 == SP1 으로 롤백
ROLLBACK TO SP1;
SELECT * FROM MEMBER;

-- MEM04 복구 == 마지막 COMMIT 시점으로 돌아가는 ROLLBACK 수행
ROLLBACK;
SELECT * FROM MEMBER;



-- **** TCL 주의 사항 ****
-- 1) TCL 구문은 DML에만 적용된다.
-- 2) DML 구문 작성 중 DDL 또는 DCL 구문이 수행될 경우
--    트랜잭션 내용이 바로 DB에 반영됨. (자동적으로 COMMIT됨)