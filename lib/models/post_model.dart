import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  late String postimageUrl;
  late DateTime posttimestamp;
  late String postId;
  late String userId;
  List<String> likedPosts = [];

  PostModel({
    required this.postimageUrl,
    required this.posttimestamp,
    required this.postId,
    required this.userId,
    required this.likedPosts
  });

  PostModel.fromMap(Map<String, dynamic> data){
    postimageUrl = data['ImageUrl'] as String? ?? ''; // Provide a default value if 'ImageUrl' is null
    posttimestamp = (data['Timetamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    postId = data['PostId'] as String? ?? ''; // Provide a default value if 'UserId' is null
    userId = data['UserId'] as String? ?? ''; // Provide a default value if 'UserId' is null
    likedPosts = List<String>.from(data['LikedPosts'] ?? []);
  }

  Map<String,dynamic> toMap(){
    return{
      'ImageUrl': postimageUrl,
      'Timetamp': FieldValue.serverTimestamp(),
      'PostId': postId,
      'UserId': userId,
      'LikedPosts': likedPosts,
    };
  }
}
