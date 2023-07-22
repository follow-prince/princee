import 'package:flutter/material.dart';
import 'package:princee/pages/auth/login_page.dart';
import 'package:princee/pages/home_page.dart';
import 'package:princee/service/auth_service.dart';
import 'package:princee/widgets/widgets.dart';


class ProfilePage extends StatefulWidget {
  String userName;
  String email;
ProfilePage({super.key, required this.email, required this.userName});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          elevation: 0,
          centerTitle: true,
          title: const Text("Profile", style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),),
          ),
            drawer: Drawer(
              child: ListView(
    padding: const EdgeInsets.symmetric(vertical: 50),
    children: <Widget> [
      Icon(
        Icons.account_circle,
         size:150, 
         color: Colors.grey[700] ,),
         const SizedBox(height: 15,),
         Text(widget.userName , textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 30,),
          Divider(
            height: 2,
          ),
          ListTile(
            onTap: (){
                            nextScreen(context, const HomePage());

            },

            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),

            title: const Text("Groups",style: TextStyle(color: Colors.black),),
          ),
                    ListTile(
            onTap: (){},

        

            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            leading: const Icon(Icons.group),
              selected: true,selectedColor: Colors.red,

            
            title: const Text("Profile",style: TextStyle(color: Colors.black),),
          ),
                  ListTile(
                            onTap: () async {
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Logout"),
                                    content: Text("Are you sure you want to logout ?"),
                                    actions: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: const Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      ),
                                       IconButton(
                                        onPressed: () async {
                                          await authService.signOut();
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>
                                          const LoginPage()), (route) => false);
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
                            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            leading: Icon(Icons.exit_to_app),
                            title: const Text(
                              "Logout",
                              style: TextStyle(color: Colors.black),
                            ),
                          )




         
    ],
  )),

  body: Container(
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
    child:  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget> [
       const Icon(
        Icons.account_circle,
        size: 200,
        color: Colors.grey,
       ),
        const SizedBox(height: 15,),
       Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
           Text("Full Name", style: const TextStyle(fontSize: 17),),
           Text(widget.userName, style: const TextStyle(fontSize: 17),)
        ],
       ),


       const Divider(height: 20,),
        Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Email", style: const TextStyle(fontSize: 17),),
                  Text(widget.email, style: const TextStyle(fontSize: 17),)
                ],
              ),


      ],
    ),
  ),
    );
  }
}