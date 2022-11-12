BEGIN;

CREATE TABLE Categories(
    category_id SERIAL,
    category_name VARCHAR(50) NOT NULL UNIQUE,

    CONSTRAINT pk_category_id PRIMARY KEY(category_id)
);

CREATE TABLE Authors(
    author_id SERIAL, 
    author_name VARCHAR(255) NOT NULL UNIQUE,
    about_author TEXT NOT NULL,

    CONSTRAINT pk_author_id PRIMARY KEY(author_id)
);

CREATE TABLE Publishers(
    publisher_id SERIAL,
    publisher_name VARCHAR(255) NOT NULL UNIQUE,
    about_publisher TEXT NOT NULL,

    CONSTRAINT pk_publisher_id PRIMARY KEY(publisher_id)
);

CREATE TABLE Books(
    book_id SERIAL,
    book_code VARCHAR(6) NOT NULL UNIQUE,
    book_title VARCHAR(255) NOT NULL UNIQUE,
    book_author BIGINT REFERENCES Authors(author_id) ON DELETE SET NULL,
    book_publisher BIGINT REFERENCES Publishers(publisher_id) ON DELETE SET NULL,
    book_availability_status BOOLEAN NOT NULL DEFAULT TRUE,
    book_description TEXT NOT NULL,

    CONSTRAINT pk_book_id PRIMARY KEY(book_id)
);

CREATE TABLE Metadatas(
    metadata_id serial,
    book_id BIGINT REFERENCES Books(book_id) ON DELETE CASCADE,
    isbn VARCHAR(17) NOT NULL UNIQUE,
    price SMALLINT NOT NULL CHECK(price > 0),
    availability_count SMALLINT NOT NULL CHECK(availability_count >= 0),
    page_count SMALLINT NOT NULL CHECK(page_count > 0),
    reading_age SMALLINT NOT NULL CHECK(reading_age >= 0),

    CONSTRAINT pk_metadata_id PRIMARY key(metadata_id)
);

CREATE TABLE Photos(
    photo_id SERIAL,
    book_id BIGINT REFERENCES Books(book_id) ON DELETE CASCADE,
    photo_url TEXT NOT NULL,

    CONSTRAINT pk_photo_id PRIMARY KEY(photo_id)
);

CREATE TABLE Books_Category(
    books_category_id SERIAL,
    book_id BIGINT REFERENCES Books(book_id) ON DELETE CASCADE,
    category_id BIGINT REFERENCES Categories(category_id) ON DELETE CASCADE,

    CONSTRAINT pk_books_category_id PRIMARY KEY(books_category_id)
);

CREATE TABLE Users(
    users_id SERIAL,
    users_name VARCHAR(255) NOT NULL,
    users_email VARCHAR(255) NOT NULL,
    users_phone_num VARCHAR(12) UNIQUE NOT NULL,
    users_hash_password VARCHAR(16) UNIQUE NOT NULL,
    users_registered_date TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_users_id PRIMARY KEY(users_id)
);

CREATE TABLE Carts(
    cart_id SERIAL,
    users_id BIGINT REFERENCES Users(users_id) ON DELETE CASCADE,
    book_id BIGINT REFERENCES Books(book_id) ON DELETE CASCADE,
    products_count SMALLINT CHECK(products_count > 0) DEFAULT 1,
    add_to_cart_date TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT pk_cart_id PRIMARY KEY(cart_id)
);

CREATE TABLE Order_Status(
    status_id serial,
    status_name VARCHAR(50) NOT NULL UNIQUE,
    
    CONSTRAINT pk_status_id PRIMARY KEY(status_id)
);

CREATE TABLE Orders(
    order_id serial,
    order_code VARCHAR(10) UNIQUE NOT NULL,
    cart_id BIGINT REFERENCES Carts(cart_id) ON DELETE SET NULL,
    street VARCHAR(255) NOT NULL,
    house_num VARCHAR(255) NOT NULL,
    flat_num VARCHAR(255),
    description_for_shipping TEXT,
    order_status BIGINT REFERENCES Order_Status(order_id),
    ordered_date TIMESTAMP NOT NULL DEFAULT NOW(),
    
    CONSTRAINT pk_order_id PRIMARY KEY(order_id)
);

COMMIT;