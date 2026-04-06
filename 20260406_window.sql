INSERT INTO poptbl (pref_name, population)
VALUES 
	('전주', 100),
    ('여수', 200),
    ('광주', 150),
    ('목포', 200),
    ('대구', 300),
    ('경주', 100),
    ('포항', 250),
    ('서울', 400);
    
SELECT * FROM poptbl;

-- 지역 이름을 권역 이름으로 재분류하기
SELECT
	CASE pref_name
		WHEN '전주' THEN '호남권'
		WHEN '여수' THEN '호남권'
		WHEN '광주' THEN '호남권'
		WHEN '목포' THEN '호남권'
		WHEN '대구' THEN '영남권'
		WHEN '경주' THEN '영남권'
		WHEN '포항' THEN '영남권'
        ELSE '기타'
	END AS district,
    SUM(population)
FROM poptbl
GROUP BY
	CASE pref_name
		WHEN '전주' THEN '호남권'
		WHEN '여수' THEN '호남권'
		WHEN '광주' THEN '호남권'
		WHEN '목포' THEN '호남권'
		WHEN '대구' THEN '영남권'
		WHEN '경주' THEN '영남권'
		WHEN '포항' THEN '영남권'
        ELSE '기타'
	END;

-- 인구 규모별로 지역 분류하기
SELECT
	CASE
		WHEN population < 100 THEN '01'
        WHEN population >= 100
			AND population < 200 THEN '02'
		WHEN population >= 200
			AND population < 300 THEN '03'
		WHEN population >= 300 THEN '04'
        ELSE NULL
	END AS pop_class,
	COUNT(*) As cnt
FROM poptbl
GROUP BY
	CASE
		WHEN population < 100 THEN '01'
        WHEN population >= 100
			AND population < 200 THEN '02'
		WHEN population >= 200
			AND population < 300 THEN '03'
		WHEN population >= 300 THEN '04'
        ELSE NULL
	END;
    
-- 권역 단위로 재분류하기(방법 2: CASE 식을 한 곳에만 작성)
SELECT
	CASE pref_name
		WHEN '전주' THEN '호남권'
		WHEN '여수' THEN '호남권'
		WHEN '광주' THEN '호남권'
		WHEN '목포' THEN '호남권'
		WHEN '대구' THEN '영남권'
		WHEN '경주' THEN '영남권'
		WHEN '포항' THEN '영남권'
        ELSE '기타'
    END AS district,
    SUM(population)
FROM poptbl
GROUP BY district;	-- SELECT 절에서 붙인 별칭을 GROUP BY 절에서 사용

DROP TABLE IF EXISTS poptbl2;

CREATE TABLE poptbl2 (
	id			INT NOT NULL AUTO_INCREMENT PRIMARY KEY,	-- 자동으로 증가하는 ID
    pref_name	VARCHAR(20) NOT NULL,
    sex			INT NOT NULL,
    population	INT
);

INSERT INTO poptbl2 (pref_name, sex, population)
VALUES 
	('전주', 1, 60),
	('전주', 2, 40),
    ('여수', 1, 100),
    ('여수', 2, 100),
    ('광주', 1, 100),
    ('광주', 2, 50),
    ('목포', 1, 100),
    ('목포', 2, 100),
    ('대구', 1, 100),
    ('대구', 2, 200),
    ('경주', 1, 20),
    ('경주', 2, 80),
    ('포항', 1, 125),
    ('포항', 2, 125),
    ('서울', 1, 250),
    ('서울', 2, 150);
    
-- 남성 인구
SELECT	pref_name,
		population
FROM	poptbl2
WHERE	sex = '1';
    
-- 여성 인구
SELECT	pref_name,
		population
FROM	poptbl2
WHERE	sex = '2';

SELECT
	pref_name AS '지역명',
    -- 남성 인구
    SUM(
		CASE
			WHEN sex = '1' THEN population
            ELSE 0
        END
    ) AS '남성 인구',
    -- 여성 인구
    SUM(
		CASE
			WHEN sex = '2' THEN population
            ELSE 0
        END
    ) AS '여성 인구'
FROM poptbl2
GROUP BY pref_name;

SELECT
	pref_name AS '지역명',
    -- 남성 인구
	CASE
		WHEN sex = '1' THEN population
		ELSE 0
	END AS '남성 인구',
    -- 여성 인구
	CASE
		WHEN sex = '2' THEN population
		ELSE 0
	END AS '여성 인구'
FROM poptbl2;

SHOW CREATE TABLE poptbl2;

CREATE TABLE personnel (
	id		INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name	varchar(45) NOT NULL,
    salary	INT
);

INSERT INTO personnel (name, salary)
VALUES
	('이주안', 3000000),
    ('이대윤', 2700000),
    ('이은호', 2200000),
    ('김민준', 2900000);
    
UPDATE personnel
	SET
		salary = CASE
					WHEN salary >= 3000000 THEN salary * 0.9
                    WHEN salary >= 2500000 AND salary < 2800000 THEN salary * 1.2
                    ELSE salary
                 END
WHERE id > 0;	-- PK인 id를 조건에 넣어 Safe Mode 우회

CREATE TABLE SOMETABLE (
	p_key	VARCHAR(10) NOT NULL COMMENT '기본 키',
    col_1	INT COMMENT '열1',
	col_2	VARCHAR(10)
);

INSERT INTO SOMETABLE
VALUES
	('a', 1, '가'),
    ('b', 2, '나'),
    ('c', 3, '다');

-- 1. 안전 모드 잠시 해제
SET SQL_SAFE_UPDATES = 0;

-- 2. CASE 식으로 기본 키 바꾸기
UPDATE SOMETABLE
	SET p_key = CASE
					WHEN p_key = 'a' THEN 'b'
                    WHEN p_key = 'b' THEN 'a'
                    ELSE p_key
				END
WHERE p_key IN ('a', 'b');

-- 3. 안전모드 다시 설정(중요!)
SET SQL_SAFE_UPDATES = 1;

SELECT DATE('2018-02-01');

CREATE TABLE LoadSample (
	id				INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    sample_date		DATE COMMENT '계측일',
    load_val		INT COMMENT '부하량'
);

INSERT INTO loadsample (sample_date, load_val)
VALUES
	('2018-02-01', 1024),
	('2018-02-02', 2366),
	('2018-02-05', 2366),
	('2018-02-07', 985),
	('2018-02-08', 780),
	('2018-02-12', 1000);

-- 각 행에서 '바로 이전 날짜' 구하기
SELECT
	ls.sample_date AS cur_date,
    MIN(ls.sample_date) OVER (
		ORDER BY 
			ls.sample_date ASC ROWS BETWEEN 1 PRECEDING
            AND 1 PRECEDING
    ) AS latest_date
FROM loadsample ls;

-- 해당 날짜의 부하량 구하기
SELECT
	ls.sample_date AS cur_date,
    ls.load_val AS cur_load,
    MIN(ls.sample_date) OVER (
		ORDER BY 
			ls.sample_date ASC ROWS BETWEEN 1 PRECEDING
            AND 1 PRECEDING
    ) AS latest_date,
    MIN(ls.load_val) OVER (
		ORDER BY
			ls.sample_date ASC ROWS BETWEEN 1 PRECEDING
            AND 1 PRECEDING
    ) AS latest_load
FROM loadsample ls;


-- 해당 날짜의 부하량 구하기 + 이름 있는 윈도 문법 사용
SELECT
	ls.sample_date AS cur_date,
    ls.load_val AS cur_load,
    MIN(ls.sample_date) OVER W AS latest_date,
    MIN(ls.load_val) OVER W AS latest_load
FROM loadsample ls
WINDOW
	W AS (
		ORDER BY
			sample_date ASC ROWS BETWEEN 1 PRECEDING
            AND 1 PRECEDING
    );
