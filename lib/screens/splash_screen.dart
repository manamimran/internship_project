import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internship_project/models/user_model.dart';
import 'package:internship_project/screens/auth_screen.dart';
import 'package:internship_project/screens/profile.Data.dart';
import 'package:internship_project/screens/profile_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserModel? userModel;

  @override
  void initState() {
    super.initState();
    checkUserAuthentication();
  }

   checkUserAuthentication() {
    // Check if there is a signed-in user
    User? currentUser = FirebaseAuth.instance.currentUser;
     Future.delayed(Duration(seconds: 4)).then((value) =>{
     if (currentUser != null) {
         // User is signed in, navigate to ProfileScreen
         Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>ProfileScreen()), (route) => false)

   } else {
     // User is not signed in, navigate to AUthscreen
     Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>AuthScreen()), (route) => false)

     }
     });

  }

  @override
  Widget build(BuildContext context) {
    // You can display a loading indicator or an image/logo during the splash screen
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}