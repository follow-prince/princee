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




//Creating ka group
Future createGroup(String userName, String id, String groupName )async{
  DocumentReference documentReference = await groupCollection.add({
    "groupName": groupName,
    "groupIcon": "",
    "admin": "${id}_$userName",
    "members":[], 
    "groupId": "",
    "recentMessage":"",
    "recentMessageSender":"",


  });

  //update the member 
  await documentReference.update({
    "members": FieldValue.arrayUnion(["${uid}_$userName"]),
    "groupId": documentReference.id,
  });


DocumentReference userDocumentReference =  userCollection.doc(uid);

return await userDocumentReference.update({
  "groups": FieldValue.arrayUnion(["${documentReference.id}_$groupName"])



});
}
// getting the chats 

getChats(String groupId) async {
  return groupCollection.doc(groupId)
  .collection("messages")
  .orderBy("time")
  .snapshots();
}
 Future getGroupAdmin(String groupId) async{
  DocumentReference d = groupCollection.doc(groupId);
  DocumentSnapshot documentSnapshot = await d.get();
  return documentSnapshot['admin'];
 }

 // get group members

 getGroupMembers(groupId) async {
  return groupCollection.doc(groupId).snapshots();


 }
// search 

searchByName(String groupName){
  return groupCollection.where("groupName",isEqualTo: groupName).get(

  );
}





// function ---> Bool

Future<bool> isUserJoined(
  String groupName, String groupId, String userName
) async {
  DocumentReference userDocumentReference = userCollection.doc(uid);
  DocumentSnapshot documentSnapshot = await userDocumentReference.get();


  List<dynamic> groups = await documentSnapshot['groups'];
  if(groups.contains("${groupId}_$groupName")){
    return true;
  }else{
    return false;
  }
}



// toggling the group join/exit
Future toggleGroupJoin(String groupId, String userName, String groupName) async{

//i will  create doc reference

DocumentReference userDocumentReference = userCollection.doc(uid);
DocumentReference groupDecumentReference = groupCollection.doc(groupId);
DocumentSnapshot documentSnapshot = await userDocumentReference.get() ;
List<dynamic> groups = await documentSnapshot['groups'];




//if user has our group ----> then remove them or also other part rejoin them

if(groups.contains("${groupId}_$groupName")){
  await userDocumentReference.update({
    "groups" : FieldValue.arrayRemove(["${groupId}_$groupName"])

  });
   await groupDecumentReference.update({
    "groups" : FieldValue.arrayRemove(["${uid}_$userName"])
    
  });
}else{

  await userDocumentReference.update({
    "groups" : FieldValue.arrayUnion(["${groupId}_$groupName"])

  });
   await groupDecumentReference.update({
    "groups" : FieldValue.arrayUnion(["${uid}_$userName"])
    
  });

}


}





}






