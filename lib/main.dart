import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internship_project/Active_screens/Profile_screen.dart';
import 'package:internship_project/Active_screens/home_screen.dart';
import 'package:internship_project/screens/provider_class.dart';
import 'package:internship_project/screens/dashboard_screen.dart';
import 'package:internship_project/Active_screens/profile.Data.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'screens/Auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<PostProvider>(create:(_)=>PostProvider(),),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: ProfileScreen(),
      ),
    );
  }
}
