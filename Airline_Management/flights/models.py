from django.db import models

class Airport(models.Model):
    airport_code = models.CharField(primary_key=True, max_length=3)
    name = models.CharField(max_length=45)
    city = models.CharField(max_length=45)
    country = models.CharField(max_length=45)

    class Meta:
        managed = False
        db_table = 'Airports'

    def __str__(self):
        return f"{self.airport_code} — {self.name}"


class Aircraft(models.Model):
    aircraft_id = models.AutoField(primary_key=True)
    model = models.CharField(max_length=45)
    capacity = models.IntegerField()

    class Meta:
        managed = False
        db_table = 'Aircraft'

    def __str__(self):
        return f"{self.model} (ID {self.aircraft_id})"


class FoodType(models.Model):
    food_type_id = models.AutoField(primary_key=True)
    description = models.CharField(max_length=100)

    class Meta:
        managed = False
        db_table = 'Food_Types'

    def __str__(self):
        return self.description


class Flight(models.Model):
    flight_id = models.AutoField(primary_key=True)
    flight_date = models.DateField()
    departure_time = models.TimeField()
    duration = models.IntegerField()
    aircraft = models.ForeignKey(Aircraft, on_delete=models.CASCADE, db_column='aircraft_id')
    food_type = models.ForeignKey(FoodType, on_delete=models.SET_NULL, null=True, db_column='food_type_id')
    departure_airport = models.ForeignKey(
        Airport,
        on_delete=models.CASCADE,
        related_name='departures',
        db_column='departure_airport'
    )
    arrival_airport = models.ForeignKey(
        Airport,
        on_delete=models.CASCADE,
        related_name='arrivals',
        db_column='arrival_airport'
    )

    class Meta:
        managed = False
        db_table = 'Flights'

    def __str__(self):
        return f"#{self.flight_id} on {self.flight_date} at {self.departure_time}"



class Crew(models.Model):
    crew_id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=100)
    position = models.CharField(max_length=45)
    phone = models.CharField(max_length=15)
    email = models.EmailField()

    class Meta:
        managed = False
        db_table = 'Crew'

    def __str__(self):
        return self.name + f" ({self.position})"


class CrewAssignment(models.Model):

    crew = models.ForeignKey(
        Crew,
        on_delete=models.CASCADE,
        db_column='crew_id',
        primary_key=True
    )
    flight = models.ForeignKey(
        Flight,
        on_delete=models.CASCADE,
        db_column='flight_id'
    )
    role = models.CharField(max_length=45)

    class Meta:
        managed = False
        db_table = 'Crew_Assignments'
        unique_together = ("crew", "flight", "role")



class Passenger(models.Model):
    passenger_id = models.AutoField(primary_key=True)
    first_name = models.CharField(max_length=45)
    last_name = models.CharField(max_length=45)
    email = models.EmailField(unique=True)
    phone = models.CharField(max_length=15)
    passport_number = models.CharField(max_length=20, unique=True)
    nationality = models.CharField(max_length=45)

    class Meta:
        managed = False
        db_table = 'Passengers'

    def __str__(self):
        return f"{self.first_name} {self.last_name} (ID {self.passenger_id})"


class Booking(models.Model):
    booking_id = models.AutoField(primary_key=True)
    passenger = models.ForeignKey(Passenger, on_delete=models.CASCADE)
    flight = models.ForeignKey(Flight, on_delete=models.CASCADE)
    seat_number = models.CharField(max_length=5)
    booking_date = models.DateTimeField(auto_now_add=True)

    class Meta:
        managed = False
        db_table = 'Bookings'
        unique_together = (('flight', 'seat_number'),)
