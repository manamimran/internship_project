import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internship_project/models/user_model.dart';
import 'package:internship_project/screens/friends_screen.dart';
import 'package:internship_project/screens/search_screen.dart';

class ChatScreen extends StatelessWidget {
  UserModel? userModel;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat Screen'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
          children: [
             SizedBox(
              height: 500),
            Container(
              // child: FriendsListWidget(authModel),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) =>
                         FriendsScreen()));
                },
                child: Icon(Icons.add),
                backgroundColor: Colors.amber,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(50.0), // You can adjust the radius
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget FriendsListWidget(AuthModel? authModel){
  //   return Container(
  //     child: ListView.builder(
  //       itemCount: authModel!.friends.length,
  //       itemBuilder: (context, index) {
  //         String friend = authModel.friends[index];
  //         // Your widget for each friend
  //         return ListTile(
  //           title: Text(friend),
  //           // Add more details as needed
  //         );
  //       },
  //     ),
  //   );
  // }
}
