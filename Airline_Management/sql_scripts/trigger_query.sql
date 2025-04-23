USE airline_management;

-- Тригер върху таблицата Bookings, който автоматично превръща 
-- seat_number в главни букви и не използва допълнителна таблица.
DELIMITER $$

CREATE TRIGGER trg_before_booking_insert
BEFORE INSERT ON Bookings
FOR EACH ROW
BEGIN
  -- Превръщаме seat_number в главни букви
  SET NEW.seat_number = UPPER(NEW.seat_number);
END$$

DELIMITER ;

-- Тестова INSERT заявка
INSERT INTO Bookings (passenger_id, flight_id, seat_number)
VALUES (3, 1, 'a2b');
-- Резултат
SELECT booking_id, seat_number
FROM Bookings
WHERE booking_id = LAST_INSERT_ID();