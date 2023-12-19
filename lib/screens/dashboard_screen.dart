import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:internship_project/Active_screens/chat_screen.dart';
import 'package:internship_project/Active_screens/home_screen.dart';
import 'package:internship_project/Active_screens/search_screen.dart';
import 'package:internship_project/providers/post_provider.dart';
import 'package:internship_project/providers/user_provider.dart';
import 'package:provider/provider.dart';
import '../models/model_class.dart';
import '../Active_screens/Profile_screen.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int currentIndex = 0;
  List<Widget> screens = [HomeScreen(), ChatScreen(), SearchScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: GNav(
        backgroundColor: Colors.amber,
        color: Colors.white,
        tabs: [
          GButton(icon: Icons.home, text: "Home"),
          GButton(icon: Icons.chat, text: "Chat"),
          GButton(icon: Icons.search, text: "Search"),
          GButton(icon: Icons.person, text: "Profile"),
        ],
        selectedIndex: currentIndex,
        onTabChange: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
