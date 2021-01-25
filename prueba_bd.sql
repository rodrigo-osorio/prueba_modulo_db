--PARTE 2
--creando base de datos:
CREATE DATABASE prueba;

--ingresando a base de datos
\c prueba

--CREACION DE TABLAS
--creando tabla DIRECCIONES
CREATE TABLE addresses(
    address_id SERIAL PRIMARY KEY,
    street VARCHAR(50),
    street_number INT,
    precinct VARCHAR(25),
    city VARCHAR(25)
);

--creando tabla CLIENTES
CREATE TABLE clients(
    client_id SERIAL PRIMARY KEY,
    client_name VARCHAR(20),
    last_name VARCHAR(20),
    rut VARCHAR(15) UNIQUE,
    address_id INT REFERENCES addresses(address_id)
);

--creando tabla FACTURAS
CREATE TABLE bills( 
    bill_num SERIAL PRIMARY KEY,
    bill_date DATE,
    quantity INT,
    subtotal INT,
    total_price DECIMAL,
    client_id INT REFERENCES clients(client_id)
);

--creando tabla PRODUCTOS
CREATE TABLE products(
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(30),
    product_description VARCHAR(50),
    unit_value INT,
    iva DECIMAL
);

--creando tabla FACTURAS_PRODUCTOS (RELACIONAL)
CREATE TABLE bills_products(
    bill_num INT REFERENCES bills(bill_num),
    product_id INT REFERENCES products(product_id)
);

--creando tabla CATEGORIAS
CREATE TABLE categories(
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(30) UNIQUE,
    category_description VARCHAR(50)
);

--creando tabla PRODUCTOS_CATEGORIAS (RELACIONAL)
CREATE TABLE products_categories(
    product_id INT REFERENCES products(product_id),
    category_id INT REFERENCES categories(category_id)
);


--INGRESO DE DATOS 
--insertando direcciones (5) a tabla direcciones:
INSERT INTO addresses(street, street_number, precinct, city) VALUES
    ('Las torres', 234, 'Puente alto', 'Santiago'),
    ('Francisco de bilbao', 8976, 'Providencia', 'Santiago'),
    ('Arturo Prat', 1523, 'Mejillones', 'Antofagasta'),
    ('Avenida Simpson', 6798, 'Corral', 'Valdivia'),
    ('Caupolican', 964, 'Vilcun', 'Temuco');

--insertando clientes (5) a tabla clientes:
INSERT INTO clients(client_name, last_name, rut, address_id) VALUES
    ('Rodrigo', 'Osorio', '12345678-7', 1),
    ('Deyna', 'Contreras', '87654321-9', 2),
    ('David', 'Aravena', '13243546-7', 3),
    ('Hector', 'Azocar', '24681234-4', 4),
    ('Cristian', 'Zuniga', '34512367-8', 5);

--insertando productos (8) a tabla productos:
INSERT INTO products(product_name, product_description, unit_value, iva) VALUES
    ('Teclado', 'Teclado Hiper cherry mx brown', 65000, 12350),
    ('Mouse', 'Mouse ergonomico Logitech', 21990, 4178.1),
    ('Monitor', 'Monitor Dell full HD', 85990, 16338.1),
    ('Silla', 'Silla ergonomica Karl', 128000, 24320),
    ('Apoya pies', 'Apoya pies ergonomico ajustable', 23800, 4522),
    ('Disco externo', 'Disco externo Toshiba 2T', 64990, 12348.1),
    ('Pendrive', 'Pendrive Sony 16gb', 12900, 2451),
    ('Cable hdmi', 'Philips 90 grados 1.5 mts', 7990, 1518.1);

--insertando categorias (3) a tabla cagetorias:
INSERT INTO categories(category_name, category_description) VALUES
    ('Ergonomia', 'Uso intensivo y postura corporal'),
    ('Almacenamiento', 'Respaldo de informacion'),
    ('Perifericos', 'Accesorios para pc');

--insertando facturas (10) a tabla facturas:
INSERT INTO bills(bill_date, quantity, subtotal, total_price, client_id) VALUES
    ('2020-01-21', 2, 88800, 105672, 1),
    ('2020-02-22', 3, 122690, 146001.1, 1),
    ('2020-03-23', 3, 115970, 138004.3, 2),
    ('2020-01-24', 2, 86990, 103518.1, 2),
    ('2020-08-25', 3, 158970, 189174.3, 2),
    ('2020-07-26', 1, 64990, 77338.1, 3),
    ('2020-03-27', 2, 151800, 180642, 4),
    ('2020-10-28', 3, 193970, 230824.3, 4),
    ('2020-12-29', 4, 265980, 316516.2, 4),
    ('2020-02-28', 1, 65000, 77350, 4);


--insertando relacion facturas y productos a tabla facturas_productos:
INSERT INTO bills_products(bill_num, product_id) VALUES
    (1, 1), (1, 5), (2, 3), (2, 5), (2, 7), (3, 8), (3, 3),
    (3, 2), (4, 1), (4, 2), (5, 3), (5, 6), (5, 8), (6, 6),
    (7, 5), (7, 4), (8, 3), (8, 2), (8, 3), (9, 1), (9, 4),
    (9, 6), (9, 8), (10, 1);

--insertando relacion productos y categorias a tabla productos_categorias:
INSERT INTO products_categories(product_id, category_id) VALUES
    (1, 3), (1, 1), (2, 3), (2, 1), (3, 3), (4, 1), (5, 1),
    (6, 2), (6, 3), (7, 2), (7, 3), (8, 3);



--PARTE 3
--Consulta 1: ¿Que cliente realizó la compra más cara?
SELECT client_name, total_price FROM clients INNER JOIN bills 
    ON clients.client_id = bills.client_id 
        WHERE bills.total_price = (
            SELECT max(bills.total_price) FROM bills);

--Consulta 2: ¿Que cliente pagó sobre 100 de monto?
SELECT DISTINCT client_name FROM clients INNER JOIN bills 
    ON clients.client_id = bills.client_id
        WHERE bills.total_price > 100;

--Consulta 3: ¿Cuantos clientes han comprado el producto 6?
SELECT COUNT(client_name) FROM clients INNER JOIN bills 
    ON clients.client_id = bills.client_id INNER JOIN bills_products
        ON bills.bill_num = bills_products.bill_num WHERE
            product_id = 6;

            