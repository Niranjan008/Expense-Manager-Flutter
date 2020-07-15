import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'category_database_helper.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        theme: ThemeData.light(),
        home: HomePage(),
    );
  }
}