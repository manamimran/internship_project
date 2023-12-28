import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_project/models/user_model.dart';
import 'package:internship_project/providers/post_provider.dart';
import 'package:internship_project/providers/user_provider.dart';
import 'package:internship_project/screens/profile.data.dart';
import 'package:internship_project/widgets/button_widget.dart';
import 'package:internship_project/widgets/textfield_widget.dart';
import 'package:provider/provider.dart';

import 'profile_screen.dart';

class AuthScreen extends StatefulWidget {
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var email_controller = TextEditingController();

  var password_controller = TextEditingController();

  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('SignUp & SignIn'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 30),
          child: SizedBox(

            child: Column(
              children: [
                TextFieldWidget(
                  isPassword: false,
                  textEditingController: email_controller,
                  labelText: "Your Email",
                ),
                SizedBox(height: 10),
                TextFieldWidget(
                  isPassword: true,
                  textEditingController: password_controller,
                  labelText: "Your Password",
                ),
                SizedBox(height: 10),
                ButtonWidget(
                  labelText: "Sign Up",
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email_controller.text,
                              password: password_controller.text)
                          .then((value) async {
                        // print(value.user?.uid);
                        print('SignUp successfully');

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ProfileData(userModel: userModel)),
                            (route) => false);
                      });
                    } catch (e) {
                      print("Error: $e");
                      // Show a SnackBar with the error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "$e"),
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 10),
                ButtonWidget(
                  labelText: "Sign In",
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                        email: email_controller.text,
                        password: password_controller.text,
                      )
                          .then((value) {
                        print("SignIn successfully");
                        Provider.of<UserProvider>(context,listen: false).updateUser();      //call update function of userProvider to update changes
                        Provider.of<PostProvider>(context,listen: false).updatePost();      //call update function of postProvider to update changes
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                userModel == null ?  ProfileScreen()
                                    : ProfileData(userModel: userModel)),
                                (route) => false);
                      });
                    } catch (e) {
                      print("Error: $e");
                      // Show a SnackBar with the error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Error: Something went wrong : SignIn failed"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
