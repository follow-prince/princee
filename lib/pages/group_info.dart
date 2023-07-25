// This Flutter code imports necessary packages, including 'firebase_auth' and 'flutter/material.dart'.
// It also imports 'princee/pages/home_page.dart', 'princee/service/database_service.dart', and 'princee/widgets/widgets.dart'.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:princee/pages/home_page.dart';
import 'package:princee/service/database_service.dart';
import 'package:princee/widgets/widgets.dart';

// 'GroupInfo' is a modified main class with required parameters and additional 'adminName'.
class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;

  // This constructor receives essential data for the main class, including 'groupName', 'groupId', 'adminName', and 'userName'.
  // 'userName' is not used in the code.
  const GroupInfo({
    Key? key,
    required this.groupName,
    required this.groupId,
    required this.adminName,
    required String userName,
  }) : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  Stream? members;

  @override
  void initState() {
    // 'initState' is a lifecycle hook that gets called to fetch data.
    // 'getMembers' is used to retrieve data from files.
    getMembers();
    super.initState();
  }

  // 'getMembers' is used to fetch data from files.
  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  // 'getName' is a helper function that extracts the name from the given string.
  String getName(String r) {
    return r.substring(r.indexOf("_") + 1);
  }

  // 'getId' is a helper function that extracts the ID from the given string.
  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  @override
  Widget build(BuildContext context) {
    // The build function returns the main Scaffold widget for the UI.
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Group Info"),
        actions: [
          // When the exit button is clicked, an alert dialog prompts for confirmation.
          IconButton(
            onPressed: () {
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text("Exit"),
                    content: Text("Are you sure you want to exit the Group?"),
                    actions: [
                      // If the cancel button is clicked, the alert dialog is dismissed.
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        ),
                      ),
                      // If the 'yes' button is clicked, the service function is called to toggle the group join and replace the current page with the Home page.
                      IconButton(
                        onPressed: () async {
                          DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                              .toggleGroupJoin(
                                widget.groupId,
                                getName(widget.adminName),
                                widget.groupName,
                              ).whenComplete(() {
                            nextScreenReplace(context, const HomePage());
                          });
                        },
                        icon: const Icon(
                          Icons.done,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.exit_to_app),
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 5,),
                      Text("Admin: ${getName(widget.adminName)}")
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
    );
  }

  // 'memberList' displays the list of members.
  memberList() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 10,
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          getName(snapshot.data['members'][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(getName(snapshot.data['members'][index])),
                      subtitle: Text(getId(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }
}
