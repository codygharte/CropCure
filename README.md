# Crop Cure - Plant Disease Detection App
![Purple Pink Gradient Mobile Application Presentation](https://github.com/user-attachments/assets/7aa443b0-bfaa-4030-a633-03aadc1d376b)


A Flutter application for detecting plant diseases using AI technology, built with the BLoC pattern for state management.

## Features

### Authentication
- **Login**: Secure user authentication with email and password
- **Register**: User registration with form validation
- **Logout**: Secure logout functionality
- **Persistent Login**: Users stay logged in across app restarts

### Home Screen
- **AI Plant Scanner**: Large, prominent card for plant disease detection
  - Take Photo: Capture images using device camera
  - Upload Photo: Select images from gallery
- **Search Bar**: Search functionality for plants and diseases
- **Scanned Plants List**: Display previously scanned plants with:
  - Plant name and detected disease
  - Visual thumbnails
  - View details functionality

### Navigation
- **Bottom Navigation Bar**: Easy access to main features
  - Home: Main dashboard
  - Scan: Plant scanning functionality
  - Chat: AI chat assistant (placeholder)
  - Profile: User profile and settings

## Architecture

The app follows the **BLoC (Business Logic Component)** pattern for state management:

### Data Layer
- **Data Sources**: `AuthRemoteDataSource` - Handles API communication
- **Repositories**: `AuthRepository` - Manages data flow and local storage
- **Models**: User authentication data structures

### Logic Layer
- **BLoC**: `AuthBloc` - Manages authentication state
- **Events**: `LoginRequested`, `RegisterRequested`, `LoggedOut`, `AppStarted`
- **States**: `Authenticated`, `Unauthenticated`, `AuthLoading`, `AuthFailure`

### Presentation Layer
- **Screens**: Login, Register, Home, Profile, Scan, Chat
- **Widgets**: Reusable UI components
- **Navigation**: Bottom navigation and screen routing

## API Integration

The app is designed to work with a REST API for authentication:

### Endpoints
- `POST /auth/login` - User login
- `POST /auth/register` - User registration
- `POST /auth/logout` - User logout

### API Configuration
Update the `_baseUrl` in `lib/data/data_sources/auth_remote_data_source.dart`:

```dart
final String _baseUrl = "https://your-api-url.com/api";
```

### Mock Data
For development and testing, the app includes mock authentication that works with:
- Email: `test@test.com`
- Password: `password`

## Dependencies

### Core
- `flutter_bloc: ^8.1.3` - State management
- `equatable: ^2.0.5` - Value equality

### API & Storage
- `http: ^1.1.0` - HTTP requests
- `flutter_secure_storage: ^9.0.0` - Secure token storage

### UI & Navigation
- `image_picker: ^1.0.4` - Camera and gallery access
- `cached_network_image: ^3.3.0` - Image caching
- `google_fonts: ^6.3.1` - Custom fonts

## Getting Started

### Prerequisites
- Flutter SDK (>=3.2.3)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd crop_cure
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure API**
   - Update the API URL in `lib/data/data_sources/auth_remote_data_source.dart`
   - Ensure your API follows the expected response format

4. **Run the app**
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/
│   └── app_theme.dart              # App theming and colors
├── data/
│   ├── data_sources/
│   │   └── auth_remote_data_source.dart
│   └── repositories/
│       └── auth_repository.dart
├── logic/
│   └── auth/
│       ├── auth_bloc.dart
│       ├── auth_event.dart
│       └── auth_state.dart
├── presentation/
│   ├── auth/
│   │   ├── login/
│   │   ├── register/
│   │   └── widgets/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── scan/
│   ├── chat/
│   ├── profile/
│   └── splash/
└── main.dart
```

## Key Features Implementation

### Authentication Flow
1. **App Start**: Check for existing authentication token
2. **Login/Register**: Validate credentials and store token
3. **Logout**: Clear stored token and return to login screen
4. **Error Handling**: Display user-friendly error messages

### Home Screen Design
- **AI Scanner Card**: Prominent green card with camera and upload options
- **Scanned Plants**: List of previously analyzed plants with disease information
- **Search**: Quick search functionality
- **Navigation**: Easy access to all app features

### State Management
- **BLoC Pattern**: Clean separation of business logic and UI
- **Event-Driven**: User actions trigger events that update state
- **Reactive UI**: UI automatically updates based on state changes

## Customization

### Colors
The app uses a green color scheme for plant/nature theme:
- Primary: `#2DBE62`
- Secondary: `#1E8E3E`
- Background: `#F5F5F5`

### Fonts
- Primary: Poppins
- Secondary: PoltawskiNowy

### API Response Format
The app expects the following API response format:

```json
{
  "token": "jwt_token_here",
  "user": {
    "email": "user@example.com",
    "name": "User Name"
  }
}
```

## Future Enhancements

- [ ] Real plant disease detection API integration
- [ ] Image processing and analysis
- [ ] Plant care recommendations
- [ ] Disease treatment suggestions
- [ ] Offline mode support
- [ ] Push notifications
- [ ] Social sharing features

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

