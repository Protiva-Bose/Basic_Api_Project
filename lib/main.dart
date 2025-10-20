import 'package:basic_api_project/view/course/food_recipes_ostad/food_recipe_json_data.dart';
import 'package:basic_api_project/view/course/module_20_assignment/registration/registration_screen.dart';
import 'package:basic_api_project/view/course/module_20_assignment/splash/splash_screen.dart';
import 'package:basic_api_project/view/get_api/user_details_get/User_details.dart';
import 'package:flutter/material.dart';
import 'flutter_map/flutter_map.dart';

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
      home: SplashScreen(),
    );
  }
}


