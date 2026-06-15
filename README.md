<div align="center">

# 🏋️ FitFlow

**Your personal workout companion — built with Flutter**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![CI/CD](https://github.com/mohdasadkhan/workout_rep_timer/actions/workflows/deploy.yml/badge.svg)](https://github.com/mohdasadkhan/workout_rep_timer/actions)
[![Platform](https://img.shields.io/badge/Platform-Android-brightgreen?logo=android)](https://play.google.com/store)

**Package ID:** `com.asadcoder.fitness.fitflow`

[Features](#features) • [Architecture](#architecture) • [Tech Stack](#tech-stack) • [Getting Started](#getting-started) • [CI/CD](#cicd-pipeline) • [Screenshots](#screenshots)

</div>

---

## Overview

FitFlow is a production-grade fitness companion app designed for people who take their training seriously. It combines a Tabata-style interval timer, a full workout logging system with personal record tracking, and smart workout reminders — all in a clean, dark-aesthetic UI.

Built from the ground up using **Clean Architecture** and **BLoC state management**, FitFlow is structured for scalability, testability, and long-term maintainability.

---

## Features

### ⏱️ Tabata Interval Timer
- Fully configurable: prepare, work, rest, cycles, sets, inter-set rest, and cool down
- Runs as a **foreground service** — keeps ticking even when the app is in the background
- Live notification with **Pause / Stop** controls
- Workout preview screen before starting a session

### 📋 Rep Tracker
- Log workout sessions with exercises, sets, weight, and reps
- Dynamically add exercises mid-session
- Automatic **Personal Record (PR)** detection across your entire history
- Full session history with date and duration

### 🔔 Smart Workout Reminders
- Set independent reminders for each day of the week
- Each day has its own custom time picker
- Notifications survive app kills and device reboots
- Random rotating notification titles to keep things fresh
- Uses `zonedSchedule` with `DateTimeComponents.dayOfWeekAndTime` for reliable weekly recurrence

### 🌙 Theme Support
- Dark and light mode with persistent preference
- Clean, gym-aesthetic dark UI as the default experience

---

## Architecture

FitFlow follows **Clean Architecture** with a strict 3-layer separation:

```
┌──────────────────────────────────┐
│        PRESENTATION LAYER        │
│  Screens · BLoC · Widgets        │
│  No business logic in UI         │
└──────────────┬───────────────────┘
               │
┌──────────────┴───────────────────┐
│           DOMAIN LAYER           │
│  Entities · Use Cases · Repos    │
│  Pure Dart — zero Flutter deps   │
└──────────────┬───────────────────┘
               │
┌──────────────┴───────────────────┐
│            DATA LAYER            │
│  Repositories · Data Sources     │
│  SharedPreferences / Hive        │
└──────────────────────────────────┘
```

### Project Structure

```
lib/
├── core/
│   ├── theme/          # AppColors, AppTextStyles, AppTheme
│   ├── router/         # GoRouter configuration
│   ├── di/             # GetIt dependency injection
│   ├── constants/      # Shared constants & pref keys
│   ├── failure/        # Error handling (Dartz Either)
│   ├── services/       # Shared services
│   └── widgets/        # Reusable core widgets
│
└── features/
    ├── workout_timer/  # Tabata timer feature
    ├── rep_tracker/    # Session logging + history + PRs
    ├── reminder/       # Scheduled workout notifications
    ├── settings/       # Theme & app preferences
    └── notification/   # FCM + local notification handling
```

Each feature follows the same internal structure:
```
feature/
├── domain/
│   ├── entities/
│   ├── repositories/   # Interfaces only
│   └── usecases/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/   # Implementations
└── presentation/
    ├── bloc/
    ├── screens/
    └── widgets/
```

---

## Tech Stack

| Category | Package | Version |
|---|---|---|
| State Management | `flutter_bloc` | ^9.1.1 |
| Dependency Injection | `get_it` | ^9.2.1 |
| Navigation | `go_router` | ^17.1.0 |
| Local Storage | `shared_preferences` | ^2.5.5 |
| Key-Value DB | `hive` + `hive_flutter` | ^2.2.3 |
| Notifications | `flutter_local_notifications` | ^20.1.0 |
| Background Service | `flutter_foreground_task` | ^9.2.1 |
| Push Notifications | `firebase_messaging` | ^16.1.3 |
| Firebase Core | `firebase_core` | ^4.6.0 |
| Audio | `just_audio` | ^0.10.5 |
| Functional Programming | `dartz` | ^0.10.1 |
| Equality | `equatable` | ^2.0.8 |
| Timezone | `timezone` | ^0.10.1 |
| Internationalization | `intl` | ^0.20.2 |
| Permissions | `permission_handler` | ^12.0.1 |
| Animations | `flutter_staggered_animations` | ^1.1.1 |
| Timeline UI | `timeline_tile` | ^2.0.0 |
| Splash Screen | `flutter_native_splash` | ^2.4.7 |

---

## Getting Started

### Prerequisites
- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio or VS Code
- A Firebase project (for push notifications)

### Setup

```bash
# Clone the repo
git clone https://github.com/mohdasadkhan/workout_rep_timer.git
cd workout_rep_timer

# Install dependencies
flutter pub get

# Run code generation (if needed)
flutter packages pub run build_runner build --delete-conflicting-outputs

# Run on device
flutter run
```

### Firebase Setup

1. Create a project at [Firebase Console](https://console.firebase.google.com)
2. Add an Android app with package name `com.asadcoder.fitness.fitflow`
3. Download `google-services.json` and place it in `android/app/`
4. Enable **Cloud Messaging** in your Firebase project

> ⚠️ `google-services.json` is excluded from version control. Never commit it.

---

## CI/CD Pipeline

FitFlow uses **GitHub Actions** for automated builds and Play Store deployment.

### What the pipeline does:

1. **Trigger** — Runs on every push to the `main` branch
2. **Setup** — Configures Flutter SDK and Java environment
3. **Dependencies** — Installs all pub packages
4. **Secrets injection** — Decodes `google-services.json` from GitHub Secrets
5. **Build** — Compiles a release Android App Bundle (`.aab`)
6. **Deploy** — Uploads the AAB directly to Google Play (Internal / Closed Testing track) via the [Google Play Upload GitHub Action](https://github.com/r0adkll/upload-google-play)

### Secrets required:

| Secret | Description |
|---|---|
| `GOOGLE_SERVICES_JSON` | Base64-encoded `google-services.json` |
| `KEYSTORE_FILE` | Base64-encoded release keystore |
| `KEY_ALIAS` | Keystore key alias |
| `KEY_PASSWORD` | Key password |
| `STORE_PASSWORD` | Keystore store password |
| `SERVICE_ACCOUNT_JSON` | Google Play service account credentials |

---

## Screenshots

> 📸 Coming soon — screenshots will be added after public launch.

---

## Roadmap

- [ ] Migrate from SharedPreferences to Drift (SQLite) for better query performance
- [ ] Add pagination to workout history
- [ ] Unit tests for PR calculation and timer state machine
- [ ] Exercise library with suggested workouts
- [ ] iOS support & App Store release
- [ ] Widget for home screen workout streak

---

## Contributing

Contributions are welcome! Feel free to open an issue or submit a pull request.

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Commit your changes: `git commit -m 'feat: add your feature'`
4. Push to the branch: `git push origin feature/your-feature`
5. Open a Pull Request

---

## Author

**Asad Khan**
- GitHub: [@mohdasadkhan](https://github.com/mohdasadkhan)

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.