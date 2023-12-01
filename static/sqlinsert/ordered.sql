USE newdb;

DELIMITER //
CREATE TRIGGER SetDefaultStatus
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
    SET NEW.status = CASE WHEN NEW.lateness_fine > 0 THEN 'Delayed' ELSE 'On Time' END;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER UpdateReservationStatus
BEFORE UPDATE ON Reservation
FOR EACH ROW
BEGIN
    SET NEW.stop3_real = CASE WHEN TIMESTAMPDIFF(MINUTE, NEW.stop3_expected, NEW.stop3_real) > 15 THEN NEW.stop3_real ELSE NEW.stop3_expected + INTERVAL 15 MINUTE END;
    
    SET NEW.lateness_fine = GREATEST(0,
        (CASE WHEN TIMESTAMPDIFF(MINUTE, NEW.stop1_expected, NEW.stop1_real) > 15 THEN (TIMESTAMPDIFF(MINUTE, NEW.stop1_expected, NEW.stop1_real) - 15) * 5 ELSE 0 END) +
        (CASE WHEN TIMESTAMPDIFF(MINUTE, NEW.stop2_expected, NEW.stop2_real) > 15 THEN (TIMESTAMPDIFF(MINUTE, NEW.stop2_expected, NEW.stop2_real) - 15) * 5 ELSE 0 END) +
        (CASE WHEN TIMESTAMPDIFF(MINUTE, NEW.stop3_expected, NEW.stop3_real) > 15 THEN (TIMESTAMPDIFF(MINUTE, NEW.stop3_expected, NEW.stop3_real) - 15) * 5 ELSE 0 END)
    );

    SET NEW.status = CASE WHEN NEW.lateness_fine > 0 THEN 'Delayed' ELSE 'On Time' END;
END;
//
DELIMITER ;



CREATE VIEW ReservationWithPassenger AS
SELECT
    r.res_id,
    r.passen_id,
    r.bus_id,
    r.transaction_id,
    r.stop1_expected,
    r.stop1_real,
    r.stop2_expected,
    r.stop2_real,
    r.stop3_expected,
    r.stop3_real,
    r.lateness_fine,
    r.status,
    p.passen_fname,
    p.passen_lname,
    p.passen_address,
    p.passen_ph_no
FROM Reservation r
JOIN Passenger p ON r.passen_id = p.passen_id;


CREATE VIEW BusWithType AS
SELECT
    b.bus_id,
    b.type_id,
    b.description,
    b.price,
    b.occupancy_status,
    bt.name AS type_name,
    bt.capacity
FROM Bus b
JOIN Bus_Type bt ON b.type_id = bt.type_id;


CREATE VIEW EmployeeWithJob AS
SELECT
    e.emp_id,
    e.job_id,
    e.emp_fname,
    e.emp_lname,
    e.emp_address,
    e.emp_ph_no,
    j.job_title,
    j.salary
FROM Employees e
JOIN Job j ON e.job_id = j.job_id;


SELECT * FROM ReservationWithPassenger;
SELECT * FROM BusWithType;
SELECT * FROM EmployeeWithJob;

DELIMITER //
CREATE FUNCTION CalculateTotalAmount(passenID INT) RETURNS INT READS SQL DATA
BEGIN
    DECLARE totalAmount INT;
    SELECT SUM(amount) INTO totalAmount
    FROM Transactions
    WHERE res_id IN (SELECT res_id FROM Reservation WHERE passen_id = passenID);
    RETURN totalAmount;
END;
//
DELIMITER ;

SELECT CalculateTotalAmount(1) AS total_amount_for_passenger_1;





DELIMITER //
CREATE PROCEDURE CalculateTotalDelay(IN busID INT, OUT totalDelayMinutes INT)
BEGIN
    DECLARE totalDelay INT DEFAULT 0;
    
    -- Calculate delay for each reservation and accumulate
    SELECT 
        SUM(
            GREATEST(0,
                (CASE WHEN TIMESTAMPDIFF(MINUTE, stop1_expected, stop1_real) > 15 THEN (TIMESTAMPDIFF(MINUTE, stop1_expected, stop1_real) - 15) ELSE 0 END) +
                (CASE WHEN TIMESTAMPDIFF(MINUTE, stop2_expected, stop2_real) > 15 THEN (TIMESTAMPDIFF(MINUTE, stop2_expected, stop2_real) - 15) ELSE 0 END) +
                (CASE WHEN TIMESTAMPDIFF(MINUTE, stop3_expected, stop3_real) > 15 THEN (TIMESTAMPDIFF(MINUTE, stop3_expected, stop3_real) - 15) ELSE 0 END)
            )
        ) INTO totalDelay
    FROM Reservation
    WHERE bus_id = busID;

    SET totalDelayMinutes = totalDelay;
END;
//
DELIMITER ;




INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Rajiv', 'Coudhary', 'Kolkata', '9892849581', 1);

INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Ravi', 'Chary', 'Outy', '9487449581', 1);

INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Ishan', 'Yuvi', 'Rachi', '9490219581', 0);

INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Isiwaka', 'Umar', 'Jaipur', '8531119581', 0);

INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Ushi', 'Mundhra', 'Bikaner', '9487234581', 1);

INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Hinata', 'Shoyo', 'Kanpur', '9876219581', 0);

INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Kageyama', 'Kun', 'Kanpur', '8976519581', 0);

INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Daichi', 'Shoyo', 'Tokyo', '9765419581', 1);

INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Ushiwaka', 'Mon', 'Srinagar', '9487519581', 0);

INSERT INTO Passenger (passen_fname, passen_lname, passen_address, passen_ph_no, status)
VALUES ('Sumi', 'Mai', 'Jajpur', '9490219581', 0);


INSERT INTO Job (job_title, salary)
VALUES ('Admin', 50000);

INSERT INTO Job (job_title, salary)
VALUES ('Driver', 45000);

INSERT INTO Job (job_title, salary)
VALUES ('Conductor', 30000);

INSERT INTO Job (job_title, salary)
VALUES ('Mechanic', 20000);

INSERT INTO Job (job_title, salary)
VALUES ('Peon', 15000);

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (1, 'Raghav', 'Bahety', 'Kolkata', '8017797696');

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (2, 'Abhinav', 'Kumar', 'Patna', '8235484476');

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (3, 'Bhavya', 'Kumari', 'Outy', '9867843214');

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (4, 'Eren', 'Yegar', 'Dispur', '9876543212');

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (4, 'Mikasa', 'Yegar', 'Dispur', '9878794234');

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (4, 'Captain', 'Levi', 'Guwahati', '9485643298');

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (4, 'Albo', 'Josai', 'Rampur', '9087643198');

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (4, 'Albedo', 'Smith', 'Ranchi', '9847566021');

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (5, 'Archon', 'Zhongli', 'Liyue', '9087465329');

INSERT INTO Employees (job_id, emp_fname, emp_lname, emp_address, emp_ph_no)
VALUES (5, 'Raiden', 'Shogan', 'Delhi', '8746509832');

INSERT INTO Bus_Type (type_id, name, capacity)
VALUES ('SDX', 'Super Deluxe', 55);

INSERT INTO Bus_Type (type_id, name, capacity)
VALUES ('DXL', 'Deluxe', 60);

INSERT INTO Bus_Type (type_id, name, capacity)
VALUES ('NAC', 'Normal AC', 50);

INSERT INTO Bus_Type (type_id, name, capacity)
VALUES ('NOL', 'Normal NON-AC', 55);

INSERT INTO Bus_Type (type_id, name, capacity)
VALUES ('PRM', 'Primary', 60);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (101, 'DXL', 'Deluxe Bus with maximum capacity of 60 people', 2000, 1);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (102, 'SDX', 'Super Deluxe Bus with amazing window view and capacity of 55 people', 3000, 0);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (103, 'SDX', 'Super Deluxe Bus with amazing window view and capacity of 55 people', 3000, 1);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (104, 'DXL', 'Deluxe Bus with maximum capacity of 60 people', 2000, 0);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (105, 'NAC', 'Normal Bus with basic features like TV and AC', 1500, 1);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (201, 'NAC', 'Normal Bus with basic features like TV and AC', 1500, 0);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (202, 'NAC', 'Normal Bus with basic features like TV and AC', 1500, 0);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (203, 'NOL', 'Normal Bus with no AC', 1250, 1);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (204, 'NOL', 'Normal Bus with no AC', 1250, 0);

INSERT INTO Bus (bus_id, type_id, description, price, occupancy_status)
VALUES (205, 'PRM', 'Primary Budget Bus for 60 people', 1000, 1);

-- Insert data into Transactions table
INSERT INTO Transactions (transaction_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM1234',  1, '2022-02-16', 6000, 'Credit Card', 1, 1);

INSERT INTO Transactions (transaction_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM7927', 2, '2022-02-20', 4000, 'Credit Card', 1, 1);

INSERT INTO Transactions (transaction_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM5721' ,3, '2022-02-28', 6250, 'Debit Card', 1, 1);

INSERT INTO Transactions (transaction_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM2461', 4, '2022-03-13', 4500, 'UPI', 1, -1);

INSERT INTO Transactions (transaction_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM2171', 4, '2022-03-13', 4500, 'UPI', 1, 1);

INSERT INTO Transactions (transaction_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM2232', 2, '2022-03-15', 60000, 'Bank Transfer', 0, 1);

INSERT INTO Transactions (transaction_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM5719', 5, '2022-03-28', 14000, 'Net Banking', 1, 1);

INSERT INTO Transactions (transaction_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM2112', 5 ,'2022-03-28', 45000, 'Bank Transfer', 0, 1);

INSERT INTO Reservation (passen_id, bus_id, transaction_id, stop1_expected, stop1_real, stop2_expected, stop2_real,stop3_expected,stop3_real)
VALUES 
    (1, 102, 'PYTM1234', '2022-02-16 08:00:00', '2022-02-16 09:30:00', '2022-02-16 12:00:00', '2022-02-16 12:30:00','2022-02-16 14:00:00', '2022-02-16 14:30:00'),
    (7, 201, 'PYTM7927', '2022-02-20 08:00:00', '2022-02-20 10:30:00', '2022-02-20 12:00:00', '2022-02-20 12:30:00','2022-02-20 13:00:00', '2022-02-20 14:30:00'),
    (1, 204, 'PYTM5721', '2022-03-02 08:00:00', '2022-03-02 08:30:00', '2022-03-02 12:00:00', '2022-03-02 12:30:00','2022-03-02 13:30:00', '2022-03-02 14:00:00'),
    (4, 201, 'PYTM2171', '2022-03-10 08:00:00', '2022-03-10 08:00:00', '2022-03-10 12:00:00', '2022-03-10 12:00:00','2022-03-10 14:00:00', '2022-03-10 14:00:00'),
    (5, 205, 'PYTM5719', '2022-03-14 08:00:00', '2022-03-14 08:30:00', '2022-03-14 10:00:00', '2022-03-14 11:30:00','2022-03-14 12:00:00', '2022-03-14 12:30:00');
SELECT * FROM RESERVATION;


-----These queries are to check the triggers

UPDATE Reservation 
SET stop3_real = '2022-03-10 14:45:00' -- assuming this update triggers a lateness fine
WHERE res_id = 4;
SELECT * FROM Reservation WHERE res_id = 4;


INSERT INTO Reservation (passen_id, bus_id, transaction_id, stop1_expected, stop1_real, stop2_expected, stop2_real, stop3_expected, stop3_real)
VALUES
    (1, 201, 'TXN123', '2023-12-01 08:00:00', '2023-12-01 09:30:00', '2023-12-01 12:00:00', '2023-12-01 12:30:00', '2023-12-01 14:00:00', '2023-12-01 14:30:00');
SELECT * FROM Bus WHERE bus_id = 201;


----These queries are to check the views

SELECT * FROM ReservationWithPassenger;
SELECT * FROM BusWithType;
SELECT * FROM EmployeeWithJob;


----These queries are to check functions and procedures


SELECT CalculateTotalAmount(1) AS total_amount_for_passenger_1;

CALL CalculateTotalDelay(201, @totalDelayMinutes);
SELECT @totalDelayMinutes AS total_delay_minutes_for_bus_201;
