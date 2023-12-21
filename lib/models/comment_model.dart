import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  late String id;
  late String postId;
  late String comment;
  late DateTime timestamp;
  late String user;

  CommentModel({
    required this.id,
    required this.postId,
    required this.comment,
    required this.timestamp,
    required this.user,
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


}
