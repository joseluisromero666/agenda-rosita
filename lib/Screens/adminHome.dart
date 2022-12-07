import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Components/side_menu.dart';
import 'package:tienda_rosita/Responsive/widgetTreeAgenda.dart';
import 'package:tienda_rosita/Responsive/widgetTreeProducts.dart';
import 'package:tienda_rosita/Responsive/widgetTreeReports.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class AdminHome extends StatefulWidget {
  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    List<Widget> _widgetOptions = [
      AgendaTree(index: (index) {
        this.setState(() {
          this.selectedIndex = index;
        });
      }),
      ProductsTree(index: (index) {
        this.setState(() {
          this.selectedIndex = index;
        });
      }),
      ReportTree(
        index: (index) {
          this.setState(() {
            this.selectedIndex = index;
          });
        },
      ),
    ];
    return Scaffold(
      key: _scaffoldKey,
      drawer: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 250),
        child: SideMenu(
            inCustomerView: false,
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
                      color: Color(0xFFD46382),
                    ),
                  )),
              title: Text(
                "Tienda Rosita",
                style: GoogleFonts.dancingScript(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFD46382),
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
