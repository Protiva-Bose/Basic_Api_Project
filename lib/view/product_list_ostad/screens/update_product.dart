import 'package:flutter/material.dart';
class UpdateProduct extends StatefulWidget {
  const UpdateProduct({super.key});

  @override
  State<UpdateProduct> createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _uniPriceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new product')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
              spacing: 8,
              children: [
                TextFormField(
                  controller: _productNameController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Product Name',
                      labelText: 'Product Name'
                  ),
                ),
                TextFormField(
                  controller: _productCodeController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Product Code',
                      labelText: 'Product Code'
                  ),
                ),
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Quantity',
                      labelText: 'Quantity'
                  ),
                ),
                TextFormField(
                  controller: _uniPriceController,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Unit Price',
                      labelText: 'Unit Price'
                  ),
                ),TextFormField(
                  controller: _imageUrlController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                      hintText: 'Image Url',
                      labelText: 'Image Url'
                  ),
                ),
                SizedBox(height: 20,),
                FilledButton(onPressed: (){},
                  child: Text('Add Product'),
                )
              ]
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _productNameController.dispose();
    _productCodeController.dispose();
    _quantityController.dispose();
    _uniPriceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}

//import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// // ----------------- MODEL -----------------
// class Product {
//   String? id;
//   String productName;
//   int productCode;
//   int qty;
//   int unitPrice;
//   int totalPrice;
//   String img;
//
//   Product({
//     this.id,
//     required this.productName,
//     required this.productCode,
//     required this.qty,
//     required this.unitPrice,
//     required this.totalPrice,
//     required this.img,
//   });
//
//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       productName: json['ProductName'],
//       productCode: json['ProductCode'],
//       qty: json['Qty'],
//       unitPrice: json['UnitPrice'],
//       totalPrice: json['TotalPrice'],
//       img: json['Img'],
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       "ProductName": productName,
//       "ProductCode": productCode,
//       "Qty": qty,
//       "UnitPrice": unitPrice,
//       "TotalPrice": totalPrice,
//       "Img": img,
//     };
//   }
// }
//
// // ----------------- CONSTANTS -----------------
// class Constants {
//   static const String baseUrl = 'http://35.73.30.144:2008/api/v1';
// }
//
// // ----------------- API SERVICE -----------------
// class ApiService {
//   // GET all products
//   static Future<List<Product>> getProducts() async {
//     final uri = Uri.parse('${Constants.baseUrl}/ReadProduct');
//     final response = await http.get(uri);
//
//     if (response.statusCode == 200) {
//       final List data = jsonDecode(response.body)['data'];
//       return data.map((e) => Product.fromJson(e)).toList();
//     } else {
//       throw Exception('Failed to load products');
//     }
//   }
//
//   // POST: create product
//   static Future<bool> createProduct(Product product) async {
//     final uri = Uri.parse('${Constants.baseUrl}/CreateProduct');
//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(product.toJson()),
//     );
//
//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       return decoded['status'] == 'success';
//     } else {
//       return false;
//     }
//   }
//
//   // PUT: update product
//   // static Future<bool> updateProduct(int id, Product product) async {
//   //   final uri = Uri.parse('${Constants.baseUrl}/UpdateProduct/$id');
//   //   final response = await http.put(
//   //     uri,
//   //     headers: {'Content-Type': 'application/json'},
//   //     body: jsonEncode(product.toJson()),
//   //   );
//   //
//   //   if (response.statusCode == 200) {
//   //     final decoded = jsonDecode(response.body);
//   //     return decoded['status'] == 'success';
//   //   } else {
//   //     return false;
//   //   }
//   // }
//
//   // DELETE: delete product
//   static Future<bool> deleteProduct(int id) async {
//     final uri = Uri.parse('${Constants.baseUrl}/DeleteProduct/$id');
//     final response = await http.delete(uri);
//
//     if (response.statusCode == 200) {
//       final decoded = jsonDecode(response.body);
//       return decoded['status'] == 'success';
//     } else {
//       return false;
//     }
//   }
// }
//
// // ----------------- ADD / UPDATE SCREEN -----------------
// class AddProductScreen extends StatefulWidget {
//   final Product? product; // null if adding new
//
//   const AddProductScreen({this.product, Key? key}) : super(key: key);
//
//   @override
//   State<AddProductScreen> createState() => _AddProductScreenState();
// }
//
// class _AddProductScreenState extends State<AddProductScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late TextEditingController _nameController;
//   late TextEditingController _codeController;
//   late TextEditingController _qtyController;
//   late TextEditingController _priceController;
//   late TextEditingController _imgController;
//   bool _isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _nameController = TextEditingController(text: widget.product?.productName ?? '');
//     _codeController = TextEditingController(text: widget.product?.productCode.toString() ?? '');
//     _qtyController = TextEditingController(text: widget.product?.qty.toString() ?? '');
//     _priceController = TextEditingController(text: widget.product?.unitPrice.toString() ?? '');
//     _imgController = TextEditingController(text: widget.product?.img ?? '');
//   }
//
//   @override
//   void dispose() {
//     _nameController.dispose();
//     _codeController.dispose();
//     _qtyController.dispose();
//     _priceController.dispose();
//     _imgController.dispose();
//     super.dispose();
//   }
//
//   Future<void> _onTapAppProductButton() async {
//     if(_formKey.currentState!.validate()==false){
//       return;
//     }
//
//     //Prepare URI to request
//     Uri uri = Uri.parse('http://35.73.30.144:2008/api/v1/CreateProduct');
//
//     //Prepare data
//     int totalPrice =
//         int.parse(_priceController.text) *
//             int.parse(_qtyController.text);
//     Map<String, dynamic> requestBody = {
//       "ProductName": _nameController.text,
//       "ProductCode": int.parse(_codeController.text),
//       "Img": _imgController.text,
//       "Qty": int.parse(_qtyController.text),
//       "UnitPrice": int.parse(_priceController.text),
//       "TotalPrice": totalPrice,
//     };
//
//     final response = await http.post(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(requestBody),
//     );
//     print(response.statusCode);
//     print(response.body);
//
//     if (response.statusCode == 200) {
//       final decodedJson = jsonDecode(response.body);
//       if (decodedJson['status'] == 'success') {
//
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Product Created Successfully')));
//       }else{
//         String errorMassege = decodedJson['data'];
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text(errorMassege)));
//       }
//     }
//     setState(() {});
//   }
//
//   Future<void> _updateProduct(String id) async {
//     if (_formKey.currentState!.validate() == false) {
//       return;
//     }
//
//     Uri uri = Uri.parse('${Constants.baseUrl}/UpdateProduct/$id');
//
//     int totalPrice =
//         int.parse(_priceController.text) * int.parse(_qtyController.text);
//
//     Map<String, dynamic> requestBody = {
//       "ProductName": _nameController.text,
//       "ProductCode": int.parse(_codeController.text),
//       "Img": _imgController.text,
//       "Qty": int.parse(_qtyController.text),
//       "UnitPrice": int.parse(_priceController.text),
//       "TotalPrice": totalPrice,
//     };
//
//     final response = await http.put(
//       uri,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode(requestBody),
//     );
//
//     print("=============${response.statusCode}");
//     print(response.body);
//
//     if (response.statusCode == 200) {
//       final decodedJson = jsonDecode(response.body);
//       if (decodedJson['status'] == 'success') {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Product Updated Successfully')),
//         );
//         Navigator.pop(context, true); // go back and refresh list
//       } else {
//         String errorMessage = decodedJson['data'];
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage)),
//         );
//       }
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(widget.product == null ? 'Add Product' : 'Edit Product')),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(controller: _nameController, decoration: InputDecoration(labelText: 'Product Name')),
//               TextFormField(controller: _codeController, decoration: InputDecoration(labelText: 'Product Code'), keyboardType: TextInputType.number),
//               TextFormField(controller: _qtyController, decoration: InputDecoration(labelText: 'Quantity'), keyboardType: TextInputType.number),
//               TextFormField(controller: _priceController, decoration: InputDecoration(labelText: 'Unit Price'), keyboardType: TextInputType.number),
//               TextFormField(controller: _imgController, decoration: InputDecoration(labelText: 'Image URL')),
//               SizedBox(height: 20),
//               _isLoading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                 onPressed: () {
//                   if (widget.product == null) {
//                     _onTapAppProductButton(); // Create
//                   } else {
//                     _updateProduct(widget.product!.id!); // Update
//                   }
//                 },
//                 child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
//               ),
//
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// // ----------------- PRODUCT LIST SCREEN -----------------
// class ProductListScreen extends StatefulWidget {
//   @override
//   State<ProductListScreen> createState() => _ProductListScreenState();
// }
//
// class _ProductListScreenState extends State<ProductListScreen> {
//   late Future<List<Product>> _products;
//
//   @override
//   void initState() {
//     super.initState();
//     _products = ApiService.getProducts();
//   }
//
//   void _deleteProduct(int id) async {
//     bool success = await ApiService.deleteProduct(id);
//     if (success) {
//       setState(() {
//         _products = ApiService.getProducts(); // refresh list
//       });
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Product deleted successfully')),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to delete product')),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Products')),
//       body: FutureBuilder<List<Product>>(
//         future: _products,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting)
//             return Center(child: CircularProgressIndicator());
//           if (!snapshot.hasData || snapshot.data!.isEmpty)
//             return Center(child: Text('No products found'));
//
//           final products = snapshot.data!;
//           return ListView.builder(
//             itemCount: products.length,
//             itemBuilder: (context, index) {
//               final product = products[index];
//               return ListTile(
//                 leading: Image.network(product.img, width: 50, height: 50),
//                 title: Text(product.productName,style: TextStyle(color: Colors.white,),),
//                 subtitle: Text('Qty: ${product.qty} | Price: ${product.unitPrice}'),
//                 trailing: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     IconButton(
//                       icon: Icon(Icons.edit),
//                       onPressed: () async {
//                         final result = await Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => AddProductScreen(product: product),
//                           ),
//                         );
//                         if (result == true) {
//                           setState(() {
//                             _products = ApiService.getProducts();
//                           });
//                         }
//                       },
//                     ),
//                     // IconButton(
//                     //   icon: Icon(Icons.delete),
//                     //   onPressed: () => _deleteProduct(product.id!),
//                     // ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(builder: (_) => AddProductScreen()),
//           );
//           if (result == true) {
//             setState(() {
//               _products = ApiService.getProducts();
//             });
//           }
//         },
//       ),
//     );
//   }
// }
//
// // ----------------- MAIN -----------------
// void main() {
//   runApp(MaterialApp(
//     home: ProductListScreen(),
//     debugShowCheckedModeBanner: false,
//   ));
// }