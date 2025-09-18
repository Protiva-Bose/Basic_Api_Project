import 'dart:convert';
import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  final String jsonData = '''
  {
    "recipes": [
      {"title": "Pasta Carbonara", "description": "Creamy pasta dish with bacon and cheese."},
      {"title": "Caprese Salad", "description": "Simple and refreshing salad with tomatoes, mozzarella, and basil."},
      {"title": "Banana Smoothie", "description": "Healthy and creamy smoothie with bananas and milk."},
      {"title": "Chicken Stir-Fry", "description": "Quick and flavorful stir-fried chicken with vegetables."},
      {"title": "Grilled Salmon", "description": "Delicious grilled salmon with lemon and herbs."},
      {"title": "Vegetable Curry", "description": "Spicy and aromatic vegetable curry."},
      {"title": "Berry Parfait", "description": "Layered dessert with fresh berries and yogurt."}
    ]
  }
  ''';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> data = jsonDecode(jsonData);
    final List recipes = data['recipes'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Food Recipes',style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue[300],
      ),


      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          final recipe = recipes[index];
          return Padding(

            padding: const EdgeInsets.all(8.0),
            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Row(
                  children: [
                    Icon(Icons.food_bank_outlined),
                    SizedBox(width: 8),
                    Text(
                      recipe['title'],style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 4),

                Text(
                  recipe['description'],style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                ),

                Divider(),
              ],
            ),
          );
        },
      ),
    );
  }
}
