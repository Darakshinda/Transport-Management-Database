USE tmsfinal12;
INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
VALUES ('Rajiv', 'Coudhary', 'Kolkata', '9892849581', 1);

INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
VALUES ('Ravi', 'Chary', 'Outy', '9487449581', 1);

INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
VALUES ('Ishan', 'Yuvi', 'Rachi', '9490219581', 0);

INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
VALUES ('Isiwaka', 'Umar', 'Jaipur', '8531119581', 0);

INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
VALUES ('Ushi', 'Mundhra', 'Bikaner', '9487234581', 1);

INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
VALUES ('Hinata', 'Shoyo', 'Kanpur', '9876219581', 0);

INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
VALUES ('Kageyama', 'Kun', 'Kanpur', '8976519581', 0);

INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
VALUES ('Daichi', 'Shoyo', 'Tokyo', '9765419581', 1);

INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
VALUES ('Ushiwaka', 'Mon', 'Srinagar', '9487519581', 0);

INSERT INTO Customer (cust_fname, cust_lname, cust_address, cust_ph_no, status)
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

INSERT INTO Room_Type (type_id, name, capacity)
VALUES ('SDX', 'Super Deluxe', 55);

INSERT INTO Room_Type (type_id, name, capacity)
VALUES ('DXL', 'Deluxe', 60);

INSERT INTO Room_Type (type_id, name, capacity)
VALUES ('NAC', 'Normal AC', 50);

INSERT INTO Room_Type (type_id, name, capacity)
VALUES ('NOL', 'Normal NON-AC', 55);

INSERT INTO Room_Type (type_id, name, capacity)
VALUES ('PRM', 'Primary', 60);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (101, 'DXL', 'Deluxe Bus with maximum capacity of 60 people', 2000, 1);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (102, 'SDX', 'Super Deluxe Bus with amazing window view and capacity of 55 people', 3000, 0);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (103, 'SDX', 'Super Deluxe Bus with amazing window view and capacity of 55 people', 3000, 1);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (104, 'DXL', 'Deluxe Bus with maximum capacity of 60 people', 2000, 0);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (105, 'NAC', 'Normal Bus with basic features like TV and AC', 1500, 1);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (201, 'NAC', 'Normal Bus with basic features like TV and AC', 1500, 0);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (202, 'NAC', 'Normal Bus with basic features like TV and AC', 1500, 0);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (203, 'NOL', 'Normal Bus with no AC', 1250, 1);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (204, 'NOL', 'Normal Bus with no AC', 1250, 0);

INSERT INTO Room (room_id, type_id, description, price, occupancy_status)
VALUES (205, 'PRM', 'Primary Budget Bus for 60 people', 1000, 1);

-- Insert data into Transactions table
INSERT INTO Transactions (transaction_id, emp_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM1234', NULL, 1, '2022-02-16', 6000, 'Credit Card', 1, 1);

INSERT INTO Transactions (transaction_id, emp_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM7927', NULL, 2, '2022-02-20', 4000, 'Credit Card', 1, 1);

INSERT INTO Transactions (transaction_id, emp_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM5721', NULL, 3, '2022-02-28', 6250, 'Debit Card', 1, 1);

INSERT INTO Transactions (transaction_id, emp_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM2461', NULL, 4, '2022-03-13', 4500, 'UPI', 1, -1);

INSERT INTO Transactions (transaction_id, emp_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM2171', NULL, 4, '2022-03-13', 4500, 'UPI', 1, 1);

INSERT INTO Transactions (transaction_id, emp_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM2232', 2, NULL, '2022-03-15', 60000, 'Bank Transfer', 0, 1);

INSERT INTO Transactions (transaction_id, emp_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM5719', NULL, 5, '2022-03-28', 14000, 'Net Banking', 1, 1);

INSERT INTO Transactions (transaction_id, emp_id, res_id, dated, amount, payment_mode, type, status)
VALUES ('PYTM2112', 5, NULL, '2022-03-28', 45000, 'Bank Transfer', 0, 1);

INSERT INTO Reservation (cust_id, room_id, transaction_id, stop1_expected, stop1_real, stop2_expected, stop2_real)
VALUES 
    (1, 102, 'PYTM1234', '2022-02-16 08:00:00', '2022-02-16 08:30:00', '2022-02-18 12:00:00', '2022-02-18 12:30:00'),
    (7, 201, 'PYTM7927', '2022-02-20 08:00:00', '2022-02-20 08:30:00', '2022-02-22 12:00:00', '2022-02-22 12:30:00'),
    (1, 204, 'PYTM5721', '2022-03-02 08:00:00', '2022-03-02 08:30:00', '2022-03-07 12:00:00', '2022-03-07 12:30:00'),
    (4, 201, 'PYTM2171', '2022-03-10 08:00:00', '2022-03-10 08:30:00', '2022-03-13 12:00:00', '2022-03-13 12:30:00'),
    (5, 205, 'PYTM5719', '2022-03-14 08:00:00', '2022-03-14 08:30:00', '2022-03-28 12:00:00', '2022-03-28 12:30:00');
