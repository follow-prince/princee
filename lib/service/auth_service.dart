  import 'package:firebase_auth/firebase_auth.dart';
import 'package:princee/helper/helper_function.dart';
  import 'package:princee/service/database_service.dart';

  class AuthService {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // login function

 Future loginWithUserNameandPassword( String email, String password) async {
    try{


    User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, 
    password: password)).user!;

    if(user!=null){

      // call Data Base Service update the user dat

      return true;
    }
    } on FirebaseAuthException catch(e){

  return e.message;   
    }
  }






  // Register function 
  Future registerUserWithEmailandPassword(String fullName, String email, String password) async {
    try{


    User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, 
    password: password)).user!;



    
    if(user!=null){

      // call Data Base Service update the user data
    await DatabaseService(uid: user.uid).savingUserData(fullName,email);


      return true;
    }


    

    } on FirebaseAuthException catch(e){

  return e.message;   
    }
  }








  // Log Out function

Future signOut() async{

  try {

    await HelperFunction.saveUserLoggedInStatus(false);
    await HelperFunction.saveUserEmailSF("");
    await HelperFunction.saveUserNameSF("");
    await firebaseAuth.signOut();


  } catch (e){
    return null;
  }
}





  }