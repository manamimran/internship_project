import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/comment_model.dart';
import '../providers/comment_provider.dart';
import '../providers/user_provider.dart';

class ShowCommentDialog {
  static void showCommentDialog2(
      BuildContext context,
      String postId,
      String userId,
      CommentProvider commentProvider,
      UserProvider userProvider) async {
    List<CommentModel> comments =
    await commentProvider.getCommentsForPost(postId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: Text('Comments'),
          content: Container(
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                UserModel? user =
                userProvider.getUser(comments[index].user); // Updated this line
                // Display each comment in the list
                return ListTile(
                  leading: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(user!.image),
                      ),
                      Text(user.name)
                    ],
                  ),
                  title: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      comments[index].comment,
                      style: TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }
}