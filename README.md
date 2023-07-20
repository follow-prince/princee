# ELAVARASAN

![GitHub Repo Size](https://img.shields.io/github/repo-size/follow-prince/princee?color=d62936&label=Repo%20Size&style=flat-square)
![GitHub Code Size](https://img.shields.io/github/languages/code-size/follow-prince/princee?color=e6a400&label=Code%20Size&style=flat-square)
![GitHub Commit Activity](https://img.shields.io/github/commit-activity/m/follow-prince/princee?color=138a3d&label=Commit%20Activity&style=flat-square)
![GitHub Language Count](https://img.shields.io/github/languages/count/follow-prince/princee?color=1f77b4&label=Total%20Languages&style=flat-square)
![GitHub Top Language](https://img.shields.io/github/languages/top/follow-prince/princee?color=7f0c7f&style=flat-square)
![GitHub Issues](https://img.shields.io/github/issues/follow-prince/princee?color=098f76&label=GitHub%20Issues&style=flat-square)
![GitHub Pull Erequests](https://img.shields.io/github/issues-pr/follow-prince/princee?color=2c324f&label=GitHub%20Pull%20Requests&style=flat-square)
![GitHub Latest Release](https://img.shields.io/github/v/release/follow-prince/princee?color=f5426f&label=Latest%20Release&style=flat-square)
![GitHub Total Downloads](https://img.shields.io/github/downloads/follow-prince/princee/total?color=4a2600&label=Total%20Downloads&style=flat-square)
![Website Status](https://img.shields.io/website?down_message=Down%20%26%20Offline&label=Website%20Status&up_message=Up%20%26%20Online&url=https%3A%2F%2Fprince-dev.vercel.app)




## Overview

GroupChatApp is a Flutter-based Group Chatting application that allows users to create and participate in group conversations. The app uses Firebase as the backend to store and manage chat messages and user authentication.

## Features

- User registration and authentication
- Create new chat groups
- Send and receive messages in real-time
- View the list of all chat groups
- Real-time updates on new messages
- Group management (Add/remove members)

## Screenshots
Coming Soon
<!-- ![Screenshot 1](screenshots/screenshot_1.png) -->


## Getting Started

Follow these steps to set up and run the project on your local machine:

1. Clone the repository: `git clone https://github.com/follow-prince/princee.git`
2. Change into the project directory: `cd princee`
3. Install dependencies: `flutter pub get`
4. Run the app: `flutter run`

## Firebase Setup

To use Firebase for the backend, follow these steps:

1. Create a new project on [Firebase](https://firebase.google.com/)
2. Enable the Firestore database and Firebase Authentication in your project settings
3. Add your Firebase configuration file to the app (`android/app/google-services.json` and `ios/Runner/GoogleService-Info.plist`)

## Dependencies

- [firebase_core](https://pub.dev/packages/firebase_core): FlutterFire plugin for Firebase Core
- [firebase_auth](https://pub.dev/packages/firebase_auth): FlutterFire plugin for Firebase Authentication
- [cloud_firestore](https://pub.dev/packages/cloud_firestore): FlutterFire plugin for Cloud Firestore
- [firebase_storage](https://pub.dev/packages/firebase_storage): FlutterFire plugin for Firebase Cloud Storage
- [flutter_bloc](https://pub.dev/packages/flutter_bloc): State management library for Flutter
- [equatable](https://pub.dev/packages/equatable): Simplify equality comparisons for Dart classes
- [fluttertoast](https://pub.dev/packages/fluttertoast): Flutter plugin for displaying toast messages
- [cached_network_image](https://pub.dev/packages/cached_network_image): Caches network images to improve performance

## Contributing

Contributions are welcome! If you find any issues or want to add new features, please feel free to open a pull request.

## License

This project is licensed under the [MIT License](LICENSE).

---

Now, let's include some code snippets for the essential parts of the app.

1. **Firebase Initialization** (main.dart)

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GroupChatApp());
}
```

2. **Authentication Service** (auth_service.dart)

```dart
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      final UserCredential result = await _auth.signInAnonymously();
      final User? user = result.user;
      return user;
    } catch (e) {
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
```

3. **Chat Message Model** (message_model.dart)

```dart
class Message {
  final String id;
  final String content;
  final String senderId;
  final Timestamp timestamp;

  Message({
    required this.id,
    required this.content,
    required this.senderId,
    required this.timestamp,
  });
}
```

4. **Firebase Cloud Firestore Integration** (chat_service.dart)

```dart
class ChatService {
  final CollectionReference _messagesCollection =
      FirebaseFirestore.instance.collection('messages');

  Stream<List<Message>> getMessages() {
    return _messagesCollection
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs
            .map((doc) => Message(
                  id: doc.id,
                  content: doc['content'],
                  senderId: doc['senderId'],
                  timestamp: doc['timestamp'],
                ))
            .toList());
  }

  Future<void> sendMessage(String content, String senderId) {
    return _messagesCollection.add({
      'content': content,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
```
