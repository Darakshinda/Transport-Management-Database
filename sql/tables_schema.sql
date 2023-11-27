CREATE TABLE Passenger(
    passen_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    passen_fname VARCHAR(255),
    passen_lname VARCHAR(255),
    passen_address VARCHAR(255),
    passen_ph_no CHAR(10),
    status BOOLEAN);

CREATE TABLE Reservation (
    res_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    passen_id INT,
    bus_id INT,
    transaction_id VARCHAR(12),
    stop1_expected DATETIME,
    stop1_real DATETIME,
    stop2_expected DATETIME,
    stop2_real DATETIME,
    hours INT GENERATED ALWAYS AS (
    (TIMESTAMPDIFF(HOUR, stop1_expected, stop1_real) + TIMESTAMPDIFF(HOUR, stop2_expected, stop2_real))*100
    ) STORED

);

CREATE TABLE Bus(
    bus_id INT PRIMARY KEY NOT NULL,
    type_id CHAR(3),
    description TEXT,
    price INT,
    occupancy_status BOOLEAN);

CREATE TABLE Bus_Type(
    type_id CHAR(3) PRIMARY KEY NOT NULL,
    name VARCHAR(255),
    capacity INT);

CREATE TABLE Transactions(
    transaction_id VARCHAR(12) PRIMARY KEY NOT NULL,
    emp_id INT,
    res_id INT,
    dated DATETIME,
    amount INT,
    payment_mode VARCHAR(255),
    type BOOLEAN,
    status TINYINT(1));

CREATE TABLE Employees(
    emp_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    job_id INT,
    emp_fname VARCHAR(255),
    emp_lname VARCHAR(255),
    emp_address VARCHAR(255),
    emp_ph_no CHAR(10));

CREATE TABLE Job(
    job_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    job_title VARCHAR(255),
    salary INT);

CREATE TABLE User (
    user_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    username VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    job_id INT,
    FOREIGN KEY (job_id) REFERENCES Job(job_id)
);
