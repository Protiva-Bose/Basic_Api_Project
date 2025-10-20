import 'package:basic_api_project/cors/routes/route_names.dart';
import 'package:flutter/material.dart';

import '../../view/get_api/random_users_get/random_user.dart';
import '../../view/get_api/user_details_get/User_details.dart';
import '../../view/post_Api/add_product.dart';
import '../../view/post_Api/get_post_data.dart';

class AppRoutes {
  static const String initialRoute = RouteNames.userDetails;

  static final Map<String, WidgetBuilder> routes = {

     RouteNames.userDetails: (context) =>  UserDetails(),
     RouteNames.randomUser: (context) =>  RandomUser(),
     RouteNames.getPostData: (context) =>  GetPostData(),
     RouteNames.addProduct: (context) =>  AddProduct(),

  };
}