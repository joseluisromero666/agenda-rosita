import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  final changeView;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _FormItemsState({this.changeView});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
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
                    Form(
                      key: _formKey,
                      child: _formWidget(
                          emailController: emailController,
                          passwordController: passwordController),
                    ),
                    _forgotPassword(),
                    SizedBox(
                      height: 20,
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
                    content: (title == "Contraseña")
                        ? Text('El campo contraseña no puede estar vacio')
                        : Text(
                            'El campo correo electrónico no puede estar vacio'),
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
      'Inicio de Sesión',
      textAlign: TextAlign.center,
      style: GoogleFonts.dancingScript(
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _formWidget({emailController, passwordController}) {
    return Column(
      children: [
        _entryField("Correo electrónico", emailController),
        _entryField("Contraseña", passwordController, isPassword: true),
      ],
    );
  }

  Widget _forgotPassword() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 1),
      alignment: Alignment.centerRight,
      child: TextButton(
        onPressed: () {
          changeView(2);
        },
        child: Text(
          '¿Olvidaste tu contraseña?',
          style: GoogleFonts.poppins(
            color: Color(0xFFD46382),
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
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
        onPressed: () {
          if (_formKey.currentState.validate()) {
            signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim());
          }
        },
        child: Text(
          'Iniciar Sesión',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // SIGN IN WITH EMAIL AND PASSWORD
  Future<void> signIn({String email, String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-email' ||
          e.code == 'wrong-password' ||
          e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'El correo electronico o la contraseña son incorrectos, intentelo de nuevo.'),
            duration: Duration(milliseconds: 1500),
            width: 280,
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
}
