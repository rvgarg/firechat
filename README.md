# FireChat

A Flutter mobile chat application powered by Firebase for authentication, real-time messaging, and group communication.

This project is a demonstration of a Firebase-backed messaging app built with Flutter, where users can sign in, browse chats, create groups, and exchange messages with support for profile images and cloud-hosted data.

## Overview

FireChat is structured as a mobile-first chat application with a clean tabbed interface for personal messages and group conversations. The app initializes Firebase on startup, routes the user to either the login screen or the active chat list based on authentication state, and then loads data from Firestore.

## Tech stack

- Flutter
- Dart
- Firebase Core
- Firebase Authentication
- Cloud Firestore
- Firebase Storage
- Google Sign-In
- Cached network image loading

## Key features

- User authentication flow
- Chat list with direct-message conversations
- Group conversation support
- Group creation UI
- Profile image and media handling
- Firebase-backed real-time data access
- Material Design-based interface

## Project structure

```text
.
├── android/                 # Android app setup
├── ios/                    # iOS app setup
├── lib/
│   ├── api/                # Firebase API helpers for chat/group interactions
│   ├── model/              # App models such as users and groups
│   ├── pages/              # Login, chat, group, and settings-related screens
│   ├── main.dart           # App bootstrap and route configuration
│   └── ...
├── test/                   # Test suite
├── .gitignore              # Git ignore rules
├── pubspec.yaml            # Flutter package configuration and dependencies
├── pubspec.lock            # Dependency lockfile
├── README.md               # Project documentation
└── .metadata               # Flutter metadata file
```

## Main application flow

The app bootstraps in `lib/main.dart`:

- initializes Firebase
- checks the current authenticated user
- routes to the login screen if no user is logged in
- loads the chat dashboard if a user is present

The primary screens include:

- `lib/pages/login_page.dart` — sign-in experience
- `lib/pages/chat_list.dart` — personal and group chat list
- `lib/pages/chat_page.dart` — direct message conversation view
- `lib/pages/group_chat.dart` — group chat UI
- `lib/pages/new_group_page.dart` — interface for creating a new group

## Dependencies

This app depends on Firebase and Flutter packages declared in `pubspec.yaml`, including:

- `firebase_core`
- `firebase_auth`
- `cloud_firestore`
- `google_sign_in`
- `image_picker`
- `firebase_storage`
- `cached_network_image`

## Getting started

### Prerequisites

- Flutter SDK installed
- Firebase project configured for Android and iOS
- Firebase credentials added to the app configuration

### Install dependencies

```bash
flutter pub get
```

### Run app

```bash
flutter run
```

## Notes

This repository is a small demo-style chat app and not a production-grade messaging platform. It is useful as a practical reference for building Firebase-backed Flutter chat features, including authentication, real-time lists, and grouped conversations.

## License

No explicit project license is included in the repository root, so licensing terms should be confirmed before broader reuse or commercial distribution.
