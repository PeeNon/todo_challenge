# Todo Challenge (Flutter)

A Todo list application built with Flutter for the VTech Coding Challenge.

## Features Checklist

### Basic Requirements
- [x] Todo list with Flutter
- [x] Input widget and list element
- [x] Enter key adds new item to list
- [x] State management: **Provider** (ChangeNotifier)

### Building More Functionalities
- [x] **Valid Todo list** - No empty items allowed (shows warning)
- [x] **Unique Todo list** - No duplicate items (warns user on duplicate)
- [x] **Removable Todo list** - Remove button next to each item
- [x] **Editable Todo list**
  - Edit button next to each item
  - Same input widget used for adding and editing
  - Update button to apply changes
- [x] **Filter Todo list**
  - Real-time text matching while typing
  - Shows "No result. Create a new one instead" when no matches
- [x] **Mark as Complete**
  - "Mark as Complete" / "Mark as Incomplete" button
  - Strikethrough text for completed items

### Bonus Challenges
- [x] **Cloud sync for multi-user editing**
  - Real-time synchronization with Firebase Firestore
  - Multiple users can edit the same todo list simultaneously
  - No authentication required (as per requirements)
  - Cloud sync indicator in app bar

## Project Structure

```
lib/
├── main.dart                    # App entry point with Firebase & Provider setup
├── firebase_options.dart        # Firebase configuration (auto-generated)
├── models/
│   └── todo.dart               # Todo data model with Firestore serialization
├── controllers/
│   └── todo_controller.dart    # State management with real-time Firestore sync
├── services/
│   └── firebase_service.dart   # Firebase Firestore service layer
├── screens/
│   └── home_screen.dart        # Main UI screen
└── widgets/
    └── todo_item.dart          # Reusable todo item widget
```

## Run Locally

### Prerequisites
- Flutter SDK (3.7.2 or later)
- Dart SDK
- Firebase project (required if running locally)

### Steps
1. Clone the repository
   ```bash
   git clone https://github.com/PeeNon/todo_challenge.git
   cd todo_challenge
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Run the app
   ```bash
   flutter run
   ```

   Or run on specific platform:
   ```bash
   flutter run -d chrome    # Web
   flutter run -d macos     # macOS
   flutter run -d ios       # iOS Simulator
   flutter run -d android   # Android Emulator
   ```

## How to Use

1. **Add a Todo**: Type in the input field and press Enter (or click "Add Todo")
2. **Edit a Todo**: Click the edit (pencil) icon, modify text, then click "Update"
3. **Delete a Todo**: Click the delete (trash) icon
4. **Mark Complete/Incomplete**: Click "Mark as Complete" or "Mark as Incomplete"
5. **Filter Todos**: Type in the input field to filter the list in real-time
6. **Cloud Sync**: All changes are automatically synced to Firebase (green cloud icon = synced)

## Evaluation Quick Start

- **Live Demo**: https://todo-challenge-vtech.web.app/ (no setup required)
- **DartPad**: Not used for this submission

## Multi-User Testing

To test multi-user real-time sync:
1. Open the app in two different browser windows/tabs
2. Add, edit, or delete todos in one window
3. Changes will appear instantly in the other window

## Firebase Notes

- Firestore collection: `todos`
- Authentication: none (per challenge requirement)
- Security rules: open for evaluation/demo purposes
- If you want to use your own Firebase project, replace `lib/firebase_options.dart`
  and the platform config files under `android/app` and `ios/Runner` / `macos/Runner`.
  
### Local Firebase Setup (Optional)

1. Create a Firebase project and add apps for the platforms you plan to run.
2. Install and run FlutterFire CLI:
   ```bash
   dart pub global activate flutterfire_cli
   flutterfire configure
   ```
3. Follow the official setup guide:
   ```
   https://firebase.google.com/docs/flutter/setup
   ```

## Submission

- **Repo URL**: https://github.com/PeeNon/todo_challenge
- **Live Demo**: https://todo-challenge-vtech.web.app/
- **Total hours spent**: 8 hours

## Tech Stack

- Flutter 3.7.2+
- Provider 6.1.2 (State Management)
- Firebase Core & Cloud Firestore (Real-time Database)
- Material Design 3
