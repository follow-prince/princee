import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;
  DatabaseService({this.uid});


//reference for our collection 
final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");

// group collection
final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
      
      


  //saving the  user data

  Future savingUserData(String fullName, String email) async{
    return await userCollection.doc(uid).set({

      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });

  }

  //getting user data


  Future gettingUserDate(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email",isEqualTo: email).get();
    return snapshot;
  }

//Getting  user group

getUserGroups() async {
  return userCollection.doc(uid).snapshots();
}


}





