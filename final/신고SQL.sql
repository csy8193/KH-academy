CREATE TABLE REPORT2(
  REPORT_NO NUMBER PRIMARY KEY,
  REPORT_DIV NUMBER NOT NULL,
  REPORT_CONTENT VARCHAR2(1000) NOT NULL,
  REPORT_ST NUMBER DEFAULT 0 NOT NULL,
  REPORT_MEM_NO NUMBER REFERENCES MEMBER(MEMBER_NO) NOT NULL,
  TARGET_MEM_NO NUMBER REFERENCES MEMBER(MEMBER_NO),
  TARGET_CLASS_NO NUMBER REFERENCES CLASS(CLASS_NO),
  REPORT_REQ_DT DATE DEFAULT SYSDATE
);

ALTER TABLE REPORT ADD REPORT_REQ_DT DATE DEFAULT SYSDATE;

INSERT INTO REPORT2 VALUES(1, 1, '악질 신고', 0, 3, 1, null);

ALTER TABLE REPORT2 ADD REPORT_REQ_DT DATE DEFAULT SYSDATE;

commit;

ALTER TABLE REPORT2 MODIFY REPORT_MEM_NO NOT NULL;

COMMENT ON COLUMN REPORT2.REPORT_NO IS '신고번호';
COMMENT ON COLUMN REPORT2.REPORT_DIV IS '구분';
COMMENT ON COLUMN REPORT2.REPORT_CONTENT IS '신고내용';
COMMENT ON COLUMN REPORT2.REPORT_ST IS '신고상태';
COMMENT ON COLUMN REPORT2.REPORT_MEM_NO IS '신고자회원번호';
COMMENT ON COLUMN REPORT2.TARGET_MEM_NO IS '신고대상회원번호';
COMMENT ON COLUMN REPORT2.TARGET_CLASS_NO IS '신고대상클래스번호';
COMMENT ON COLUMN REPORT.REPORT_REQ_DT IS '신고요청일자';


SELECT M1.MEMBER_NM "신고자", M2.MEMBER_NM "피신고자" FROM REPORT2 R
JOIN MEMBER M1 ON(R.REPORT_MEM_NO = M1.MEMBER_NO)
JOIN MEMBER M2 ON(R.TARGET_MEM_NO = M2.MEMBER_NO);


INSERT INTO REGISTER VALUES(SEQ_REG_NO.NEXTVAL, '유저이', '010-1111-2222', SYSDATE, 0, 0, 1, 10);

COMMIT;

INSERT INTO REPORT VALUES(SEQ_REPORT_NO.NEXTVAL, 0, '악질 클래스 신고2', 0, 2);


SELECT A.*, 

(SELECT COUNT(*) FROM REPORT R
JOIN REGISTER REG USING(REG_NO)
WHERE REG.MEMBER_NO = A.REPORT_TARGET_NO AND REPORT_ST = 2) "REPORT_COUNT"

FROM

(SELECT REG_NM "REPORT_TARGET", REPORT_CONTENT, MEMBER_NM "REPORT_NM", REG_NO, REPORT_REQ_DT, REPORT_NO, REGISTER.MEMBER_NO "REPORT_TARGET_NO"
FROM REPORT
JOIN REGISTER USING(REG_NO)
JOIN EPISODE USING(EP_NO)
JOIN CLASS C USING(CLASS_NO)
JOIN TEACHER T ON(T.MEMBER_NO = C.MEMBER_NO)
JOIN MEMBER M ON(M.MEMBER_NO = T.MEMBER_NO)
WHERE REPORT_DIV = 1 AND REPORT_ST = 0) A



SELECT REG_NM "신고자", REPORT_CONTENT, CLASS_NM,
(SELECT COUNT(*) FROM REPORT
JOIN REGISTER USING(REG_NO)
JOIN EPISODE E USING(EP_NO)
JOIN CLASS C ON(C.CLASS_NO = E.CLASS_NO)
WHERE REPORT_ST = 2 AND ) "신고당한 횟수"
FROM REPORT
JOIN REGISTER USING(REG_NO)
JOIN EPISODE USING(EP_NO)
JOIN CLASS C USING(CLASS_NO)
JOIN TEACHER T ON(T.MEMBER_NO = C.MEMBER_NO)
JOIN MEMBER M ON(M.MEMBER_NO = T.MEMBER_NO)
WHERE REPORT_ST  = 0 AND REPORT_ST = 0;



INSERT INTO CLASS VALUES(SEQ_CLASS_NO.NEXTVAL, '경기', 1, 10, 5, 15, '뜨또', '안녕하세요', '하', SYSDATE, 2, 2, 4);

COMMIT;

INSERT INTO TEACHER VALUES(4, '프로필', '안녕하세요', SYSDATE, 2);

INSERT INTO EPISODE VALUES(SEQ_EP_NO.NEXTVAL, 20000, 21, 2, 1);

UPDATE REPORT SET REPORT_ST = 0;
COMMIT;



UPDATE (
        SELECT T.TEACHER_ST AS TEACHER_ST, M.TEACHER_ENROLL AS TEACHER_ENROLL FROM MEMBER M, TEACHER T
        WHERE M.MEMBER_NO = T.MEMBER_NO AND M.MEMBER_NO = 1
        )
SET TEACHER_ST = 2, TEACHER_ENROLL = 'Y';

commit;

INSERT INTO NOTICE VALUES(SEQ_NOTICE_NO.NEXTVAL, '제목', '내용', SYSDATE);

COMMIT;


INSERT INTO CALCULATE VALUES(SEQ_CAL_NO.NEXTVAL, SYSDATE, SYSDATE, 0, 1);

COMMIT;


-- 정산하기
SELECT REG_NM "STUDENT_NM",
    CASE WHEN REFUND_MONEY IS NULL
        THEN EP_PRICE
        ELSE REFUND_MONEY
    END "CAL_PRICE", CAL_NO

FROM CALCULATE
JOIN EPISODE USING(EP_NO)
JOIN REGISTER USING(EP_NO)
LEFT JOIN REFUND USING(REG_NO)
WHERE PAY_ST = 0 AND (REFUND_DT IS NULL OR REFUND_DT = 1) AND CAL_NO = 1;


CREATE TABLE NOTICE_IMG(
    NOTICE_IMG_NO NUMBER PRIMARY KEY,
    IMG_PATH VARCHAR2(200) NOT NULL,
    IMG_NM VARCHAR2(50) NOT NULL,
    IMG_ORIGINAL VARCHAR2(200) NOT NULL,
    NOTICE_NO NUMBER REFERENCES NOTICE(NOTICE_NO) ON DELETE CASCADE
);


SELECT CAL_NO, CAL_REQ_NO, MEMBER_NM TEACHER_NM, CLASS_NM, EP_COUNT, STUDENT_NM FROM CALCULATE
		JOIN EPISODE USING(EP_NO)
		JOIN CLASS USING(CLASS_NO)
		JOIN TEACHER USING(MEMBER_NO)
		JOIN MEMBER USING(MEMBER_NO)
        LEFT JOIN RECEIPT USING(CAL_NO);

INSERT INTO REGISTER VALUES(SEQ_REG_NO.NEXTVAL, '최승엽', '010-8702-8193', SYSDATE, 0, 0, 1, 61);


SELECT  A.*,
(
SELECT CLASS_PROGRESS FROM REGISTER R
JOIN REFUND USING(REG_NO)
WHERE R.EP_NO = A.EP_NO
) "CLASS_PROGRESS"

FROM

(SELECT STUDENT_NM, CAL_PRICE, EP_NO FROM RECEIPT
JOIN CALCULATE USING(CAL_NO)
JOIN EPISODE USING(EP_NO)
WHERE CAL_NO = 1) A;


SELECT CAL_NO, CAL_REQ_NO, MEMBER_NM TEACHER_NM, CLASS_NM, EP_COUNT, CAL_ST
		FROM CALCULATE
		JOIN EPISODE USING(EP_NO)
		JOIN CLASS USING(CLASS_NO)
		JOIN TEACHER USING(MEMBER_NO)
		JOIN MEMBER USING(MEMBER_NO)
		WHERE CAL_ST != 1;
        
SELECT MEMBER_NO, MEMBER_NM TEACHER_NM, CLASS_NM, EP_COUNT
FROM CALCULATE
JOIN EPISODE USING(EP_NO)
JOIN CLASS USING(CLASS_NO)
JOIN TEACHER USING(MEMBER_NO)
JOIN MEMBER USING(MEMBER_NO)
WHERE CAL_NO = 1;



SELECT REFUND_NO, REFUND_REQ_DT, CLASS_PROGRESS, REFUND_MONEY, REG_NM "STUDENT_NM", CLASS_NM, EP_COUNT, REGISTER.MEMBER_NO
		FROM REFUND
		JOIN REGISTER USING(REG_NO)
		JOIN EPISODE USING(EP_NO)
		JOIN CLASS USING(CLASS_NO)
		WHERE REFUND_ST = 0;