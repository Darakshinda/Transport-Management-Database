---trigger 1 to update status on time orr delay 
DELIMITER //
CREATE TRIGGER SetDefaultStatus
BEFORE INSERT ON Reservation
FOR EACH ROW
BEGIN
    SET NEW.status = CASE WHEN NEW.lateness_fine > 0 THEN 'Delayed' ELSE 'On Time' END;
END;
//
DELIMITER ;
--trigger 2 to update




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

-- to check do: 
UPDATE Reservation 
SET stop3_real = '2022-03-10 14:45:00' 
WHERE res_id = 4;
SELECT * FROM Reservation WHERE res_id = 4;


