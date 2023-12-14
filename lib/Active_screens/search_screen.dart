import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:internship_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../models/model_class.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {

        return Scaffold(
          appBar: AppBar(
            title: Text('Search Screen'),
            backgroundColor: Colors.amber,
          ),
          body: ListView.builder(
            itemCount: userProvider.allUserData.length,
            itemBuilder: (context, index) {
              ModelClass user = userProvider.allUserData[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.image),
                ),
                title: Text(user.name),
                subtitle:
                    Text('Phone: ${user.phone}, Country: ${user.country}'),
                // Add more details as needed
              );
            },
          ),
        );
      },
    );
  }
}
