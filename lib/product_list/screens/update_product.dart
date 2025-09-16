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
