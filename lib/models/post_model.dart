import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  late String postImageUrl;
  late DateTime postTimestamp;
  late String postId;
  late String userId;
  List<String> likedPosts = [];

  PostModel({
    required this.postImageUrl,
    required this.postTimestamp,
    required this.postId,
    required this.userId,
    required this.likedPosts,
  });

  PostModel.fromMap(Map<String, dynamic> data){
    postImageUrl = data['ImageUrl'] as String? ?? ''; // Provide a default value if 'ImageUrl' is null
    postTimestamp = (data['Timetamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    postId = data['PostId'] as String? ?? ''; // Provide a default value if 'UserId' is null
    userId = data['UserId'] as String? ?? ''; // Provide a default value if 'UserId' is null
    likedPosts = List<String>.from(data['LikedPosts'] ?? []);
  }

  Map<String,dynamic> toMap(){
    return{
      'ImageUrl': postImageUrl,
      'Timetamp': FieldValue.serverTimestamp(),
      'PostId': postId,
      'UserId': userId,
      'LikedPosts': likedPosts,
    };
  }
}
