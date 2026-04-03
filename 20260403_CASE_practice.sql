CREATE TABLE COURSEMaster (
	course_id	INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    course_name	varchar(45) NOT NULL
);

INSERT INTO coursemaster (course_name)
VALUES
	('경리 입문'),
    ('재무 지식'),
    ('회계 자격증'),
    ('세무사');

CREATE TABLE opencourses (
	id			int not null auto_increment primary key,
    month		int not null,
    course_id	int not null
);

insert into opencourses (month, course_id)
values
	(201806, 1),
    (201806, 3),
    (201806, 4),
    (201807, 4),
    (201808, 2),
    (201808, 4);
    
-- 두 테이블을 기반으로 각 월의 개설 상황을 한눈에 볼 수 있는 크로스 테이블 만들기
-- opencourses 테이블에 특정 월의 강좌가 있는지를 coursemater 테이블과 비교 확인

-- 1. 테이블 매칭 : IN 사용
SELECT
	course_name,
    CASE
		WHEN course_id IN (
			SELECT course_id
            FROM opencourses
            WHERE MONTH = 201806
        ) THEN 'O'
        ELSE 'X'
    END AS "6월",
    CASE
		WHEN course_id IN (
			SELECT course_id
            FROM opencourses
            WHERE MONTH = 201807
        ) THEN 'O'
        ELSE 'X'
    END AS "7월",
    CASE
		WHEN course_id IN (
			SELECT course_id
            FROM opencourses
            WHERE MONTH = 201808
        ) THEN 'O'
        ELSE 'X'
    END AS "8월"
FROM coursemaster;

-- 테이블 매칭: EXISTS 사용
SELECT
	cm.course_name,
    CASE
		WHEN EXISTS (
			SELECT oc.course_id
            FROM opencourses oc
            WHERE 
				oc.month = 201806
                AND oc.course_id = cm.course_id
        ) THEN 'O'
        ELSE 'X'
    END AS "6월",
    CASE
		WHEN EXISTS (
			SELECT oc.course_id
            FROM opencourses oc
            WHERE 
				oc.month = 201807
                AND oc.course_id = cm.course_id
        ) THEN 'O'
        ELSE 'X'
    END AS "7월",
    CASE
		WHEN EXISTS (
			SELECT oc.course_id
            FROM opencourses oc
            WHERE 
				oc.month = 201808
                AND oc.course_id = cm.course_id
        ) THEN 'O'
        ELSE 'X'
    END AS "8월"
FROM coursemaster cm;

CREATE TABLE studentclub (
	id				INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    std_id			INT NOT NULL COMMENT '학생 번호',
    club_id			INT NOT NULL COMMENT '동아리 ID',
    club_name		VARCHAR(45) NOT NULL COMMENT '동아리 이름',
    main_club_flg	CHAR(1) NOT NULL COMMENT '주 동아리 플래그'
);

INSERT INTO studentclub (std_id, club_id, club_name, main_club_flg)
VALUES
	(100, 1, '야구', 'Y'),
	(100, 2, '관현악', 'N'),
	(200, 2, '관현악', 'N'),
	(200, 3, '배드민턴', 'Y'),
	(200, 4, '축구', 'N'),
	(300, 4, '축구', 'N'),
	(400, 5, '수영', 'N'),
	(500, 6, '바둑', 'N');
    
-- 학생은 여러 동아리에 속할 수도 있고(100, 200)
-- 하나에만 속할 수도 있다(300, 400, 500)
-- 여러 동아리에 속한 학생은 주 동아리를 Y로 표시하고, 
-- 하나에만 속한 학생은 N으로 표시

-- 하나의 동아리에만 속한 학생 선택
SELECT
	sc.std_id,
	MAX(sc.club_id) AS main_club
FROM studentclub sc
GROUP BY sc.std_id
HAVING COUNT(*) = 1;

-- 여러 동아리에 속한 학생의 주 동아리 선택
SELECT
	sc.std_id,
    sc.club_id AS main_club
FROM studentclub sc
WHERE sc.main_club_flg = 'Y';

SELECT
	sc.std_id,
    CASE
		WHEN COUNT(*) = 1 THEN MAX(sc.club_id) -- 동아리 하나에만 속한 학생
        ELSE MAX(
			CASE
				WHEN sc.main_club_flg = 'Y' THEN sc.club_id
                ELSE NULL
            END
        )
    END AS main_club
FROM studentclub sc
GROUP BY sc.std_id;
    