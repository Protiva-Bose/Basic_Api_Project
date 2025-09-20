import 'package:basic_api_project/view/product_list_ostad/screens/update_product.dart';
import 'package:flutter/material.dart';
class ProductItem extends StatelessWidget {
  const ProductItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(

      ),
      title: Text('Product Name'),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Code : 4858459745'),
          Row(
            children: [ Text('Quantity : 5'),
              Text('Unit price : 865'),
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
    );
  }
}
enum ProductOptions {
  Update,
  Delete
}