
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/comment_model.dart';
import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {

  PostProvider() {                                                  //The constructor initializes postsController as a broadcast stream controller.
    postsController = StreamController<List<PostModel>>.broadcast();    //we have more than one user so we are using  broadcast streams controller
    updatePost();
  }

  List<PostModel> posts = [];
  late StreamController<List<PostModel>> postsController;  //StreamController responsible for managing a broadcast stream of lists of PostModel.
  bool isLoading = false; // Add this property to track loading state

  // Expose the stream to consumers
  Stream<List<PostModel>> get postsStream => postsController.stream;
  final CollectionReference<Map<String, dynamic>> postCollection = FirebaseFirestore.instance.collection('posts');

  Future<void> addPost(String imageUrl) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;   //current loginin user id

    if (uid != null) {
      isLoading = true; // Set loading state to true before fetching

      var doc = postCollection.doc();
      PostModel postModel = PostModel(
        postImageUrl: imageUrl,
        postTimestamp: DateTime.now(),
        postId:doc.id,
        likedPosts: [],
        userId: uid,
      );
      await doc.set(postModel.toMap());
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
            .where('UserId', isEqualTo: uid)              //fetch profile info of user who make the post only logged_in user
            // .orderBy('Timetamp', descending: true)
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

  Future<void> deletePost(String postId) async {
    try {
      // Delete the post from Firestore
      await postCollection.doc(postId).delete();

      print('Post deleted successfully');
    } catch (error) {
      print('Error deleting post: $error');
      // Handle the error as needed
    }
  }

  bool likePost(String UserId,String PostId) {
    print("like");
    postCollection.doc(PostId).update({
      'LikedPosts': [UserId]
    });
    return true;
  }

  void unlikePost(String UserId,String PostId) {
    print("unlike");
    postCollection.doc(PostId).update({
      'LikedPosts': FieldValue.arrayRemove([UserId])
    }).then((_) {   //This section is a callback function that executes after the Firestore update is complete.
      notifyListeners();
    });
  }

  Future<void> addComment(String PostId,CommentModel commentModel) async {
    try {
      final doc =  await postCollection
            .doc(PostId)
            .collection('comments')
            .doc();
      commentModel.id= doc.id;         //Assigns the ID of the newly created document (doc.id) to the id property of the commentModel
      await doc.set(commentModel.toMap());
      notifyListeners();
    } catch (error) {
      print("Error adding comment: $error");
    }
  }

  // Dispose the stream controller when the provider is disposed
  @override
  void dispose() {
    postsController.close();
    super.dispose();
  }

}





