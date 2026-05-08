package main

import (
	"log"
	"net/http"
	"os"

	"github.com/ahmedOsman64/bus-booking-backend/internal/db"
	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
)

func main() {
	// Load .env file
	if err := godotenv.Load(); err != nil {
		log.Println("No .env file found, using system environment variables")
	}

	// Initialize Database
	db.InitDB()
	defer db.CloseDB()

	// Initialize Router
	router := gin.Default()

	// Basic Health Check
	router.GET("/health", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"status":  "up",
			"message": "Bus Booking API is running",
		})
	})

	// TODO: Add routes for Users, Buses, Routes, Bookings
	// Example:
	// router.GET("/buses", handlers.GetBuses)
	// router.POST("/bookings", handlers.CreateBooking)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	log.Printf("Server starting on port %s", port)
	if err := router.Run(":" + port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}
