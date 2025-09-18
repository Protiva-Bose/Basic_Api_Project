import 'package:basic_api_project/product_list/screens/products_list.dart';
import 'package:flutter/material.dart';

import 'food_recipes/food_recipe_json_data.dart';

void main() {
  runApp(const ApiBasicApp());
}

class ApiBasicApp extends StatelessWidget {
  const ApiBasicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  RecipeScreen(),
    );
  }
}


