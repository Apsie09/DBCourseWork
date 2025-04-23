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