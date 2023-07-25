// Tamil: டார்ட் பைண்
// English: Dart import
import 'dart:js';

// Tamil: க்ளவுட் ஃபயர்ஸ்டோர் கிளவுட்
// English: Cloud Firestore import
import 'package:cloud_firestore/cloud_firestore.dart';

// Tamil: பிளட்டர் அமெரிகான்
// English: Flutter Material
import 'package:flutter/material.dart';

// Tamil: பிரிஞ்சி பக்கங்கள்
// English: Princee Pages
import 'package:princee/pages/group_info.dart';

// Tamil: பிரிஞ்சி சேவை கோப்பு
// English: Princee Service Database
import 'package:princee/service/database_service.dart';

// Tamil: பிரிஞ்சி விட்ஜெட்கள்
// English: Princee Widgets
import 'package:princee/widgets/message_tile.dart';
import 'package:princee/widgets/widgets.dart';

// Tamil: சொற்பொழிக்குகள் பில்ட்
// English: Chat Page Stateful Widget
class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  // Tamil: கட்டப்பட்ட செடுக்கும் மற்றும் பெயரிடும் திட்டம்
  // English: Constructor with required and named parameters
  const ChatPage({
    Key? key,
    required this.groupId,
    required this.groupName,
    required this.userName,
  }) : super(key: key);

  // Tamil: செயலி உருவாக்குதல்
  // English: Create and return the state for the Chat Page
  @override
  State<ChatPage> createState() => _ChatPageState();
}

// Tamil: செயலி பிரிக்குதல்
// English: Create and return the state for the Chat Page
class _ChatPageState extends State<ChatPage> {
  // Tamil: செய்யுள் ஒட்டுமொத்த மற்றும் ஆட்மின் பெயரிடுதல்
  // English: Stream of QuerySnapshot for fetching chats and admin name
  Stream<QuerySnapshot>? chats;

  // Tamil: செய்யுள் விரித்திரத்தை மற்றும் ஆட்மின் பெயரிடுதல்
  // English: TextEditingController for handling message input
  TextEditingController messageController = TextEditingController();

  // Tamil: ஆட்மின் பெயரிடுதல்
  // English: Variable to store the admin name
  String admin = "";

  // Tamil: திட்டத்தின் தொடக்கத்தின் போது செயல்படுகிறது
  // English: Executes when the state is created
  @override
  void initState() {
    getChatandAdmin();
    super.initState();
  }

  // Tamil: செய்யுள் மற்றும் ஆட்மின் பெயரிடுதல்
  // English: Function to fetch chats and admin name
  getChatandAdmin() {
    DatabaseService().getChats(widget.groupId).then((val) {
      setState(() {
        chats = val;
      });
    });

    DatabaseService().getGroupAdmin(widget.groupId).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  // Tamil: செய்யுள் மற்றும் அஞ்சலாளர் செய்தி
  // English: Build the UI for the Chat Page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Tamil: படிம பொத்தானை செய்க
      // English: App Bar customization
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
            onPressed: () {
              nextScreen(
                context,
                GroupInfo(
                  groupId: widget.groupId,
                  groupName: widget.groupName,
                  adminName: admin,
                  userName: '',
                ),
              );
            },
            icon: const Icon(Icons.info),
          ),
        ],
      ),
      // Tamil: உடைகளை நிலை மற்றும் அஞ்சலாளர் செய்தி
      // English: Body with chat messages and message input field
      body: Stack(
        children: <Widget>[
          // Tamil: செய்யுள் செய்தி இங்கே
          // English: Chat messages are displayed here
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
              width: MediaQuery.of(context).size.width,
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Send a Message...",
                        hintStyle: TextStyle(color: Colors.white, fontSize: 16),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: const Center(
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // Tamil: செய்யுள் செய்தி விரிப்பானின்
  // English: Function to display chat messages
  chatMessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                    message: snapshot.data.docs[index]['message'],
                    sender: snapshot.data.docs[index]['sender'],
                    sendByMe: widget.userName ==
                        snapshot.data.docs[index]['sender'],
                  );
                },
              )
            : Container();
      },
    );
  }

  // Tamil: செய்யுள் அஞ்சலாளர்
  // English: Function to send a message
  sendMessage() {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "message": messageController.text,
        "sender": widget.userName,
        "time": DateTime.now().microsecondsSinceEpoch,
      };
      DatabaseService().sendMessage(widget.groupId, chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}
