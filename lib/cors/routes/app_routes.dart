import 'package:basic_api_project/cors/routes/route_names.dart';
import 'package:flutter/material.dart';

import '../../view/random_users_get/random_user.dart';
import '../../view/user_details_get/User_details.dart';
class AppRoutes {
  static const String initialRoute = RouteNames.userDetails;

  static final Map<String, WidgetBuilder> routes = {
    //RouteNames.splashScreen: (context) =>  SplashScreen(),
    // RouteNames.productListScreen: (context) =>  ProductListScreen(),
    // RouteNames.addProductScreen: (context) =>  AddProductScreen(),
     RouteNames.userDetails: (context) =>  UserDetails(),
     RouteNames.randomUser: (context) =>  RandomUser(),

  };
}