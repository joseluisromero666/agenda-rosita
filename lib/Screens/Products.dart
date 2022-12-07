import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Screens/ProductsRegister.dart';
import 'package:tienda_rosita/Screens/viewProducts.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class Products extends StatefulWidget {
  final changeData;
  Products({this.changeData});
  @override
  _ProductsState createState() => _ProductsState(changeData: this.changeData);
}

class _ProductsState extends State<Products> {
  var currentIndex;
  final changeData;

  _ProductsState({this.changeData});

  int agendaView = 1;
  changeView(view) {
    this.setState(() {
      agendaView = view;
    });
  }

  String filter = "";

  Stream productsCollection(filter) {
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
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: NetworkImage(
                            "https://images.unsplash.com/photo-1513884923967-4b182ef167ab?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=1050&q=80"),
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
                            "Productos",
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
                        (ResponsiveLayout.isPhone(context))
                            ? this.setState(() {
                                agendaView = 2;
                              })
                            : changeData(ProductsRegister(
                                changeView: changeData,
                                addView: false,
                              ));
                      },
                      child: Text(
                        'Agregar Producto',
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
                  Expanded(
                    child: StreamBuilder(
                        stream: productsCollection(filter),
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
                                                .get('onSale') ==
                                            'Disponible') {
                                          return GestureDetector(
                                            onTap: () {
                                              if (ResponsiveLayout.isPhone(
                                                  context)) {
                                                currentIndex = index;
                                                changeView(4);
                                              } else
                                                changeData(ViewProducts(
                                                  inCustomerView: false,
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
                                                                color: Color(
                                                                    0xFFFFFFFF),
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .normal),
                                                      )
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
                                              changeData(ViewProducts(
                                                  index: index,
                                                  key: ValueKey(index),
                                                  fil: filter));
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
                                        'No hay Productos',
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
            ? ProductsRegister(
                changeView: changeView,
                addView: false,
              )
            : (agendaView == 3)
                ? ProductsRegister(
                    changeView: changeView,
                    addView: true,
                    index: currentIndex,
                    fil: filter,
                  )
                : ViewProducts(
                    inCustomerView: false,
                    index: currentIndex,
                    changeView: changeView,
                    fil: filter,
                  );
  }
}
