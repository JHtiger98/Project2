SELECT * FROM CHANNEL; --����ȣ, ���޻�(MOBILE/APP, ONLINEMALL)
SELECT * FROM COMPETE; --����ȣ, ���޻�
SELECT * FROM CUSTDEMO; --����ȣ
SELECT * FROM MEMBER; --����ȣ
SELECT * FROM PRODCL; --���޻�, (��,��,��)�з��ڵ�
SELECT * FROM PRODPUR; --����ȣ, ���޻�, (��,��,��)�з��ڵ�

SELECT COUNT(*) FROM CHANNEL; --8824
SELECT COUNT(*) FROM COMPETE; --28159
SELECT COUNT(*) FROM CUSTDEMO; --19383
SELECT COUNT(*) FROM MEMBER; --7456
SELECT COUNT(*) FROM PRODCL; --4386
SELECT COUNT(*) FROM PRODPUR; --28593030

SELECT UNIQUE ���޻� FROM CHANNEL
ORDER BY ���޻�;

SELECT UNIQUE ����� FROM COMPETE
ORDER BY �����;

SELECT UNIQUE ���ɴ� FROM CUSTDEMO
ORDER BY ���ɴ�;

SELECT UNIQUE ����ʸ� FROM  MEMBER
ORDER BY ����ʸ�;

SELECT UNIQUE ���޻� FROM PRODCL
ORDER BY ���޻�;

SELECT UNIQUE ��з��ڵ� FROM PRODPUR
ORDER BY ��з��ڵ�;

------------------------------------------------------------------------------
SELECT * FROM UPPERCLASS;

SELECT UPPERCLASS, SUM(���űݾ�) �ѱ��űݾ�
FROM PRODPUR P JOIN UPPERCLASS U ON (P.���޻� = U.���޻� AND P.��з��ڵ� = U.��з��ڵ�)
GROUP BY U.UPPERCLASS;


CREATE TABLE PRODCLASS
AS SELECT UPPERCLASS, EXTRACT(YEAR FROM TO_DATE(��������)) YEAR, SUM(���űݾ�) �������űݾ�
FROM PRODPUR P, UPPERCLASS U
WHERE P.�Һз��ڵ� = U.�Һз��ڵ�
GROUP BY UPPERCLASS, EXTRACT(YEAR FROM TO_DATE(��������))
ORDER BY UPPERCLASS;

SELECT * FROM PRODCLASS;

SELECT A.UPPERCLASS, A.�������űݾ� - B.�������űݾ� AS ����, ROUND((A.�������űݾ� - B.�������űݾ�) / B.�������űݾ�, 2) AS ������
FROM PRODCLASS A, (SELECT UPPERCLASS, YEAR, �������űݾ� FROM PRODCLASS WHERE YEAR = 2014) B
WHERE A.YEAR = 2015 AND A.UPPERCLASS = B.UPPERCLASS
ORDER BY ������ DESC;

------------------------------------------------------------------------------
CREATE TABLE STORE_ELEC
AS SELECT P.���޻�, P.�����ڵ�, C.�ߺз���, EXTRACT(YEAR FROM TO_DATE(P.��������)) YEAR, SUM(P.���űݾ�) �������űݾ�
FROM PRODPUR P, UPPERCLASS U, PRODCL C
WHERE P.�Һз��ڵ� = U.�Һз��ڵ� AND P.�Һз��ڵ� = C.�Һз��ڵ� AND U.UPPERCLASS = '����'
GROUP BY P.���޻�, P.�����ڵ�, C.�ߺз���, EXTRACT(YEAR FROM TO_DATE(��������))
ORDER BY P.���޻�, �����ڵ�, C.�ߺз���, YEAR;

SELECT * FROM STORE_ELEC;

SELECT A.�����ڵ�, A.�ߺз���, A.�������űݾ� - B.�������űݾ� AS ����, ROUND((A.�������űݾ� - B.�������űݾ�) / B.�������űݾ�, 2) AS ������
FROM STORE_ELEC A, (SELECT ���޻�, �����ڵ�, YEAR, �������űݾ�, �ߺз��� FROM STORE_ELEC WHERE YEAR = 2014) B
WHERE A.YEAR = 2015 AND A.���޻� = B.���޻� AND A.�����ڵ� = B.�����ڵ� AND A.�ߺз��� = B.�ߺз���
ORDER BY ������ DESC;

CREATE TABLE STORE_ELEC2
AS SELECT ���޻�, �����ڵ�,  CONCAT(���޻�, �����ڵ�) AS ���޻������ڵ�, YEAR, SUM(�������űݾ�) �������űݾ� FROM STORE_ELEC
GROUP BY ���޻�, �����ڵ�, YEAR;

SELECT * FROM STORE_ELEC2;

SELECT A.���޻������ڵ�, A.�������űݾ� - B.�������űݾ� AS ����, ROUND((A.�������űݾ� - B.�������űݾ�) / B.�������űݾ�, 2) AS ������
FROM STORE_ELEC2 A, (SELECT ���޻������ڵ�, YEAR, �������űݾ� FROM STORE_ELEC2 WHERE YEAR = 2014) B
WHERE A.YEAR = 2015 AND A.���޻������ڵ� = B.���޻������ڵ�
ORDER BY ������ DESC;

SELECT A.���޻������ڵ�, A.�������űݾ� - B.�������űݾ� AS ����, ROUND((A.�������űݾ� - B.�������űݾ�) / B.�������űݾ�, 2) AS ������, ROUND((A.�������űݾ�*A.�������űݾ� - 2*A.�������űݾ�*B.�������űݾ� + B.�������űݾ�*B.�������űݾ�)/B.�������űݾ�,2) AS ��������
FROM STORE_ELEC2 A, (SELECT ���޻������ڵ�, YEAR, �������űݾ� FROM STORE_ELEC2 WHERE YEAR = 2014) B
WHERE A.YEAR = 2015 AND A.���޻������ڵ� = B.���޻������ڵ�
ORDER BY �������� DESC;

CREATE TABLE STORE_ELEC3
AS SELECT P.���޻�, P.�����ڵ�, CONCAT(P.���޻�, P.�����ڵ�) AS ���޻������ڵ�, EXTRACT(YEAR FROM TO_DATE(P.��������)) YEAR, P.����ȣ, SUM(P.���űݾ�) �������űݾ�
FROM PRODPUR P, UPPERCLASS U, CUSTDEMO C
WHERE P.�Һз��ڵ� = U.�Һз��ڵ� AND P.����ȣ = C.����ȣ AND U.UPPERCLASS = '����' AND CONCAT(P.���޻�, P.�����ڵ�) IN ('B108', 'A032', 'B055', 'B050', 'A044')
GROUP BY P.���޻�, P.�����ڵ�, EXTRACT(YEAR FROM TO_DATE(��������)), P.����ȣ
ORDER BY P.���޻�, �����ڵ�, YEAR;

SELECT * FROM STORE_ELEC3;

CREATE TABLE STORE_ELEC_GENDER
AS SELECT S.���޻�, S.�����ڵ�, S.���޻������ڵ�, S.YEAR, C.����, SUM(S.�������űݾ�) AS �������űݾ�
FROM STORE_ELEC3 S, CUSTDEMO C
GROUP BY ���޻�, �����ڵ�, ���޻������ڵ�, YEAR, ����
ORDER BY ���޻�, �����ڵ�, ���޻������ڵ�, YEAR, ����;

SELECT * FROM STORE_ELEC_GENDER;

CREATE TABLE STORE_ELEC_AGE
AS SELECT S.���޻�, S.�����ڵ�,  S.���޻������ڵ�, S.YEAR, C.���ɴ�, SUM(S.�������űݾ�) AS �������űݾ�
FROM STORE_ELEC3 S, CUSTDEMO C
GROUP BY ���޻�, �����ڵ�, ���޻������ڵ�, YEAR, ���ɴ�
ORDER BY ���޻�, �����ڵ�, ���޻������ڵ�, YEAR, ���ɴ�;

SELECT * FROM STORE_ELEC_AGE;

CREATE TABLE STORE_ELEC_LOC
AS SELECT S.���޻�, S.�����ڵ�, S.���޻������ڵ�, S.YEAR, C.��������, SUM(S.�������űݾ�) AS �������űݾ�
FROM STORE_ELEC3 S, CUSTDEMO C
GROUP BY ���޻�, �����ڵ�, ���޻������ڵ�, YEAR, ��������
ORDER BY ���޻�, �����ڵ�, ���޻������ڵ�, YEAR, ��������;

SELECT * FROM STORE_ELEC_LOC;

SELECT * FROM POST;
SELECT * FROM PRODPUR;
SELECT * FROM CUSTDEMO;

CREATE TABLE COUNT_ONE
AS SELECT COUNT(*) AS COUNT, P.���޻�, P.�����ڵ�, L.�ñ���
FROM PRODPUR P, POST L, CUSTDEMO C, UPPERCLASS U
WHERE L.�������� = C.�������� AND P.����ȣ = C.����ȣ AND
P.�Һз��ڵ� = U.�Һз��ڵ� AND U.UPPERCLASS = '����'
GROUP BY P.���޻�, P.�����ڵ�, L.�ñ���
ORDER BY COUNT(*) DESC;

SELECT * FROM COUNT_ONE;

CREATE TABLE COUNT_ONE_MAX
AS SELECT MAX(COUNT) AS COUNT2, ���޻�, �����ڵ� FROM COUNT_ONE
GROUP BY ���޻�, �����ڵ�
ORDER BY MAX(COUNT) DESC;

SELECT * FROM COUNT_ONE_MAX;

CREATE TABLE MAX_LOC 
AS SELECT O.COUNT, M.���޻�, M.�����ڵ�, O.�ñ���
FROM COUNT_ONE O, COUNT_ONE_MAX M
WHERE O.COUNT = M.COUNT2 AND O.���޻� = M.���޻� AND O.�����ڵ� = M.�����ڵ�;

SELECT * FROM MAX_LOC;

SELECT * FROM STORE_LIST;
-------------------------------------------------------
CREATE TABLE PROD_PUR_Q_SUM
AS SELECT �����ڵ�, �б�, ROUND(SUM(���űݾ�)) AS ���űݾ� FROM PROD_PUR_Q
GROUP BY �����ڵ�, �б�
ORDER BY �����ڵ�, �б�;

SELECT * FROM PROD_PUR_Q_SUM;

CREATE TABLE LABEL
AS SELECT A.�����ڵ�, (C.���űݾ� - A.���űݾ�) AS Y_TRAIN, (D.���űݾ� - B.���űݾ�) AS Y_VAL_TEST
FROM PROD_PUR_Q_SUM A, (SELECT * FROM PROD_PUR_Q_SUM WHERE �б� = '2nd') B, (SELECT * FROM PROD_PUR_Q_SUM WHERE �б� = '7th') C, (SELECT * FROM PROD_PUR_Q_SUM WHERE �б� = '8th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ�;

SELECT * FROM LABEL;
-------------------------------------------------------
CREATE TABLE AVG_PUR
AS SELECT �����ڵ�, �б�, ROUND(SUM(���űݾ�)/COUNT(���űݾ�)) AS ��ձ��ž� FROM PROD_PUR_Q
GROUP BY �����ڵ�, �б�
ORDER BY �����ڵ�, �б�;

SELECT * FROM AVG_PUR;

SELECT * FROM AVG_PUR_RANK;

CREATE TABLE AVG_PUR_CUST
AS SELECT A.�����ڵ�, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM AVG_PUR_RANK A, (SELECT * FROM AVG_PUR_RANK WHERE �б� = '2nd') B, (SELECT * FROM AVG_PUR_RANK WHERE �б� = '6th') C, (SELECT * FROM AVG_PUR_RANK WHERE �б� = '7th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ�
ORDER BY A.�����ڵ�;

SELECT * FROM AVG_PUR_CUST;
-------------------------------------------------------
CREATE TABLE STORE_CNT
AS SELECT �����ڵ�, �б�, COUNT(*) AS �����̿�Ƚ�� FROM PROD_PUR_Q
GROUP BY �����ڵ�, �б�
ORDER BY �����ڵ�, �б�;

SELECT * FROM STORE_CNT;

SELECT * FROM STORE_CNT_RANK;

CREATE TABLE STORE_CNT_CUST
AS SELECT A.�����ڵ�, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM STORE_CNT_RANK A, (SELECT * FROM STORE_CNT_RANK WHERE �б� = '2nd') B, (SELECT * FROM STORE_CNT_RANK WHERE �б� = '6th') C, (SELECT * FROM STORE_CNT_RANK WHERE �б� = '7th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ�
ORDER BY A.�����ڵ�;

SELECT * FROM STORE_CNT_CUST;
-------------------------------------------------------
CREATE TABLE COMPETE_Q
AS SELECT ����ȣ, ���޻�, �����, TO_NUMBER(SUBSTR(�̿���,1,4)) AS �⵵, TO_NUMBER(SUBSTR(�̿���,5,7)) AS �� FROM COMPETE;

SELECT * FROM COMPETE_Q;

CREATE TABLE QUARTER
AS SELECT �⵵, ��, �б� FROM PROD_PUR_Q
GROUP BY �⵵, ��, �б�
ORDER BY �⵵, ��, �б�;

SELECT * FROM QUARTER;

CREATE TABLE COMPETE_Q_2
AS SELECT C.����ȣ, Q.�б�, COUNT(*) AS COUNT
FROM COMPETE_Q C, QUARTER Q
WHERE C.�⵵ = Q.�⵵ AND C.�� = Q.��
GROUP BY C.����ȣ, Q.�б�
ORDER BY C.����ȣ, Q.�б�;

CREATE TABLE COMPETE_CNT
AS SELECT P.�����ڵ�, P.�б�, SUM(C.COUNT) AS COUNT
FROM PROD_PUR_Q P, COMPETE_Q_2 C
WHERE P.����ȣ = C.����ȣ AND P.�б� = C.�б�
GROUP BY P.�����ڵ�, P.�б�
ORDER BY P.�����ڵ�, P.�б�;

SELECT * FROM COMPETE_CNT;

SELECT * FROM COMPETE_CNT_RANK;

CREATE TABLE COMPETE_CNT_CUST
AS SELECT A.�����ڵ�, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM COMPETE_CNT_RANK A, (SELECT * FROM COMPETE_CNT_RANK WHERE �б� = '6th') B, (SELECT * FROM COMPETE_CNT_RANK WHERE �б� = '7th') C, (SELECT * FROM COMPETE_CNT_RANK WHERE �б� = '8th') D
WHERE A.�б� = '5th' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ�
ORDER BY A.�����ڵ�;

SELECT * FROM COMPETE_CNT_CUST;
-------------------------------------------------------
CREATE TABLE MEMBER_Q
AS SELECT ����ȣ, TO_NUMBER(SUBSTR(���Գ��,1,4)) AS �⵵, TO_NUMBER(SUBSTR(���Գ��,5,7)) AS �� FROM MEMBER;

SELECT * FROM MEMBER_Q;

SELECT * FROM QUARTER;

CREATE TABLE MEMBER_Q_2
AS SELECT C.����ȣ, Q.�б�, COUNT(*) AS COUNT
FROM MEMBER_Q C, QUARTER Q
WHERE C.�⵵ = Q.�⵵ AND C.�� = Q.��
GROUP BY C.����ȣ, Q.�б�
ORDER BY C.����ȣ, Q.�б�;

SELECT * FROM MEMBER_Q_2;

CREATE TABLE MEMBER_CNT
AS SELECT P.�����ڵ�, P.�б�, SUM(C.COUNT) AS COUNT
FROM PROD_PUR_Q P, MEMBER_Q_2 C
WHERE P.����ȣ = C.����ȣ AND P.�б� = C.�б�
GROUP BY P.�����ڵ�, P.�б�
ORDER BY P.�����ڵ�, P.�б�;

SELECT * FROM MEMBER_CNT WHERE �б� = '1st';

SELECT * FROM PROD_PUR_Q;

CREATE TABLE MEMBER_SUM
AS SELECT P.�����ڵ�, P.�б�, SUM(P.���űݾ�) AS SUM
FROM PROD_PUR_Q P, MEMBER_Q_2 C
WHERE P.����ȣ = C.����ȣ AND P.�б� = C.�б�
GROUP BY P.�����ڵ�, P.�б�
ORDER BY P.�����ڵ�, P.�б�;

SELECT * FROM MEMBER_CNT_RANK;

CREATE TABLE MEMBER_CNT_CUST
AS SELECT A.�����ڵ�, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM MEMBER_CNT_RANK A, (SELECT * FROM MEMBER_CNT_RANK WHERE �б� = '2nd') B, (SELECT * FROM MEMBER_CNT_RANK WHERE �б� = '6th') C, (SELECT * FROM MEMBER_CNT_RANK WHERE �б� = '7th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ�
ORDER BY A.�����ڵ�;

SELECT * FROM MEMBER_CNT_CUST;

SELECT * FROM MEMBER_SUM_RANK;

CREATE TABLE MEMBER_SUM_CUST
AS SELECT A.�����ڵ�, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM MEMBER_SUM_RANK A, (SELECT * FROM MEMBER_SUM_RANK WHERE �б� = '2nd') B, (SELECT * FROM MEMBER_SUM_RANK WHERE �б� = '6th') C, (SELECT * FROM MEMBER_SUM_RANK WHERE �б� = '7th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ�
ORDER BY A.�����ڵ�;

SELECT * FROM MEMBER_SUM_CUST;

-------------------------------------------------------
CREATE TABLE PUR_SUM
AS SELECT �����ڵ�, �б�, SUM(���űݾ�) AS ���űݾ� FROM PROD_PUR_Q
GROUP BY �����ڵ�, �б�
ORDER BY �����ڵ�, �б�;

SELECT * FROM PUR_SUM;

SELECT * FROM SUM_RANK;

CREATE TABLE SUM_CUST
AS SELECT A.�����ڵ�, C.RANK - A.RANK AS X_TRAIN, D.RANK - B.RANK X_VAL_TEST
FROM SUM_RANK A, (SELECT * FROM SUM_RANK WHERE �б� = '2nd') B, (SELECT * FROM SUM_RANK WHERE �б� = '6th') C, (SELECT * FROM SUM_RANK WHERE �б� = '7th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ�
ORDER BY A.�����ڵ�;

SELECT * FROM SUM_CUST;

CREATE TABLE PUR_RATE
AS SELECT A.�����ڵ�, ROUND((C.���űݾ� - A.���űݾ�) / A.���űݾ�, 2) AS X_TRAIN, ROUND((D.���űݾ� - B.���űݾ�) / B.���űݾ�, 2) AS X_VAL_TEST
FROM PUR_SUM A, (SELECT �����ڵ�, �б�, ���űݾ� FROM PUR_SUM WHERE �б� = '2nd') B, (SELECT * FROM PUR_SUM WHERE �б� = '6th') C, (SELECT * FROM PUR_SUM WHERE �б� = '7th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ�
ORDER BY A.�����ڵ�;

SELECT * FROM PUR_RATE;
-------------------------------------------------------
CREATE TABLE UPPERCLASS_Q
AS SELECT A.�����ڵ�, A.�б�, B.UPPERCLASS, SUM(A.���űݾ�) AS SUM
FROM PROD_PUR_Q A, UPPERCLASS B
WHERE A.�Һз��ڵ� = B.�Һз��ڵ�
GROUP BY A.�����ڵ�, A.�б�, B.UPPERCLASS
ORDER BY A.�����ڵ�, A.�б�, B.UPPERCLASS;

SELECT * FROM UPPERCLASS_Q;

SELECT A.�����ڵ�, (C.SUM - A.SUM) AS X_TRAIN, (D.SUM - B.SUM) AS X_VAL_TEST
FROM UPPERCLASS_Q A, (SELECT * FROM UPPERCLASS_Q WHERE �б� = '2nd') B, (SELECT * FROM UPPERCLASS_Q WHERE �б� = '6th') C, (SELECT * FROM UPPERCLASS_Q WHERE �б� = '7th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ� AND A.UPPERCLASS = '��ǰ' AND B.UPPERCLASS = '��ǰ' AND C.UPPERCLASS = '��ǰ' AND D.UPPERCLASS = '��ǰ';

SELECT A.�����ڵ�, (C.SUM - A.SUM) AS X_TRAIN, (D.SUM - B.SUM) AS X_VAL_TEST
FROM UPPERCLASS_Q A, (SELECT * FROM UPPERCLASS_Q WHERE �б� = '2nd') B, (SELECT * FROM UPPERCLASS_Q WHERE �б� = '6th') C, (SELECT * FROM UPPERCLASS_Q WHERE �б� = '7th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ� AND A.UPPERCLASS = '����' AND B.UPPERCLASS = '����' AND C.UPPERCLASS = '����' AND D.UPPERCLASS = '����';

SELECT A.�����ڵ�, (C.SUM - A.SUM) AS X_TRAIN, (D.SUM - B.SUM) AS X_VAL_TEST
FROM UPPERCLASS_Q A, (SELECT * FROM UPPERCLASS_Q WHERE �б� = '2nd') B, (SELECT * FROM UPPERCLASS_Q WHERE �б� = '6th') C, (SELECT * FROM UPPERCLASS_Q WHERE �б� = '7th') D
WHERE A.�б� = '1st' AND A.�����ڵ� = B.�����ڵ� AND B.�����ڵ� = C.�����ڵ� AND C.�����ڵ� = D.�����ڵ� AND A.UPPERCLASS = '�Ƿ�' AND B.UPPERCLASS = '�Ƿ�' AND C.UPPERCLASS = '�Ƿ�' AND D.UPPERCLASS = '�Ƿ�';
-------------------------------------------------------
SELECT * FROM CHANNEL; --����ȣ, ���޻�(MOBILE/APP, ONLINEMALL)
SELECT * FROM COMPETE; --����ȣ, ���޻�
SELECT * FROM CUSTDEMO; --����ȣ
SELECT * FROM MEMBER; --����ȣ
SELECT * FROM PRODCL; --���޻�, (��,��,��)�з��ڵ�
SELECT * FROM PRODPUR; --����ȣ, ���޻�, (��,��,��)�з��ڵ�
SELECT * FROM PROD_PUR_Q;

SELECT * FROM INCREASE;
SELECT * FROM DECREASE;


-------------------------------------------------------
--LMEMBERS �����Ϳ��� ���� ���űݾ��� �հ踦 ���� CUSPUR ���̺��� ������ �� CUST ���̺�� 
--����ȣ�� �������� �����Ͽ� ����ϼ���.
CREATE TABLE CUSPUR
AS SELECT ����ȣ, SUM(���űݾ�) AS ���űݾ� FROM PRODPUR
GROUP BY ����ȣ
ORDER BY ����ȣ;

--purprd ���̺��� 2�Ⱓ ���űݾ��� ���� ������ �и��Ͽ� ����14, ����15 �÷��� �����ϴ� AMT_YEAR ���̺��� 
--������ �� 14��� 15���� ���űݾ� ���̸� ǥ���ϴ� ���� �÷��� �߰��Ͽ� ����ϼ���.
--��, ����ȣ, ���޻纰�� ���űݾ� �� ������ ���еǾ�� ��.
CREATE TABLE AMT14
AS SELECT ����ȣ, ���޻�, SUM(���űݾ�) AS ���űݾ� FROM PRODPUR
WHERE �������� < '20150101'
GROUP BY ����ȣ, ���޻�
ORDER BY ����ȣ, ���޻�;

CREATE TABLE AMT15
AS SELECT ����ȣ, ���޻�, SUM(���űݾ�) AS ���űݾ� FROM PRODPUR
WHERE �������� > '20141231'
GROUP BY ����ȣ, ���޻�
ORDER BY ����ȣ, ���޻�;

SELECT * FROM AMT15;

CREATE TABLE AMT_YEAR
AS SELECT A4.����ȣ, A4.���޻�, A4.���űݾ� ����14, A5.���űݾ� ����15
FROM AMT14 A4 FULL OUTER JOIN AMT15 A5
ON (A4.����ȣ = A5.����ȣ AND A4.���޻� = A5.���޻�);

SELECT * FROM AMT_YEAR;

SELECT ����ȣ, ���޻�, NVL(����14, 0) AS ����14, NVL(����15, 0) AS ����15,
(NVL(����15,0) - NVL(����14,0)) AS ����
FROM AMT_YEAR;







