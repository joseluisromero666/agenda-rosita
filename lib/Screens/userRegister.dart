import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Controller/user.dart';
import 'package:tienda_rosita/Model/User.dart';
import 'package:tienda_rosita/Screens/viewUser.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class Registro extends StatefulWidget {
  final addView, changeView, index, userView, fil;

  Registro({
    Key key,
    this.changeView,
    this.addView,
    this.index,
    this.userView,
    this.fil,
  }) : super(key: key);

  @override
  _RegistroState createState() => _RegistroState(
      changeView: this.changeView,
      addView: this.addView,
      index: this.index,
      userView: this.userView);
}

class _RegistroState extends State<Registro> {
  final addView, changeView, index, userView;
  var currentEmail;
  final UserModel newUser = UserModel();
  final formKey = GlobalKey<FormState>();

  _RegistroState(
      {this.changeView,
      this.addView,
      this.index,
      this.currentEmail,
      this.userView});

  String filter = "";

  Stream usersCollection(filter) {
    var coll = FirebaseFirestore.instance
        .collection('users')
        .orderBy('lowerName')
        .startAt([filter.toLowerCase()]).endAt(
            [filter.toLowerCase() + '\uf8ff']).snapshots();
    return coll;
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    InputDecoration formDecoration() {
      return InputDecoration(
        errorStyle: TextStyle(
          fontSize: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(width: 0, style: BorderStyle.none),
        ),
        fillColor: Color(0xFFF3F3F4),
        filled: true,
        hoverColor: Color(0xFFF3F3F4),
      );
    }

    Widget _buildNameField({String name}) {
      return TextFormField(
        keyboardType: TextInputType.text,
        initialValue: (addView) ? name : "",
        validator: (String value) {
          if (value.isEmpty) {
            return "El campo nombre no puede estar vacio";
          }
          newUser.name = value;
          newUser.lowerName = value.toLowerCase();
          return null;
        },
        decoration: formDecoration(),
      );
    }

    Widget _buildUrlField({String url}) {
      return TextFormField(
        keyboardType: TextInputType.url,
        initialValue: (addView) ? url : "",
        validator: (String value) {
          if (value.isEmpty) {
            return "El campo Url Foto no puede estar vacio";
          }
          if (!Uri.parse(value).isAbsolute) {
            return "El Url no es valido";
          }
          newUser.urlImg = value;
          return null;
        },
        decoration: formDecoration(),
      );
    }

    Widget _buildEmailField({String email}) {
      currentEmail = email;
      return TextFormField(
        keyboardType: TextInputType.emailAddress,
        initialValue: (addView) ? email : "",
        onChanged: (value) {},
        validator: (String value) {
          if (value.isEmpty) {
            return "El campo correo electrónico no puede estar vacio";
          }
          if (!EmailValidator.validate(value)) {
            return "El correo electrónico no es valido.";
          }
          print(value);
          newUser.email = value;
          return null;
        },
        decoration: formDecoration(),
      );
    }

    bool isPhone(phone) {
      String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';
      RegExp regExp = new RegExp(pattern);
      return regExp.hasMatch(phone);
    }

    Widget _buildPhoneField({String phone}) {
      return TextFormField(
        keyboardType: TextInputType.phone,
        initialValue: (addView) ? phone : "",
        validator: (String value) {
          if (value.isEmpty) {
            return "El campo teléfono no puede estar vacio";
          }
          if (!isPhone(value)) {
            return "El teléfono no es valido";
          }
          newUser.phone = value;
          return null;
        },
        decoration: formDecoration(),
      );
    }

    Widget _buildCityField({String city}) {
      return TextFormField(
        keyboardType: TextInputType.text,
        initialValue: (addView) ? city : "",
        validator: (String value) {
          if (value.isEmpty) {
            return "El campo ciudad no puede estar vacio";
          }
          newUser.city = value;
          return null;
        },
        decoration: formDecoration(),
      );
    }

    Widget _buildRoleField() {
      String selected;
      return DropdownButtonFormField<String>(
        decoration: formDecoration(),
        value: selected,
        items: ["Contacto", "Cliente", "Administrador"]
            .map(
              (label) => DropdownMenuItem(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(),
                ),
                value: label,
              ),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            selected = value;
          });
        },
        validator: (String value) {
          if (value == null) {
            return "Hay campos vacios";
          }
          newUser.role = value;
          return null;
        },
      );
    }

    Widget _entryField(String title, Widget formFied) {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: (ResponsiveLayout.isPhone(context))
            ? EdgeInsets.symmetric(horizontal: 40)
            : null,
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
            formFied,
          ],
        ),
      );
    }

    List<Widget> miswidget = [
      (addView)
          ? StreamBuilder(
              stream: usersCollection(widget.fil),
              builder: (context, snapshot) => snapshot.hasData
                  ? (snapshot.data.docs.length != 0)
                      ? Column(
                          children: [
                            _entryField(
                              "Url Foto",
                              _buildUrlField(
                                  url: snapshot.data.docs[index].get('urlImg')),
                            ),
                            _entryField(
                              "Nombre",
                              _buildNameField(
                                  name: snapshot.data.docs[index].get('name')),
                            ),
                            _entryField(
                              "Correo electrónico",
                              _buildEmailField(
                                  email:
                                      snapshot.data.docs[index].get('email')),
                            ),
                            _entryField(
                              "Telefono",
                              _buildPhoneField(
                                  phone:
                                      snapshot.data.docs[index].get('phone')),
                            ),
                            _entryField(
                              "Ciudad",
                              _buildCityField(
                                  city: snapshot.data.docs[index].get('city')),
                            ),
                          ],
                        )
                      : Text('El usuario no existe')
                  : CircularProgressIndicator(),
            )
          : Column(
              children: [
                _entryField(
                  "Url Foto",
                  _buildUrlField(),
                ),
                _entryField(
                  "Nombre",
                  _buildNameField(),
                ),
                _entryField(
                  "Correo electrónico",
                  _buildEmailField(),
                ),
                _entryField(
                  "Telefono",
                  _buildPhoneField(),
                ),
                _entryField(
                  "Ciudad",
                  _buildCityField(),
                ),
                _entryField(
                  "Rol",
                  _buildRoleField(),
                ),
              ],
            )
    ];

    Widget _buildBtn(String title, Function action) {
      return Container(
        width: (ResponsiveLayout.isPhone(context))
            ? _size.width / 2.5
            : _size.width / 7,
        child: ElevatedButton(
          onPressed: action,
          style: ElevatedButton.styleFrom(
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            primary: Color(0xFFD46382),
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

    Widget _buildRowBtn() {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBtn(
              (addView) ? "Editar" : "Agregar",
              (addView)
                  ? () async {
                      if (formKey.currentState.validate()) {
                        UserServices().updateUser(newUser, currentEmail);
                        (userView != null) ? userView(1) : changeView(1);
                      }
                      formKey.currentState.save();
                    }
                  : () async {
                      if (formKey.currentState.validate()) {
                        UserServices().addUser(newUser);
                        (ResponsiveLayout.isPhone(context))
                            ? ((userView != null) ? userView(1) : changeView(1))
                            : changeView(ViewUser(
                                index: 0,
                                key: ValueKey(0),
                                fil: "",
                              ));
                      }
                      formKey.currentState.save();
                    }),
          _buildBtn("Cancelar", () {
            (userView != null)
                ? userView(1)
                : (ResponsiveLayout.isPhone(context))
                    ? ((addView) ? changeView(4) : changeView(1))
                    : changeView(ViewUser(
                        index: 0,
                        key: ValueKey(0),
                        fil: "",
                      ));
          }),
        ],
      );
    }

    Widget _buildListProduct() {
      final liprod = ListView.builder(
        itemCount: miswidget.length,
        itemBuilder: (BuildContext context, int index) => Column(
          children: [miswidget[index]],
        ),
      );
      return liprod;
    }

    return Scaffold(
      body: Container(
        padding: (ResponsiveLayout.isDesktop(context))
            ? EdgeInsets.only(left: 70, right: 35, top: 20, bottom: 20)
            : null,
        child: Column(
          children: [
            SizedBox(
              height: 05.0,
            ),
            Expanded(
              child: Form(
                key: formKey,
                child: _buildListProduct(),
              ),
            ),
            _buildRowBtn(),
            SizedBox(
              height: 30.0,
            ),
          ],
        ),
      ),
    );
  }
}
