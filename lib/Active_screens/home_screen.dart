import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screens/provider_class.dart';
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
            child: Column(
              children: [
                // Display the posts
                SingleChildScrollView(
                  child: SizedBox(
                    height: 500,
                    child: ListView.builder(
                      itemCount: postProvider.posts.length,
                      itemBuilder: (context, index) {
                        String imageUrl = postProvider.posts[index].imageUrl;
                        String userId = postProvider.posts[index].userId;

                        return PostWidget(imageUrl, userId);
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

  Widget PostWidget(String imageUrl, String userId) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey, // Set your desired background color
        borderRadius:
            BorderRadius.circular(10.0), // Set your desired border radius
      ),
      child: Column(
        children: [
          Image.network(imageUrl),
          // Text('User ID: $userId'),
          // You can add more widgets or customize as needed
        ],
      ),
    );
  }
}
