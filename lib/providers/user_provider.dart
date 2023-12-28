import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {

  UserProvider() {
    usersController = StreamController<List<UserModel>>.broadcast();
    updateUser();
    // print('List of all Users');
  }

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser?.uid;   //current loginin user id

  List<UserModel> allUserData = [];
  // List of friends for the current user
  // List<String> friends = [];
  late StreamController<List<UserModel>> usersController;

  Stream<List<UserModel>> get usersStream => usersController.stream;

  // New function to get a user by ID
  UserModel? getUser(String id){
    UserModel? userModel;

    userModel = allUserData.where((element) => element.uid == id).firstOrNull;
    return userModel;
  }

  Future<void> getAllUserData() async {
    try {
      final Stream<QuerySnapshot<Map<String, dynamic>>> snapshotStream =
      firestoreInstance.collection("usersData").snapshots();

      await for (QuerySnapshot<Map<String, dynamic>> snapshot in snapshotStream) {
        if (snapshot.docs.isNotEmpty) {
          allUserData = snapshot.docs
              .map((doc) =>
              UserModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          print(allUserData.length);
          print("all users");
          notifyListeners();
          usersController.add(allUserData);
        } else {
          print("No user data exists");
        }
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  Future<void> updateUser() async {
    currentUser = FirebaseAuth.instance.currentUser!.uid;
    await getAllUserData();
    notifyListeners();
  }

  Future<void> sendFriendRequest(UserModel other, UserModel current) async {
    try {
      // Update the receiver's friend requests
      await firestoreInstance.collection("usersData").doc(currentUser).update({
        'SendRequest': FieldValue.arrayUnion([other.uid]),
      });

      // Update the sender's friends list
      await firestoreInstance.collection("usersData").doc(other.uid).update({
        'GetRequest': FieldValue.arrayUnion([current.uid]),
      });

      // Listen to changes on the sender's document (optional)
      firestoreInstance.collection("usersData").doc(other.uid).snapshots().listen((DocumentSnapshot<Map<String, dynamic>> snapshot) {
      });
    } catch (e) {
      print("Error sending friend request: $e");
    }
  }

  Future<List<String>> getFriendRequests(String uid) async {
    try {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
      await firestoreInstance.collection("usersData").doc(uid).get();

      return (snapshot.data()?['GetRequest'] as List<dynamic>? ?? []).cast<String>();
    } catch (e) {
      print("Error fetching friend requests: $e");
      return [];
    }
  }

  Future<void> acceptFriendRequest(UserModel other, UserModel current) async {
  try {
    // Update the current user's document in the "usersData" collection
    await firestoreInstance.collection("usersData").doc(current.uid).update({
      'GetRequest': FieldValue.arrayRemove([other.uid]),         // Remove the other user's ID from the GetRequest array
      'Friends': FieldValue.arrayUnion([other.uid]),            // Add the other user's ID to the Friends array
    });
    // Update the other user's document in the "usersData" collection
    await firestoreInstance.collection("usersData").doc(other.uid).update({
      'SendRequest': FieldValue.arrayRemove([current.uid]),           // Remove the current user's ID from the SendRequest array
      'Friends': FieldValue.arrayUnion([current.uid]),              // Add the current user's ID to the Friends array
    });
  } catch (e) {
    print("Error accepting friend request: $e");
  }
}

  Future<void> rejectFriendRequest(UserModel other, UserModel current) async {
    try {
      await firestoreInstance.collection("usersData").doc(current.uid).update({
        'GetRequest': FieldValue.arrayRemove([other.uid]),

      });
    } catch (e) {
      print("Error rejecting friend request: $e");
    }
  }

  Future<void> unFriend(UserModel other, UserModel current) async {
    try {
      await firestoreInstance.collection("usersData").doc(current.uid).update({
        'Friends': FieldValue.arrayRemove([other.uid])
      });

      await firestoreInstance.collection("usersData").doc(other.uid).update({
        'Friends': FieldValue.arrayRemove([current.uid])
      });

    } catch (e) {
      print("Error rejecting friend request: $e");
    }
    notifyListeners();
  }

  @override
  void dispose() {
    usersController.close();
    super.dispose();
  }
}

// Future<List<String>> friendsList(String uid) async {
//   try {
//     final DocumentSnapshot<Map<String, dynamic>> snapshot =
//     await firestoreInstance.collection("usersData").doc(uid).get();
//
//     return (snapshot.data()?['friends'] as List<dynamic>? ?? []).cast<String>();
//   } catch (e) {
//     print("Error fetching friends: $e");
//     return [];
//   }
// }