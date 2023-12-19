import 'package:flutter/material.dart';
import 'package:internship_project/models/model_class.dart';
import 'package:internship_project/models/post_model.dart';
import 'package:internship_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import 'add_post_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
        builder: (BuildContext context, userProvider, Widget? child) {
          // print(userProvider);
      return Consumer<PostProvider>(
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
                    child: postProvider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(), // Loader widget
                          )
                        : ListView.builder(
                            itemCount: postProvider.posts.length,
                            itemBuilder: (context, index) {
                              // Pass the current PostModel to the PostWidget
                              PostModel currentPost = postProvider.posts[index];

                              ModelClass? userdata =
                                  userProvider.allUserData.firstWhere(
                                (modelClass) =>
                                    modelClass.uid == currentPost.postId,
                              );
                              return Container(
                                padding: EdgeInsets.all(20),
                                child: PostWidget(currentPost, userdata, postProvider),
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
                              builder: (context) => ChangeNotifierProvider(
                                  create: (BuildContext context) {
                                    return PostProvider();
                                  },
                                  child: AddPostScreen())));
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
    }
    );
  }

  Widget PostWidget(PostModel postModel, ModelClass? userdata, PostProvider postProvider) {
    bool isLiked = false;

    return Container(
      padding: EdgeInsets.only(top: 10, right: 20, left: 20),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User's profile details
          if (userdata != null)
            ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userdata.image),
              ),
              title: Text(userdata.name),
            ),
          Divider(
            color: Colors.grey,
            height: 5,
            thickness: 2,
          ),
          // Post details
          Image.network(postModel.postimageUrl),
          Divider(
            color: Colors.grey,
            height: 5,
            thickness: 2,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                  InkWell(
                  onTap: () {
                    // Toggle like status
                    setState(() {
                      if (isLiked) {
                        // Unlike the post
                        postProvider.unlikePost(userdata!.uid, postModel.postId);
                      } else {
                        // Like the post
                        postProvider.likePost(userdata!.uid, postModel.postId);
                      }
                      isLiked = !isLiked;
                    });
                  },
                  child: Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : Colors.grey,
                  ),
                ),
                SizedBox(width: 30),
                Icon(Icons.comment),
              ],
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
