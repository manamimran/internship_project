import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internship_project/providers/user_provider.dart';
import '../models/comment_model.dart';
import '../models/user_model.dart';
import '../providers/comment_provider.dart';

class AddCommentDialog {
  static void showCommentDialog(
      BuildContext context,
      String postId,
      CommentProvider commentProvider,
      UserProvider userProvider
      ) {
    TextEditingController commentController = TextEditingController();
    UserModel? userModel =  userProvider.getUser(userProvider.currentUser!);    // using getUser model of user provider to know user details

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: Text('Add Comment'),
          content: TextField(
            controller: commentController,
            decoration: InputDecoration(hintText: 'comment'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel', style: TextStyle(color: Colors.black)),
            ),
            TextButton(
              onPressed: () {
                // Adding comment via CommentModel class
                CommentModel commentModel = CommentModel(
                  id: '', // You can generate or obtain a unique ID for the comment
                  postId: postId,
                  comment: commentController.text,
                  timestamp: DateTime.now(),
                  user: userModel!.uid,
                );

                // Save the comment
                commentProvider.addCommentForPost(postId, commentModel);

                Navigator.pop(context); // Close the dialog
              },
              child: Text('Add Comment', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}