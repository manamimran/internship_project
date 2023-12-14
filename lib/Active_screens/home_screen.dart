import 'package:flutter/material.dart';
import 'package:internship_project/models/post_model.dart';
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
    return Consumer<PostProvider>(
      builder: (context, postProvider, child) {

        return Scaffold(
          appBar: AppBar(
            title: Text('Home Screen'),
            backgroundColor: Colors.amber,
          ),
          body: Padding(
            padding: EdgeInsets.all(10),
            child: Column(mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Display the posts
                SingleChildScrollView(
                  child: SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: postProvider.posts.length,
                      itemBuilder: (context, index) {
                        // Pass the current PostModel to the PostWidget
                        PostModel currentPost = postProvider.posts[index];
                        return Container(
                            padding: EdgeInsets.all(20),
                        child: PostWidget(currentPost),
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
                      borderRadius: BorderRadius.circular(50.0), // You can adjust the radius
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget PostWidget(PostModel postModel) {
    return Container(padding: EdgeInsets.only(top:80 ,bottom: 50,right: 20,left: 20),
      decoration: BoxDecoration(
        color: Colors.black12, // Set your desired background color
        borderRadius:
            BorderRadius.circular(20.0), // Set your desired border radius
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //User's profile details
          // ListTile(
          //   leading: CircleAvatar(
          //     backgroundImage: NetworkImage(postModel.userProfile.profileImageUrl),
          //   ),
          //   title: Text(postModel.userProfile.username),
          // ),
          SizedBox(height: 10),
          // Post details
          Image.network(postModel.postimageUrl),
          SizedBox(height: 10),
          // You can add more widgets or customize as needed
        ],
      ),
    );
  }

}