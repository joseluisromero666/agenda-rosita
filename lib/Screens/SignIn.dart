import 'package:flutter/material.dart';
import 'package:tienda_rosita/Screens/ForgotPassword.dart';
import 'package:tienda_rosita/responsive_layout.dart';
import 'package:tienda_rosita/Components/form_items.dart';

class SingIn extends StatefulWidget {
  @override
  _SingInState createState() => _SingInState();
}

class _SingInState extends State<SingIn> {
  int signInView = 1;
  changeView(view) {
    this.setState(() {
      signInView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return (signInView == 1)
        ? Scaffold(
            body: ResponsiveLayout(
              phone: FormItems(changeView: changeView),
              tablet: FormItems(changeView: changeView),
              desktop: Row(
                children: [
                  Expanded(
                    flex: _size.width > 1340 ? 8 : 10,
                    child: Container(
                      child: Image(
                        image: AssetImage('assets/images/login_background.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: _size.width > 1340 ? 8 : 10,
                    child: FormItems(changeView: changeView),
                  )
                ],
              ),
            ),
          )
        : ForgotPassword(changeView: changeView);
  }
}
