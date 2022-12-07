import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Controller/user.dart';
import 'package:tienda_rosita/Screens/userRegister.dart';

import '../responsive_layout.dart';

class ViewUser extends StatefulWidget {
  final changeView;
  var index;
  ValueKey<int> key;
  var fil;
  ViewUser({this.changeView, @required this.index, this.key, this.fil});
  @override
  _ViewUserState createState() => _ViewUserState(
        changeView: this.changeView,
        index: this.index,
      );
}

class _ViewUserState extends State<ViewUser> {
  final changeView;
  var index;
  _ViewUserState({this.changeView, this.index});

  int userView = 1;
  changeUserView(view) {
    this.setState(() {
      userView = view;
    });
  }

  Stream usersCollection(filter) {
    var coll = FirebaseFirestore.instance
        .collection('users')
        .orderBy('lowerName')
        .startAt([filter.toLowerCase()]).endAt(
            [filter.toLowerCase() + '\uf8ff']).snapshots();
    return coll;
  }

  Widget _buildCard({String data, icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      height: 50,
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            data,
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({String data, tap}) {
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
        onPressed: tap,
        child: Text(
          data,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> miswidgets = [
      StreamBuilder(
          key: widget.key,
          stream: usersCollection(widget.fil),
          builder: (context, snapshot) {
            return snapshot.hasData
                ? (snapshot.data.docs.length != 0)
                    ? Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: (ResponsiveLayout.isDesktop(context))
                                ? 350
                                : 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: NetworkImage(
                                    snapshot.data.docs[index].get('urlImg')),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomRight,
                                  colors: (snapshot.data.docs[index]
                                          .get('isActive'))
                                      ? [
                                          Colors.black.withOpacity(.6),
                                          Colors.black.withOpacity(.3),
                                        ]
                                      : [
                                          Colors.black.withOpacity(1),
                                          Colors.black.withOpacity(1),
                                        ],
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    snapshot.data.docs[index].get('name'),
                                    style: GoogleFonts.dancingScript(
                                        color: (snapshot.data.docs[index]
                                                .get('isActive'))
                                            ? Colors.white
                                            : Colors.redAccent,
                                        fontSize: 35,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Color(0xFFF4D6D6),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    Column(
                                      children: [
                                        _buildCard(
                                            data: snapshot.data.docs[index]
                                                .get('email'),
                                            icon: FeatherIcons.mail),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        _buildCard(
                                            data: snapshot.data.docs[index]
                                                .get('city'),
                                            icon: FeatherIcons.home),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        _buildCard(
                                            data: snapshot.data.docs[index]
                                                .get('phone'),
                                            icon: FeatherIcons.phone),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        _buildCard(
                                            data: snapshot.data.docs[index]
                                                .get('role'),
                                            icon: FeatherIcons.shield),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        (snapshot.data.docs[index]
                                                    .get('role') ==
                                                'Cliente')
                                            ? Column(
                                                children: [
                                                  _buildCard(
                                                    data: (snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'document') !=
                                                            null)
                                                        ? snapshot
                                                            .data.docs[index]
                                                            .get('document')
                                                        : 'N/A',
                                                    icon:
                                                        FeatherIcons.creditCard,
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  _buildCard(
                                                    data: (snapshot.data
                                                                .docs[index]
                                                                .get(
                                                                    'address') !=
                                                            null)
                                                        ? snapshot
                                                            .data.docs[index]
                                                            .get('address')
                                                        : 'N/A',
                                                    icon: FeatherIcons.mapPin,
                                                  ),
                                                ],
                                              )
                                            : SizedBox(
                                                height: 0,
                                              ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              _buildButton(
                                  data: (snapshot.data.docs[index]
                                          .get('isActive'))
                                      ? 'Editar'
                                      : 'Reactivar contacto',
                                  tap: () {
                                    (snapshot.data.docs[index].get('isActive'))
                                        ? (ResponsiveLayout.isPhone(context))
                                            ? changeView(3)
                                            : changeUserView(2)
                                        : UserServices().activateUser(snapshot
                                            .data.docs[index]
                                            .get('email'));
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              _buildButton(
                                  data: (snapshot.data.docs[index]
                                          .get('isActive'))
                                      ? 'Eliminar'
                                      : 'Eliminar permanentemente',
                                  tap: () {
                                    (snapshot.data.docs[index].get('isActive'))
                                        ? _alertDelete(
                                            snapshot.data.docs[index])
                                        : null;
                                  }),
                              SizedBox(
                                height: 15,
                              ),
                              if (ResponsiveLayout.isPhone(context))
                                _buildButton(
                                    data: 'Volver',
                                    tap: () {
                                      changeView(1);
                                    }),
                            ],
                          ),
                        ],
                      )
                    : Text('El empleado no existe')
                : Center(
                    child: CircularProgressIndicator(),
                  );
          })
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

    return (userView == 1)
        ? SafeArea(
            child: Container(
              padding: (ResponsiveLayout.isDesktop(context))
                  ? EdgeInsets.only(left: 70, right: 35, top: 20, bottom: 20)
                  : EdgeInsets.all(20),
              child: _buildListProduct(),
            ),
          )
        : Registro(
            addView: true,
            index: index,
            userView: changeUserView,
            fil: widget.fil,
          );
  }

  Future<void> _alertDelete(user) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Elimiar empleado'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text(user.get('name') + ' será eliminad@.'),
                  Text('Seguro de que desea hacerlo?'),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  UserServices().deleteUser(user.get('email'));
                  Navigator.of(context).pop();
                  if (ResponsiveLayout.isPhone(context)) changeView(1);
                },
                child: Text('Acepto'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancelar'),
              ),
            ],
          );
        });
  }
}
