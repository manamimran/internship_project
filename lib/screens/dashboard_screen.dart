import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:internship_project/Active_screens/home_screen.dart';
import '../models/model_class.dart';
import '../Active_screens/Profile_screen.dart';

class DashBoardScreen extends StatefulWidget {

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  ModelClass? modelClass;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: [
          // Screens corresponding to each tab
          HomeScreen(),
          HomeScreen(),
          HomeScreen(),
          ProfileScreen(),
        ],
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Colors.amber,
        color: Colors.white,
        tabs: [
          GButton(icon: Icons.home, text: "Home"),
          GButton(icon: Icons.chat, text: "Chat"),
          GButton(icon: Icons.search, text: "Search"),
          GButton(icon: Icons.person, text: "Profile"),
        ],
        selectedIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
          });
          _pageController.animateToPage(
            index,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
      ),
    );
  }
}

