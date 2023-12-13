
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  late String content;
  late String postimageUrl;
  late DateTime posttimestamp;
  late String postId; // Add this field

  PostModel({
    required this.content,
    required this.postimageUrl,
    required this.posttimestamp,
    required this.postId,
  });

  PostModel.fromMap(Map<String, dynamic> data){
    content = data['Content'] as String? ?? ''; // Provide a default value if 'Content' is null
    postimageUrl = data['ImageUrl'] as String? ?? ''; // Provide a default value if 'ImageUrl' is null
    posttimestamp = (data['Timetamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    postId = data['UserId'] as String? ?? ''; // Provide a default value if 'UserId' is null
  }

  Map<String,dynamic> toMap(){
    return{
      'Content': content,
      'ImageUrl': postimageUrl,
      'Timetamp': FieldValue.serverTimestamp(),
      'UserId': postId,
    };
  }
}