import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

class AddProducts extends StatefulWidget {
  const AddProducts({super.key});

  @override
  State<AddProducts> createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  bool _onProgressProduct = false;
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
                  labelText: 'Product Name',
                ),
              ),
              TextFormField(
                controller: _productCodeController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Product Code',
                  labelText: 'Product Code',
                ),
              ),
              TextFormField(
                controller: _quantityController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Quantity',
                  labelText: 'Quantity',
                ),
              ),
              TextFormField(
                controller: _uniPriceController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Unit Price',
                  labelText: 'Unit Price',
                ),
              ),
              TextFormField(
                controller: _imageUrlController,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: 'Image Url',
                  labelText: 'Image Url',
                ),
              ),
              SizedBox(height: 20),
              Visibility(
                visible: _onProgressProduct == false,
                replacement: Center(child: CircularProgressIndicator()),
                child: FilledButton(
                  onPressed: _onTapAppProductButton,
                  child: Text('Add Product'),
                ),
              ),
            ],
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

  Future<void> _onTapAppProductButton() async {
    if(_formKey.currentState!.validate()==false){
      return;
    }
    _onProgressProduct = true;
    setState(() {});
    //Prepare URI to request
    Uri uri = Uri.parse('http://35.73.30.144:2008/api/v1/CreateProduct');

    //Prepare data
    int totalPrice =
        int.parse(_uniPriceController.text) *
        int.parse(_quantityController.text);
    Map<String, dynamic> requestBody = {
      "ProductName": _productNameController.text,
      "ProductCode": int.parse(_productCodeController.text),
      "Img": _imageUrlController.text,
      "Qty": int.parse(_quantityController.text),
      "UnitPrice": int.parse(_uniPriceController.text),
      "TotalPrice": totalPrice,
    };

    Response response = await post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      if (decodedJson['status'] == 'success') {
        _clearTextField();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Product Created Successfully')));
      }else{
        String errorMassege = decodedJson['data'];
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(errorMassege)));
      }
    }
    _onProgressProduct = false;
    setState(() {});
  }

  void _clearTextField() {
    _productNameController.clear();
    _productCodeController.clear();
    _quantityController.clear();
    _uniPriceController.clear();
    _imageUrlController.clear();
  }
}
