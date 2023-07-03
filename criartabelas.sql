CREATE TABLE customer (
       cust_no INTEGER PRIMARY KEY,
       name VARCHAR(80) NOT NULL,
       email VARCHAR(254) UNIQUE NOT NULL,
       phone VARCHAR(15),
       address VARCHAR(255)
);
-- Index for customer table
CREATE INDEX idx_customer_email ON customer (email);

CREATE TABLE orders (
       order_no INTEGER PRIMARY KEY,
       cust_no INTEGER NOT NULL REFERENCES customer,
       date DATE NOT NULL
      --order_no must exist in contains
);
-- Index for "order" table
CREATE INDEX idx_order_cust_no ON orders (cust_no);

CREATE TABLE pay(
       order_no INTEGER PRIMARY KEY REFERENCES orders,
       cust_no INTEGER NOT NULL REFERENCES customer
);
-- Index for pay table
CREATE INDEX idx_pay_cust_no ON pay (cust_no);

CREATE TABLE employee(
       ssn VARCHAR(20) PRIMARY KEY,
       TIN VARCHAR(20) UNIQUE NOT NULL,
       bdate DATE,
       name VARCHAR NOT NULL
      --age must be >=18
);
-- Index for employee table
CREATE INDEX idx_employee_age ON employee (age);

CREATE TABLE process(
       ssn VARCHAR(20) REFERENCES employee,
       order_no INTEGER REFERENCES orders,
       PRIMARY KEY (ssn, order_no)
);
-- Index for process table
CREATE INDEX idx_process_ssn ON process (ssn);
CREATE INDEX idx_process_order_no ON process (order_no);

CREATE TABLE department(
       name VARCHAR PRIMARY KEY
);

CREATE TABLE workplace(
       address VARCHAR PRIMARY KEY,
       lat NUMERIC(8, 6) NOT NULL,
       long NUMERIC(9, 6) NOT NULL,
       UNIQUE(lat, long)
      --address must be either in warehouse or office
      --address cannot be both in warehouse and office simultaneously
);
-- Index for workplace table
CREATE INDEX idx_workplace_address ON workplace (address);

CREATE TABLE office(
       address VARCHAR(255) PRIMARY KEY REFERENCES workplace
);
-- Index for office table
CREATE INDEX idx_office_address ON office (address);

CREATE TABLE warehouse(
       address VARCHAR(255) PRIMARY KEY REFERENCES workplace
);
-- Index for warehouse table
CREATE INDEX idx_warehouse_address ON warehouse (address);

CREATE TABLE works(
       ssn VARCHAR(20) REFERENCES employee,
       name VARCHAR(200) REFERENCES department,
       address VARCHAR(255) REFERENCES workplace,
       PRIMARY KEY (ssn, name, address)
);
-- Index for works table
CREATE INDEX idx_works_ssn ON works (ssn);
CREATE INDEX idx_works_name ON works (name);
CREATE INDEX idx_works_address ON works (address);

CREATE TABLE product(
       SKU VARCHAR(25) PRIMARY KEY,
       name VARCHAR(200) NOT NULL,
       description VARCHAR,
       price NUMERIC(10, 2) NOT NULL,
       ean NUMERIC(13) UNIQUE
);
-- Index for product table
CREATE INDEX idx_product_name ON product (name);
CREATE INDEX idx_product_SKU ON product (SKU);

CREATE TABLE contains(
       order_no INTEGER REFERENCES orders,
       SKU VARCHAR(25) REFERENCES product,
       qty INTEGER,
       PRIMARY KEY (order_no, SKU)
);
-- Index for contains table
CREATE INDEX idx_contains_order_no ON contains (order_no);
CREATE INDEX idx_contains_SKU ON contains (SKU);

CREATE TABLE supplier(
       TIN VARCHAR(20) PRIMARY KEY,
       name VARCHAR(200),
       address VARCHAR(255),
       SKU VARCHAR(25) REFERENCES product,
       date DATE
);
-- Index for supplier table
CREATE INDEX idx_supplier_SKU ON supplier (SKU);

CREATE TABLE delivery(
       address VARCHAR(255) REFERENCES warehouse,
       TIN VARCHAR(20) REFERENCES supplier,
       PRIMARY KEY (address, TIN)
);
-- Index for delivery table
CREATE INDEX idx_delivery_address ON delivery (address);
CREATE INDEX idx_delivery_TIN ON delivery (TIN);