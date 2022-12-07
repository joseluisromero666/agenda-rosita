import 'package:flutter/material.dart';
import 'package:tienda_rosita/Components/side_menu.dart';
import 'package:tienda_rosita/Screens/Products.dart';
import 'package:tienda_rosita/Screens/ProductsConnection.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class ProductsTree extends StatefulWidget {
  final index;
  ProductsTree({this.index});
  @override
  _ProductsTreeState createState() => _ProductsTreeState(index: this.index);
}

class _ProductsTreeState extends State<ProductsTree> {
  final index;
  _ProductsTreeState({this.index});
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: ResponsiveLayout(
        phone: Products(),
        tablet: Row(
          children: [
            Expanded(
              flex: 9,
              child: ProductsConnection(),
            )
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 2 : 3,
              child: SideMenu(
                inCustomerView: false,
                index: this.index,
              ),
            ),
          
         Expanded(
            flex: _size.width > 1340 ? 10 : 14,
              child: ProductsConnection(),
            )
          ],
        ),
      ),
    );
  }
}
