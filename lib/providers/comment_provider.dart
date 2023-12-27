import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../models/comment_model.dart';

class CommentProvider with ChangeNotifier {
  final CollectionReference<Map<String, dynamic>> postCollection = FirebaseFirestore.instance.collection('posts');

  final StreamController<List<CommentModel>> _commentsController =
  StreamController<List<CommentModel>>.broadcast();
  List<CommentModel> comments = [];
  late StreamController<List<CommentModel>> commentsController; //StreamController responsible for managing a broadcast stream of lists of PostModel.

  // Expose the stream to consumers
  Stream<List<CommentModel>> get commentsStream => _commentsController.stream;

  // Add a comment for a specific post
  Future<void> addCommentForPost(
      String postId, CommentModel commentmodel) async {
    try {
      final doc = await postCollection.doc(postId).collection('comments').doc();
      commentmodel.id = doc.id;
      await doc.set(commentmodel.toMap());
      // Notify listeners and update the stream
      notifyListeners();
      commentsController.add(comments);
    } catch (error) {
      print("Error adding comment for post: $error");
    }
  }

  // Get comments for a specific post
  Future<List<CommentModel>> getCommentsForPost(String postId) async {
    try {
      final querySnapshot = await postCollection
          .doc(postId)
          .collection('comments')
          .orderBy('timestamp', descending: true)
          .get();

      comments = querySnapshot.docs.map((doc) {
        return CommentModel.fromMap(doc.data() as Map<String, dynamic>);
      }).toList();
      return comments;
    } catch (error) {
      print("Error getting comments for post: $error");
      return [];
    }
  }

  // Dispose the stream controller when the provider is disposed
  @override
  void dispose() {
    commentsController.close();
    super.dispose();
  }
}
