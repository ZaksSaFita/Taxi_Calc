# 🚕 Taxi Calc

> A powerful, cross-platform earnings tracker for taxi drivers. Monitor daily, weekly, monthly, and yearly income with an intuitive and modern interface.

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.11%2B-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.11%2B-blue?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)
![Status](https://img.shields.io/badge/Status-Active%20Development-orange)

[Features](#-features) • [Platforms](#-supported-platforms) • [Installation](#-installation) • [Usage](#-usage) • [Documentation](#-documentation)

</div>

---

## 🎯 About

**Taxi Calc** is a comprehensive earnings management application designed specifically for taxi drivers and ride-share professionals. Track your income, manage driver documents, monitor services, and gain insights into your earnings with detailed analytics and statistics.

The app is built with **Flutter** for optimal performance across all platforms and uses **Drift** (SQLite) for secure local data storage.

---

## ✨ Features

### 📊 Earnings Tracking
- **Daily Earnings** - Track income by individual day
- **Weekly Earnings** - Monitor weekly performance and trends
- **Monthly Earnings** - Detailed monthly financial overview
- **Yearly Earnings** - Annual earnings analysis and comparison

### 📋 Advanced Management
- **Document Management** - Track driver licenses, vehicle documents, insurance, etc.
  - Status tracking (active, expiring soon, expired)
  - Document expiration alerts
  - Organized document library

- **Services** - Manage vehicle services and maintenance
  - Service history tracking
  - Cost management
  - Service reminders

- **Entry Management** - Add and edit individual earnings entries
  - Quick entry creation
  - Edit historical entries
  - Detailed tracking

### ⚙️ Additional Features
- 🎨 **Modern UI** - Clean, intuitive interface with smooth animations
- 🌍 **Multi-language Support** - Localization support for global users
- 💾 **Offline-First** - All data stored securely on device with SQLite
- 🔄 **Real-time Sync** - Instant updates across the app
- 📱 **Responsive Design** - Optimized for all screen sizes
- 🎯 **Cross-Platform** - Seamless experience across all platforms

---

## 🖥️ Supported Platforms

| Platform | Status | Version |
|----------|--------|---------|
| 🍎 iOS | ✅ Supported | 11.0+ |
| 🤖 Android | ✅ Supported | 5.0+ |
| 🌐 Web | ✅ Supported | Chrome, Firefox, Safari |
| 🐧 Linux | ✅ Supported | Modern distributions |
| 🍏 macOS | ✅ Supported | 10.15+ |
| 🪟 Windows | ✅ Supported | 10+ |

---

## 🚀 Installation

### Prerequisites
- **Flutter SDK** 3.11.3 or higher
- **Dart SDK** 3.11.3 or higher
- Platform-specific requirements (Android SDK, Xcode, etc.)

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/taxi_calc.git
cd taxi_calc
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate database code** (if needed)
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **Run the app**
```bash
flutter run
```

---

## 💻 Usage

### Running on Different Platforms

**Android**
```bash
flutter run -d device_name
```

**iOS**
```bash
flutter run -d device_name
```

**Web**
```bash
flutter run -d chrome
```

**Desktop (Windows, macOS, Linux)**
```bash
flutter run -d windows
# or
flutter run -d macos
# or
flutter run -d linux
```

### Building for Release

**Android**
```bash
flutter build apk
# or for app bundle
flutter build appbundle
```

**iOS**
```bash
flutter build ios
```

**Web**
```bash
flutter build web
```

---

## 🏗️ Project Structure

```
lib/
├── main.dart                 # App entry point
├── core/
│   └── localization/        # Multi-language support
├── data/
│   ├── database.dart        # Drift database configuration
│   ├── providers/           # Data providers & state management
│   └── tables/              # Database table definitions
├── layout_screen/
│   └── master_screen.dart   # Main navigation layout
├── screens/                 # Application screens
│   ├── home.dart           # Home dashboard
│   ├── daily.dart          # Daily earnings
│   ├── weekly.dart         # Weekly earnings
│   ├── monthly.dart        # Monthly earnings
│   ├── yearly.dart         # Yearly earnings
│   ├── add_entry.dart      # Entry creation/editing
│   ├── documents.dart      # Document management
│   ├── services.dart       # Service tracking
│   └── settings.dart       # App settings
├── theme/
│   └── app_theme.dart      # Theme configuration
├── utilities/
│   └── transition.dart     # Navigation transitions
└── widgets/                # Reusable components
    └── animated_card.dart  # Custom widgets
```

---

## 📦 Key Dependencies

| Package | Purpose | Version |
|---------|---------|---------|
| `flutter` | UI Framework | 3.11.3+ |
| `drift` | Database ORM | 2.32.1+ |
| `go_router` | Navigation | 17.2.0+ |
| `intl` | Internationalization | 0.20.2+ |
| `shared_preferences` | User preferences | 2.5.3+ |
| `path_provider` | File path access | 2.1.5+ |
| `sqlite3_flutter_libs` | SQLite support | 0.6.0+ |
| `auto_size_text` | Responsive text | 3.0.0+ |

---

## 🔧 Development

### Code Generation
The project uses `build_runner` for code generation (Drift models, etc.).

```bash
# Generate code
dart run build_runner build

# Watch mode for development
dart run build_runner watch
```

### Code Quality
```bash
# Format code
dart format .

# Analyze code
flutter analyze

# Run tests
flutter test
```

---

## 📝 Database

Taxi Calc uses **Drift** (formerly moor) for database management:

- ✅ Type-safe queries
- ✅ Auto-migration support
- ✅ SQLite backend
- ✅ Local-first data storage

Tables include:
- **DailyEntries** - Individual earning entries
- **Documents** - Driver documents and licenses
- **Services** - Vehicle service history

---

## 🐛 Known Issues & In-Progress

- Documents screen UI completed (database integration in progress)
- Build runner and Dart format processes require optimization in certain environments

See [NEXT_STEPS_DOCUMENTS.md](./NEXT_STEPS_DOCUMENTS.md) for detailed development notes.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 💬 Support

For support, please:
- 📧 Open an issue on GitHub
- 💭 Discuss in the discussions section
- 📖 Check existing documentation

---

## 🙏 Acknowledgments

- **Flutter Team** - Amazing framework
- **Drift** - Powerful database solution
- **Go Router** - Elegant navigation
- **Community** - Continued support and feedback

---

<div align="center">

Made with ❤️ for taxi drivers and ride-share professionals

[⬆ Back to Top](#-taxi-calc)

</div>
