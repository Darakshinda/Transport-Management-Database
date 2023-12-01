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
    stop3_expected DATETIME,
    stop3_real DATETIME,
    lateness_fine REAL GENERATED ALWAYS AS (
        GREATEST(0,
            (CASE WHEN TIMESTAMPDIFF(MINUTE, stop1_expected, stop1_real) > 15 THEN (TIMESTAMPDIFF(MINUTE, stop1_expected, stop1_real) - 15) * 5 ELSE 0 END) +
            (CASE WHEN TIMESTAMPDIFF(MINUTE, stop2_expected, stop2_real) > 15 THEN (TIMESTAMPDIFF(MINUTE, stop2_expected, stop2_real) - 15) * 5 ELSE 0 END) +
            (CASE WHEN TIMESTAMPDIFF(MINUTE, stop3_expected, stop3_real) > 15 THEN (TIMESTAMPDIFF(MINUTE, stop3_expected, stop3_real) - 15) * 5 ELSE 0 END)
        )
    ) STORED,
    status VARCHAR(50) 
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


