import 'package:flutter/material.dart';
import 'package:tienda_rosita/responsive_layout.dart';
import 'package:tienda_rosita/Components/form_items_pass.dart';

class ForgotPassword extends StatefulWidget {
  final changeView;
  ForgotPassword({this.changeView});
  @override
  _ForgotPasswordState createState() =>
      _ForgotPasswordState(changeView: this.changeView);
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final changeView;
  _ForgotPasswordState({this.changeView});
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: ResponsiveLayout(
        phone: FormItems(
          changeView: changeView,
        ),
        tablet: FormItems(
          changeView: changeView,
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: Container(
                child: Image(
                  image: AssetImage('assets/images/paisaje.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: FormItems(
                changeView: changeView,
              ),
            )
          ],
        ),
      ),
    );
  }
}
