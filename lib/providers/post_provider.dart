
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
  bool isLoading = false; // Add this property to track loading state

  // Expose the stream to consumers
  Stream<List<PostModel>> get postsStream => postsController.stream;
  final CollectionReference<Map<String, dynamic>> postCollection = FirebaseFirestore.instance.collection('posts');


  Future<void> addPost(PostModel postModel) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      isLoading = true; // Set loading state to true before fetching
      postModel.postId = uid;

      await postCollection.add(postModel.toMap());
      notifyListeners();
      // print("data added");
    } else {
      print("User is not logged in. Cannot add post.");
    }
  }

  Future<void> fetchPosts() async {
    try {
      var uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {

        postCollection
            .where('PostId', isEqualTo: uid)
            .snapshots()                                       //Specifically, it contains a list of QueryDocumentSnapshot instances, where each QueryDocumentSnapshot represents a document in the query result.
            .listen((QuerySnapshot querySnapshot) {            //It uses a stream to listen for updates to the posts collection.
          posts = querySnapshot.docs
              .map((doc) => PostModel.fromMap(doc.data() as Map<String, dynamic>))
              .toList();
          // // Notify listeners about the change
          notifyListeners();
          // Add the updated posts list to the stream
          postsController.add(posts);
          isLoading = false; // Set loading state to false after fetching
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

  bool likePost(String userId, String postId) {
    postCollection.doc(postId).update({
      'LikedPosts': FieldValue.arrayUnion([userId])
    });
    return true;
  }

  void unlikePost(String userId, String postId) {
    postCollection.doc(postId).update({
      'LikedPosts': FieldValue.arrayRemove([userId])
    }).then((_) {
      notifyListeners();
    });
  }

  // Dispose the stream controller when the provider is disposed
  @override
  void dispose() {
    postsController.close();
    super.dispose();
  }
}





