import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:princee/widgets/widgets.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}




class _LoginPageState extends State<LoginPage>{
final formKey = GlobalKey<FormState>();
String email = "";
String password = "";


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).primaryColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: <Widget> [
              const Text("Prince", style: 
              TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
              const SizedBox(height: 10),
              const Text(" This is not the end, this is the beginning.. Wait on see..😊  ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),),
              Image.asset("assets/login-access.png"),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  labelText: "Email",
                  prefixIcon:  const Icon(
                    Icons.email,
                    color: Color(0xFFee7b64),
                  )
                ),
                onChanged: (value){
                  setState(() {
                    email = value;  
                   
                  });
                },
            //Check validation

                 validator: (value) {
                return RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                  .hasMatch(value!)
                  ? null
                  : "Please enter a valid email";
                  },

              ),
             
              
              const SizedBox(height: 15),
              TextFormField(
                obscureText: true,
                decoration: textInputDecoration.copyWith(
                labelText: "Password",
                prefixIcon:  const Icon(
                  Icons.lock,
                  color: Color(0xFFee7b64),
                )
              ),
              validator: (value) {
                if(value!.length < 6){
                  return "Password must be at least 6 of characters ";
                }else{
                  return null;
                }
              },
              onChanged: (val){
                  setState(() {
                    password = val;
                    print(password);
                  });
                },
              ),
              SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            child: const Text(
                              "Sign In",
                              style:
                                  TextStyle(color: Color.fromARGB(255, 206, 21, 21), fontSize: 16),

                            ),
                            onPressed: () {
                              login();
                            },
                          ),
            ),

            const SizedBox(height: 10,),
            const Text.rich(
              TextSpan(
                text: "Don't Hava An Account ?",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                    text: "Register here",
                  style: const TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                    // recognizer: TapGestureRecognizer()..onTap = () =;
                  )
                ],
              

              )
            )

            ],
            ),
        
          ),
        ),
      )

    );
  }
  login(){
if(formKey.currentState!.validate()){
}
  }
}


