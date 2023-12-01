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


CREATE VIEW TransactionWithReservationAndEmployee AS
SELECT
    t.transaction_id,
    t.res_id,
    t.dated,
    t.amount,
    t.payment_mode,
    t.type,
    t.status,
    r.bus_id,
    r.stop1_expected,
    r.stop1_real,
    r.stop2_expected,
    r.stop2_real,
    r.stop3_expected,
    r.stop3_real,
    e.emp_id,
    e.emp_fname,
    e.emp_lname
FROM Transactions t
JOIN Reservation r ON t.res_id = r.res_id
JOIN Employees e ON t.emp_id = e.emp_id;



SELECT * FROM ReservationWithPassenger;
SELECT * FROM BusWithType;
SELECT * FROM EmployeeWithJob;
