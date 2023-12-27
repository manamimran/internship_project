import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {

  UserProvider() {
    usersController = StreamController<List<UserModel>>.broadcast();
    updateUser();
    print('List of all Users');
  }

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  var currentUser = FirebaseAuth.instance.currentUser?.uid;   //current loginin user id

  List<UserModel> allUserData = [];
  // List of friends for the current user
  List<String> friends = [];
  late StreamController<List<UserModel>> usersController;

  Stream<List<UserModel>> get usersStream => usersController.stream;


  Future<void> getAllUserData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await firestoreInstance.collection("usersData").get();

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
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  UserModel? getUser(String id){
    UserModel? userModel;

    userModel = allUserData.where((element) => element.uid == id).firstOrNull;
    return userModel;
  }

  Future<void> updateUser() async {
    currentUser = FirebaseAuth.instance.currentUser!.uid;
    await getAllUserData();
  }


  // Method to check if a user is a friend
  bool isFriend(String userId) {
    return friends.contains(userId);
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
    await firestoreInstance.collection("usersData").doc(current.uid).update({
      'GetRequest': FieldValue.arrayRemove([other.uid]),
      'Friends': FieldValue.arrayUnion([other.uid]),
    });

    await firestoreInstance.collection("usersData").doc(other.uid).update({
      'Friends': FieldValue.arrayUnion([current.uid]),
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
        'Friends': FieldValue.arrayRemove([other.uid]),
      });
    } catch (e) {
      print("Error rejecting friend request: $e");
    }
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