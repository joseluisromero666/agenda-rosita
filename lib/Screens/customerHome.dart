import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Components/side_menu.dart';
import 'package:tienda_rosita/Responsive/widgetTreeCarrito.dart';
import 'package:tienda_rosita/Responsive/widgetTreeOrder.dart';

import '../responsive_layout.dart';

class CustomerHome extends StatefulWidget {
  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    List<Widget> _widgetOptions = [
      OrderTree(
        index: (index) {
          this.setState(() {
            this.selectedIndex = index;
          });
        },
      ),
       CarritoTree(
        index: (index) {
          this.setState(() {
            this.selectedIndex = index;
          });
        },
      )
      
     
    ];
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(
            inCustomerView: true,
            index: (index) {
              this.setState(() {
                this.selectedIndex = index;
              });
            }),
      ),
      appBar: (!ResponsiveLayout.isDesktop(context))
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: GestureDetector(
                  onTap: () {
                    _scaffoldKey.currentState.openDrawer();
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(
                      FeatherIcons.menu,
                      color: Color(0xFF8063D4),
                    ),
                  )),
              title: Text(
                "Tienda Rosita",
                style: GoogleFonts.dancingScript(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8063D4),
                ),
              ),
            )
          : null,
      body: (selectedIndex == null)
          ? _widgetOptions.elementAt(0)
          : _widgetOptions.elementAt(selectedIndex),
    );
  }
}
