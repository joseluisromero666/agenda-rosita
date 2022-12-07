import 'package:flutter/material.dart';
import 'package:tienda_rosita/Components/side_menu.dart';
import 'package:tienda_rosita/Screens/orderConnection.dart';
import 'package:tienda_rosita/Screens/orderView.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class OrderTree extends StatefulWidget {
  final index;
  OrderTree({this.index});
  @override
  _OrderTreeState createState() => _OrderTreeState(index: this.index);
}

class _OrderTreeState extends State<OrderTree> {
  final index;
  _OrderTreeState({this.index});
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: ResponsiveLayout(
        phone: OrderView(),
        tablet: Row(
          children: [
            Expanded(
              flex: 9,
              child: OrderConnection(),
            )
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 2 : 3,
              child: SideMenu(
                inCustomerView: true,
                index: this.index,
              ),
            ),
            Expanded(
              flex: _size.width > 1340 ? 10 : 14,
              child: OrderConnection(),
            )
          ],
        ),
      ),
    );
  }
}
