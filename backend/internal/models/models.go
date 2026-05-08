package models

import (
	"time"
)

type UserRole string

const (
	RolePassenger UserRole = "passenger"
	RoleDriver    UserRole = "driver"
	RoleAdmin     UserRole = "admin"
)

type UserStatus string

const (
	StatusActive   UserStatus = "active"
	StatusInactive UserStatus = "inactive"
)

type Profile struct {
	ID            string     `json:"id" db:"id"`
	FirstName     string     `json:"first_name" db:"first_name"`
	LastName      string     `json:"last_name" db:"last_name"`
	Email         string     `json:"email" db:"email"`
	PhoneNumber   string     `json:"phone_number" db:"phone_number"`
	Role          UserRole   `json:"role" db:"role"`
	Status        UserStatus `json:"status" db:"status"`
	AdminCategory string     `json:"admin_category,omitempty" db:"admin_category"`
	ProfileImage  string     `json:"profile_image,omitempty" db:"profile_image"`
	LastActive    time.Time  `json:"last_active" db:"last_active"`
	CreatedAt     time.Time  `json:"created_at" db:"created_at"`
}

type Bus struct {
	ID          string    `json:"id" db:"id"`
	BusNumber   string    `json:"bus_number" db:"bus_number"`
	PlateNumber string    `json:"plate_number" db:"plate_number"`
	TotalSeats  int       `json:"total_seats" db:"total_seats"`
	BusType     string    `json:"bus_type" db:"bus_type"`
	Status      string    `json:"status" db:"status"`
	CreatedAt   time.Time `json:"created_at" db:"created_at"`
}

type Route struct {
	ID                string    `json:"id" db:"id"`
	Origin            string    `json:"origin" db:"origin"`
	Destination       string    `json:"destination" db:"destination"`
	BasePrice         float64   `json:"base_price" db:"base_price"`
	EstimatedDuration string    `json:"estimated_duration" db:"estimated_duration"`
	CreatedAt         time.Time `json:"created_at" db:"created_at"`
}

type Trip struct {
	ID            string     `json:"id" db:"id"`
	RouteID       string     `json:"route_id" db:"route_id"`
	BusID         string     `json:"bus_id" db:"bus_id"`
	DepartureTime time.Time  `json:"departure_time" db:"departure_time"`
	ArrivalTime   *time.Time `json:"arrival_time,omitempty" db:"arrival_time"`
	Status        string     `json:"status" db:"status"`
	Price         float64    `json:"price" db:"price"`
	CreatedAt     time.Time  `json:"created_at" db:"created_at"`
}

type Booking struct {
	ID             string    `json:"id" db:"id"`
	TripID         string    `json:"trip_id" db:"trip_id"`
	PassengerID    string    `json:"passenger_id" db:"passenger_id"`
	PassengerName  string    `json:"passenger_name" db:"passenger_name"`
	PassengerPhone string    `json:"passenger_phone" db:"passenger_phone"`
	SeatNumbers    []int     `json:"seat_numbers" db:"seat_numbers"`
	TotalFare      float64   `json:"total_fare" db:"total_fare"`
	Status         string    `json:"status" db:"status"`
	CreatedAt      time.Time `json:"created_at" db:"created_at"`
}
