import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:internship_project/Active_screens/profile.Data.dart';
import 'package:provider/provider.dart';

import '../models/model_class.dart';
import '../screens/provider_class.dart';
import 'add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final auth = FirebaseAuth.instance;
  ModelClass? modelClass;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              height: 500,
              width: 300,
            ),
             Align(alignment: Alignment.bottomRight,
               child: FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => AddPostScreen()));
                  },
                  child: Icon(Icons.add),
                  backgroundColor: Colors.amber,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(50.0), // You can adjust the radius
                  ),
                ),
             ),

          ],
        ),
      ),
    );
  }
}
