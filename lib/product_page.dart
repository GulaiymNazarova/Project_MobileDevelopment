import 'package:firstflutterproject/widgets/product_view.dart';
import 'package:flutter/material.dart';
import 'product.dart';

class ProductPage extends StatelessWidget {
  Product product;
  ProductPage({required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(leading: IconButton(onPressed: (){
        Navigator.of(context).pop();

      }, icon: Icon(
        Icons.arrow_back
      ))),
      body: SingleChildScrollView(
        child: Expanded(child: ProductCard(product: product)),
      ),
    );
  }
}