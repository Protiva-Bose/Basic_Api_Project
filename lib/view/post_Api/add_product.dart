import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product {
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

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  bool _onProgress = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _userIdController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  List<Product> product = [];

  Future<void> fetchGivenData() async {
    if (_formKey.currentState!.validate() == false) {
      return;
    }
    setState(() => _onProgress = true);

    final response = await http.post(
      Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({
        'userId': int.parse(_userIdController.text),
        'title': _titleController.text,
        'body': _bodyController.text,
      }),
    );

    if (response.statusCode == 201) {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        product.add(Product.fromJson(jsonData));
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product Created Successfully')));
      _clearTextField();
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Product Creation Failed')));
    }

    setState(() => _onProgress = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Products')),
      backgroundColor: Colors.blueAccent.shade100,
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 8,
                children: [
                  TextFormField(
                    controller: _userIdController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'User Id',
                      labelText: 'User Id',
                    ),
                  ),
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      labelText: 'Title',
                    ),
                  ),
                  TextFormField(
                    controller: _bodyController,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      labelText: 'Description',
                    ),
                  ),
                  Visibility(
                    visible: _onProgress == false,
                    replacement: Center(child: CircularProgressIndicator()),
                    child: ElevatedButton(
                      onPressed: fetchGivenData,
                      child: Center(child: Text('Add')),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
          Expanded(
            child: ListView.builder(
              itemCount: product.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Text(product[index].id.toString()),
                  title: Text(product[index].title),
                  subtitle: Text(product[index].body),
                  trailing: Text("User: ${product[index].userId}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _clearTextField() {
    _userIdController.clear();
    _titleController.clear();
    _bodyController.clear();
  }

  @override
  void dispose() {
    _userIdController.dispose();
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }
}
