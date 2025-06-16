🍽️ Jameia - Recipe Discovery App

Welcome to Jameia, a modern and responsive recipe discovery application built with Flutter.
It features a clean design, rich UI/UX, and a solid, maintainable codebase using Clean Architecture.

✨ Features

✅ Endless Recipe Browsing
Infinite scroll with real-time API fetching.

✅ Responsive UI
Adapts seamlessly across phones, tablets, and desktops (portrait/landscape).

✅ Detailed Recipe View
Full-screen views with ingredients, instructions, and metadata.

✅ Dynamic Font Scaling
Text scales with screen width for better readability.

✅ Light & Dark Theme
Instant theme switching for comfort in all lighting conditions.

✅ Shimmer Loading Effects
Modern loading placeholders while data is being fetched.

✅ Error Handling
User-friendly messages and retry logic for network failures.

🏗️ Architecture & Tech Stack

Follows Clean Architecture for testability and separation of concerns.

🔹 Layers

🎨 Presentation Layer

    UI, Widgets, and Screens

    State management using flutter_bloc

    Libraries: flutter_bloc, shimmer, cached_network_image

🧠 Domain Layer

    Pure business logic (Entities + Use Cases)

    Independent of UI or APIs

    Libraries: dartz, equatable

🌐 Data Layer

    API integration and data mapping

    Implements Domain Repositories

    Libraries: dio, get_it

📦 Dependencies

Package Purpose
flutter_bloc State Management (BLoC Pattern)
dio API Client
get_it Dependency Injection
dartz Functional Programming (Either types)
equatable Value Equality for Dart classes
cached_network_image Efficient image loading & caching
shimmer Beautiful shimmer loading effects
google_fonts Clean, custom fonts
stream_transform Throttling events in streams for BLoC

📁 Project Structure

lib/
├── core/
│ ├── api/ API clients & consumers
│ ├── config/ Theme, Routing, etc.
│ ├── constants/ App-wide constants
│ ├── di/ Dependency injection setup
│ ├── error/ Failures and exceptions
│ ├── presentation/ Shared Cubits and base UIs
│ └── responsive/ Responsive layout helpers
│
├── features/
│ └── recipes/
│ ├── data/ API models, datasources
│ ├── domain/ Entities, use cases, repositories
│ └── presentation/ UI, Widgets, BLoC
│
└── main.dart App entry point

🚀 Getting Started

Prerequisites

    Flutter SDK (>= 3.0.0)

    Dart SDK

Installation

    Clone the repo
    git clone https://github.com/your_username/jameia.git

    Navigate to the project
    cd jameia

    Get dependencies
    flutter pub get

    Run the app
    flutter run

📌 Notes

    Ensure internet connection for recipe fetching.

    Designed to work smoothly across different screen sizes.

💙 Contributing
Pull requests are welcome! For major changes, please open an issue first to discuss what you'd like to change.
