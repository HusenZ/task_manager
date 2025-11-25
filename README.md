# Task Manager App

A modern, feature-rich Flutter task management application built with Clean Architecture and BLoC state management pattern.

## 📱 Features

### Core Features

- ✅ **Create Tasks** - Add new tasks with title and description
- ✅ **View Tasks** - Browse all tasks in a clean, organized list
- ✅ **Update Tasks** - Edit existing task details
- ✅ **Delete Tasks** - Remove tasks with confirmation dialog
- ✅ **Pull-to-Refresh** - Refresh task list with a simple pull gesture
- ✅ **Empty State** - Beautiful empty state UI when no tasks exist
- ✅ **Swipe-to-Delete** - Quick delete with swipe gesture
- ✅ **Task Count** - Display total number of tasks in app bar

### Advanced Features

- 🎨 **Light & Dark Mode** - Toggle between themes with persistent storage
- 💾 **Local Persistence** - Tasks saved locally using SharedPreferences
- 🚀 **Quick Actions** - iOS/Android home screen shortcuts for quick access
- 🎯 **Form Validation** - Input validation for task creation and editing
- ⚡ **Loading States** - Smooth loading indicators for async operations
- 🎪 **Smooth Animations** - Card transitions and navigation animations
- 📱 **Material Design 3** - Modern UI following Material Design guidelines
- 🔄 **Real-time Updates** - Task list updates automatically after changes

## 🏗️ Architecture

This app follows **Clean Architecture** principles with three distinct layers:

```
lib/
├── core/                          # Core utilities and constants
│   ├── constants/
│   │   └── app_constants.dart     # App-wide constants
│   ├── theme/
│   │   ├── app_theme.dart         # Theme configuration
│   │   └── app_colors.dart        # Color definitions
│   └── utils/
│       └── date_formatter.dart    # Date formatting utilities
│
├── data/                          # Data Layer
│   ├── models/
│   │   └── task_model.dart        # Task data model with JSON serialization
│   ├── datasources/
│   │   └── local_data_source.dart # SharedPreferences implementation
│   └── repositories/
│       └── task_repository_impl.dart # Repository implementation
│
├── domain/                        # Domain Layer
│   ├── entities/
│   │   └── task.dart              # Task entity (business logic)
│   └── repositories/
│       └── task_repository.dart   # Repository interface
│
└── presentation/                  # Presentation Layer
    ├── bloc/
    │   ├── task_bloc.dart         # Business Logic Component
    │   ├── task_event.dart        # BLoC events
    │   └── task_state.dart        # BLoC states
    ├── screens/
    │   ├── task_list_screen.dart  # Main task list UI
    │   ├── add_task_screen.dart   # Add task form
    │   └── edit_task_screen.dart  # Edit/delete task form
    └── widgets/
        ├── task_card.dart         # Task list item widget
        ├── empty_state.dart       # Empty state widget
        └── loading_indicator.dart # Loading widget
```

### Architecture Layers Explained

#### 1. **Domain Layer** (Business Logic)

- **Entities**: Core business objects (Task)
- **Repository Interfaces**: Defines contracts for data operations
- **Pure Dart**: No framework dependencies

#### 2. **Data Layer** (Data Management)

- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: Handles data persistence (SharedPreferences)
- **Repository Implementation**: Implements domain repository interfaces
- **Error Handling**: Manages data-related errors

#### 3. **Presentation Layer** (UI)

- **BLoC**: State management using flutter_bloc
- **Screens**: UI pages/routes
- **Widgets**: Reusable UI components
- **State Management**: Event-driven architecture

## 🎯 State Management - BLoC Pattern

The app uses **flutter_bloc** for state management:

### Events (User Actions)

- `LoadTasks` - Load all tasks from storage
- `AddTask` - Add a new task
- `UpdateTask` - Update existing task
- `DeleteTask` - Delete a task
- `RefreshTasks` - Refresh task list

### States (UI States)

- `TaskInitial` - Initial state
- `TaskLoading` - Loading state (shows spinner)
- `TaskLoaded` - Success state with task list
- `TaskError` - Error state with error message

### BLoC Flow

```
User Action → Event → BLoC → Repository → Data Source → Storage
                ↓
            State Update
                ↓
            UI Rebuild
```

## 💾 Data Storage

### SharedPreferences Implementation

- Tasks stored as **JSON array** in SharedPreferences
- Each task has unique **UUID** identifier
- Theme preference persisted across app launches
- Automatic serialization/deserialization
- Error handling for corrupted data

### Task Model Structure

```dart
{
  "id": "uuid-v4",
  "title": "Task title",
  "description": "Task description",
  "createdAt": "2025-01-01T12:00:00.000Z",
  "updatedAt": "2025-01-01T12:00:00.000Z"
}
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_bloc: ^8.1.3 # BLoC pattern implementation
  equatable: ^2.0.5 # Value equality for states/events

  # Local Storage
  shared_preferences: ^2.2.2 # Local data persistence

  # Utilities
  intl: ^0.18.1 # Internationalization & date formatting
  uuid: ^4.2.1 # Generate unique IDs

  # Quick Actions
  quick_actions: ^1.0.7 # Home screen shortcuts (iOS/Android)

  # UI
  cupertino_icons: ^1.0.8 # iOS-style icons
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK: ^3.10.1
- Dart SDK: ^3.10.1
- iOS Simulator / Android Emulator / Physical Device

### Installation

1. **Clone or Download the Project**

   ```bash
   cd koders_assignment
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the App**

   ```bash
   flutter run
   ```

4. **Build APK (Android)**

   ```bash
   flutter build apk --release
   ```

   APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

5. **Build IPA (iOS)**
   ```bash
   flutter build ios --release
   ```

## 🎨 Theme Support

### Light Mode

- Primary Color: Purple (#6200EE)
- Background: Light gray (#FAFAFA)
- Surface: White (#FFFFFF)
- Modern, clean appearance

### Dark Mode

- Primary Color: Light purple (#BB86FC)
- Background: Dark gray (#121212)
- Surface: Darker gray (#1E1E1E)
- OLED-friendly, eye-comfortable

### Theme Toggle

- Icon button in app bar
- Persists across app restarts
- Smooth transition animations
- Respects system theme initially

## ⚡ Quick Actions

### iOS

Long-press app icon to reveal:

- **Add New Task** - Opens add task screen
- **View Tasks** - Opens main task list

### Android

Long-press app icon (Android 7.1+) to reveal:

- **Add New Task** - Opens add task screen
- **View Tasks** - Opens main task list

## 🎯 Key Implementation Details

### Form Validation

- **Title**: Required, minimum 3 characters
- **Description**: Optional
- Real-time validation feedback
- Error messages displayed inline

### Error Handling

- Try-catch blocks in data layer
- User-friendly error messages via SnackBars
- Retry functionality on errors
- Graceful handling of corrupted data

### UI/UX Features

- **8dp Grid System** - Consistent spacing
- **Material 3 Components** - Modern design
- **Smooth Animations** - Card transitions, page routes
- **Haptic Feedback** - Touch feedback (ready for implementation)
- **Accessibility** - Semantic labels, contrast ratios
- **Loading Indicators** - Async operation feedback
- **Confirmation Dialogs** - Prevent accidental deletions

### Performance Optimizations

- **Const Constructors** - Reduces widget rebuilds
- **Efficient State Management** - Only rebuilds necessary widgets
- **Lazy Loading** - ListView.builder for large lists
- **Minimal Dependencies** - Fast app startup

## 🧪 Testing

Run tests:

```bash
flutter test
```

## 🐛 Known Issues & Future Improvements

### Potential Improvements

1. **Search Functionality** - Search tasks by title/description
2. **Task Categories** - Organize tasks into categories
3. **Due Dates** - Add deadline tracking
4. **Priority Levels** - High/Medium/Low priority
5. **Task Completion** - Mark tasks as complete
6. **Sorting Options** - Sort by date, priority, alphabet
7. **Export/Import** - Backup/restore tasks
8. **Cloud Sync** - Firebase/backend integration
9. **Notifications** - Reminder notifications
10. **Task Statistics** - Visualize task completion rates

---

**Built with ❤️ using Flutter & BLoC**
