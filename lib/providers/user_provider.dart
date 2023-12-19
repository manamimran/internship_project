import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/model_class.dart';

class UserProvider extends ChangeNotifier {
  UserProvider() {
    usersController = StreamController<List<ModelClass>>.broadcast();
    updateUser();
    print('List of all Users');
  }

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List<ModelClass> allUserData = [];
  late StreamController<List<ModelClass>> usersController;

  Stream<List<ModelClass>> get usersStream => usersController.stream;

  Future<void> getAllUserData() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot =
      await firestoreInstance.collection("usersData").get();

      if (snapshot.docs.isNotEmpty) {
        allUserData = snapshot.docs
            .map((doc) =>
            ModelClass.fromMap(doc.data() as Map<String, dynamic>))
            .toList();

        notifyListeners();
        usersController.add(allUserData);
      } else {
        print("No user data exists");
      }
    } catch (error) {
      print("Error fetching user data: $error");
    }
  }

  Future<void> updateUser() async {
    await getAllUserData();
  }

  Future<void> sendFriendRequest(ModelClass sender, ModelClass recipient) async {
    try {
      // Assume you have a "friendRequests" collection in Firestore
      await firestoreInstance.collection("friendRequests").add({
        'senderId': sender.uid,
        'recipientId': recipient.uid,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Friend request sent from ${sender.name} to ${recipient.name}');
    } catch (error) {
      print("Error sending friend request: $error");
    }
  }

  Future<bool> hasSentFriendRequest(ModelClass sender, ModelClass recipient) async {
    try {
      final QuerySnapshot<Map<String, dynamic>> snapshot = await firestoreInstance
          .collection("friendRequests")
          .where('senderId', isEqualTo: sender.uid)
          .where('recipientId', isEqualTo: recipient.uid)
          .get();
      return snapshot.docs.isNotEmpty;
    } catch (error) {
      print("Error checking friend request: $error");
      return false;
    }
  }

  Future<void> FriendsAcepted(ModelClass sender, ModelClass recipient) async {
    try {
      // Update friends list for the recipient
      await firestoreInstance.collection("usersData").doc(recipient.uid).update({
        'friends': FieldValue.arrayUnion([sender.uid]),
      });

      // Update friends list for the sender
      await firestoreInstance.collection("usersData").doc(sender.uid).update({
        'friends': FieldValue.arrayUnion([recipient.uid]),
      });

      // Remove the friend request
      await firestoreInstance.collection("friendRequests").where('senderId', isEqualTo: sender.uid)
          .where('recipientId', isEqualTo: recipient.uid)
          .get()
          .then((snapshot) {
        for (DocumentSnapshot doc in snapshot.docs) {
          doc.reference.delete();
        }
      });

      print('Friend request accepted from ${sender.name} by ${recipient.name}');
    } catch (error) {
      print("Error accepting friend request: $error");
    }
  }

  @override
  void dispose() {
    usersController.close();
    super.dispose();
  }
}