-- final project

-- figurium 데이터 베이스 삭제
drop database figurium_db;

-- figurium 데이터 베이스 생성
create database figurium_db;

-- 사용할 데이터베이스 지정
use figurium_db;

-- 회원 테이블
CREATE TABLE users (
                       id              INT             AUTO_INCREMENT PRIMARY KEY, -- 회원 고유 ID (자동 증가)
                       email           VARCHAR(255)	unique,                  	-- 회원 이메일 (유일 값)
                       password        VARCHAR(255),                               -- 회원 비밀번호 (소셜 로그인의 경우 NULL 가능)
                       name            VARCHAR(255)    NOT NULL,                   -- 회원 이름
                       phone           VARCHAR(30),                                -- 회원 전화번호
                       address         TEXT,                                       -- 회원 주소
                       profile_img     VARCHAR(255),                               -- 회원 프로필 이미지
                       created_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,  -- 계정 생성 시간
                       updated_at      TIMESTAMP       DEFAULT CURRENT_TIMESTAMP   ON UPDATE CURRENT_TIMESTAMP -- 계정 정보 수정 시간
);



-- 소셜 회원 테이블
CREATE TABLE social_accounts (
                                 id                  INT             AUTO_INCREMENT PRIMARY KEY,  -- 소셜 계정 고유 ID (자동 증가)
                                 user_id             INT          NOT NULL,                    -- 회원 테이블과 연결된 회원 ID
                                 provider            VARCHAR(30) CHECK(provider IN ('google', 'kakao', 'naver')) NOT NULL,   -- 소셜 로그인 제공자
                                 provider_user_id    VARCHAR(255)    NOT NULL,                    -- 소셜 제공자에 의해 부여된 사용자 고유 ID
                                 created_at          TIMESTAMP       DEFAULT CURRENT_TIMESTAMP,   -- 소셜 계정 생성 시간
                                 FOREIGN KEY (user_id) REFERENCES users(id) on delete cascade,    -- 회원 테이블과 연결
                                 UNIQUE KEY unique_provider_user (provider, provider_user_id)     -- 소셜 제공자별로 고유한 사용자 ID
);


-- 카테고리 테이블
CREATE TABLE categories (
                            id          INT             AUTO_INCREMENT PRIMARY KEY,   -- 카테고리 고유 ID (자동 증가)
                            name        VARCHAR(255)    NOT NULL                      -- 카테고리 이름
);


-- 상품 테이블
CREATE TABLE products (
                          id 						INT AUTO_INCREMENT PRIMARY KEY, -- 상품 고유 ID (자동 증가)
                          category_id 			INT,                            -- 카테고리 테이블과 연결된 카테고리 ID
                          name 					VARCHAR(255) NOT NULL,          -- 상품 이름
                          price 					INT NOT NULL,       			-- 상품 가격
                          quantity 				INT DEFAULT 1,                 	-- 상품 재고 수량
                          image_url 				VARCHAR(255),                   -- 상품 이미지 URL
                          status					ENUM('AVAILABLE','SOLD_OUT') DEFAULT 'AVAILABLE', -- 해당 상품의 재고가 없으면 SOLD_OUT 처리
                          created_at  			TIMESTAMP DEFAULT CURRENT_TIMESTAMP,  -- 상품 등록 시간
                          updated_at 				TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 상품 수정 시간
                          FOREIGN KEY (category_id) REFERENCES categories(id), -- 카테고리 테이블과 연결
                          INDEX (name)											-- 상품 이름에 대한 인덱스를 추가해 조회기능 향상

);


-- 상품 좋아요 테이블
create table product_likes(
                              id INT AUTO_INCREMENT PRIMARY key,
                              user_id INT,
                              product_id INT,
                              FOREIGN KEY (user_id) REFERENCES users(id),
                              FOREIGN KEY (product_id) REFERENCES products(id)
);




-- 상품 검색어 순위
CREATE TABLE search_product (
                                id 				INT AUTO_INCREMENT PRIMARY KEY, -- 고유 ID
                                search_name 	VARCHAR(255) NOT NULL,   		-- 검색어
                                search_count 	INT DEFAULT 0,  				-- 검색 횟수
                                INDEX (search_name)								-- 검색어에 대한 인덱스 추가로 검색 기능 향상
);


-- 장바구니 테이블
CREATE TABLE carts (
                       id INT PRIMARY KEY AUTO_INCREMENT COMMENT '장바구니 ID',
                       user_id INT NOT NULL COMMENT '회원 ID',
                       product_id INT NOT NULL COMMENT '상품 ID',
                       quantity INT NOT NULL DEFAULT 1 COMMENT '상품 수량',
                       added_time DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '등록 시간',
                       FOREIGN KEY (user_id) REFERENCES users(id) ,
                       FOREIGN KEY (product_id) REFERENCES products(id)
);

/*
-- 주문 정보 테이블
CREATE TABLE orders (
    id                  INT             AUTO_INCREMENT PRIMARY KEY, -- 주문번호
    user_id             INT             NOT NULL,                   -- 주문고객번호
    coupon_id           INT             DEFAULT NULL,               -- 쿠폰 ID (NULL 허용)
    buyer_name          VARCHAR(15)     NOT NULL,                   -- 주문자명
    total_item_price    DECIMAL(8,0)    NOT NULL,                   -- 상품총금액
    earn_point          DECIMAL(4,0)    DEFAULT 0,                  -- 적립금액
    shipping_fee        DECIMAL(5, 0)   NOT NULL,                   -- 배송비
    total_plus_price    DECIMAL(8, 0)   NOT NULL,                   -- 총금액 (상품 총금액 + 배송비)
    total_minus_price   DECIMAL(8,0)    DEFAULT 0,                  -- 할인금액
    total_price         DECIMAL(8,0)    DEFAULT 0,                  -- 결제금액
    payment_type        VARCHAR(50)     NOT NULL,                   -- 결제 방식
    order_status        VARCHAR(50)     NOT NULL,                   -- 주문 상태
    order_time          DATETIME        DEFAULT NOW(),              -- 주문 시간
    total_quantity      INT             NOT NULL,                   -- 총 상품 수량
    FOREIGN KEY (user_id) REFERENCES users(id),                     -- 주문고객번호
    FOREIGN KEY (coupon_id) REFERENCES coupons(id) ON DELETE SET NULL -- 쿠폰 번호 연결
);

-- 주문 상품 정보 테이블
CREATE TABLE order_items (
    id                  INT             AUTO_INCREMENT PRIMARY KEY, -- 일련번호
    order_id            INT             NOT NULL,                   -- 주문번호
    product_id          INT             NOT NULL,                   -- 상품번호
    product_inventory   INT             NOT NULL,                   -- 주문 상품 갯수
    product_price       DECIMAL(8,0)    NOT NULL,                   -- 상품 가격
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE, -- 주문번호 연결
    FOREIGN KEY (product_id) REFERENCES products(id)                -- 상품번호 연결
);

-- 배송지 정보 테이블
CREATE TABLE shipping_addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    recipient_name VARCHAR(15),
    phone VARCHAR(20),
    address VARCHAR(100),
    delivery_request VARCHAR(60),
    FOREIGN KEY (order_id) REFERENCES order_items(id)
);
*/


-- 리뷰 테이블
CREATE TABLE reviews (
                         id 			INT AUTO_INCREMENT PRIMARY KEY,    	 -- 리뷰 고유 ID (자동 증가)
                         user_id 	INT,                                 -- 회원 테이블과 연결된 회원 ID
                         product_id 	INT,                              	 -- 상품 테이블과 연결된 상품 ID
                         rating 		INT CHECK (rating BETWEEN 1 AND 5),  -- 별점 (1~5 사이)
                         content 	TEXT,                        		 -- 리뷰 내용
                         created_at	TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 리뷰 작성 시간
                         updated_at	TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 리뷰 수정 시간
                         FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE, 	   -- 회원 테이블과 연결
                         FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE -- 상품 테이블과 연결
);


-- 상품 Q&A 통합 테이블
CREATE TABLE qa (
                    id INT AUTO_INCREMENT PRIMARY KEY,						-- Q&A 게시물 IDX
                    product_id INT ,										-- 상품 ID
                    user_id INT not null ,  								-- 사용자가 질문을 작성한 경우
                    content VARCHAR(400) ,									-- 질문내용
                    recontent VARCHAR(400) ,								-- 질문 답글
                    created DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,	-- 작성일자
                    updated DATETIME NULL ON UPDATE CURRENT_TIMESTAMP,		-- 수정일자
                    FOREIGN KEY (product_id) REFERENCES products(id),		-- 상품 참조키
                    FOREIGN KEY (user_id) REFERENCES users(id)		-- 상품 참조키
);



