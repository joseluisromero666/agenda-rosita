import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Components/side_menu_item.dart';
import 'package:tienda_rosita/Controller/auth.dart';
import 'package:provider/provider.dart';
import '../responsive_layout.dart';

class SideMenu extends StatelessWidget {
  final bool inCustomerView;
  final index;
  const SideMenu({Key key, this.index, this.inCustomerView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _buildBtn(String title) {
      return Container(
        width: 200,
        child: ElevatedButton(
          onPressed: () {
            context.read<AuthenticationService>().signOut();
          },
          style: ElevatedButton.styleFrom(
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            primary: (inCustomerView) ? Color(0xFF8063D4) : Color(0xFFD46382),
          ),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.normal,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    List<Widget> miswidgets = [
      SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                children: (inCustomerView)
                    ? [
                        SvgPicture.asset(
                          'assets/images/client_logo.svg',
                          alignment: Alignment.topLeft,
                        ),
                        Spacer(),
                        if (!ResponsiveLayout.isDesktop(context)) CloseButton(),
                      ]
                    : [
                        SvgPicture.asset(
                          'assets/images/logo_svg.svg',
                          alignment: Alignment.topLeft,
                        ),
                        Spacer(),
                        if (!ResponsiveLayout.isDesktop(context)) CloseButton(),
                      ],
              ),
              SizedBox(
                height: 25,
              ),
              SideMenuItem(
                icon: (inCustomerView)
                    ? FeatherIcons.shoppingBag
                    : FeatherIcons.bookOpen,
                title: (inCustomerView) ? "Tienda" : "Agenda",
                press: (inCustomerView)
                    ? () { index(0);}
                    : () {
                        index(0);
                      },
              ),
              if (!inCustomerView)
                SideMenuItem(
                  icon: FeatherIcons.database,
                  title: "Reportes",
                  press: () {
                    index(2);
                  },
                ),
              if (!inCustomerView)
                SideMenuItem(
                  icon: FeatherIcons.shoppingBag,
                  title: "Productos",
                  press: () {
                    index(1);
                  },
                ),
                  if (inCustomerView)
                SideMenuItem(
                  icon: FeatherIcons.shoppingCart,
                  title: "Carrito de Compras",
                  press: () {
                    index(1);
                  },
                ),
            ],
          ),
        ),
      ),
    ];
    Widget _buildListProduct() {
      final liprod = ListView.builder(
        itemCount: miswidgets.length,
        itemBuilder: (BuildContext context, int index) => Column(
          children: [miswidgets[index]],
        ),
      );
      return liprod;
    }

    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? 20 : 0),
      color: (inCustomerView) ? Color(0xFFB4AEE8) : Color(0xFFF4D6D6),
      child: Column(
        children: [
          Expanded(child: _buildListProduct()),
          _buildBtn('Cerrar Sesión'),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
