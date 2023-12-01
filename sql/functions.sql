DELIMITER //
CREATE FUNCTION CalculateTotalAmount(passenID INT)
RETURNS INT
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



-- Replace 201 with the desired bus ID
CALL CalculateTotalDelay(201, @totalDelayMinutes);
SELECT @totalDelayMinutes AS total_delay_minutes_for_bus_201;


