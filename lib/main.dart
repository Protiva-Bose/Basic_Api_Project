import 'package:basic_api_project/view/course/food_recipes_ostad/food_recipe_json_data.dart';
import 'package:basic_api_project/view/course/module_20_assignment/auth/otp/otp_verify.dart';
import 'package:basic_api_project/view/course/module_20_assignment/profile/profile_details/profile_screen.dart';
import 'package:basic_api_project/view/course/module_20_assignment/profile/update_profile/update_profile_screen.dart';
import 'package:basic_api_project/view/course/module_20_assignment/splash/splash_screen.dart';
import 'package:basic_api_project/view/course/module_20_assignment/user_task/user_task_home_page.dart';
import 'package:basic_api_project/view/get_api/user_details_get/User_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'flutter_map/flutter_map.dart';

void main() {
  runApp(const ApiBasicApp());
}

class ApiBasicApp extends StatelessWidget {
  const ApiBasicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),  // set the design size matching your design mock-up
        minTextAdapt: true,
        splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
          home: UserTaskHomePage(),
        );
      }
    );
  }
}


