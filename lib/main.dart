import 'package:basic_api_project/view/get_api/user_details_get/User_details.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ApiBasicApp());
}

class ApiBasicApp extends StatelessWidget {
  const ApiBasicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  UserDetails(),
    );
  }
}


