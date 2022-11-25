-- Вставка в таблицу Users
INSERT INTO users (
   users_id, users_name, users_email, users_phone_num, users_hash_password, users_registered_date
   )
SELECT
   users_id,
   md5(random()::text)::VARCHAR(50) || ' ' || md5(random()::text)::VARCHAR(50),
   md5(random()::text)::VARCHAR(25) || '.' ||
   md5(random()::text)::VARCHAR(25) || '@gmail.com',
   
   '996' || floor(random() * (519-501+1) + 501)::int::VARCHAR(3) || floor(random() * 1000000 + 1)::int::VARCHAR(10),
   md5(random()::text)::VARCHAR(16),
   (select * from now())
FROM generate_series(1,10) users_id;

-- Вставка в таблицу Authors, Publishers, Categories
INSERT INTO public.authors (author_id, author_name, about_author)
SELECT
   author_id,
   md5(random()::text)::VARCHAR(50) || ' ' || md5(random()::text)::VARCHAR(50),
   md5(random()::text)::VARCHAR(50)
FROM generate_series(1, 20) author_id;

INSERT INTO public.publishers (publisher_id, publisher_name, about_publisher)
SELECT
   publisher_id,
   md5(random()::text)::VARCHAR(50) || ' ' || md5(random()::text)::VARCHAR(50),
   md5(random()::text)::VARCHAR(50)
FROM generate_series(1, 20) publisher_id;

INSERT INTO public.categories (category_id, category_name)
SELECT
   category_id,
   md5(random()::text)::VARCHAR(50)
FROM generate_series(1, 20) category_id;

-- Вставка в таблицу Books и Metadatas
DO $$
   DECLARE
      i INT;
   BEGIN
      FOR i IN 1..5
      LOOP
	    
	    WITH add_books AS(
      	INSERT INTO books(book_id, book_code, book_title, book_author, book_publisher, book_description)
      	SELECT
           i,
           floor(random() * (999999-100000+1) + 100000)::int::VARCHAR(6),
           md5(random()::text)::VARCHAR(100),
           (SELECT a.author_id FROM authors a WHERE a.author_id = (SELECT floor(random() * 20 + 1)::int)),
           (SELECT p.publisher_id FROM publishers p WHERE p.publisher_id = (SELECT floor(random() * 20 + 1)::int)),
           md5(random()::text)::VARCHAR(100)
        RETURNING book_id AS add_books_id)
        
        INSERT INTO metadatas (metadata_id, book_id, isbn, price, availability_count, page_count, reading_age)
        SELECT
           i,
           (SELECT add_books_id FROM add_books),
           '978' || floor(random() * (9999999999-1000000000+1) + 1000000000)::BIGINT::VARCHAR(10),
           floor(random() * (1000-500+1) + 500)::INT,
           floor(random() * (100-50+1) + 50)::INT,
           floor(random() * (1000-500+1) + 100)::INT,
           floor(random() * (21-1+1) + 1)::INT;
        
      END LOOP;
END$$

-- Вставка в таблицу Photos и Books_Category
DO $$
   DECLARE
      i INT;
   BEGIN
      FOR i IN 6..10
      LOOP

	     WITH cte_table_1 AS (
	        SELECT b.book_id 
	        FROM books b 
	        WHERE b.book_id = (SELECT floor(random() * (SELECT COUNT(book_id) FROM books) + 1)::int)  
	     ), cte_table_2 AS (
	        INSERT INTO photos (photo_id, book_id, photo_url)
	        SELECT
	           i,
	           (SELECT * FROM cte_table_1),
	           md5(random()::text)::VARCHAR(50)
	           
	     RETURNING book_id)
	     
	     INSERT INTO books_category (books_category_id, book_id, category_id)
	     SELECT
	        i,
	        (SELECT * FROM cte_table_2),
	        (SELECT category_id FROM categories WHERE category_id = (SELECT floor(random() * 20 + 1)::int));
      END LOOP;
END$$