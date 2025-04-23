USE airline_management;

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



