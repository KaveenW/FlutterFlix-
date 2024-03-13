import 'package:firebase_core/firebase_core.dart';
import 'package:flutflix/colors.dart';
import 'package:flutflix/firebase_options.dart';
import 'package:flutflix/screens/home_screen.dart';
import 'package:flutflix/screens/login_screen.dart';
import 'package:flutflix/screens/search_screen.dart';
import 'package:flutflix/screens/singup_screen.dart';
import 'package:flutflix/screens/watch_later_screen.dart';
import 'package:flutflix/screens/watched_screen.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure that Flutter is initialized
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutflix',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colours.scaffoldBgColor,
      ),
      initialRoute: "login", // Set the initial route to the signup screen
      routes: {
        "login": (context) =>
            const LoginScreen(), // Route to your signup screen
        "home": (context) => const HomeScreen(),
        "searchPage": (context) => const SearchScreen(),
        "watchLaterPage": (context) => WatchLaterScreen(),
        "watchedPage": (context) => WatchedScreen(),
      },
    );
  }
}
