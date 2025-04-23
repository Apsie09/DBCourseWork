# flights/forms.py
from django import forms
from .models import Passenger, Aircraft, Flight, Crew, Airport, Booking, CrewAssignment

class PassengerForm(forms.ModelForm):
    class Meta:
        model = Passenger
        fields = ['first_name','last_name','email','phone','passport_number','nationality']
        widgets = {
            'first_name':      forms.TextInput(attrs={'class':'form-control'}),
            'last_name':       forms.TextInput(attrs={'class':'form-control'}),
            'email':           forms.EmailInput(attrs={'class':'form-control'}),
            'phone':           forms.TextInput(attrs={'class':'form-control'}),
            'passport_number': forms.TextInput(attrs={'class':'form-control'}),
            'nationality':     forms.TextInput(attrs={'class':'form-control'}),
        }

class AircraftForm(forms.ModelForm):
    class Meta:
        model = Aircraft
        fields = ['model','capacity']
        widgets = {
            'model':    forms.TextInput(attrs={'class':'form-control'}),
            'capacity': forms.NumberInput(attrs={'class':'form-control'}),
        }

class FlightForm(forms.ModelForm):
    class Meta:
        model = Flight
        fields = [
            'flight_date','departure_time','duration',
            'aircraft','food_type',
            'departure_airport','arrival_airport'
        ]
        labels = {
            'flight_date':       'Flight date',
            'departure_time':    'Departure time',
            'duration':          'Duration (minutes)',
            'aircraft':          'Aircraft',
            'food_type':         'Food type',
            'departure_airport': 'Departure airport',
            'arrival_airport':   'Arrival airport',
        }
        widgets = {
            'flight_date':       forms.DateInput(attrs={'class':'form-control','type':'date'}),
            'departure_time':    forms.TimeInput(attrs={'class':'form-control','type':'time'}),
            'duration':          forms.NumberInput(attrs={'class':'form-control'}),
            'aircraft':          forms.Select(attrs={'class':'form-select'}),
            'food_type':         forms.Select(attrs={'class':'form-select'}),
            'departure_airport': forms.Select(attrs={'class':'form-select'}),
            'arrival_airport':   forms.Select(attrs={'class':'form-select'}),
        }

class CrewForm(forms.ModelForm):
    class Meta:
        model = Crew
        fields = ['name','position','phone','email']
        widgets = {
            'name':     forms.TextInput(attrs={'class':'form-control'}),
            'position': forms.TextInput(attrs={'class':'form-control'}),
            'phone':    forms.TextInput(attrs={'class':'form-control'}),
            'email':    forms.EmailInput(attrs={'class':'form-control'}),
        }

class AirportForm(forms.ModelForm):
    class Meta:
        model = Airport
        fields = ['airport_code','name','city','country']
        widgets = {
            'airport_code': forms.TextInput(attrs={'class':'form-control'}),
            'name':         forms.TextInput(attrs={'class':'form-control'}),
            'city':         forms.TextInput(attrs={'class':'form-control'}),
            'country':      forms.TextInput(attrs={'class':'form-control'}),
        }

class BookingForm(forms.ModelForm):
    class Meta:
        model = Booking
        fields = ['passenger','flight','seat_number']
        widgets = {
            'passenger': forms.Select(attrs={'class':'form-select'}),
            'flight':    forms.Select(attrs={'class':'form-select'}),
            'seat_number': forms.TextInput(attrs={
                'class':'form-control',
                'placeholder':'e.g. 12A'
            }),
        }

class CrewAssignmentForm(forms.ModelForm):
    class Meta:
        model = CrewAssignment
        fields = ['crew', 'flight', 'role']
        widgets = {
            'crew':   forms.Select(attrs={'class':'form-select'}),
            'flight': forms.Select(attrs={'class':'form-select'}),
            'role':   forms.TextInput(attrs={'class':'form-control','placeholder':'e.g. Main Pilot'}),
        }
