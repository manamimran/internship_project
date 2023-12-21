import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internship_project/models/model_class.dart';


class CommentModel {
  late String id;
  late String postId;
  late String comment;
  late DateTime timestamp;
  late String user;
  ModelClass? userDetails; // Add this field to store user details

  CommentModel({
    required this.id,
    required this.postId,
    required this.comment,
    required this.timestamp,
    required this.user,
    this.userDetails, // Add this line
  });

  CommentModel.fromMap(Map<String, dynamic> data) {
    id = data['Id'] as String? ?? '';
    postId = data['PostId'] as String? ?? '';
    comment = data['comment'] as String? ?? '';
    timestamp = (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    user = data['User'] as String? ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'Id': id,
      'PostId': postId,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(),
      'User': user,
    };
  }

  // Function to set user details
  void setUserDetails(ModelClass user) {
    userDetails = user;
  }
}
