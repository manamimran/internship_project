
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import '../models/post_model.dart';

class PostProvider extends ChangeNotifier {

  PostProvider() {  //The constructor initializes postsController as a broadcast stream controller.
    postsController = StreamController<List<PostModel>>.broadcast();
    initialize();
  }

  final FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;
  List<PostModel> posts = [];
  late StreamController<List<PostModel>> postsController;  //StreamController responsible for managing a broadcast stream of lists of PostModel.

  // Expose the stream to consumers
  Stream<List<PostModel>> get postsStream => postsController.stream; //This declares a getter named postsStream.The return type of the getter is a Stream of lists of PostModel
                                                                      //It means consumers can listen to this stream to receive updates when the list of posts changes.

  Future<void> initialize() async {
    await fetchPosts();
    print('data fetched');
  }

  Future<void> addPost(PostModel postModel) async {
    var uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid != null) {
      postModel.userId = uid;

      await firestoreInstance.collection('posts').add(postModel.toMap());
      notifyListeners();
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
            .where('userId', isEqualTo: uid)
            .snapshots()
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

  // Dispose the stream controller when the provider is disposed
  @override
  void dispose() {
    postsController.close();
    super.dispose();
  }
}


