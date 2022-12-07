import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class FormItems extends StatefulWidget {
  final changeView;
  FormItems({this.changeView});
  @override
  _FormItemsState createState() => _FormItemsState(changeView: this.changeView);
}

class _FormItemsState extends State<FormItems> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final changeView;
  _FormItemsState({this.changeView});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Color(0xFFFAFAFA),
        leading: IconButton(
          hoverColor: Colors.transparent,
          icon: Icon(
            FeatherIcons.chevronLeft,
            color: Colors.black,
          ),
          onPressed: () {
            changeView(1);
          },
        ),
      ),
      body: Container(
        height: height,
        child: Stack(
          children: [
            Container(
              padding: ResponsiveLayout.isPhone(context)
                  ? EdgeInsets.symmetric(horizontal: 40)
                  : ResponsiveLayout.isTablet(context)
                      ? EdgeInsets.symmetric(horizontal: 80)
                      : EdgeInsets.symmetric(horizontal: 150),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: height * .1),
                    SvgPicture.asset(
                      'assets/images/logo_svg.svg',
                      alignment: Alignment.topLeft,
                    ),
                    SizedBox(height: height * .07),
                    _title(),
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                        'Ingresa la dirección de correo electrónico que usaste cuando te uniste y te enviaremos instrucciones para restablecer tu contraseña.'),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                        'Por razones de seguridad, NO almacenamos su contraseña. Así que tenga la seguridad de que nunca le enviaremos su contraseña por correo electrónico. '),
                    SizedBox(
                      height: 70,
                    ),
                    Form(
                      key: _formKey,
                      child: _formWidget(
                        emailController: emailController,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    _submitButton(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title, TextEditingController controller,
      {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          TextFormField(
            controller: controller,
            obscureText: isPassword,
            decoration: InputDecoration(
              errorStyle: TextStyle(fontSize: 0, height: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(width: 0, style: BorderStyle.none),
              ),
              fillColor: Color(0xFFF3F3F4),
              filled: true,
              hoverColor: Color(0xFFF3F3F4),
            ),
            validator: (value) {
              if (value.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'El campo correo electrónico no puede estar vacio',
                    ),
                    duration: Duration(milliseconds: 1500),
                    width: 280,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
                return "";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _title() {
    return Text(
      '¿Olvidaste tu contraseña?',
      textAlign: TextAlign.center,
      style: GoogleFonts.dancingScript(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _formWidget({emailController}) {
    return Column(
      children: [
        _entryField("Correo electrónico", emailController),
      ],
    );
  }

  Widget _submitButton(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(
        width: double.infinity,
        height: 55,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          primary: Color(0xFFD46382),
        ),
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            try {
              await FirebaseAuth.instance
                  .sendPasswordResetEmail(email: emailController.text.trim());
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Te hemos enviado un enlace al correo para restablecer tu contraseña.'),
                  duration: Duration(milliseconds: 1500),
                  width: 280,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              );
            } catch (e) {
              if (e.code == 'invalid-email' || e.code == 'user-not-found') {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'El correo electronico es incorrecto, intentelo de nuevo.'),
                    duration: Duration(milliseconds: 1500),
                    width: 300,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                );
              }
            }
          }
        },
        child: Text(
          'Enviar y resetear contraseña',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
