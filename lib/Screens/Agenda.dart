import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Screens/userRegister.dart';
import 'package:tienda_rosita/Screens/viewUser.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class Agenda extends StatefulWidget {
  final changeData;
  Agenda({this.changeData});
  @override
  _AgendaState createState() => _AgendaState(changeData: this.changeData);
}

class _AgendaState extends State<Agenda> {
  var currentIndex;
  final changeData;

  _AgendaState({this.changeData});

  int agendaView = 1;
  changeView(view) {
    this.setState(() {
      agendaView = view;
    });
  }

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
    return (agendaView == 1)
        ? SafeArea(
            child: Container(
              padding: (ResponsiveLayout.isDesktop(context))
                  ? EdgeInsets.only(left: 70, right: 35, top: 20, bottom: 20)
                  : EdgeInsets.all(20),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://images.unsplash.com/photo-1511632765486-a01980e01a18?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1500&q=80"),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.bottomRight,
                          colors: [
                            Colors.black.withOpacity(.6),
                            Colors.black.withOpacity(.3),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Agenda de Contactos",
                            style: GoogleFonts.dancingScript(
                                color: Colors.white,
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
                    height: 15,
                  ),
                  ConstrainedBox(
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
                        // UserServices().ems = await UserServices()
                        //     .retrieveUsers()
                        //     .then((value) {});
                        // print(await UserServices()
                        //     .retrieveUsers()
                        //     .then((value) {}));
                        // print(UserServices().ems);
                        (ResponsiveLayout.isPhone(context))
                            ? this.setState(() {
                                agendaView = 2;
                              })
                            : changeData(Registro(
                                changeView: changeData,
                                addView: false,
                              ));
                      },
                      child: Text(
                        'Agregar Contacto',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    initialValue: filter,
                    onChanged: (value) {
                      this.setState(() {
                        filter = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: "Buscar",
                      fillColor: Colors.white.withOpacity(0.7),
                      filled: true,
                      suffixIcon: Padding(
                        padding: const EdgeInsets.all(20 * 0.70),
                        child: Icon(
                          FeatherIcons.search,
                          color: Color(0xFFB4AEE8),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: StreamBuilder(
                        stream: usersCollection(filter),
                        builder: (context, snapshot) {
                          return snapshot.hasData
                              ? (snapshot.data.docs.length != 0)
                                  ? GridView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 2,
                                              crossAxisSpacing: 10,
                                              mainAxisSpacing: 10),
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        if (snapshot.data.docs[index]
                                            .get('isActive')) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (ResponsiveLayout.isPhone(
                                                  context)) {
                                                currentIndex = index;
                                                changeView(4);
                                              } else
                                                changeData(
                                                  ViewUser(
                                                      index: index,
                                                      key: ValueKey(index),
                                                      fil: filter),
                                                );
                                            },
                                            child: Card(
                                              color: Colors.transparent,
                                              elevation: 0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  image: DecorationImage(
                                                    image: NetworkImage(snapshot
                                                        .data.docs[index]
                                                        .get('urlImg')),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                    gradient: LinearGradient(
                                                      begin:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.black
                                                            .withOpacity(.9),
                                                        Colors.black
                                                            .withOpacity(.3),
                                                      ],
                                                    ),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        snapshot
                                                            .data.docs[index]
                                                            .get('name'),
                                                        style:
                                                            GoogleFonts.poppins(
                                                                color: (snapshot
                                                                            .data
                                                                            .docs[
                                                                                index]
                                                                            .get(
                                                                                'role') ==
                                                                        'Administrador')
                                                                    ? Color(
                                                                        0xFFD46382)
                                                                    : (snapshot.data.docs[index].get('role') ==
                                                                            'Cliente')
                                                                        ? Color(
                                                                            0xFFB4AEE8)
                                                                        : Colors
                                                                            .white,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      ),
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            if (ResponsiveLayout.isPhone(
                                                context)) {
                                              currentIndex = index;
                                              changeView(4);
                                            } else
                                              changeData(ViewUser(
                                                index: index,
                                                key: ValueKey(index),
                                                fil: filter,
                                              ));
                                          },
                                          child: Card(
                                            color: Colors.transparent,
                                            elevation: 0,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                image: DecorationImage(
                                                  image: NetworkImage(snapshot
                                                      .data.docs[index]
                                                      .get('urlImg')),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  gradient: LinearGradient(
                                                    begin:
                                                        Alignment.bottomRight,
                                                    colors: [
                                                      Colors.black
                                                          .withOpacity(1),
                                                      Colors.black
                                                          .withOpacity(1),
                                                    ],
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      snapshot.data.docs[index]
                                                              .get('name') +
                                                          " (Eliminado)",
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color: (snapshot
                                                                      .data
                                                                      .docs[
                                                                          index]
                                                                      .get(
                                                                          'isActive'))
                                                                  ? (snapshot.data.docs[index].get(
                                                                              'role') ==
                                                                          'Administrador')
                                                                      ? Color(
                                                                          0xFFD46382)
                                                                      : (snapshot.data.docs[index].get('role') ==
                                                                              'Cliente')
                                                                          ? Color(
                                                                              0xFFB4AEE8)
                                                                          : Colors
                                                                              .white
                                                                  : Colors
                                                                      .redAccent,
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Center(
                                      child: Text(
                                        'No hay usuarios',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 42,
                                        ),
                                      ),
                                    )
                              : Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                );
                        }),
                  ),
                ],
              ),
            ),
          )
        : (agendaView == 2)
            ? Registro(
                changeView: changeView,
                addView: false,
                fil: filter,
              )
            : (agendaView == 3)
                ? Registro(
                    changeView: changeView,
                    addView: true,
                    index: currentIndex,
                    fil: filter,
                  )
                : ViewUser(
                    index: currentIndex, changeView: changeView, fil: filter);
  }
}
