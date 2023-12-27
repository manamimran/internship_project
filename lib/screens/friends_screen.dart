import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_provider.dart';

class FriendsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Friend List'),
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Get the current user's UserModel
          UserModel? currentUserModel =
          userProvider.getUser(userProvider.currentUser!);

          if (currentUserModel != null) {
            // Display the getRequest list with user details
            return ListView.builder(
              itemCount: currentUserModel.friends.length,
              itemBuilder: (context, index) {
                String getRequest = currentUserModel.friends[index];

                // Assuming getRequest is a UID of another user, get that user's details
                UserModel? requestUser = userProvider.getUser(getRequest);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        requestUser?.image ?? ''), // Display the user's image
                  ),
                  title: Text(requestUser?.name ?? 'User Name'),
                  subtitle: Text(requestUser?.phone ?? 'Country'),
                  trailing: Column(
                    children: [
                      IconButton(
                        onPressed: () async {
                          UserModel? currentUser =
                              userProvider.getUser(userProvider.currentUser!);
                          userProvider.unFriend(
                              requestUser!, currentUser!);
                          print('friend removed');

                          // Optionally, you can provide feedback to the user (e.g., a snackbar).
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Friend request removed'),
                            ),
                          );
                        },
                          icon: Icon(Icons.delete),
                      ),

                    ],
                  ),
                );
              },
            );
          } else {
            // Handle the case where the current user's UserModel is not found
            return Center(
              child: Text('User not found'),
            );
          }
        },
      ),
    );
  }
}
