import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class RequestScreen extends StatefulWidget {
  @override
  _RequestScreenState createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requests Pending'),
        backgroundColor: Colors.amber,
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          // Get the current user's UserModel
          UserModel? currentUserModel =  userProvider.getUser(userProvider.currentUser!);    // using getUser model of user provider to know user details

          if (currentUserModel != null) {
            // Filter out requests that have already been accepted
            List<String> pendingRequests = currentUserModel.getRequests
                .where((requestUserId) => !currentUserModel.sendRequests.contains(requestUserId))
                .toList();

            // Display the getRequest list with user details
            return ListView.builder(
              itemCount: currentUserModel.getRequests.length,
              itemBuilder: (context, index) {
                String getRequestList = currentUserModel.getRequests[index];

                // Assuming getRequest is a UID of another user, get that user's details
                UserModel? requestUser = userProvider.getUser(getRequestList);

                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(requestUser?.image ?? ''),
                  ),
                  title: Text(requestUser?.name ?? 'User Name'),
                  subtitle: ElevatedButton(
                    onPressed: () async {

                      UserModel? currentUser = userProvider.getUser(userProvider.currentUser!);   // using getUser model of user provider to know user details
                      userProvider.acceptFriendRequest(requestUser!, currentUser!);
                      print('friend added');

                      // Optionally, you can provide feedback to the user (e.g., a snackbar).
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Friend Request Accepted'),
                        ),
                      );
                      // Remove the item from the list after accepting the request
                      setState(() {
                        pendingRequests.removeAt(index);
                      });
                    },
                    child: Text('Accept'),

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

// IconButton(
// onPressed: () async {
// UserModel? currentUser =
// userProvider.getUser(userProvider.currentUser!);
// userProvider.rejectFriendRequest(
// requestUser!, currentUser!);
// print('friend removed');
//
// // Optionally, you can provide feedback to the user (e.g., a snackbar).
// ScaffoldMessenger.of(context).showSnackBar(
// SnackBar(
// content: Text('Friend request removed'),
// ),
// );
// },
// icon: Icon(Icons.delete),
// ),