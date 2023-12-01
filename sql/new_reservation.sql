INSERT INTO Reservation(passen_id, room_id, transaction_id, stop1_expected, stop1_real, stop2_expected,stop2_real, stop3_expected, stop3_real)
    VALUES
    (%s, %s, %s, %s, %s,%s,%s, %s,%s, %s);