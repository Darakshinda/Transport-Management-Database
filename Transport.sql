CREATE DATABASE BusTransportManagementSystem	;

-- Create Buses table
CREATE TABLE Buses (
    BusID INT PRIMARY KEY,
    BusNumber VARCHAR(20),
    Model VARCHAR(50),
    Capacity INT,
    YearManufactured INT,
    Color VARCHAR(50)
    -- Add other fields as needed
);

-- Create BusDrivers table
CREATE TABLE BusDrivers (
    DriverID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    LicenseNumber VARCHAR(20),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    BusID INT, -- Foreign key to link with Buses table
    FOREIGN KEY (BusID) REFERENCES Buses(BusID)
);

-- Create Routes table
CREATE TABLE Routes (
    RouteID INT PRIMARY KEY,
    StartLocation VARCHAR(100),
    EndLocation VARCHAR(100),
    Distance INT,
    EstimatedDuration INT,
    EstimatedFuelConsumption DECIMAL(10, 2)
    -- Add other fields as needed
);

-- Create BusSchedule table
CREATE TABLE BusSchedule (
    ScheduleID INT PRIMARY KEY,
    BusID INT, -- Foreign key to link with Buses table
    RouteID INT, -- Foreign key to link with Routes table
    DepartureTime TIME,
    ArrivalTime TIME,
    -- Add other fields as needed
    FOREIGN KEY (BusID) REFERENCES Buses(BusID),
    FOREIGN KEY (RouteID) REFERENCES Routes(RouteID)
);

-- Create PassengerBookings table
CREATE TABLE PassengerBookings (
    BookingID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    BusID INT, -- Foreign key to link with Buses table
    RouteID INT, -- Foreign key to link with Routes table
    ShipmentDate DATE,
    ArrivalDate DATE,
    Status VARCHAR(20),
    -- Add other fields as needed
    FOREIGN KEY (BusID) REFERENCES Buses(BusID),
    FOREIGN KEY (RouteID) REFERENCES Routes(RouteID)
);

-- Create Stops table
CREATE TABLE Stops (
    StopID INT PRIMARY KEY,
    LocationName VARCHAR(100),
    Latitude DECIMAL(9, 6),  -- Adjust precision based on requirements
    Longitude DECIMAL(9, 6)  -- Adjust precision based on requirements
    -- Add other fields as needed
);

-- Modify Routes table to include information about stops
ALTER TABLE Routes
ADD COLUMN Stop1ID INT, -- Foreign key to link with Stops table
ADD COLUMN Stop2ID INT, -- Foreign key to link with Stops table
ADD COLUMN Stop3ID INT; -- Foreign key to link with Stops table

-- Add foreign key constraints
ALTER TABLE Routes
ADD CONSTRAINT FK_Stop1 FOREIGN KEY (Stop1ID) REFERENCES Stops(StopID),
ADD CONSTRAINT FK_Stop2 FOREIGN KEY (Stop2ID) REFERENCES Stops(StopID),
ADD CONSTRAINT FK_Stop3 FOREIGN KEY (Stop3ID) REFERENCES Stops(StopID);

-- Create BusScheduleStops table
CREATE TABLE BusScheduleStops (
    ScheduleStopID INT PRIMARY KEY,
    ScheduleID INT, -- Foreign key to link with BusSchedule table
    StopID INT, -- Foreign key to link with Stops table
    ExpectedArrivalTime TIME,
    ActualArrivalTime TIME,
    Lateness INT, -- In minutes
    -- Add other fields as needed
    FOREIGN KEY (ScheduleID) REFERENCES BusSchedule(ScheduleID),
    FOREIGN KEY (StopID) REFERENCES Stops(StopID)
);
-- Alter BusDrivers table to add a feedback column
ALTER TABLE BusDrivers
ADD COLUMN FeedbackRating DECIMAL(3, 2);  -- Assuming a rating out of 5, adjust precision as needed
-- Create a stored procedure to calculate bonus based on average rating
DELIMITER //

CREATE PROCEDURE CalculateDriverBonus()
BEGIN
    UPDATE BusDrivers
    SET Bonus = CASE
        WHEN FeedbackRating >= 4.5 THEN 500  -- Bonus for excellent rating
        WHEN FeedbackRating >= 4.0 THEN 300  -- Bonus for good rating
        ELSE 0  -- No bonus for lower ratings
    END;
END //

DELIMITER ;


-- Create Conductors table
CREATE TABLE Conductors (
    ConductorID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PhoneNumber VARCHAR(20),
    Email VARCHAR(100),
    BusID INT, -- Foreign key to link with Buses table
    FOREIGN KEY (BusID) REFERENCES Buses(BusID)
);

-- Alter BusSchedule table to include ConductorID
ALTER TABLE BusSchedule
ADD COLUMN ConductorID INT, -- Foreign key to link with Conductors table
ADD FOREIGN KEY (ConductorID) REFERENCES Conductors(ConductorID);

-- Alter PassengerBookings table to include ConductorID
ALTER TABLE PassengerBookings
ADD COLUMN ConductorID INT, -- Foreign key to link with Conductors table
ADD FOREIGN KEY (ConductorID) REFERENCES Conductors(ConductorID);

-- Modify Buses table to include seating information
ALTER TABLE Buses
ADD COLUMN SeatingCapacity INT,
ADD COLUMN BookedSeats INT DEFAULT 0;  -- Default to 0, as initially, no seats are booked

-- Modify BusSchedule table to include seating information
ALTER TABLE BusSchedule
ADD COLUMN AvailableSeats INT;  -- Initially set to SeatingCapacity

SET SQL_SAFE_UPDATES = 0;
----------------------------TO BE UPDATED------------------------
-- Update BusSchedule table to set AvailableSeats initially
UPDATE BusSchedule
SET AvailableSeats = (SELECT SeatingCapacity FROM Buses WHERE Buses.BusID = BusSchedule.BusID);
--------------------------------------
CREATE TABLE IF NOT EXISTS PassengerBookings (
    BookingID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    BusID INT,
    RouteID INT,
    ScheduleID INT,
    ConductorID INT,
    ShipmentDate DATE,
    ArrivalDate DATE,
    Status VARCHAR(20),
    SeatNumber INT,
    -- Add other fields as needed
    FOREIGN KEY (BusID) REFERENCES Buses(BusID),
    FOREIGN KEY (RouteID) REFERENCES Routes(RouteID),
    FOREIGN KEY (ScheduleID) REFERENCES BusSchedule(ScheduleID),
    FOREIGN KEY (ConductorID) REFERENCES Conductors(ConductorID)
);

-- Create a procedure to calculate fines for bus arrival times
DELIMITER //

CREATE PROCEDURE CalculateBusFines(IN schedule_id INT)
BEGIN
    DECLARE stop_id INT;
    DECLARE done BOOLEAN DEFAULT FALSE;
    DECLARE arrival_time TIME;
    DECLARE expected_arrival_time TIME;
    DECLARE fine_amount INT DEFAULT 0;

    -- Cursor to iterate through bus stops
    DECLARE cursor_stops CURSOR FOR
        SELECT StopID, ExpectedArrivalTime
        FROM BusScheduleStops
        WHERE ScheduleID = schedule_id;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cursor_stops;

    read_loop: LOOP
        FETCH cursor_stops INTO stop_id, expected_arrival_time;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Get the actual arrival time for the stop
        SELECT ActualArrivalTime INTO arrival_time
        FROM BusScheduleStops
        WHERE ScheduleID = schedule_id AND StopID = stop_id;

        -- Calculate the difference in minutes
        SET @time_difference = TIMESTAMPDIFF(MINUTE, expected_arrival_time, arrival_time);

        -- Calculate fines based on time difference
        IF @time_difference > 5 THEN
            SET fine_amount = fine_amount + 50; -- Fine for being late by more than 5 minutes
        END IF;
    END LOOP;

    -- Check final arrival time and apply additional fines
    SELECT ActualArrivalTime INTO arrival_time
    FROM BusScheduleStops
    WHERE ScheduleID = schedule_id
    ORDER BY StopID DESC
    LIMIT 1;

    -- Calculate the difference in minutes from the expected final arrival time
    SET @time_difference = TIMESTAMPDIFF(MINUTE, expected_arrival_time, arrival_time);

    -- Apply fines for exceeding the final arrival time
    IF @time_difference > 10 THEN
        SET fine_amount = fine_amount + 100 + ((@time_difference - 10) / 5) * 50;
    END IF;

    -- Insert the fine into a fines table or update the BusSchedule table with the fine amount
    -- Example: INSERT INTO Fines (ScheduleID, FineAmount) VALUES (schedule_id, fine_amount);

    CLOSE cursor_stops;
END //

DELIMITER ;


CREATE PROCEDURE BookSeat(
    IN p_CustomerName VARCHAR(100),
    IN p_BusID INT,
    IN p_RouteID INT,
    IN p_ScheduleID INT,
    OUT p_BookingID INT,
    OUT p_Success INT
)
BEGIN
    DECLARE v_AvailableSeats INT;

    -- Check if seats are available
    SELECT AvailableSeats INTO v_AvailableSeats
    FROM BusSchedule
    WHERE ScheduleID = p_ScheduleID;

    IF v_AvailableSeats > 0 THEN
        -- Decrement available seats
        UPDATE BusSchedule
        SET AvailableSeats = AvailableSeats - 1
        WHERE ScheduleID = p_ScheduleID;

        -- Book the seat
        INSERT INTO PassengerBookings (CustomerName, BusID, RouteID, ScheduleID, ShipmentDate, Status)
        VALUES (p_CustomerName, p_BusID, p_RouteID, p_ScheduleID, CURDATE(), 'Booked');

        -- Get the booking ID
        SET p_BookingID = LAST_INSERT_ID();
        SET p_Success = 1;  -- Booking success
    ELSE
        SET p_BookingID = NULL;
        SET p_Success = 0;  -- Booking failed, no available seats
    END IF;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE CancelBooking(
    IN p_BookingID INT,
    OUT p_Success INT
)
BEGIN
    DECLARE v_ScheduleID INT;

    -- Get the ScheduleID associated with the booking
    SELECT ScheduleID INTO v_ScheduleID
    FROM PassengerBookings
    WHERE BookingID = p_BookingID;

    IF v_ScheduleID IS NOT NULL THEN
        -- Increment available seats
        UPDATE BusSchedule
        SET AvailableSeats = AvailableSeats + 1
        WHERE ScheduleID = v_ScheduleID;

        -- Cancel the booking
        UPDATE PassengerBookings
        SET Status = 'Cancelled'
        WHERE BookingID = p_BookingID;

        SET p_Success = 1;  -- Cancellation success
    ELSE
        SET p_Success = 0;  -- Cancellation failed, invalid booking ID
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE GetBusSchedule(
    IN p_BusID INT
)
BEGIN
    SELECT
        bs.ScheduleID,
        r.StartLocation AS DepartureLocation,
        r.EndLocation AS ArrivalLocation,
        bs.DepartureTime,
        bs.ArrivalTime,
        s1.LocationName AS Stop1,
        s2.LocationName AS Stop2,
        s3.LocationName AS Stop3
    FROM
        BusSchedule bs
    JOIN Routes r ON bs.RouteID = r.RouteID
    LEFT JOIN Stops s1 ON r.Stop1ID = s1.StopID
    LEFT JOIN Stops s2 ON r.Stop2ID = s2.StopID
    LEFT JOIN Stops s3 ON r.Stop3ID = s3.StopID
    WHERE
        bs.BusID = p_BusID;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE GetPassengerList(
    IN p_RouteID INT,
    IN p_ScheduleID INT
)
BEGIN
    SELECT
        pb.BookingID,
        pb.CustomerName,
        pb.SeatNumber,
        pb.Status
    FROM
        PassengerBookings pb
    WHERE
        pb.RouteID = p_RouteID
        AND pb.ScheduleID = p_ScheduleID;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE GetDriverInformation(
    IN p_BusID INT
)
BEGIN
    SELECT
        bd.DriverID,
        bd.FirstName,
        bd.LastName,
        bd.LicenseNumber,
        bd.PhoneNumber,
        bd.Email
    FROM
        BusDrivers bd
    WHERE
        bd.BusID = p_BusID;
END //

DELIMITER ;
DELIMITER //

CREATE PROCEDURE GetConductorInformation(
    IN p_BusID INT
)
BEGIN
    SELECT
        c.ConductorID,
        c.FirstName,
        c.LastName,
        c.PhoneNumber,
        c.Email
    FROM
        Conductors c
    WHERE
        c.BusID = p_BusID;
END //

DELIMITER ;



CREATE VIEW DetailedBusScheduleView AS
SELECT
    bs.ScheduleID,
    r.RouteID,
    r.StartLocation AS DepartureLocation,
    r.EndLocation AS ArrivalLocation,
    bs.DepartureTime,
    bs.ArrivalTime,
    s.LocationName AS StopName,
    bss.ExpectedArrivalTime,
    bss.ActualArrivalTime,
    bss.Lateness
FROM
    BusSchedule bs
JOIN Routes r ON bs.RouteID = r.RouteID
JOIN BusScheduleStops bss ON bs.ScheduleID = bss.ScheduleID
JOIN Stops s ON bss.StopID = s.StopID;

CREATE VIEW AvailableBusesView AS
SELECT
    bs.ScheduleID,
    b.BusID,
    b.BusNumber,
    r.RouteID,
    r.StartLocation AS DepartureLocation,
    r.EndLocation AS ArrivalLocation,
    bs.DepartureTime,
    bs.ArrivalTime,
    bs.AvailableSeats
FROM
    BusSchedule bs
JOIN Buses b ON bs.BusID = b.BusID
JOIN Routes r ON bs.RouteID = r.RouteID
WHERE
    bs.AvailableSeats > 0;

CREATE VIEW BookingSummaryView AS
SELECT
    bs.ScheduleID,
    b.BusID,
    b.BusNumber,
    r.RouteID,
    r.StartLocation AS DepartureLocation,
    r.EndLocation AS ArrivalLocation,
    bs.DepartureTime,
    bs.ArrivalTime,
    COUNT(pb.BookingID) AS BookedSeats,
    bs.AvailableSeats AS AvailableSeats,
    b.Capacity AS TotalSeatingCapacity
FROM
    BusSchedule bs
JOIN Buses b ON bs.BusID = b.BusID
JOIN Routes r ON bs.RouteID = r.RouteID
LEFT JOIN PassengerBookings pb ON bs.ScheduleID = pb.ScheduleID AND pb.Status = 'Booked'
GROUP BY
    bs.ScheduleID, b.BusID, b.BusNumber, r.RouteID, r.StartLocation, r.EndLocation, bs.DepartureTime, bs.ArrivalTime, bs.AvailableSeats, b.Capacity;
CREATE VIEW FeedbackSummaryView AS
SELECT
    bd.DriverID,
    bd.FirstName,
    bd.LastName,
    AVG(bd.FeedbackRating) AS AverageRating,
    COUNT(bd.FeedbackRating) AS NumberOfFeedbacks
FROM
    BusDrivers bd
GROUP BY
    bd.DriverID, bd.FirstName, bd.LastName;

CREATE VIEW LateBusSummaryView AS
SELECT
    bs.ScheduleID,
    bss.StopID,
    bss.Lateness
FROM
    BusSchedule bs
JOIN BusScheduleStops bss ON bs.ScheduleID = bss.ScheduleID
WHERE
    bss.Lateness > 0;

CREATE VIEW ConductorScheduleView AS
SELECT
    c.ConductorID,
    c.FirstName,
    c.LastName,
    b.BusID,
    r.RouteID,
    r.StartLocation AS DepartureLocation,
    r.EndLocation AS ArrivalLocation,
    bs.DepartureTime,
    bs.ArrivalTime
FROM
    Conductors c
JOIN BusSchedule bs ON c.ConductorID = bs.ConductorID
JOIN Buses b ON bs.BusID = b.BusID
JOIN Routes r ON bs.RouteID = r.RouteID;



DELIMITER //

CREATE TRIGGER AfterBookingTrigger
AFTER INSERT ON PassengerBookings
FOR EACH ROW
BEGIN
    -- Update available seats after a booking
    UPDATE BusSchedule
    SET AvailableSeats = AvailableSeats - 1
    WHERE ScheduleID = NEW.ScheduleID;
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER AfterCancellationTrigger
AFTER UPDATE ON PassengerBookings
FOR EACH ROW
BEGIN
    -- Update available seats after a cancellation
    IF NEW.Status = 'Cancelled' AND OLD.Status = 'Booked' THEN
        UPDATE BusSchedule
        SET AvailableSeats = AvailableSeats + 1
        WHERE ScheduleID = NEW.ScheduleID;
    END IF;
END //

DELIMITER ;
DELIMITER //

CREATE TRIGGER AfterLateArrivalTrigger
AFTER UPDATE ON BusScheduleStops
FOR EACH ROW
BEGIN
    -- Your logic for handling late arrivals, e.g., update fines table
    -- For simplicity, let's assume you have a Fines table
    IF NEW.Lateness > 5 THEN
        INSERT INTO Fines (ScheduleID, StopID, FineAmount)
        VALUES (NEW.ScheduleID, NEW.StopID, 50);
    END IF;
END //

DELIMITER ;
-- Example: Index on ScheduleID column in BusSchedule table
CREATE INDEX idx_ScheduleID ON BusSchedule(ScheduleID);
-- Add similar indexes on other frequently used columns
DELIMITER //

CREATE PROCEDURE BookSeat(
    IN p_CustomerName VARCHAR(100),
    IN p_BusID INT,
    IN p_RouteID INT,
    IN p_ScheduleID INT,
    OUT p_BookingID INT,
    OUT p_Success INT
)
BEGIN
    DECLARE v_AvailableSeats INT;

    -- Check if seats are available
    SELECT AvailableSeats INTO v_AvailableSeats
    FROM BusSchedule
    WHERE ScheduleID = p_ScheduleID;

    IF v_AvailableSeats > 0 THEN
        -- Decrement available seats
        UPDATE BusSchedule
        SET AvailableSeats = AvailableSeats - 1
        WHERE ScheduleID = p_ScheduleID;

        -- Book the seat
        INSERT INTO PassengerBookings (CustomerName, BusID, RouteID, ScheduleID, ShipmentDate, Status)
        VALUES (p_CustomerName, p_BusID, p_RouteID, p_ScheduleID, CURDATE(), 'Booked');

        -- Get the booking ID
        SET p_BookingID = LAST_INSERT_ID();
        SET p_Success = 1;  -- Booking success
    ELSE
        -- Handle error when no available seats
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No available seats for booking';
    END IF;
END //

DELIMITER ;


