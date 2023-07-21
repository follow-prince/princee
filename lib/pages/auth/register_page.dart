import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:princee/pages/auth/login_page.dart';
import 'package:princee/widgets/widgets.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
  @override
  Widget build(BuildContext context) {
  return  Scaffold(
      appBar: AppBar(),
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Form(
            key: formKey,
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center, 
              children: <Widget> [
              const Text("Register", style: 
              TextStyle(fontSize: 40,fontWeight: FontWeight.bold),),
              const SizedBox(height: 10),
              const Text(" Create a new account Now  ", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w100),),
              Image.asset("assets/register.png", width: 200,),
                const SizedBox(height: 15,),
              TextFormField(
                decoration: textInputDecoration.copyWith(
                  labelText: "Full Name",
                  prefixIcon:  const Icon(
                    Icons.person,
                    color: Color(0xFFee7b64),
                  )
                ),
                onChanged: (value){
                  setState(() {
                    fullName = value;  
                  
                  });
                },
                validator: (value){
                  if(value!.isNotEmpty){
                    return null;

                  }else{
                    return "Name cannot be empty";
                  }
                },
              ), 



              const SizedBox(height: 15,),
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
              const SizedBox(height: 15),
              SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColorDark,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40))),
                            child: const Text(
                              "Register",
                              style:
                                  TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16),

                            ),
                            onPressed: () {
                              Register();
                          },
                          ),
            ),
                          const SizedBox(height: 25),


             SizedBox(height: 10,),
             Text.rich(
              TextSpan(
                text: "Already have an account ?",
                  style: TextStyle(color: Colors.black, fontSize: 14),
                children: <TextSpan>[
                  TextSpan(
                    text: "Login now",
                    style: TextStyle(color: Colors.black, decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()..onTap = (){
                      nextScreenReplace(context, const LoginPage());

                          }),  
                       
                       
                              ]
              

              )
            )

            ],
            ),
        
          ),
        ),
      )

    );
      
    
  }
      Register(){}

}