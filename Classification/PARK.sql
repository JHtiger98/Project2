SELECT * FROM CHANNEL; --고객번호, 제휴사(MOBILE/APP, ONLINEMALL)
SELECT * FROM COMPETE; --고객번호, 제휴사
SELECT * FROM CUSTDEMO; --고객번호
SELECT * FROM MEMBER; --고객번호
SELECT * FROM PRODCL; --제휴사, (대,중,소)분류코드
SELECT * FROM PRODPUR; --고객번호, 제휴사, (대,중,소)분류코드

SELECT COUNT(*) FROM CHANNEL; --8824
SELECT COUNT(*) FROM COMPETE; --28159
SELECT COUNT(*) FROM CUSTDEMO; --19383
SELECT COUNT(*) FROM MEMBER; --7456
SELECT COUNT(*) FROM PRODCL; --4386
SELECT COUNT(*) FROM PRODPUR; --28593030

SELECT UNIQUE 제휴사 FROM CHANNEL
ORDER BY 제휴사;

SELECT UNIQUE 경쟁사 FROM COMPETE
ORDER BY 경쟁사;

SELECT UNIQUE 연령대 FROM CUSTDEMO
ORDER BY 연령대;

SELECT UNIQUE 멤버십명 FROM  MEMBER
ORDER BY 멤버십명;

SELECT UNIQUE 제휴사 FROM PRODCL
ORDER BY 제휴사;

SELECT UNIQUE 대분류코드 FROM PRODPUR
ORDER BY 대분류코드;

------------------------------------------------------------------------------
SELECT * FROM UPPERCLASS;

SELECT UPPERCLASS, SUM(구매금액) 총구매금액
FROM PRODPUR P JOIN UPPERCLASS U ON (P.제휴사 = U.제휴사 AND P.대분류코드 = U.대분류코드)
GROUP BY U.UPPERCLASS;


CREATE TABLE PRODCLASS
AS SELECT UPPERCLASS, EXTRACT(YEAR FROM TO_DATE(구매일자)) YEAR, SUM(구매금액) 월별구매금액
FROM PRODPUR P, UPPERCLASS U
WHERE P.소분류코드 = U.소분류코드
GROUP BY UPPERCLASS, EXTRACT(YEAR FROM TO_DATE(구매일자))
ORDER BY UPPERCLASS;

SELECT * FROM PRODCLASS;

SELECT A.UPPERCLASS, A.월별구매금액 - B.월별구매금액 AS 증감, ROUND((A.월별구매금액 - B.월별구매금액) / B.월별구매금액, 2) AS 증감율
FROM PRODCLASS A, (SELECT UPPERCLASS, YEAR, 월별구매금액 FROM PRODCLASS WHERE YEAR = 2014) B
WHERE A.YEAR = 2015 AND A.UPPERCLASS = B.UPPERCLASS
ORDER BY 증감율 DESC;

------------------------------------------------------------------------------
CREATE TABLE STORE_ELEC
AS SELECT P.제휴사, P.점포코드, C.중분류명, EXTRACT(YEAR FROM TO_DATE(P.구매일자)) YEAR, SUM(P.구매금액) 월별구매금액
FROM PRODPUR P, UPPERCLASS U, PRODCL C
WHERE P.소분류코드 = U.소분류코드 AND P.소분류코드 = C.소분류코드 AND U.UPPERCLASS = '가전'
GROUP BY P.제휴사, P.점포코드, C.중분류명, EXTRACT(YEAR FROM TO_DATE(구매일자))
ORDER BY P.제휴사, 점포코드, C.중분류명, YEAR;

SELECT * FROM STORE_ELEC;

SELECT A.점포코드, A.중분류명, A.월별구매금액 - B.월별구매금액 AS 증감, ROUND((A.월별구매금액 - B.월별구매금액) / B.월별구매금액, 2) AS 증감율
FROM STORE_ELEC A, (SELECT 제휴사, 점포코드, YEAR, 월별구매금액, 중분류명 FROM STORE_ELEC WHERE YEAR = 2014) B
WHERE A.YEAR = 2015 AND A.제휴사 = B.제휴사 AND A.점포코드 = B.점포코드 AND A.중분류명 = B.중분류명
ORDER BY 증감율 DESC;

CREATE TABLE STORE_ELEC2
AS SELECT 제휴사, 점포코드,  CONCAT(제휴사, 점포코드) AS 제휴사점포코드, YEAR, SUM(월별구매금액) 월별구매금액 FROM STORE_ELEC
GROUP BY 제휴사, 점포코드, YEAR;

SELECT * FROM STORE_ELEC2;

SELECT A.제휴사점포코드, A.월별구매금액 - B.월별구매금액 AS 증감, ROUND((A.월별구매금액 - B.월별구매금액) / B.월별구매금액, 2) AS 증감율
FROM STORE_ELEC2 A, (SELECT 제휴사점포코드, YEAR, 월별구매금액 FROM STORE_ELEC2 WHERE YEAR = 2014) B
WHERE A.YEAR = 2015 AND A.제휴사점포코드 = B.제휴사점포코드
ORDER BY 증감율 DESC;

SELECT A.제휴사점포코드, A.월별구매금액 - B.월별구매금액 AS 증감, ROUND((A.월별구매금액 - B.월별구매금액) / B.월별구매금액, 2) AS 증감율, ROUND((A.월별구매금액*A.월별구매금액 - 2*A.월별구매금액*B.월별구매금액 + B.월별구매금액*B.월별구매금액)/B.월별구매금액,2) AS 증감정도
FROM STORE_ELEC2 A, (SELECT 제휴사점포코드, YEAR, 월별구매금액 FROM STORE_ELEC2 WHERE YEAR = 2014) B
WHERE A.YEAR = 2015 AND A.제휴사점포코드 = B.제휴사점포코드
ORDER BY 증감정도 DESC;

CREATE TABLE STORE_ELEC3
AS SELECT P.제휴사, P.점포코드, CONCAT(P.제휴사, P.점포코드) AS 제휴사점포코드, EXTRACT(YEAR FROM TO_DATE(P.구매일자)) YEAR, P.고객번호, SUM(P.구매금액) 월별구매금액
FROM PRODPUR P, UPPERCLASS U, CUSTDEMO C
WHERE P.소분류코드 = U.소분류코드 AND P.고객번호 = C.고객번호 AND U.UPPERCLASS = '가전' AND CONCAT(P.제휴사, P.점포코드) IN ('B108', 'A032', 'B055', 'B050', 'A044')
GROUP BY P.제휴사, P.점포코드, EXTRACT(YEAR FROM TO_DATE(구매일자)), P.고객번호
ORDER BY P.제휴사, 점포코드, YEAR;

SELECT * FROM STORE_ELEC3;

CREATE TABLE STORE_ELEC_GENDER
AS SELECT S.제휴사, S.점포코드, S.제휴사점포코드, S.YEAR, C.성별, SUM(S.월별구매금액) AS 월별구매금액
FROM STORE_ELEC3 S, CUSTDEMO C
GROUP BY 제휴사, 점포코드, 제휴사점포코드, YEAR, 성별
ORDER BY 제휴사, 점포코드, 제휴사점포코드, YEAR, 성별;

SELECT * FROM STORE_ELEC_GENDER;

CREATE TABLE STORE_ELEC_AGE
AS SELECT S.제휴사, S.점포코드,  S.제휴사점포코드, S.YEAR, C.연령대, SUM(S.월별구매금액) AS 월별구매금액
FROM STORE_ELEC3 S, CUSTDEMO C
GROUP BY 제휴사, 점포코드, 제휴사점포코드, YEAR, 연령대
ORDER BY 제휴사, 점포코드, 제휴사점포코드, YEAR, 연령대;

SELECT * FROM STORE_ELEC_AGE;

CREATE TABLE STORE_ELEC_LOC
AS SELECT S.제휴사, S.점포코드, S.제휴사점포코드, S.YEAR, C.거주지역, SUM(S.월별구매금액) AS 월별구매금액
FROM STORE_ELEC3 S, CUSTDEMO C
GROUP BY 제휴사, 점포코드, 제휴사점포코드, YEAR, 거주지역
ORDER BY 제휴사, 점포코드, 제휴사점포코드, YEAR, 거주지역;

SELECT * FROM STORE_ELEC_LOC;

SELECT * FROM POST;
SELECT * FROM PRODPUR;
SELECT * FROM CUSTDEMO;

CREATE TABLE COUNT_ONE
AS SELECT COUNT(*) AS COUNT, P.제휴사, P.점포코드, L.시군구
FROM PRODPUR P, POST L, CUSTDEMO C, UPPERCLASS U
WHERE L.거주지역 = C.거주지역 AND P.고객번호 = C.고객번호 AND
P.소분류코드 = U.소분류코드 AND U.UPPERCLASS = '가전'
GROUP BY P.제휴사, P.점포코드, L.시군구
ORDER BY COUNT(*) DESC;

SELECT * FROM COUNT_ONE;

CREATE TABLE COUNT_ONE_MAX
AS SELECT MAX(COUNT) AS COUNT2, 제휴사, 점포코드 FROM COUNT_ONE
GROUP BY 제휴사, 점포코드
ORDER BY MAX(COUNT) DESC;

SELECT * FROM COUNT_ONE_MAX;

CREATE TABLE MAX_LOC 
AS SELECT O.COUNT, M.제휴사, M.점포코드, O.시군구
FROM COUNT_ONE O, COUNT_ONE_MAX M
WHERE O.COUNT = M.COUNT2 AND O.제휴사 = M.제휴사 AND O.점포코드 = M.점포코드;

SELECT * FROM MAX_LOC;

SELECT * FROM STORE_LIST;
-------------------------------------------------------
CREATE TABLE PROD_PUR_Q_SUM
AS SELECT 점포코드, 분기, ROUND(SUM(구매금액)) AS 구매금액 FROM PROD_PUR_Q
GROUP BY 점포코드, 분기
ORDER BY 점포코드, 분기;

SELECT * FROM PROD_PUR_Q_SUM;

CREATE TABLE LABEL
AS SELECT A.점포코드, (C.구매금액 - A.구매금액) AS Y_TRAIN, (D.구매금액 - B.구매금액) AS Y_VAL_TEST
FROM PROD_PUR_Q_SUM A, (SELECT * FROM PROD_PUR_Q_SUM WHERE 분기 = '2nd') B, (SELECT * FROM PROD_PUR_Q_SUM WHERE 분기 = '7th') C, (SELECT * FROM PROD_PUR_Q_SUM WHERE 분기 = '8th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드;

SELECT * FROM LABEL;
-------------------------------------------------------
CREATE TABLE AVG_PUR
AS SELECT 점포코드, 분기, ROUND(SUM(구매금액)/COUNT(구매금액)) AS 평균구매액 FROM PROD_PUR_Q
GROUP BY 점포코드, 분기
ORDER BY 점포코드, 분기;

SELECT * FROM AVG_PUR;

SELECT * FROM AVG_PUR_RANK;

CREATE TABLE AVG_PUR_CUST
AS SELECT A.점포코드, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM AVG_PUR_RANK A, (SELECT * FROM AVG_PUR_RANK WHERE 분기 = '2nd') B, (SELECT * FROM AVG_PUR_RANK WHERE 분기 = '6th') C, (SELECT * FROM AVG_PUR_RANK WHERE 분기 = '7th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드
ORDER BY A.점포코드;

SELECT * FROM AVG_PUR_CUST;
-------------------------------------------------------
CREATE TABLE STORE_CNT
AS SELECT 점포코드, 분기, COUNT(*) AS 점포이용횟수 FROM PROD_PUR_Q
GROUP BY 점포코드, 분기
ORDER BY 점포코드, 분기;

SELECT * FROM STORE_CNT;

SELECT * FROM STORE_CNT_RANK;

CREATE TABLE STORE_CNT_CUST
AS SELECT A.점포코드, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM STORE_CNT_RANK A, (SELECT * FROM STORE_CNT_RANK WHERE 분기 = '2nd') B, (SELECT * FROM STORE_CNT_RANK WHERE 분기 = '6th') C, (SELECT * FROM STORE_CNT_RANK WHERE 분기 = '7th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드
ORDER BY A.점포코드;

SELECT * FROM STORE_CNT_CUST;
-------------------------------------------------------
CREATE TABLE COMPETE_Q
AS SELECT 고객번호, 제휴사, 경쟁사, TO_NUMBER(SUBSTR(이용년월,1,4)) AS 년도, TO_NUMBER(SUBSTR(이용년월,5,7)) AS 월 FROM COMPETE;

SELECT * FROM COMPETE_Q;

CREATE TABLE QUARTER
AS SELECT 년도, 월, 분기 FROM PROD_PUR_Q
GROUP BY 년도, 월, 분기
ORDER BY 년도, 월, 분기;

SELECT * FROM QUARTER;

CREATE TABLE COMPETE_Q_2
AS SELECT C.고객번호, Q.분기, COUNT(*) AS COUNT
FROM COMPETE_Q C, QUARTER Q
WHERE C.년도 = Q.년도 AND C.월 = Q.월
GROUP BY C.고객번호, Q.분기
ORDER BY C.고객번호, Q.분기;

CREATE TABLE COMPETE_CNT
AS SELECT P.점포코드, P.분기, SUM(C.COUNT) AS COUNT
FROM PROD_PUR_Q P, COMPETE_Q_2 C
WHERE P.고객번호 = C.고객번호 AND P.분기 = C.분기
GROUP BY P.점포코드, P.분기
ORDER BY P.점포코드, P.분기;

SELECT * FROM COMPETE_CNT;

SELECT * FROM COMPETE_CNT_RANK;

CREATE TABLE COMPETE_CNT_CUST
AS SELECT A.점포코드, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM COMPETE_CNT_RANK A, (SELECT * FROM COMPETE_CNT_RANK WHERE 분기 = '6th') B, (SELECT * FROM COMPETE_CNT_RANK WHERE 분기 = '7th') C, (SELECT * FROM COMPETE_CNT_RANK WHERE 분기 = '8th') D
WHERE A.분기 = '5th' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드
ORDER BY A.점포코드;

SELECT * FROM COMPETE_CNT_CUST;
-------------------------------------------------------
CREATE TABLE MEMBER_Q
AS SELECT 고객번호, TO_NUMBER(SUBSTR(가입년월,1,4)) AS 년도, TO_NUMBER(SUBSTR(가입년월,5,7)) AS 월 FROM MEMBER;

SELECT * FROM MEMBER_Q;

SELECT * FROM QUARTER;

CREATE TABLE MEMBER_Q_2
AS SELECT C.고객번호, Q.분기, COUNT(*) AS COUNT
FROM MEMBER_Q C, QUARTER Q
WHERE C.년도 = Q.년도 AND C.월 = Q.월
GROUP BY C.고객번호, Q.분기
ORDER BY C.고객번호, Q.분기;

SELECT * FROM MEMBER_Q_2;

CREATE TABLE MEMBER_CNT
AS SELECT P.점포코드, P.분기, SUM(C.COUNT) AS COUNT
FROM PROD_PUR_Q P, MEMBER_Q_2 C
WHERE P.고객번호 = C.고객번호 AND P.분기 = C.분기
GROUP BY P.점포코드, P.분기
ORDER BY P.점포코드, P.분기;

SELECT * FROM MEMBER_CNT WHERE 분기 = '1st';

SELECT * FROM PROD_PUR_Q;

CREATE TABLE MEMBER_SUM
AS SELECT P.점포코드, P.분기, SUM(P.구매금액) AS SUM
FROM PROD_PUR_Q P, MEMBER_Q_2 C
WHERE P.고객번호 = C.고객번호 AND P.분기 = C.분기
GROUP BY P.점포코드, P.분기
ORDER BY P.점포코드, P.분기;

SELECT * FROM MEMBER_CNT_RANK;

CREATE TABLE MEMBER_CNT_CUST
AS SELECT A.점포코드, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM MEMBER_CNT_RANK A, (SELECT * FROM MEMBER_CNT_RANK WHERE 분기 = '2nd') B, (SELECT * FROM MEMBER_CNT_RANK WHERE 분기 = '6th') C, (SELECT * FROM MEMBER_CNT_RANK WHERE 분기 = '7th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드
ORDER BY A.점포코드;

SELECT * FROM MEMBER_CNT_CUST;

SELECT * FROM MEMBER_SUM_RANK;

CREATE TABLE MEMBER_SUM_CUST
AS SELECT A.점포코드, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM MEMBER_SUM_RANK A, (SELECT * FROM MEMBER_SUM_RANK WHERE 분기 = '2nd') B, (SELECT * FROM MEMBER_SUM_RANK WHERE 분기 = '6th') C, (SELECT * FROM MEMBER_SUM_RANK WHERE 분기 = '7th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드
ORDER BY A.점포코드;

SELECT * FROM MEMBER_SUM_CUST;

-------------------------------------------------------
CREATE TABLE PUR_SUM
AS SELECT 점포코드, 분기, SUM(구매금액) AS 구매금액 FROM PROD_PUR_Q
GROUP BY 점포코드, 분기
ORDER BY 점포코드, 분기;

SELECT * FROM PUR_SUM;

SELECT * FROM SUM_RANK;

CREATE TABLE SUM_CUST
AS SELECT A.점포코드, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM SUM_RANK A, (SELECT * FROM SUM_RANK WHERE 분기 = '2nd') B, (SELECT * FROM SUM_RANK WHERE 분기 = '6th') C, (SELECT * FROM SUM_RANK WHERE 분기 = '7th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드
ORDER BY A.점포코드;

SELECT * FROM SUM_CUST;

CREATE TABLE PUR_RATE
AS SELECT A.점포코드, ROUND((C.구매금액 - A.구매금액) / A.구매금액, 2) AS X_TRAIN, ROUND((D.구매금액 - B.구매금액) / B.구매금액, 2) AS X_VAL_TEST
FROM PUR_SUM A, (SELECT 점포코드, 분기, 구매금액 FROM PUR_SUM WHERE 분기 = '2nd') B, (SELECT * FROM PUR_SUM WHERE 분기 = '6th') C, (SELECT * FROM PUR_SUM WHERE 분기 = '7th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드
ORDER BY A.점포코드;

SELECT * FROM PUR_RATE;
-------------------------------------------------------
CREATE TABLE UPPERCLASS_Q
AS SELECT A.점포코드, A.분기, B.UPPERCLASS, SUM(A.구매금액) AS SUM
FROM PROD_PUR_Q A, UPPERCLASS B
WHERE A.소분류코드 = B.소분류코드
GROUP BY A.점포코드, A.분기, B.UPPERCLASS
ORDER BY A.점포코드, A.분기, B.UPPERCLASS;

SELECT * FROM UPPERCLASS_Q;

SELECT A.점포코드, (C.SUM - A.SUM) AS X_TRAIN, (D.SUM - B.SUM) AS X_VAL_TEST
FROM UPPERCLASS_Q A, (SELECT * FROM UPPERCLASS_Q WHERE 분기 = '2nd') B, (SELECT * FROM UPPERCLASS_Q WHERE 분기 = '6th') C, (SELECT * FROM UPPERCLASS_Q WHERE 분기 = '7th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드 AND A.UPPERCLASS = '식품' AND B.UPPERCLASS = '식품' AND C.UPPERCLASS = '식품' AND D.UPPERCLASS = '식품';

SELECT A.점포코드, (C.SUM - A.SUM) AS X_TRAIN, (D.SUM - B.SUM) AS X_VAL_TEST
FROM UPPERCLASS_Q A, (SELECT * FROM UPPERCLASS_Q WHERE 분기 = '2nd') B, (SELECT * FROM UPPERCLASS_Q WHERE 분기 = '6th') C, (SELECT * FROM UPPERCLASS_Q WHERE 분기 = '7th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드 AND A.UPPERCLASS = '가전' AND B.UPPERCLASS = '가전' AND C.UPPERCLASS = '가전' AND D.UPPERCLASS = '가전';

SELECT A.점포코드, (C.SUM - A.SUM) AS X_TRAIN, (D.SUM - B.SUM) AS X_VAL_TEST
FROM UPPERCLASS_Q A, (SELECT * FROM UPPERCLASS_Q WHERE 분기 = '2nd') B, (SELECT * FROM UPPERCLASS_Q WHERE 분기 = '6th') C, (SELECT * FROM UPPERCLASS_Q WHERE 분기 = '7th') D
WHERE A.분기 = '1st' AND A.점포코드 = B.점포코드 AND B.점포코드 = C.점포코드 AND C.점포코드 = D.점포코드 AND A.UPPERCLASS = '의류' AND B.UPPERCLASS = '의류' AND C.UPPERCLASS = '의류' AND D.UPPERCLASS = '의류';
-------------------------------------------------------
SELECT * FROM CHANNEL; --고객번호, 제휴사(MOBILE/APP, ONLINEMALL)
SELECT * FROM COMPETE; --고객번호, 제휴사
SELECT * FROM CUSTDEMO; --고객번호
SELECT * FROM MEMBER; --고객번호
SELECT * FROM PRODCL; --제휴사, (대,중,소)분류코드
SELECT * FROM PRODPUR; --고객번호, 제휴사, (대,중,소)분류코드
SELECT * FROM PROD_PUR_Q;

SELECT * FROM INCREASE;
SELECT * FROM DECREASE;


-------------------------------------------------------
--LMEMBERS 데이터에서 고객별 구매금액의 합계를 구한 CUSPUR 테이블을 생성한 후 CUST 테이블과 
--고객번호를 기준으로 결합하여 출력하세요.
CREATE TABLE CUSPUR
AS SELECT 고객번호, SUM(구매금액) AS 구매금액 FROM PRODPUR
GROUP BY 고객번호
ORDER BY 고객번호;

--purprd 테이블의 2년간 구매금액을 연간 단위로 분리하여 구매14, 구매15 컬럼을 포함하는 AMT_YEAR 테이블을 
--생성한 후 14년과 15년의 구매금액 차이를 표시하는 증감 컬럼을 추가하여 출력하세요.
--단, 고객번호, 제휴사별로 구매금액 및 증감이 구분되어야 함.
CREATE TABLE AMT14
AS SELECT 고객번호, 제휴사, SUM(구매금액) AS 구매금액 FROM PRODPUR
WHERE 구매일자 < '20150101'
GROUP BY 고객번호, 제휴사
ORDER BY 고객번호, 제휴사;

CREATE TABLE AMT15
AS SELECT 고객번호, 제휴사, SUM(구매금액) AS 구매금액 FROM PRODPUR
WHERE 구매일자 > '20141231'
GROUP BY 고객번호, 제휴사
ORDER BY 고객번호, 제휴사;

SELECT * FROM AMT15;

CREATE TABLE AMT_YEAR
AS SELECT A4.고객번호, A4.제휴사, A4.구매금액 구매14, A5.구매금액 구매15
FROM AMT14 A4 FULL OUTER JOIN AMT15 A5
ON (A4.고객번호 = A5.고객번호 AND A4.제휴사 = A5.제휴사);

SELECT * FROM AMT_YEAR;

SELECT 고객번호, 제휴사, NVL(구매14, 0) AS 구매14, NVL(구매15, 0) AS 구매15,
(NVL(구매15,0) - NVL(구매14,0)) AS 증감
FROM AMT_YEAR;







