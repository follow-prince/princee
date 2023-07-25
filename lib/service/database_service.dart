import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String? uid;

  // Constructor
  DatabaseService({this.uid});

  // Reference for our "users" collection
  final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

  // Reference for our "groups" collection
  final CollectionReference groupCollection = FirebaseFirestore.instance.collection("groups");

  // Method for saving user data
  Future savingUserData(String fullName, String email) async {
    return await userCollection.doc(uid).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePic": "",
      "uid": uid,
    });
  }
  
  // Explanation:
  // The `savingUserData` method saves user data to the Firestore database.
  // It takes the user's `fullName` and `email` as parameters and creates a new document with the provided `uid` (user ID).
  // The document contains fields for the user's full name, email, an empty list for groups, an empty profile picture,
  // and the user's unique `uid`.

  // Method for getting user data based on email
  Future gettingUserData(String email) async {
    QuerySnapshot snapshot = await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }
  
  // Explanation:
  // The `gettingUserData` method retrieves user data from the Firestore database based on the user's email.
  // It performs a query to find documents where the "email" field is equal to the provided email and returns a QuerySnapshot.

  // Method for getting user groups
  getUserGroups() async {
    return userCollection.doc(uid).snapshots();
  }
  
  // Explanation:
  // The `getUserGroups` method retrieves the user's groups from the Firestore database using Firebase's real-time updates (snapshots).
  // It returns a stream of the user's document, and any changes to the document will be automatically reflected in the UI.

  // Method for creating a group
  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference documentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

    // Update the member
    await documentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": documentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);

    return await userDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${documentReference.id}_$groupName"]),
    });
  }
  
  // Explanation:
  // The `createGroup` method creates a new group in the Firestore database.
  // It takes the `userName`, `id` (user ID), and `groupName` as parameters.
  // The method first creates a new document in the "groups" collection with information like group name, group icon, admin, members, etc.
  // The admin is set as a combination of `id` and `userName`.
  // Then, it updates the `members` array in the group document and the `groups` array in the user's document to reflect the user's membership in the group.

  // Method for getting group chats
  getChats(String groupId) async {
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }
  
  // Explanation:
  // The `getChats` method retrieves the chat messages for a specific group.
  // It returns a stream of the chat messages from the "messages" subcollection of the provided `groupId`, ordered by the "time" field.

  // Method for getting the admin of a group
  Future getGroupAdmin(String groupId) async {
    DocumentReference d = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot['admin'];
  }
  
  // Explanation:
  // The `getGroupAdmin` method retrieves the admin of a specific group from the Firestore database.
  // It takes the `groupId` as a parameter and fetches the corresponding document from the "groups" collection.
  // It then returns the value of the "admin" field from the fetched document.

  // Method for getting group members
  getGroupMembers(groupId) async {
    return groupCollection.doc(groupId).snapshots();
  }
  
  // Explanation:
  // The `getGroupMembers` method retrieves the members of a specific group from the Firestore database using real-time updates (snapshots).
  // It takes the `groupId` as a parameter and returns a stream of the group's document, reflecting any changes in the group's membership.

  // Method for searching groups by name
  searchByName(String groupName) {
    return groupCollection.where("groupName", isEqualTo: groupName).get();
  }
  
  // Explanation:
  // The `searchByName` method searches for groups in the Firestore database by their group names.
  // It takes the `groupName` as a parameter and performs a query to find documents where the "groupName" field matches the provided name.
  // It then returns a QuerySnapshot containing the search results.

  // Method to check if a user has joined a group
  Future<bool> isUserJoined(String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }
  
  // Explanation:
  // The `isUserJoined` method checks if a user has joined a specific group.
  // It takes the `groupName`, `groupId`, and `userName` as parameters.
  // The method fetches the user's document from the "users" collection and checks if the "groups" array contains the provided group information.
  // If the group information is found in the array, it means the user has joined the group, and the method returns `true`; otherwise, it returns `false`.

  // Method for toggling group join/exit
  Future toggleGroupJoin(String groupId, String userName, String groupName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // If user has the group, remove them; otherwise, add them
    if (groups.contains("${groupId}_$groupName")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"]),
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"]),
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"]),
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      });
    }
  }
  
  // Explanation:
  // The `toggleGroupJoin` method allows users to join or exit a group by adding or removing the group information from the "groups" array in their document.
  // It takes the `groupId`, `userName`, and `groupName` as parameters.
  // The method fetches the user's document and checks if the group information is already present in the "groups" array.
  // If the group information is present, it means the user has already joined the group, so the method removes the group information from both the user's and group's documents.
  // If the group information is not present, it means the user is not a member of the group, so the method adds the group information to both the user's and group's documents.

  // Method for sending a message
  sendMessage(String groupId, Map<String, dynamic> chatMessageData) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage": chatMessageData['message'],
      "recentMessageSender": chatMessageData['sender'],
      "recentMessageTime": chatMessageData['time'].toString(),
    });
  }
  
  // Explanation:
  // The `sendMessage` method sends a chat message to a specific group.
  // It takes the `groupId` and `chatMessageData` (a map containing the chat message details) as parameters.
  // The method adds the chat message to the "messages" subcollection of the provided `groupId`.
  // Additionally, it updates the "recentMessage", "recentMessageSender", and "recentMessageTime" fields in the group document to reflect the latest sent message.
}
