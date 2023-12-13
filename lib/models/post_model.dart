
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  late String content;
  late String imageUrl;
  late DateTime timestamp;
  late String userId; // Add this field

  PostModel({
    required this.content,
    required this.imageUrl,
    required this.timestamp,
    required this.userId,
  });

  PostModel.fromMap(Map<String, dynamic> data){
    content = data['Content'] as String? ?? ''; // Provide a default value if 'Content' is null
    imageUrl = data['ImageUrl'] as String? ?? ''; // Provide a default value if 'ImageUrl' is null
    timestamp = (data['Timetamp'] as Timestamp?)?.toDate() ?? DateTime.now();
    userId = data['UserId'] as String? ?? ''; // Provide a default value if 'UserId' is null
  }

  Map<String,dynamic> toMap(){
    return{
      'Content': content,
      'ImageUrl': imageUrl,
      'Timetamp': FieldValue.serverTimestamp(),
      'UserId': userId,
    };
  }
}