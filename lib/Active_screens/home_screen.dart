import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:internship_project/models/comment_model.dart';
import 'package:internship_project/models/model_class.dart';
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
  final currentUser = FirebaseAuth.instance.currentUser!; //current user available

  @override
  Widget build(BuildContext context) {
    return Consumer<CommentProvider>(//consumer for userprovider
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the posts
                SingleChildScrollView(
                  child: SizedBox(
                    height: 500,
                    child: postProvider.isLoading //waiting for loading
                        ? Center(
                            child: CircularProgressIndicator(), // Loader widget
                          )
                        : ListView.builder(
                            itemCount: postProvider
                                .posts.length, //list of posts in postprovider
                            itemBuilder: (context, index) {
                              // Pass the current PostModel to the PostWidget
                              PostModel currentPost = postProvider.posts[index];

                              ModelClass? userdata = userProvider
                                      .allUserData.isNotEmpty
                                  ? userProvider.allUserData.firstWhere(
                                      (modelClass) => //pick the profile of user who posted the post ,
                                          modelClass.uid ==
                                          currentPost
                                              .userId) // filter from list of all users list from user provider
                                  : null;
                              return Container(
                                padding: EdgeInsets.all(20),
                                child: PostWidget(
                                    //showing post widget
                                    currentPost,
                                    userdata,
                                    postProvider,commentProvider,userProvider),
                              );
                            },
                          ),
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
        );
      });
    });
    });
  }

  Widget PostWidget(
      PostModel postModel,
      ModelClass? modelClass,
      PostProvider postProvider,
      CommentProvider commentProvider,UserProvider userProvider){

    bool isLiked; //isLiked variable
    isLiked = postModel.likedPosts.contains(currentUser.uid); // checking whether the currentUser.uid is present in the likedPosts list of a postModel'
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
          if (modelClass != null)
            ListTile(
              //profile of user who is posting
              leading: CircleAvatar(
                backgroundImage: NetworkImage(modelClass.image),
              ),
              title: Text(modelClass.name),
            ),
          Divider(
            color: Colors.grey,
            height: 5,
            thickness: 2,
          ),
          // Post details
          Image.network(postModel.postimageUrl), //post
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
                                modelClass!.uid, postModel.postId);
                          } else {
                            // Like the post
                            postProvider.likePost(
                                modelClass!.uid,
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
                      showCommentDialog2(context, postModel.postId, modelClass!.uid, commentProvider,userProvider);
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
                      //add comment of each post
                      showCommentDialog(context, postModel.postId,
                          modelClass!.uid, commentProvider);
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
                          content: Text(
                              "Are you sure you want to delete this post?"),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context); // Close the dialog
                              },
                              child: Text('Cancel',style: TextStyle(color: Colors.black)),
                            ),
                            TextButton(
                              onPressed: () async {
                                // Perform the post deletion logic
                                await postProvider.deletePost(postModel.postId);

                                // Close the dialog
                                Navigator.pop(context);
                              },
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.red)),
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

  // Method to add the comment dialog
  void showCommentDialog(
      BuildContext context,
      String postId,
      String userId,
      CommentProvider commentProvider
      ) {
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

                //adding comment via comment model class
                CommentModel commentModel = CommentModel(
                    id: '', // You can generate or obtain a unique ID for the comment
                    postId: postId,
                    comment: commentController.text,
                    timestamp: DateTime.now(),
                    user: currentUser.uid);

                // Save the comment
                commentProvider.addCommentForPost(postId,commentModel); //saving comment in firestore in separate collection
                Navigator.pop(context); // Close the dialog
              },
              child:
              Text('Add Comment', style: TextStyle(color: Colors.black)),
            ),
          ],
        );
      },
    );
  }

  // Method to show the comment dialog
  void showCommentDialog2(BuildContext context,
      String postId,
      String userId,
      CommentProvider commentProvider, UserProvider userProvider)
  async {
    List<CommentModel> comments = await commentProvider.getCommentsForPost(postId);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.amber,
          title: Text('Comments'),
          content: Container(
            height: 400,
            child: ListView.builder(
              itemCount: comments.length,
              itemBuilder: (BuildContext context, int index) {
                // Display each comment in the list
                return ListTile(
                  leading: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(userProvider.getUserData(userId).image),
                      ),
                      Text(userProvider.getUserData(userId).name)
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
