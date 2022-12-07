import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Components/categories.dart';
import 'package:tienda_rosita/Screens/viewProducts.dart';

import '../responsive_layout.dart';

class OrderView extends StatefulWidget {
  final changeData;
  OrderView({this.changeData});
  @override
  _OrderViewState createState() => _OrderViewState(changeData: this.changeData);
}

class _OrderViewState extends State<OrderView> {
  var currentIndex;
  final changeData;

  _OrderViewState({this.changeData});
  String filter = "";

  int agendaView = 1;

  changeView(view) {
    this.setState(() {
      agendaView = view;
    });
  }

  Stream usersCollection(filter) {
    var coll = FirebaseFirestore.instance
        .collection('products')
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
                  Row(
                    children: [
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 4),
                          child: TextFormField(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 20 / 2)
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      "Productos Rosita",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  //Categories(),
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
                                          (BuildContext context, int i) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (ResponsiveLayout.isPhone(
                                                context)) {
                                              currentIndex = i;
                                              changeView(2);
                                            } else {
                                              changeData(ViewProducts(
                                                  inCustomerView: true,
                                                  index: i,
                                                  key: ValueKey(i),
                                                  fil: filter));
                                            }
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
                                                      .data.docs[i]
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
                                                      snapshot.data.docs[i]
                                                          .get('name'),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              color:
                                                                  Colors.white,
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
                                        'No hay productos disponibles',
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
            ? ViewProducts(
                inCustomerView: true,
                index: currentIndex,
                changeView: changeView,
                fil: filter)
            : null;
  }
}
