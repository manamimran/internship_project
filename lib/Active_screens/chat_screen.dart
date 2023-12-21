import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:internship_project/Active_screens/search_screen.dart';
import 'package:internship_project/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
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
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder:
                              (context) =>
                         SearchScreen()));
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
}
