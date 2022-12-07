import 'package:flutter/material.dart';
import 'package:tienda_rosita/Screens/orderView.dart';
import 'package:tienda_rosita/Screens/viewProducts.dart';

class OrderConnection extends StatefulWidget {
  @override
  _OrderConnectionState createState() => _OrderConnectionState();
}

class _OrderConnectionState extends State<OrderConnection> {
  Widget index = ViewProducts(index: 0, inCustomerView: true, fil: "");
  changeData(value) {
    this.setState(() {
      index = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 9,
            child: OrderView(
              changeData: changeData,
            )),
        Expanded(flex: 9, child: index),
      ],
    );
  }
}
