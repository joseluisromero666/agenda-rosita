import 'package:flutter/material.dart';
import 'package:tienda_rosita/Components/side_menu.dart';
import 'package:tienda_rosita/Screens/Agenda.dart';
import 'package:tienda_rosita/Screens/agendaConnection.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class AgendaTree extends StatefulWidget {
  final index;
  AgendaTree({this.index});
  @override
  _AgendaTreeState createState() => _AgendaTreeState(index: this.index);
}

class _AgendaTreeState extends State<AgendaTree> {
  final index;
  _AgendaTreeState({this.index});
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return SafeArea(
      child: ResponsiveLayout(
        phone: Agenda(),
        tablet: Row(
          children: [
            Expanded(
              flex: 9,
              child: AgendaConnection(),
            ),
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
              child: AgendaConnection(),
            ),
          ],
        ),
      ),
    );
  }
}
