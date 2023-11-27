INSERT INTO Reservation(cust_id, room_id, transaction_id, stop1_expected, stop1_real, stop2_expected,stop2_real, hours)
    VALUES
    (%s, %s, %s, %s, %s,%s,%s, %s);