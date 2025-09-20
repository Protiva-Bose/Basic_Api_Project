import 'package:basic_api_project/view/course/product_list_ostad/screens/product_item.dart';
import 'package:flutter/material.dart';

import 'add_products.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Product List'),
      ),
      body: ListView.separated(
          itemBuilder: (context,index){
            return ProductItem();
          }, 
          separatorBuilder: (context,index){
            return Divider(
              indent: 70,
            );
          },
          itemCount: 10),
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddProducts(),));
      },
      
      child: Icon(Icons.add),),
    );
  }

}

