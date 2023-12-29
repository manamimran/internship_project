import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_project/dialogs/add_comment_dialog.dart';
import 'package:internship_project/dialogs/show_comment_dialog.dart';
import 'package:internship_project/models/user_model.dart';
import 'package:internship_project/models/post_model.dart';
import 'package:internship_project/providers/comment_provider.dart';
import 'package:internship_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import 'add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController commentController = TextEditingController(); //controller for add comment
  final currentUser = FirebaseAuth.instance.currentUser; //current user available

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(//consumer for commentprovider
        builder: (BuildContext context, commentProvider, Widget? child) {
    return Consumer<UserProvider>(//consumer for userprovider
        builder: (BuildContext context, userProvider, Widget? child) {
      // print(userProvider);
      return Consumer<PostProvider>(//consumer for postprovider
          builder: (BuildContext context, postProvider, Widget? child) {
        // print(postProvider);
            return Scaffold(
          appBar: AppBar(
            title: Text('Home Screen'),
            backgroundColor: Colors.amber,
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display the posts
                  SizedBox(
                      height: 500,
                      child: postProvider.isLoading //waiting for loading
                          ? Center(
                              child: CircularProgressIndicator(), // Loader widget
                            )
                          : ListView.builder(
                              itemCount: postProvider.posts.length, //list of posts in postprovider
                              itemBuilder: (context, index) {
                                // Pass the current PostModel to the PostWidget
                                PostModel currentPost = postProvider.posts[index];       //fetch list of posts

                                UserModel? userdata = userProvider
                                        .allUserData.isNotEmpty
                                    ? userProvider.allUserData.firstWhere(
                                        (authModel) => //pick the profile of user who posted the post ,
                                        authModel.uid ==
                                            currentPost
                                                .userId) // filter from list of all users list from user provider
                                    : null;
                                return Container(
                                  padding: EdgeInsets.all(20),
                                  child: postWidget(
                                      //showing post widget
                                      currentPost,
                                      userdata,
                                      postProvider,commentProvider,userProvider),
                                );
                              },
                            ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: //going to add post screen
                                    (context) => AddPostScreen()));
                      },
                      child: Icon(Icons.add),
                      backgroundColor: Colors.amber,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            50.0), // You can adjust the radius
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
    });
    });
  }

  Widget postWidget(
      PostModel postModel,
      UserModel? userModel,
      PostProvider postProvider,
      CommentProvider commentProvider,
      UserProvider userProvider){

    bool isLiked; //isLiked variable

    isLiked = postModel.likedPosts.contains(userProvider.currentUser!); // checking whether the currentUser.uid is present in the likedPosts list of a postModel'
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User's profile details
          if (userModel != null)
            ListTile(
              //profile of user who is posting
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userModel.image),
              ),
              title: Text(userModel.name),
            ),
          Divider(
            color: Colors.grey,
            height: 5,
            thickness: 2,
          ),
          // Post details
          Image.network(postModel.postImageUrl), //post
          Divider(
            color: Colors.grey,
            height: 5,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        //likes posts
                        //  change like status
                        setState(() {
                          if (isLiked) {
                            // Unlike the post
                            postProvider.unlikePost(
                                userProvider.currentUser!, postModel.postId);
                          } else {
                            // Like the post
                            postProvider.likePost(
                                userProvider.currentUser!,
                                postModel.postId); //saving likes wrt to user id in firestore
                          }
                          isLiked = !isLiked;
                        });
                      },
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.grey,
                      ),
                    ),
                    Text(postModel.likedPosts.length
                        .toString()), //counter of total likes
                  ],
                ),
                // Show comment dialog
                Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: InkWell(
                    onTap: () async {
                      // Show the comment dialog
                      ShowCommentDialog.showCommentDialog2(context, postModel.postId, userModel!.uid, commentProvider,userProvider);
                    },
                    child: Icon(Icons.comment),
                  ),
                ),
               //Show comment dialog
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // Set the border color
                      width: 1.0, // Set the border width
                    ),
                    borderRadius:
                        BorderRadius.circular(20), // Set the border radius
                  ),
                  child: InkWell(
                    onTap: () {
                      // Add comment for each post
                      AddCommentDialog.showCommentDialog(
                        context,
                        postModel.postId,
                        commentProvider,
                        userProvider
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Add Comment'),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.amber,
                          title: Text("Delete Post"),
                          content: Text("Are you sure you want to delete this post?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Cancel',style: TextStyle(color: Colors.black)),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Check if the current user is the one who posted the post
                                if (postModel.userId == currentUser!.uid) {
                                  // Perform the post deletion logic
                                  await postProvider.deletePost(postModel.postId);

                                  // Close the dialog
                                  Navigator.pop(context);
                                } else {
                                  // Display an error message or handle as needed
                                  // For example, show a snackbar
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("You don't have permission to delete this post."),
                                    ),
                                  );

                                  // Close the dialog
                                  Navigator.pop(context);
                                }
                              },
                              child: Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          // SizedBox(height: 10),
        ],
      ),
    );
  }

  // // Method to add the comment dialog
  // void showCommentDialog(
  //     BuildContext context,
  //     String postId,
  //     String userId,
  //     CommentProvider commentProvider
  //     ) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         backgroundColor: Colors.amber,
  //         title: Text('Add Comment'),
  //         content: TextField(
  //           controller: commentController,
  //           decoration: InputDecoration(hintText: 'comment'),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child: Text('Cancel', style: TextStyle(color: Colors.black)),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //
  //               //adding comment via comment model class
  //               CommentModel commentModel = CommentModel(
  //                   id: '', // You can generate or obtain a unique ID for the comment
  //                   postId: postId,
  //                   comment: commentController.text,
  //                   timestamp: DateTime.now(),
  //                   user: currentUser!.uid);
  //
  //               // Save the comment
  //               commentProvider.addCommentForPost(postId,commentModel); //saving comment in firestore in separate collection
  //               Navigator.pop(context); // Close the dialog
  //             },
  //             child:
  //             Text('Add Comment', style: TextStyle(color: Colors.black)),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }




}
