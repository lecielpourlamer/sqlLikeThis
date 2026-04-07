create table products (
	id		INT NOT NULL auto_increment PRIMARY KEY,
	name	VARCHAR(45) NOT NULL COMMENT '상품명',
    price	INT NOT NULL
);

INSERT INTO products (name, price)
VALUES
	('사과', 500),
    ('귤', 1000),
    ('바나나', 800);

-- 크로스 조인을 사용하여 순서쌍 만들기
-- 크로스 조인은 조인 조건이 없음
-- 두 테이블의 모든 레코드를 빠짐없이 조합하기 때문
SELECT
	p1.name AS name_1,
    p2.name AS name_2
FROM products p1
CROSS JOIN products p2;

-- 크로스 조인 2
-- 비권장 방식, 조건을 빠트리면 의도하지 않은 크로스 조인 발생
-- 크로스 조인은 연산 비용이 높아, 시스템 자원을 과도하게 사용
-- 대규모 테이블에서의 성능 문제 야기
SELECT
	p1.name AS name_1,
    p2.name AS name_2
FROM
	products p1,
    products p2;
	
-- 중복 제거
-- 순열을 구하는 SQL
SELECT
	p1.name AS name_1,
    p2.name AS name_2
FROM products p1
INNER JOIN products p2 
	ON p1.name <> p2.name -- 같은 상품끼리의 조합 제외
ORDER BY p1.name DESC;

-- 순서만 바뀐 쌍을 제거, 순서를 고려하지 않은 비순서쌍
-- 조합을 구하는 SQL
SELECT
	P1.name AS name_1,
	P2.name AS name_2
FROM Products P1
INNER JOIN Products P2 
	ON P1.name > P2.name;

-- 조합을 구하는 SQL: 3개 항목으로 확장
SELECT
	P1.name AS name_1,
    P2.name As name_2,
    P3.name AS name_3
FROM Products P1
INNER JOIN Products P2 ON p1.name > P2.name
INNER JOIN Products P3 ON P2.name > P3.name;

INSERT INTO Products (name, price)
VALUES 
	('귤', 1000),
	('귤', 1000);

-- 중복 행을 제거하는 SQL(2): 비등가 조인 사용하기
DELETE
FROM Products P1
WHERE EXISTS
	(SELECT *
     FROM Products P2
     WHERE P1.name = P2.name
		AND P1.price = P2.price
        AND P1.id < P2.id);

CREATE TABLE Addresses (
	name		varchar(20) COMMENT '이름',
    family_id	int COMMENT '가족 ID',
    address		varchar(45) COMMENT '주소'
);

INSERT INTO Addresses (name, family_id, address)
VALUES
	('윤인성', 100, '서울 강서구 마곡동 12-34'),
	('윤아린', 100, '서울 강서구 마곡동 15-34'),
	('박홍준', 200, '인천 서구 아라동 56-78'),
	('오지혜', 200, '인천 서구 아라동 56-78'),
	('홈즈', 300, '베이커가 221B'),
	('왓슨', 400, '베이커가 221B');

-- 같은 가족인데 주소가 다른 레코드를 찾기
-- 셀프 조인과 비등가 조인 조합
SELECT DISTINCT A1.name, A1.address
FROM Addresses A1
INNER JOIN Addresses A2 ON A1.family_id = A2.family_id
	AND A1.address <> A2.address;















