import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:princee/helper/helper_function.dart';
import 'package:princee/pages/auth/login_page.dart';
import 'package:princee/pages/home_page.dart';
import 'package:princee/shared/constants.dart';

// Main function, the entry point of the app
Future<void> main() async {
  // Ensure that the Flutter framework is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase based on the platform (web, Android, or iOS)
  if (kIsWeb) {
    // For web, initialize Firebase with the provided configuration options
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: Constants.apiKey,
        appId: Constants.appID,
        messagingSenderId: Constants.messagingSenderId,
        projectId: Constants.projectID,
      ),
    );
  } else {
    // For Android and iOS, initialize Firebase without additional configuration
    await Firebase.initializeApp();
  }

  // Run the app by creating an instance of MyApp and calling runApp
  runApp(const MyApp());
}

// The main application widget
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Variable to track the signed-in status of the user
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    // Check the user's logged-in status when the widget is first created
    getUserLoggedInStatus();
  }

  // Function to get the user's logged-in status
  getUserLoggedInStatus() async {
    // Use the HelperFunction class to get the user's logged-in status from storage
    await HelperFunction.getUserLoggedInStatus().then((value) {
      // Update the state with the logged-in status
      if (value != null) {
        setState(() {
          _isSignedIn = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Set the app's theme
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white,
      ),
      // Disable the debug banner on the top-right corner
      debugShowCheckedModeBanner: false,
      // Determine the home page based on the user's signed-in status
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}
