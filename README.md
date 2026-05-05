# 🚌 Bus Booking - Local Bus Routing & Ticketing System

Bus Booking is a premium, high-fidelity mobile application designed to modernize the bus travel experience. Built with **Flutter**, it provides a seamless interface for users to search for travels, book tickets, and manage their journeys.

## ✨ Features

### 📱 Mobile App (Flutter)
- **Premium UI/UX**: Modern, responsive design with glassmorphism, dynamic gradients, and smooth animations.
- **Search & Filter**: Find travels by origin, destination, and date. Filter by bus type and service level.
- **Fleet Selection**: Browse our modern fleet of buses (Luxury Coaster, Isuzu Journey, etc.) before booking.
- **Interactive Ticketing**: High-fidelity digital tickets with visual route maps, seat info, and status tracking.
- **Multi-language Support**: Fully localized in **English** and **Somali**.
- **User Profiles**: Manage personal info, view booking history, and contact support.
- **Real-time Notifications**: Stay updated with travel alerts and booking confirmations.

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **State Management**: Riverpod
- **Backend**: Supabase (PostgreSQL, Auth, Storage) - *Integration in Progress*
- **Theming**: Custom Design System (AppColors, AppTextStyles, AppSpacing)

## 📁 Project Structure

```text
lib/
├── core/               # App configuration, theme, and constants
├── l10n/               # Localization (English/Somali)
├── models/             # Data models
├── providers/          # Riverpod state providers
├── screens/            # UI Screens
│   ├── auth/           # Login & Registration
│   ├── dashboard/      # Home, Notifications
│   ├── search/         # Travels search & fleet selection
│   ├── booking/        # Seat selection & payment
│   ├── tickets/        # My Tickets & Ticket Detail
│   └── profile/        # Settings & User Info
├── services/           # Supabase & API services
└── widgets/            # Reusable custom UI components
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.22+)
- Dart SDK
- Android Studio / VS Code

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/bus-booking.git
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## 🗓️ Roadmap
- [x] High-fidelity Flutter Frontend
- [ ] Supabase Backend Integration
- [ ] React Web Admin Panel Development
- [ ] Push Notifications Implementation
- [ ] Payment Gateway Integration (EVC Plus / Sahal)

---
Developed with ❤️ by the Bus Booking Team.
