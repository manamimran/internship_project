
import 'package:flutter/material.dart';
import 'package:internship_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/model_class.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  List<ModelClass> filteredUsers = [];     //This list is used to store the users that match the search criteria.

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                border: InputBorder.none,
              ),
              onChanged: (query) {   //The parameter query represents the current text value entered by the user in the search bar.
                // Handle search as the user types
                filterUsers(userProvider.allUserData, query);
              },
            ),
            backgroundColor: Colors.amber,
          ),
          body: ListView.separated(   // ListView. separated(), which lets you add a separator to each item,
            itemCount: filteredUsers.length,
            separatorBuilder: (context, index) => Divider(),
            itemBuilder: (context, index) {
              ModelClass user = filteredUsers[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.image),
                ),
                title: Text(user.name),
                trailing: ElevatedButton(
                  onPressed: () async {

                  }, child: Text('Send Request'),
                ),
                // Add more details as needed
              );
            },
          ),
        );
      },
    );
  }

  void filterUsers(List<ModelClass> allUserData, String query) {      //It updates the filteredUsers list with users whose names contain the search query (case-insensitive).
    setState(() {
      filteredUsers = allUserData
          .where((modelClass) => modelClass.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }
}