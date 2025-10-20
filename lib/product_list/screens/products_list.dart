import 'dart:convert';

import 'package:basic_api_project/product_list/screens/product_item.dart';
import 'package:basic_api_project/product_list/screens/update_product.dart';
import 'package:basic_api_project/product_list/utils/urls/url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'add_products.dart';
import 'models/product_list_model/product_list.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {

  final List <Product> _productList = [];
  bool _getLoader = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProductList();
  }

  Future<void> _getProductList()async{
    _productList.clear();
    _getLoader = true;
    setState(() {

    });
    Uri uri = Uri.parse(EndPoint.getProductList);

   Response response= await get(uri);

   debugPrint(response.statusCode.toString());
   debugPrint(response.body);

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);

      for (Map<String, dynamic> productJson in decodedJson['data']) {
        Product product = Product.fromJson(productJson);

        _productList.add(product);
      }
    }
    _getLoader = false;
    setState(() {

    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Product List'),
        actions: [
          IconButton(onPressed: (){ _getProductList();}, icon: Icon(Icons.refresh))
        ],
      ),
      body: ListView.separated(
          itemCount: _productList.length,
          itemBuilder: (context,index){
            return ProductItem(product: _productList[index],);
          }, 
          separatorBuilder: (context,index){
            return Divider(
              indent: 70,
            );
          },
         ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProducts(),));
      },
      
      child: Icon(Icons.add),),
    );
  }

}

