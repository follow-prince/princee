// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:princee/pages/chat_page.dart';
import 'package:princee/widgets/widgets.dart';

// GroupTile Class: StatefulWidget to represent a group tile widget
class GroupTile extends StatefulWidget {
  // Class properties (variables) for the GroupTile
  final String userName;
  final String groupId;
  final String groupName;

  // Constructor for the GroupTile class
  const GroupTile({
    Key? key,
    required this.userName,
    required this.groupId,
    required this.groupName,
  }) : super(key: key);

  // Create and return the state object for the GroupTile
  @override
  State<GroupTile> createState() => _GroupTileState();
}

// Private State class for the GroupTile
class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    // GestureDetector: Detects taps and triggers the onTap function when tapped.
    return GestureDetector(
      onTap: () {
        // When the GroupTile is tapped, navigate to the ChatPage.
        nextScreen(context, ChatPage(
          groupId: widget.groupId,
          groupName: widget.groupName,
          userName: widget.userName,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          // CircleAvatar: Displays a circular user avatar with the first letter of the groupName.
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.groupName.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          // Title: Displays the groupName as the title of the ListTile.
          title: Text(
            widget.groupName,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          // Subtitle: Displays a message indicating that the user is joining the conversation with their userName.
          subtitle: Text(
            "Join the conversation as ${widget.userName}",
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
