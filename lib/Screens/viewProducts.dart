import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Controller/products.dart';
import 'package:tienda_rosita/Model/Cart.dart';
import 'package:tienda_rosita/Screens/ProductsRegister.dart';

import '../responsive_layout.dart';

// ignore: must_be_immutable
class ViewProducts extends StatefulWidget {
  final changeView;
  final bool inCustomerView;
  var index;
  ValueKey<int> key;
  String fil = "";
  ViewProducts(
      {this.changeView,
      @required this.index,
      this.inCustomerView,
      this.key,
      this.fil});

  @override
  _ViewProductsState createState() => _ViewProductsState(
      changeView: this.changeView,
      index: this.index,
      inCustomerView: this.inCustomerView);
}

class _ViewProductsState extends State<ViewProducts> {
  final bool inCustomerView;
  final changeView;
  var index;
  _ViewProductsState({this.changeView, this.index, this.inCustomerView});
  Cart thisCart = new Cart();
  int productsView = 1;

  changeProductsView(view) {
    this.setState(() {
      productsView = view;
    });
  }

  Stream usersCollection(filter) {
    var coll;
    if (filter != null)
      coll = FirebaseFirestore.instance
          .collection('products')
          .orderBy('lowerName')
          .startAt([filter.toLowerCase()]).endAt(
              [filter.toLowerCase() + '\uf8ff']).snapshots();
    else
      coll = FirebaseFirestore.instance
          .collection('products')
          .orderBy('lowerName')
          .snapshots();
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
  Widget _buildAlertDialog(String dialog,String titulo) {
    return AlertDialog(
      title: Text(titulo),
      content: Text(dialog),
      actions: [
        TextButton(
            child: Text("Aceptar"),
            onPressed: () {
              Navigator.of(context).pop();
            }),
      ],
    );
  }

  Future _showMyDialog(BuildContext context,String dialog,String titulo) async {
    return showDialog(
      context: context,
      builder: (_) => _buildAlertDialog(dialog,titulo),
    );
  }
  Widget _buildCustomerCard({String title, String data, icon}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            data,
            style: GoogleFonts.poppins(
              fontSize: 18,
            ),
            maxLines: 3,
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
          primary: (inCustomerView) ? Color(0xFF8063D4) : Color(0xFFD46382),
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
                                              .get('onSale') ==
                                          'Disponible')
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
                                                    .get('onSale') ==
                                                'Disponible')
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
                          (!inCustomerView)
                              ? Column(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: (inCustomerView)
                                            ? Color(0xFFB4AEE8)
                                            : Color(0xFFF4D6D6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Column(
                                            children: [
                                              _buildCard(
                                                  data: snapshot
                                                      .data.docs[index]
                                                      .get('name'),
                                                  icon: FeatherIcons.edit),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              _buildCard(
                                                  data: snapshot
                                                      .data.docs[index]
                                                      .get('price'),
                                                  icon:
                                                      FeatherIcons.dollarSign),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              _buildCard(
                                                  data: snapshot
                                                      .data.docs[index]
                                                      .get('description'),
                                                  icon: FeatherIcons.bookOpen),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              _buildCard(
                                                  data: snapshot
                                                      .data.docs[index]
                                                      .get('brand'),
                                                  icon: FeatherIcons.bookmark),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              _buildCard(
                                                  data: snapshot
                                                      .data.docs[index]
                                                      .get('category'),
                                                  icon: FeatherIcons.clipboard),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              _buildCard(
                                                  data: snapshot
                                                      .data.docs[index]
                                                      .get('sizes'),
                                                  icon: FeatherIcons.minimize),
                                              SizedBox(
                                                height: 15,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    if (!inCustomerView)
                                      _buildButton(
                                          data: (snapshot.data.docs[index]
                                                      .get('onSale') ==
                                                  'Disponible')
                                              ? 'Editar'
                                              : 'Reactivar contacto',
                                          tap: () {
                                            (snapshot.data.docs[index]
                                                        .get('onSale') ==
                                                    'Disponible')
                                                ? (ResponsiveLayout.isPhone(
                                                        context))
                                                    ? changeView(3)
                                                    : changeProductsView(3)
                                                // ignore: unnecessary_statements
                                                : null;
                                          }),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    if (!inCustomerView)
                                      _buildButton(
                                          data: (snapshot.data.docs[index]
                                                      .get('onSale') ==
                                                  'Disponible')
                                              ? 'Eliminar'
                                              : 'Eliminar permanentemente',
                                          tap: () {
                                            (snapshot.data.docs[index]
                                                        .get('onSale') ==
                                                    'Disponible')
                                                ? _alertDelete(
                                                    snapshot.data.docs[index])
                                                // ignore: unnecessary_statements
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
                                )
                              : Column(
                                  children: [
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      decoration: BoxDecoration(
                                        color: (inCustomerView)
                                            ? Color(0xFFB4AEE8)
                                            : Color(0xFFF4D6D6),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          _buildCustomerCard(
                                            title: 'Marca',
                                            data: snapshot.data.docs[index]
                                                .get('brand'),
                                            icon: FeatherIcons.box,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          _buildCustomerCard(
                                            title: 'Descripción',
                                            data: snapshot.data.docs[index]
                                                .get('description'),
                                            icon: FeatherIcons.bookmark,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          _buildCustomerCard(
                                            title: 'Talla',
                                            data: snapshot.data.docs[index]
                                                .get('sizes'),
                                            icon: FeatherIcons.maximize2,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                          _buildCustomerCard(
                                            title: 'Color',
                                            data: snapshot.data.docs[index]
                                                .get('colors'),
                                            icon: FeatherIcons.penTool,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '\$ ${snapshot.data.docs[index].get('price')}',
                                          style: GoogleFonts.poppins(
                                            fontSize: 40,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFB4AEE8),
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    _buildButton(
                                        data: 'Agregar al carrito',
                                        tap: () {
                                          thisCart.nombre = snapshot
                                              .data.docs[index]
                                              .get('name');
                                          thisCart.img = snapshot
                                              .data.docs[index]
                                              .get('urlImg');
                                          thisCart.marca = snapshot
                                              .data.docs[index]
                                              .get('brand');
                                          thisCart.descripcion = snapshot
                                              .data.docs[index]
                                              .get('description');
                                          thisCart.talla = snapshot
                                              .data.docs[index]
                                              .get('sizes');
                                          thisCart.color = snapshot
                                              .data.docs[index]
                                              .get('colors');
                                          thisCart.precio = int.parse(snapshot
                                              .data.docs[index]
                                              .get('price'));
                                          thisCart.cantidad = 1;
                                          bool exist=false;
                                          if (misCarts.length != 0) {
                                            for (int i = 0;
                                                i < misCarts.length;
                                                i++) {
                                              if (misCarts[i].nombre ==
                                                  thisCart.nombre) {
                                                exist = true;
                                              }
                                            }

                                            if (exist == false) {
                                              misCarts.add(thisCart);
                                              totalPriceP += int.parse(snapshot
                                                  .data.docs[index]
                                                  .get('price'));
                                                _showMyDialog(context, 'Se ha agregado el producto.', 'Exito');

                                            }else{
                                                _showMyDialog(context, 'Ya tiene este producto en su carrito.', 'Error');

                                            }
                                          } else {
                                            misCarts.add(thisCart);
                                            totalPriceP += int.parse(snapshot
                                                .data.docs[index]
                                                .get('price'));
                                                _showMyDialog(context, 'Se ha agregado el producto.', 'Exito');
                                          }
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
                    : Text('El Producto no existe')
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

    return (productsView == 1)
        ? SafeArea(
            child: Container(
              padding: (ResponsiveLayout.isDesktop(context))
                  ? EdgeInsets.only(left: 70, right: 35, top: 20, bottom: 20)
                  : EdgeInsets.all(20),
              child: _buildListProduct(),
            ),
          )
        : ProductsRegister(
            addView: true,
            index: index,
            viewProduct: changeProductsView,
            fil: widget.fil,
          );
  }

  Future<void> _alertDelete(user) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Elimiar producto'),
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
                  ProductServices().deleteProduct(user.get('name'));
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
