import 'package:flutter/material.dart';
import 'package:tienda_rosita/Screens/Products.dart';
import 'package:tienda_rosita/Screens/viewProducts.dart';

class ProductsConnection extends StatefulWidget {
  @override
  _ProductsConnectionState createState() => _ProductsConnectionState();
}

class _ProductsConnectionState extends State<ProductsConnection> {
  Widget i = ViewProducts(
    index: 0,
    key: ValueKey(0),
    inCustomerView: false,
  );
  changeData(value) {
    this.setState(() {
      i = value;
      print(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 9,
          child: Products(
            changeData: changeData,
          ),
        ),
        Expanded(
          flex: 9,
          child: i,
        )
      ],
    );
  }
}
