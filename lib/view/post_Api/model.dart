import 'package:flutter/material.dart';

class Product{
  int userId;
  int id;
  String title;
  String body;

  Product({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  factory Product.fromJson(Map<String,dynamic>json){
    return Product(
        userId : json['userId'],
        id : json['id'],
        title : json['title'],
        body : json['body']
    );
  }
}
