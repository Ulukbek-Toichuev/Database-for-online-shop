-- DEPRECATED!!!

-- Вставка в таблицу Users
INSERT INTO Users(users_name, users_email, users_phone_num, users_hash_password, users_registered_date)
VALUES
(
    (SELECT 
    (array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)
    FROM generate_series(1,10)), '')) || ' ' ||
    (array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)
    FROM generate_series(1,10)), ''))),

    (SELECT 
    (array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)
    FROM generate_series(1,10)), '')) || '.' ||
    (array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)
    FROM generate_series(1,10)), '')) || '@gmail.com'),

    (SELECT
    '996' ||
    (array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer) 
    FROM generate_series(1,9)), ''))
    ),

    (SELECT array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer) 
    FROM generate_series(1,16)), '')),
    (select * from now())
);


-- Вставка в таблицу Authors, Publishers, Categories
INSERT INTO Authors (
    author_name, about_author
)
SELECT
    left(md5(i::TEXT), 20),
    md5(random()::TEXT)
FROM generate_series(1, 5) s(i);

INSERT INTO publishers (
    publisher_name, about_publisher
)
SELECT
    left(md5(i::TEXT), 20),
    md5(random()::TEXT)
FROM generate_series(1, 5) s(i);

INSERT INTO categories (
    category_name
)
SELECT
    left(md5(i::TEXT), 20)
FROM generate_series(1, 5) s(i);

-- Вставка в таблицу Books
WITH Add_metadatas AS(
   INSERT INTO books (book_code, book_title, book_author, book_publisher, book_description)
   VALUES
   (
       (SELECT array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer) 
       FROM generate_series(1,6)), '')),
    
       (SELECT 
       (array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)
       FROM generate_series(1,50)), ''))),
    
       (SELECT a.author_id FROM authors a where a.author_id = (SELECT floor(random() * 5 + 1)::int)),
    
       (SELECT p.publisher_id FROM publishers p where p.publisher_id = (SELECT floor(random() * 5 + 1)::int)),
    
       (SELECT 
       (array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)
       FROM generate_series(1,50)), ''))))
       RETURNING book_id AS id_for_metadatas_table),
       
Add_photos AS(       
   INSERT INTO metadatas (book_id, isbn, price, availability_count, page_count, reading_age)
   VALUES
   (
       (SELECT id_for_metadatas_table FROM Add_metadatas),
       
       (SELECT
       '978' || '-' ||
       (array_to_string(ARRAY(SELECT chr((48 + round(random() * 9)) :: integer) 
       FROM generate_series(1,10)), ''))),
       
       (SELECT floor(random() * (20-10+1) + 10)::int),
       
       (SELECT floor(random() * (10-1+1) + 1)::int),
       
       (SELECT floor(random() * (1000-100+1) + 100)::int),
       
       (SELECT floor(random() * (21-10+1) + 10)::int))
       RETURNING book_id AS id_for_photos_table),
       
Add_Categories AS(
   INSERT INTO photos (book_id, photo_url)
   VALUES
   (
       (SELECT id_for_photos_table FROM Add_photos),
       (SELECT 
       (array_to_string(ARRAY(SELECT chr((97 + round(random() * 25)) :: integer)
       FROM generate_series(1,50)), ''))))
       RETURNING book_id AS id_for_categories_table)
INSERT INTO books_category (book_id, category_id)
VALUES
(
   (SELECT id_for_categories_table FROM Add_Categories),
   (SELECT c.category_id FROM categories c WHERE c.category_id = (SELECT floor(random() * 10 + 1)::int))
);

-- Вставка в таблицу Carts
INSERT INTO carts (users_id, book_id, products_count, add_to_cart_date)
VALUES
(
    (SELECT u.users_id FROM users u WHERE u.users_id = (SELECT floor(random() * (SELECT COUNT(u.users_id) FROM users u) + 1)::int)),
    (SELECT b.book_id FROM books b WHERE b.book_id = (SELECT floor(random() * (SELECT COUNT(b.book_id) FROM books b) + 1)::int)),
    (SELECT floor(random() * 10 + 1)::int),
    (SELECT * FROM NOW())
);