USE airline_management;

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