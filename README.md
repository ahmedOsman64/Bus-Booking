# 🚌 Bus Booking - Local Bus Routing & Ticketing System

Bus Booking is a premium, high-fidelity mobile application designed to modernize the bus travel experience. Built with **Flutter** and **Supabase**, it provides a seamless interface for users to search for travels, book tickets, and manage their journeys in real-time.

## ✨ Features

### 📱 Mobile App (Flutter)
- **Premium UI/UX**: Modern, responsive design with glassmorphism, dynamic gradients, and smooth animations.
- **Search & Filter**: Find travels by origin, destination, and date. Filter by bus type and service level.
- **Fleet Selection**: Browse our modern fleet of buses (Luxury Coaster, Isuzu Journey, etc.) before booking.
- **Interactive Ticketing**: High-fidelity digital tickets with visual route maps, seat info, and status tracking.
- **Multi-language Support**: Fully localized in **English** and **Somali**.
- **User Profiles**: Manage personal info, view booking history, and contact support.
- **Real-time Notifications**: Stay updated with travel alerts and booking confirmations.

### 🔐 Administrative Portal
- **Fleet Management**: Add, update, and manage bus details and status.
- **Route Management**: Define travel routes, schedules, and pricing.
- **Booking Monitoring**: Real-time view of all passenger reservations with status management (Confirm/Cancel).
- **User Management**: Oversee registered users and their profiles.

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod (Reactive state handling)
- **Backend**: Supabase (PostgreSQL, Auth, RLS Security)
- **Database Architecture**: Robust PostgreSQL schema with performance indexing and Row-Level Security.
- **Theming**: Custom Premium Design System (AppColors, AppTextStyles, AppSpacing).

## 📁 Project Structure

```text
lib/
├── core/               # App configuration, theme, and constants
│   ├── models/         # Centralized data models
│   ├── providers/      # Riverpod state providers
│   ├── services/       # Supabase & Auth services
│   └── theme/          # Premium Design System
├── l10n/               # Localization (English/Somali)
├── screens/            # UI Screens
│   ├── admin/          # Administrative Dashboard & Views
│   ├── auth/           # Login, Registration & Password Recovery
│   ├── dashboard/      # Home, Notifications
│   ├── search/         # Travels search & fleet selection
│   ├── booking/        # Seat selection & passenger info
│   ├── tickets/        # My Tickets & Ticket Detail
│   └── profile/        # Settings & User Info
└── widgets/            # Reusable custom UI components
database/               # SQL Schemas and RLS Policies
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.22+)
- Supabase Account & Project

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/ahmedOsman64/Bus-Booking.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. **Database Setup**:
   - Create a new project in [Supabase](https://supabase.com/).
   - Copy the contents of `database/schema.sql` and run it in the Supabase SQL Editor.
   - This will set up the tables (`profiles`, `buses`, `routes`, `bookings`) and RLS policies.
4. **Environment Setup**:
   - Update `lib/core/services/supabase_service.dart` with your `supabaseUrl` and `supabaseAnonKey`.
5. Run the application:
   ```bash
   flutter run
   ```

## 🗓️ Roadmap
- [x] High-fidelity Flutter Frontend
- [x] Supabase Backend Integration (Auth & Database)
- [x] Administrative Dashboard (CRUD Operations)
- [ ] Push Notifications Implementation
- [ ] Payment Gateway Integration (EVC Plus / Sahal / eDahab)
- [ ] Analytics & Reporting for Admin

---
Developed with ❤️ for a better travel experience.
