import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class PostProvider extends ChangeNotifier {
  final firestoreInstance = FirebaseFirestore.instance;


  Future<void> addPost(String content, String imageUrl) async {
    await firestoreInstance.collection('posts').add({
      'content': content,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
