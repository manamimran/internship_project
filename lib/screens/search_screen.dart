
import 'package:flutter/material.dart';
import 'package:internship_project/providers/user_provider.dart';
import 'package:internship_project/screens/request_screen.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<UserModel> filteredUsers = [];     //This list is used to store the users that match the search criteria.
  UserModel? userModel;
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            actions: [  IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RequestScreen()));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Request Pending'),
                    ),
                  );
                },
                icon: Icon(Icons.more_vert))],
            title: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
              onChanged: (query) {
                filterUsers(userProvider.allUserData, query, userProvider.currentUser!);
              },
            ),
            backgroundColor: Colors.amber,
          ),
          body: ListView.separated(
            itemCount: filteredUsers.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              UserModel userModel = filteredUsers[index];

              // Check if the user's ID is already in the sendRequests list
              bool isRequestPending = userModel.getRequests.contains(userProvider.currentUser!);    // check if current logged-in id present in getRequest list
              print(userProvider.currentUser);
              // print("current user id");
              return ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(userModel.image),
              ),
              title: Text(userModel.name),
              trailing: Column(
                children: [
                  // Check if the user is already a friend
                  if (userProvider.isFriend(userModel.uid))
                    Text('Friends') // Display "Friends" if the user is already a friend

                  else
                    ElevatedButton(
                      onPressed: () async {
                        if (!isRequestPending) {
                          // Send friend request when the button is pressed
                          UserModel? currentUser = userProvider.getUser(userProvider.currentUser!);
                          await userProvider.sendFriendRequest(
                            userModel,
                            currentUser!,
                          );

                          // Optionally, you can provide feedback to the user (e.g., a snackbar).
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Friend request sent'),
                            ),
                          );
                        } else {
                          // Notify the user that a friend request is already pending
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Friend request is already pending'),
                            ),
                          );
                        }
                      },
                      child: Text(isRequestPending ? 'Pending' : 'Add Friend'),
                    ),
                  // Divider(),
                ],
              ),
              );
            },
          ),
        );
      },
    );
  }

  void filterUsers(List<UserModel> allUserData, String query, String currentUserUid) {
    setState(() {
      filteredUsers = allUserData
          .where((userModel) =>
      userModel.name.toLowerCase().contains(query.toLowerCase()) &&
          userModel.uid != currentUserUid)  // it ensures that the user is not included if their ID matches the current user's ID.
          .toList();
    });
  }

}