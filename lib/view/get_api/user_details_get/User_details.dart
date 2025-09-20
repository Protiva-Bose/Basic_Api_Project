import 'dart:convert';
import 'package:basic_api_project/cors/routes/route_names.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../random_users_get/random_user.dart';


class User {
  int id;
  String title;
  String body;

  User({required this.id, required this.title, required this.body});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'], title: json['title'], body: json['body']);
  }
}


class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  List<User> users = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {

    final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/posts'),
        headers: {'Content-Type' : 'application/json'}
    );
    print('Response... ${response.body}');
    print('Response... ${response.statusCode}');

    if (response.statusCode == 200) {
      final List jsonData = jsonDecode(response.body);
      setState(() {
        users = jsonData.map((item) => User.fromJson(item)).toList().cast<User>();
      });
    } else {
      throw Exception('Failed to load users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users List'),
      ),
      backgroundColor: Colors.lightBlueAccent.shade100,
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users[index].title,style: TextStyle(color: Colors.blue[900],fontWeight: FontWeight.w500,fontSize: 20),),
            subtitle: Text(users[index].body),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: users.length,
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
      //Navigator.pushNamed(context, RouteNames.randomUser);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => RandomUser()),
        );

      },
        child: Icon(Icons.arrow_right,size: 40,),),
    );
  }
}

//final List jsonData = jsonDecode(response.body);
// users = jsonData.map((item) => User.fromJson(item)).toList().cast<User>();


//final Map<String, dynamic> jsonData = jsonDecode(response.body);
// users = (jsonData['results'] as List)
//     .map((item) => User.fromJson(item))
//     .toList();