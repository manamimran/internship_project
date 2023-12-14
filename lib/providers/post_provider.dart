
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {

  PostProvider() {                                                  //The constructor initializes postsController as a broadcast stream controller.
    postsController = StreamController<List<PostModel>>.broadcast();    //we have more than one user so we are using  broadcast streams controller
    updatePost();
  }

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List<PostModel> posts = [];
  late StreamController<List<PostModel>> postsController;  //StreamController responsible for managing a broadcast stream of lists of PostModel.

  // Expose the stream to consumers
  Stream<List<PostModel>> get postsStream => postsController.stream; //This declares a getter named postsStream.The return type of the getter is a Stream of lists of PostModel


  // Future<UserProfileModel> fetchUserProfile(String userId) async {
  //   // Implement a method to fetch user profile based on userId
  //   // This could be a call to Firestore or any other method to retrieve user details
  //   // Example: UserProfile userProfile = await getUserProfileFromFirestore(userId);
  //   // return userProfile;
  //   return UserProfileModel(username: '', profileImageUrl: '', uid: ''); // Replace with your actual implementation
  // }


  Future<void> addPost(PostModel postModel) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      postModel.postId = uid;

      await firestoreInstance.collection('posts').add(postModel.toMap());
      notifyListeners();
      print("data added");
    } else {
      print("User is not logged in. Cannot add post.");
    }
  }

  Future<void> fetchPosts() async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {

        firestoreInstance
            .collection('posts')
            .where('UserId', isEqualTo: uid)
            .snapshots()                                       //Specifically, it contains a list of QueryDocumentSnapshot instances, where each QueryDocumentSnapshot represents a document in the query result.
            .listen((QuerySnapshot querySnapshot) {            //It uses a stream to listen for updates to the posts collection.
          posts = querySnapshot.docs
              .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          // Notify listeners about the change
          notifyListeners();
          // Add the updated posts list to the stream
          postsController.add(posts);
        });
      } else {
        print("User is not logged in. Cannot fetch posts.");
      }
    } catch (e) {
      print("Error fetching posts: $e");
    }
  }

  //It means consumers can listen to this stream to receive updates when the list of posts changes.
  Future<void> updatePost() async {
    await fetchPosts();
    print('data fetched');
  }

  // Future<UserProfileModel?> getUserProfile(PostModel postModel) async {
  //   try {
  //     // Assuming "usersData" is the collection where user profiles are stored
  //     final DocumentSnapshot<Map<String, dynamic>> snapshot =
  //     await FirebaseFirestore.instance.collection("usersData").doc(postModel.postId).get();
  //
  //     if (snapshot.exists) {
  //       return UserProfileModel.fromMap(snapshot.data()!);
  //     } else {
  //       print("User profile not found for postId");
  //       return null;
  //     }
  //   } catch (error) {
  //     print("Error fetching user profile: $error");
  //     return null;
  //   }
  // }
  // Dispose the stream controller when the provider is disposed
  @override
  void dispose() {
    postsController.close();
    super.dispose();
  }
}





