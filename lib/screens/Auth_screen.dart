import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_project/Active_screens/Profile_screen.dart';
import 'package:internship_project/models/model_class.dart';
import 'package:internship_project/Active_screens/profile.Data.dart';
import 'package:internship_project/widgets/Button_widget.dart';
import 'package:internship_project/widgets/textfield_widget.dart';

class AuthScreen extends StatelessWidget {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  var email_controller = TextEditingController();
  var password_controller = TextEditingController();
  ModelClass? modelClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('SignUp & SignIn'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(top: 40, left: 40),
          child: SizedBox(
            height: 300,
            width: 280,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextFieldWidget(
                  textEditingController: email_controller,
                  labelText: "Enter Email",
                ),
                TextFieldWidget(
                  textEditingController: password_controller,
                  labelText: "Enter Password",
                ),
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
                                    ProfileData(modelClass: modelClass)),
                            (route) => false);
                      });
                    } catch (e) {
                      print("Error: $e");
                      // Show a SnackBar with the error message
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              "Error: Something went wrong : SignUp failed"),
                        ),
                      );
                    }
                  },
                ),
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

                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                modelClass == null ?  ProfileScreen()
                                    : ProfileData(modelClass: modelClass)),
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
