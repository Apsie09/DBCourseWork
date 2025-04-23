CREATE DATABASE airline_management;
USE airline_management;

CREATE TABLE Airports (
    airport_code CHAR(3) PRIMARY KEY,
    name VARCHAR(45),
    city VARCHAR(45),
    country VARCHAR(45)
);

CREATE TABLE Aircraft (
    aircraft_id INT AUTO_INCREMENT PRIMARY KEY,
    model VARCHAR(45),
    capacity INT
);

CREATE TABLE Food_Types (
    food_type_id INT AUTO_INCREMENT PRIMARY KEY,
    description VARCHAR(100)
);

CREATE TABLE Flights (
    flight_id INT AUTO_INCREMENT PRIMARY KEY,
    flight_date DATE,
    departure_time TIME,
    duration INT,
    aircraft_id INT,
    food_type_id INT,
    departure_airport CHAR(3),
    arrival_airport CHAR(3),
    FOREIGN KEY (aircraft_id) REFERENCES Aircraft(aircraft_id),
    FOREIGN KEY (food_type_id) REFERENCES Food_Types(food_type_id),
    FOREIGN KEY (departure_airport) REFERENCES Airports(airport_code),
    FOREIGN KEY (arrival_airport) REFERENCES Airports(airport_code)
);

CREATE TABLE Crew (
    crew_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100),
    position VARCHAR(45),
    phone VARCHAR(15),
    email VARCHAR(100)
);

CREATE TABLE Crew_Assignments (
    crew_id INT,
    flight_id INT,
    role VARCHAR(45),
    PRIMARY KEY (crew_id, flight_id),
    FOREIGN KEY (crew_id) REFERENCES Crew(crew_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id)
);

CREATE TABLE Passengers (
    passenger_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(45),
    last_name VARCHAR(45),
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    passport_number VARCHAR(20) UNIQUE,
    nationality VARCHAR(45)
);

CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    passenger_id INT,
    flight_id INT,
    seat_number VARCHAR(5),
    booking_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (passenger_id) REFERENCES Passengers(passenger_id),
    FOREIGN KEY (flight_id) REFERENCES Flights(flight_id),
    UNIQUE (flight_id, seat_number)
);

-- Попълване на базата с тестови данни

INSERT INTO Airports VALUES
('SOF', 'Sofia Airport', 'Sofia', 'Bulgaria'),
('LHR', 'Heathrow', 'London', 'UK');

INSERT INTO Aircraft (model, capacity) VALUES
('Boeing 737', 180),
('Airbus A320', 150);

INSERT INTO Food_Types (description) VALUES
('Economy Class Meal'),
('Business Class Meal');

INSERT INTO Flights (flight_date, departure_time, duration, aircraft_id, food_type_id, departure_airport, arrival_airport) VALUES
('2024-06-01', '10:00', 120, 1, 1, 'SOF', 'LHR'),
('2024-06-02', '15:00', 180, 2, 2, 'LHR', 'SOF');

INSERT INTO Crew (name, position, phone, email) VALUES
('Ivan Petrov', 'Pilot', '0888123456', 'ivan.petrov@example.com'),
('Anna Dimitrova', 'Flight Attendant', '0888654321', 'anna.dimitrova@example.com');

INSERT INTO Crew (crew_id, name, position, phone, email) VALUES
(3, 'Asen Popov', 'Pilot', '0888123478', 'asen.popov@example.com');

INSERT INTO Crew_Assignments (crew_id, flight_id, role) VALUES
(1, 1, 'Main Pilot'),
(2, 1, 'Cabin Crew'),
(3, 1, 'Main Pilot');

INSERT INTO Passengers (first_name, last_name, email, phone, passport_number, nationality) VALUES
('Petar', 'Ivanov', 'petar.ivanov@example.com', '0888123000', 'BG12345', 'Bulgaria'),
('Elena', 'Stoyanova', 'elena.stoyanova@example.com', '0888999888', 'BG67890', 'Bulgaria');

INSERT INTO Bookings (passenger_id, flight_id, seat_number) VALUES
(1, 1, '15A'),
(2, 1, '15B');

-- Извеждане на разписанията на полетите
SELECT f.flight_id, f.flight_date, f.departure_time, f.duration,
		da.name as departure_airport,
		aa.name as arrival_airport,
        a.model as aircraft_model,
        ft.description as food_type
FROM Flights f
JOIN Airports da ON f.departure_airport = da.airport_code
JOIN Airports aa on f.arrival_airport = aa.airport_code
JOIN Aircraft a on f.aircraft_id = a.aircraft_id
JOIN Food_Types ft ON f.food_type_id = ft.food_type_id
ORDER BY f.flight_date, f.departure_time;

-- Извеждане на нарядите на пилотите
SELECT c.name as pilot_name,
		f.flight_id,
        f.flight_date,
        f.departure_time,
        ca.role
FROM Crew c
JOIN Crew_Assignments ca ON ca.crew_id = c.crew_id
JOIN Flights f ON f.flight_id = ca.flight_id
WHERE c.position = 'Pilot'
ORDER BY f.flight_date, f.departure_time;

-- Намиране на свободни членове на екипажа за даден полет и роля
SELECT crew_id, name, position FROM CREW
WHERE position = 'Pilot' -- позицията, за която търсим заместник
AND crew_id NOT IN(
	SELECT ca.crew_id FROM Crew_Assignments ca
    JOIN Flights f ON f.flight_id = ca.flight_id
    WHERE f.flight_date = '2024-06-02' -- дата на полета, за който търсим заместник
);

-- Допълнителни заявки:
	-- Списък с пътниците за определен полет
SELECT p.first_name, p.last_name, b.seat_number
FROM Passengers p
JOIN Bookings b ON p.passenger_id = b.passenger_id
WHERE b.flight_id = 1;

	-- Извеждане на всички полети с техните заети и свободни места
SELECT f.flight_id, f.flight_date, COUNT(b.booking_id) AS booked_seats, a.capacity,
(a.capacity - COUNT(b.booking_id)) AS available_seats
FROM Flights f
LEFT JOIN Bookings b ON f.flight_id = b.flight_id
JOIN Aircraft a ON f.aircraft_id = a.aircraft_id
GROUP BY f.flight_id;


-- (1) Изключваш проверките за FK, за да може да ъпдейтнеш PK полето
SET FOREIGN_KEY_CHECKS = 0;

-- (2) Ако имаш reference в свързващи таблици (Crew_Assignments):
UPDATE Crew_Assignments
   SET crew_id = 4
 WHERE crew_id = 7;

-- (3) Преномерираш самата таблица Crew
UPDATE Crew
   SET crew_id = 4
 WHERE crew_id = 7;

-- (4) Нулираш AUTO_INCREMENT да стартира от следващото свободно число (5)
ALTER TABLE Crew AUTO_INCREMENT = 5;

-- (5) Включваш обратно проверките за FK
SET FOREIGN_KEY_CHECKS = 1;

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
VALUES (1, 1, 'b3c');
-- Резултат
SELECT booking_id, seat_number
FROM Bookings
WHERE booking_id = LAST_INSERT_ID();

-- Процедура с временна таблица, която дава отчет за полетите и общите заети места в тях
DELIMITER $$

CREATE PROCEDURE sp_monthly_report_temp(
    IN p_month INT,
    IN p_year  INT
)
BEGIN
  DECLARE done INT DEFAULT 0;
  DECLARE v_fid  INT;
  DECLARE v_count INT;

  -- 1) курсорът за всички полети в месеца/годината
  DECLARE cur1 CURSOR FOR
    SELECT flight_id
      FROM Flights
     WHERE MONTH(flight_date)=p_month
       AND YEAR(flight_date)=p_year;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  -- 2) създаваме временната таблица в рамките на сесията
  CREATE TEMPORARY TABLE IF NOT EXISTS temp_flight_stats (
    flight_id    INT PRIMARY KEY,
    booked_seats INT
  ) ENGINE=MEMORY;

  -- 3) обхождаме полетите и пълним temp таблицата
  OPEN cur1;
  read_loop: LOOP
    FETCH cur1 INTO v_fid;
    IF done THEN 
      LEAVE read_loop;
    END IF;

    SELECT COUNT(*) INTO v_count
      FROM Bookings
     WHERE flight_id = v_fid;

    INSERT INTO temp_flight_stats(flight_id, booked_seats)
    VALUES (v_fid, v_count);
  END LOOP;
  CLOSE cur1;

  -- 4) връщаме резултатите
  SELECT * FROM temp_flight_stats;

END$$

DELIMITER ;

TRUNCATE TABLE temp_flight_stats;

CALL sp_monthly_report_temp(6, 2024);

DELIMITER $$

CREATE PROCEDURE sp_monthly_meal_report(
    IN p_month INT,
    IN p_year  INT
)
BEGIN
  DECLARE done       INT DEFAULT 0;
  DECLARE v_ft_id     INT;
  DECLARE v_count     INT;
  DECLARE v_desc      VARCHAR(100);

  -- 1) курсор за всички различни food_type_id в зададения период
  DECLARE cur_ft CURSOR FOR
    SELECT DISTINCT food_type_id
      FROM Flights
     WHERE MONTH(flight_date) = p_month
       AND YEAR(flight_date)  = p_year;

  DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

  -- 2) временна таблица за съхранение на резултатите
  CREATE TEMPORARY TABLE IF NOT EXISTS temp_meal_stats (
    food_type_id INT PRIMARY KEY,
    description  VARCHAR(100),
    meal_count   INT
  ) ENGINE=MEMORY;

  -- 3) обхождаме типовете храна и смятаме броя поръчки
  OPEN cur_ft;
  read_loop: LOOP
    FETCH cur_ft INTO v_ft_id;
    IF done THEN 
      LEAVE read_loop;
    END IF;

    SELECT description INTO v_desc 
      FROM Food_Types 
     WHERE food_type_id = v_ft_id;

    SELECT COUNT(b.booking_id) INTO v_count
      FROM Flights f
      LEFT JOIN Bookings b ON f.flight_id = b.flight_id
     WHERE f.food_type_id = v_ft_id
       AND MONTH(f.flight_date) = p_month
       AND YEAR(f.flight_date)  = p_year;

    INSERT INTO temp_meal_stats
    VALUES (v_ft_id, v_desc, v_count);
  END LOOP;
  CLOSE cur_ft;

  -- 4) връщаме резултатите
  SELECT * FROM temp_meal_stats;

  -- 5) изчистваме временната таблица
  DROP TEMPORARY TABLE temp_meal_stats;
END$$

DELIMITER ;

CALL sp_monthly_meal_report(6, 2024);






