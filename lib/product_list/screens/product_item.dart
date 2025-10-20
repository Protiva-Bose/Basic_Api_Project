import 'package:basic_api_project/product_list/screens/models/product_list_model/product_list.dart';
import 'package:basic_api_project/product_list/screens/update_product.dart';
import 'package:flutter/material.dart';
class ProductItem extends StatelessWidget {
   ProductItem({
    super.key, required this.product,
  });

  final Product product;
  bool _getLoader=false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _getLoader == false,
      replacement: Center(child: CircularProgressIndicator()),

      child: ListTile(
        leading: CircleAvatar(
              child: Image.network(product.image,
              errorBuilder: (_,__,_){
                return Icon(Icons.error_outline);
              },
              ),
        ),
        title: Text(product.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Code :${product.code}'),
            Row(
              children: [ Text('Quantity : ${product.quantity}'),
                Text('Unit price : ${product.unitPrice}'),
              ],
            ),
          ],
        ),
        trailing: PopupMenuButton<ProductOptions>(
            itemBuilder:  (context){
              return [ PopupMenuItem(
                  value: ProductOptions.Update,
                  child: Text('Update')),
                PopupMenuItem(
                    value: ProductOptions.Delete,
                    child: Text('Delete'))
              ];
            },
            onSelected:( ProductOptions selectedOption){
              if(selectedOption == ProductOptions.Delete){
                print('Delete');
              }else if(selectedOption == ProductOptions.Update){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> UpdateProduct(),));
              }
            }

        ),
      ),
    );
  }
}
enum ProductOptions {
  Update,
  Delete
}