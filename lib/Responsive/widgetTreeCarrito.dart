import 'package:flutter/material.dart';
import 'package:tienda_rosita/Components/side_menu.dart';
import 'package:tienda_rosita/Screens/CarritoView.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class CarritoTree extends StatefulWidget {
  final index;
 CarritoTree({this.index});
  @override
  _CarritoTreeState createState() => _CarritoTreeState(index: this.index);
}

class _CarritoTreeState extends State<CarritoTree> {
  final index;
  _CarritoTreeState({this.index});
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: ResponsiveLayout(
        phone: CarritoView(),
        tablet: Row(
          children: [
            Expanded(
              flex: 9,
              child: CarritoView(),
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
              child: CarritoView(),
            )
          ],
        ),
      ),
    );
  }
}
