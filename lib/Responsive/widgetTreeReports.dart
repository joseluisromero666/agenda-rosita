import 'package:flutter/material.dart';
import 'package:tienda_rosita/Components/side_menu.dart';
import 'package:tienda_rosita/Screens/Reports.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class ReportTree extends StatefulWidget {
  final index;
  ReportTree({this.index});
  @override
  _ReportTreeState createState() => _ReportTreeState(index: this.index);
}

class _ReportTreeState extends State<ReportTree> {
  final index;
  _ReportTreeState({this.index});
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
        child: ResponsiveLayout(
      phone: Reports(),
      tablet: Reports(),
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
            child: Reports(),
          ),
        ],
      ),
    ));
  }
}
