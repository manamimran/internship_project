
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  late String postimageUrl;
  late DateTime posttimestamp;
  late String postId; // Add this field
  // late UserProfileModel userProfile;

  PostModel({
    required this.postimageUrl,
    required this.posttimestamp,
    required this.postId,
    // required this.userProfile,
  });

  PostModel.fromMap(Map<String, dynamic> data){
    postimageUrl = data['ImageUrl'] as String? ?? ''; // Provide a default value if 'ImageUrl' is null
    posttimestamp = (data['Timetamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    postId = data['UserId'] as String? ?? ''; // Provide a default value if 'UserId' is null
    // userProfile = UserProfileModel.fromMap(data['UserProfile'] as Map<String, dynamic>? ?? {});
  }

  Map<String,dynamic> toMap(){
    return{
      'ImageUrl': postimageUrl,
      'Timetamp': FieldValue.serverTimestamp(),
      'UserId': postId,
      // 'UserProfile': userProfile.toMap(),
    };
  }
}

class UserProfileModel {
  late String uid;
  late String username;
  late String profileImageUrl;

  UserProfileModel({
    required this.uid,
    required this.username,
    required this.profileImageUrl,
  });

  UserProfileModel.fromMap(Map<String, dynamic> data) {
    uid = data['Uid'] as String? ?? '';
    username = data['Username'] as String? ?? '';
    profileImageUrl = data['ProfileImageUrl'] as String? ?? '';
  }

  Map<String, dynamic> toMap() {
    return {
      'Uid': uid,
      'Username': username,
      'ProfileImageUrl': profileImageUrl,
    };
  }
}