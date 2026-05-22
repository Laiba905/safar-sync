# Safar Sync 🌍✈️

Safar Sync is a modern travel social platform built with Flutter. It helps travelers plan collaborative trips, manage group expenses, track real-time weather, and stay connected with friends.

## 🚀 Features

- **Collaborative Trip Planning**: Create trips and invite friends to join.
- **Real-time Weather Forecast**: Integrated weather updates for your trip destinations using OpenWeatherMap API.
- **Group Expense Management**: Track shared costs, see who paid for what, and split bills easily.
- **Integrated Group Chat**: Real-time messaging within trip groups (In Progress).
- **Interactive Maps**: Launch Google Maps directly from your trip cards to navigate to destinations.
- **SafarAI**: AI-powered trip planning assistance (Coming Soon).
- **Social Networking**: Connect with friends, send friend requests, and manage your travel network.

## 🛠️ Tech Stack

- **Framework**: [Flutter](https://flutter.dev/)
- **Backend**: [Firebase](https://firebase.google.com/) (Auth, Firestore, Storage)
- **State Management**: [Provider](https://pub.dev/packages/provider)
- **APIs**: 
  - Google Maps SDK
  - OpenWeatherMap API
  - Google Static Maps API (for card backgrounds)

## 📦 Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/YOUR_USERNAME/safar-sync.git
   cd safar-sync
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase:**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com/).
   - Add Android, iOS, and Web apps.
   - Download and place `google-services.json` and `GoogleService-Info.plist` in the respective directories.
   - Run `flutterfire configure` if you have the FlutterFire CLI.

4. **API Keys:**
   - Add your Google Maps API key in `AndroidManifest.xml`, `AppDelegate.swift`, and `index.html`.
   - Ensure the OpenWeatherMap API key is set in `TripProvider`.

5. **Run the app:**
   ```bash
   flutter run
   ```

## 📸 Screenshots

| Home Feed | Trip Details | Weather Forecast |
|-----------|--------------|------------------|
| *Coming Soon* | *Coming Soon* | *Coming Soon* |

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
