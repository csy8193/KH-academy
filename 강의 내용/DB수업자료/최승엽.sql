-- 계정 만들기(sys 관리자 계정)
create user java3 identified by java1234; -- 아이디 : java3 비밀번호 java1234
grant connect, resource to java3; -- java3 권한 부여


-- 회원 테이블 만들기 (java3 계정)
CREATE TABLE TB_USER(                           -- 회원 테이블
    USER_NO NUMBER PRIMARY KEY,                 -- 회원 고유 번호
    USER_ID VARCHAR2(30) NOT NULL,              -- 회원 아이디
    USER_PW VARCHAR2(30) NOT NULL,              -- 회원 비밀번호
    USER_NAME VARCHAR2(30) NOT NULL             -- 회원 닉네임
);

-- 게임 테이블 만들기
CREATE TABLE TB_GAME(                   -- 게임 테이블
    GAME_NO NUMBER PRIMARY KEY,         -- 게임 고유 번호
    RPS_SCORE NUMBER,                   -- 가위바위보 게임 점수
    USER_NO NUMBER REFERENCES TB_USER ON DELETE CASCADE, -- TB_USER(부모)랑 TB_GAME(자식) 연결
    UPDOWN_SCORE NUMBER,                -- 업다운게임 점수
    RPS_YN NUMBER DEFAULT 0,            -- 가위바위보 실행 여부 (0 OR 1)
    UPDOWN_YN NUMBER DEFAULT 0          -- 업다운게임 실행 여부 (0 OR 1)
);

-- 시퀀스 부여하기
CREATE SEQUENCE SEQ_USER_NO; -- USER_NO 시퀀스 생성
CREATE SEQUENCE SEQ_GAME_NO; -- GAME_NO 시퀀스 생성


--설명 설정하기
--회원 테이블
COMMENT ON COLUMN TB_USER.USER_NO IS '회원 고유 번호';
COMMENT ON COLUMN TB_USER.USER_ID IS '회원 아이디';
COMMENT ON COLUMN TB_USER.USER_PW IS '회원 비밀번호';
COMMENT ON COLUMN TB_USER.USER_NAME IS '회원 닉네임';

-- 게임 테이블
COMMENT ON COLUMN TB_GAME.GAME_NO IS '게임 고유 번호';
COMMENT ON COLUMN TB_GAME.RPS_SCORE IS '가위바위보 게임 점수';
COMMENT ON COLUMN TB_GAME.USER_NO IS '회원 고유 번호';
COMMENT ON COLUMN TB_GAME.UPDOWN_SCORE IS '업다운 게임 점수';
COMMENT ON COLUMN TB_GAME.RPS_YN IS '가위바위보 실행 여부';
COMMENT ON COLUMN TB_GAME.UPDOWN_YN IS '업다운 실행 여부';