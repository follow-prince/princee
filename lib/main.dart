import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:princee/helper/helper_function.dart';
import 'package:princee/pages/auth/login_page.dart';
import 'package:princee/pages/home_page.dart';
import 'package:princee/shared/constants.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
if(kIsWeb){
//run The Initialization  for web
  await Firebase.initializeApp(options: FirebaseOptions(apiKey: Constants.apiKey, appId: Constants.appID, messagingSenderId: Constants.messagingSenderId, projectId: Constants.projectID));

}else{
  //run a the Initialization for android and ios 
  await Firebase.initializeApp();

}

  runApp(const MyApp() );

}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  
@override
State<MyApp> createState() => _MyAppState();


}

class _MyAppState extends State<MyApp>{

bool _isSignedIn = false;

@override
void initState(){
  super.initState();
  getUserLoggedInStatus();
}

getUserLoggedInStatus() async {
  // ignore: non_constant_identifier_names
  await HelperFunction.getUserLoggedInStatus().then((value) {

    if(value != null){
      setState(() {
        _isSignedIn = value;
      });

    }
  });
}
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      theme: ThemeData(
        primaryColor: Constants().primaryColor,
        scaffoldBackgroundColor: Colors.white
      ),
      debugShowCheckedModeBanner: false,
      home: _isSignedIn ? const HomePage() : const LoginPage(),
    );
  }
}