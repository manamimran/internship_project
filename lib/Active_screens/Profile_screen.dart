import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internship_project/Active_screens/profile.Data.dart';
import 'package:internship_project/models/model_class.dart';
import 'package:internship_project/screens/Auth_screen.dart';
import 'package:internship_project/screens/dashboard_screen.dart';


class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final auth = FirebaseAuth.instance;
  ModelClass? modelClass;

  @override
  void initState() {
    super.initState();
    getData();
  }

  //Retrieves data from a specific document in the "users" collection based on the current user's UID.
  Future<void> getData() async {
    //the uid property provides their unique identifier.
    var uid = FirebaseAuth.instance.currentUser!.uid; //The currentUser property represents the currently signed-in user, and uid is the unique identifier for that user.
    //print(value.user?.uid);

    final doc = FirebaseFirestore.instance.collection("usersData").doc(uid);
    final snapshot = await doc.get(); //This line asynchronously retrieves the document snapshot using the get() method
    if (snapshot.exists) {
      setState(() {
        print("userdata exist"); //It takes the data from the Firestore document (snapshot.data()) and converts it into a map before passing it to the fromMap method.
        modelClass = ModelClass.fromMap(snapshot.data() as Map<String, dynamic>); //The snapshot.data() method retrieves the data from the Firestore document.
        // Now you have the Model object from Firestore data
      });
    } else {
      print("No userdata exist");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No user data exsists'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                auth.signOut();
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AuthScreen()),
                        (route) => false);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('SignOut Successfully'),
                  ),
                );
              },
              icon: Icon(Icons.logout))
        ],
        title: Text('Profile Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
                child: modelClass != null
                    ? Column(
                        children: <Widget>[
                          Center(
                            child: ClipOval(
                              child: Image(
                                image: NetworkImage(modelClass!.image),
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text('Name: ${modelClass!.name}',
                              style: TextStyle(fontSize: 15)),
                          Text('phone Number: ${modelClass!.phone}',
                              style: TextStyle(fontSize: 15)),
                          Text('Country: ${modelClass!.country}',
                              style: TextStyle(fontSize: 15)),
                          Column(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder:
                                                (context) => // setting update button, on update it move to add screen with values saved in model class
                                                    ProfileData(
                                                        modelClass:
                                                            modelClass)));
                                  },
                                  child: Text("Edit Profile")),
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DashBoardScreen()),
                                            (route) => false);
                                  },
                                  child: Text("Dashboard")),
                            ],
                          ),
                        ],
                      )
                    : Center(
                        child:
                            CircularProgressIndicator()) // Show loading indicator while data is being fetched
                ),
          ],
        ),
      ),
    );
  }
}
