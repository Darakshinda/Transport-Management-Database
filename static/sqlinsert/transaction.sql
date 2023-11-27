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
