import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/helper/helperfunctions.dart';
import 'package:flutterapp/services/auth.dart';
import 'package:flutterapp/services/database.dart';
import 'package:flutterapp/widgets/widget.dart';

import 'chatroomScreen.dart';


class  SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey = GlobalKey<FormState>();
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  bool isLoading = false;
  QuerySnapshot snapshotUserInfo;

  signIn(){
      if(formKey.currentState.validate()){
        HelperFunctions.saveUserEmailSharedPreference(emailTextEditingController.text);
        databaseMethods.getUserByUserEmail(emailTextEditingController.text)
            .then((val){
            snapshotUserInfo = val;
          HelperFunctions
              .saveUserNameSharedPreference(snapshotUserInfo.documents[0].data["name"]);
          //print("${snapshotUserInfo.documents[0].data["name"]}this is not good");
        });

        setState(() {
          isLoading = true;
        });
        authMethods.signInwithEmailAndPassword(emailTextEditingController.text, passwordTextEditingController.text)
            .then((val){
         if(val != null){

           HelperFunctions.saveUserLoggedInSharedPreference(true);
           Navigator.pushReplacement(context, MaterialPageRoute(
               builder: (context) => ChatRoom()
           ));
         }
        });

      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
            children: [
             Form(
                key:formKey,
               child: Column(
                 children: [
                   TextFormField(
                     validator: (val){
                       return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                           .hasMatch(val)  ?  null : "Please provide a valid emailId";
                     },
                     controller: emailTextEditingController,
                     style: simpleTextStyle(),
                     decoration: textFieldInputDecoration("email"),
                   ),
                   TextFormField(
                     obscureText: true,
                     validator: (val){
                       return val.length > 6 ? null : "Provide more than 6 characters";
                     },
                     controller: passwordTextEditingController,
                     style: simpleTextStyle(),
                     decoration: textFieldInputDecoration("password"),
                   ),
                 ],
               ),
             ),
              SizedBox(height: 8,),
              Container(
                alignment: Alignment.centerRight,
                child: Container( padding: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                  child: Text("Forgot Password?", style: simpleTextStyle(),),
                )
              ),
              SizedBox(height: 8,),
              GestureDetector(
                onTap: (){
                  signIn();
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff007EF4),
                        const Color(0xff2A75BC)
                      ]
                    ),
                    borderRadius: BorderRadius.circular(30)

                  ),
                  child: Text("Sign In",style: mediumTextStyle(),
                  )
                ),
              ),
              SizedBox(height:16,),
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)

                  ),
                  child: Text("Sign in with Google", style: TextStyle(
                    color: Colors.black87,
                    fontSize: 17,),
                  )
              ),
              SizedBox(height:16,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have a account? " ,style: mediumTextStyle() ,),
                  GestureDetector(
                    onTap: (){
                      widget.toggle();
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Register Now",style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          decoration: TextDecoration.underline
                      ),),
                    ),
                  )
                ],
              ),
              SizedBox(height: 50,),

              ],
          ),
          ),
        ),
      ),
    );
  }
}
