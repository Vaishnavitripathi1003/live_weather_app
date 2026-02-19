# 🌤️ Live Weather App

A beautiful Flutter weather application that provides real-time weather updates with a stunning glassmorphism UI design.

## 📱 Features

- 🌍 **Real-time Weather** - Get current weather conditions for any city
- 🔍 **City Search** - Search and save your favorite cities
- 🌙 **Dark/Light Mode** - Toggle between dark and light themes
- 💬 **Daily Quotes** - Inspirational quotes with weather-based backgrounds
- 📍 **Location-based Weather** - Auto-detect weather for your current location
- 📱 **Responsive Design** - Works perfectly on all screen sizes
- 🎨 **Glassmorphism UI** - Beautiful modern design with blur effects

## 📸 Screenshots

## 📸 Screenshots

<div align="center">
  <img src="screenshot/weather_screen.jpg" width="200" alt="Weather Screen Light">
  <img src="screenshot/weather_screen_dark.jpg" width="200" alt="Weather Screen Dark">
  <img src="screenshot/search_screen_dark.jpg" width="200" alt="Search Screen">
</div>

<div align="center">
  <img src="screenshot/drawer.jpg" width="200" alt="Navigation Drawer">
  <img src="screenshot/rating.jpg" width="200" alt="Rating Dialog">
  <img src="screenshot/rating2.jpg" width="200" alt="Rating Dialog 2">
</div>

<div align="center">
  <img src="screenshot/no_intetnet_light.jpg" width="200" alt="No Internet Light">
  <img src="screenshot/no_internet_dark.jpg" width="200" alt="No Internet Dark">
  <img src="screenshot/about_us.jpg" width="200" height="400" alt="About Screen">
</div>

## 🚀 Tech Stack

- **Flutter** - UI framework
- **Dart** - Programming language
- **BLoC/Cubit** - State management
- **Provider** - State management for specific features
- **Weather API** - Real-time weather data
- **SharedPreferences** - Local data storage
- **Connectivity Plus** - Network connectivity check
- **Geolocator** - Device location services

## 📦 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Vaishnavitripathi1003/live_weather_app.git
   ```

2. **Navigate to project directory**
   ```bash
   cd live_weather_app
   ```

3. **Install dependencies**
   ```bash
   flutter pub get
   ```

4. **Get API Key**
    - Sign up at [OpenWeatherMap](https://openweathermap.org/api)
    - Get your free API key
    - Add it to the project (instructions in code comments)

5. **Run the app**
   ```bash
   flutter run
   ```

## 🏗️ Project Structure

```
live_weather_app/
│
├── 📁 android/                          # Native Android code
├── 📁 ios/                              # Native iOS code
├── 📁 lib/                              # Main source code
│   │
│   ├── 📁 core/                         # Core functionality
│   │   ├── 📁 constants/                 
│   │   │   ├── api_constants.dart        # API URLs, timeouts
│   │   │   └── app_constants.dart        # App version, spacing, fonts
│   │   │
│   │   ├── 📁 routes/                    
│   │   │   ├── app_routes.dart           # Route names
│   │   │   └── route_generator.dart      # Route generator
│   │   │
│   │   ├── 📁 theme/                      
│   │   │   ├── app_colors.dart           # Color palette
│   │   │   └── app_theme.dart            # Light/Dark theme
│   │   │
│   │   └── 📁 utils/                     
│   │       ├── connectivity_helper.dart   # Internet check
│   │       ├── date_formatter.dart        # Date formatting
│   │       ├── location_helper.dart       # Location services
│   │       └── responsive_helper.dart     # Responsive sizing
│   │
│   ├── 📁 data/                          # Data layer
│   │   ├── 📁 datasources/                
│   │   │   ├── quote_remote_datasource.dart
│   │   │   └── weather_remote_datasource.dart
│   │   │
│   │   ├── 📁 models/                     
│   │   │   ├── forecast_model.dart
│   │   │   ├── quote_model.dart
│   │   │   └── weather_model.dart
│   │   │
│   │   ├── 📁 repositories/                
│   │   │   ├── quote_repository.dart
│   │   │   ├── quote_repository_interface.dart
│   │   │   ├── weather_repository.dart
│   │   │   └── weather_repository_interface.dart
│   │   │
│   │   └── 📁 services/                   
│   │       ├── api_service.dart           # API calls
│   │       ├── dio_client.dart             # Dio configuration
│   │       └── network_exception.dart      # Error handling
│   │
│   ├── 📁 presentation/                   # UI layer
│   │   ├── 📁 bloc/                        # BLoC state management
│   │   │   ├── 📁 quote/
│   │   │   │   ├── quote_bloc.dart
│   │   │   │   ├── quote_event.dart
│   │   │   │   └── quote_state.dart
│   │   │   │
│   │   │   ├── 📁 theme/
│   │   │   │   ├── theme_bloc.dart
│   │   │   │   ├── theme_event.dart
│   │   │   │   └── theme_state.dart
│   │   │   │
│   │   │   └── 📁 weather/
│   │   │       ├── weather_bloc.dart
│   │   │       ├── weather_event.dart
│   │   │       └── weather_state.dart
│   │   │
│   │   ├── 📁 providers/                   # Provider state management
│   │   │   └── 📁 home/
│   │   │       ├── home_provider.dart
│   │   │       └── home_state.dart
│   │   │
│   │   ├── 📁 screens/                     # All screens
│   │   │   ├── about_screen.dart
│   │   │   ├── home_screen.dart
│   │   │   ├── search_screen.dart
│   │   │   └── splash_screen.dart
│   │   │
│   │   └── 📁 widgets/                      # Reusable widgets
│   │       ├── app_drawer.dart
│   │       ├── custom_error_widget.dart
│   │       ├── empty_state.dart
│   │       ├── forecast_card.dart
│   │       ├── glassmorphism_card.dart
│   │       ├── loading_widget.dart
│   │       ├── quote_card.dart
│   │       ├── weather_card.dart
│   │       └── weather_chip.dart
│   │
│   └── main.dart                            # App entry point
│
├── 📁 screenshot/                          # App screenshots
│   ├── about_us.jpg
│   ├── drawer.jpg
│   ├── no_internet_dark.jpg
│   ├── no_intetnet_light.jpg
│   ├── rating.jpg
│   ├── rating2.jpg
│   ├── search_screen_dark.jpg
│   ├── weather_screen.jpg
│   └── weather_screen_dark.jpg
│
├── .gitignore                              # Git ignore rules
├── pubspec.yaml                            # Dependencies
└── README.md                               # Project documentation
```

## 🎯 Key Features Explained

### Weather Updates
- Real-time temperature, humidity, wind speed
- 5-day weather forecast
- Weather conditions with icons

### Search Functionality
- Search any city worldwide
- Auto-suggestions while typing
- Save favorite locations

### Theme Support
- Seamless dark/light mode switching
- Persistent theme preference
- Beautiful glassmorphism effects

## 📱 How to Use

1. **Open the app** - Splash screen appears
2. **Allow location** - For current location weather (optional)
3. **Search cities** - Use search icon to find any city
4. **View weather** - See detailed weather information
5. **Toggle theme** - Use drawer to switch dark/light mode
6. **Share app** - Rate and share with friends

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the project
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📧 Contact

**Vaishnavi Tripathi**

- GitHub: [@Vaishnavitripathi1003](https://github.com/Vaishnavitripathi1003)
- Project Link: [https://github.com/Vaishnavitripathi1003/live_weather_app](https://github.com/Vaishnavitripathi1003/live_weather_app)

## 🙏 Acknowledgments

- [OpenWeatherMap API](https://openweathermap.org/api) for weather data
- [Flutter](https://flutter.dev) for the amazing framework
- All contributors and supporters

---

<div align="center">
  Made with ❤️ by Vaishnavi Tripathi
</div>