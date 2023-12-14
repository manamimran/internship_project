import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/model_class.dart';

class UserProvider extends ChangeNotifier {
  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List<ModelClass> allUserData = [];

  // Stream controller to handle the stream
   StreamController<List<ModelClass>> _userStreamController =
  StreamController<List<ModelClass>>.broadcast();

  // Expose the stream to the outside world
  Stream<List<ModelClass>> get userStream => _userStreamController.stream;

  UserProvider() {
    updateUser();
    notifyListeners();
    print('user fetched');
  }

  Future<void> getAllUserData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await firestoreInstance.collection("usersData").get();

      if (snapshot.docs.isNotEmpty) {
        allUserData = snapshot.docs
            .map((doc) => ModelClass.fromMap(doc.data() as Map<String, dynamic>),)
            .toList();

        // Now you have a list containing ModelClass objects for all users
        print("All User Data");
        // Push the updated data to the stream
        _userStreamController.add(allUserData);
      } else {
        print("No user data exists");
      }
    } catch (error) {
      print("Error fetching user data: $error");
      // Handle the error appropriately (show a message, retry, etc.)
    }
  }

  Future<void> updateUser() async {
    await getAllUserData();
    notifyListeners();
  }

  // Clean up the stream controller when the provider is disposed
  @override
  void dispose() {
    _userStreamController.close();
    super.dispose();
  }
}