import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'add_product.dart';

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


class GetPostData extends StatefulWidget {
  const GetPostData({super.key});

  @override
  State<GetPostData> createState() => _GetPostDataState();
}

class _GetPostDataState extends State<GetPostData> {

List<Product> product=[];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProduct();
  }

  Future<void> fetchProduct()async{
    final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/posts'),
      headers: {'Content-Type': 'application/json'},);

    print('Response...++++++++++++++ ${response.statusCode}');
    print('Response... ${response.body}');


    if(response.statusCode == 200){
    final List jsonData = jsonDecode(response.body);
    setState(() {
      product = jsonData.map((item) => Product.fromJson(item)).toList();
    });
    }else{
      debugPrint('response .......456');
      throw Exception('Failed to load product');
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.green.shade50,
        title: Text('Get Post Data'),
      ),
      backgroundColor: Colors.greenAccent.shade100,
      body: ListView.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("User: ${product[index].userId} "),
                    Text("ID: ${product[index].id}"),
                  ],
                ),
                Text(product[index].title ),
              ],
            ),
            subtitle: Text(product[index].body),
          );
        },
        separatorBuilder: (context, index) {
          return Divider();
        },
        itemCount: product.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Wait until AddProduct page is closed
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProduct()),
          );

          fetchProduct();
        },
        child: Icon(Icons.arrow_right, size: 20),
      ),

    );
  }
}

