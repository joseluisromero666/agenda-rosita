import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Controller/products.dart';
import 'package:tienda_rosita/Model/Product.dart';
import 'package:tienda_rosita/Screens/viewProducts.dart';
import 'package:tienda_rosita/responsive_layout.dart';

class ProductsRegister extends StatefulWidget {
  final addView, changeView, index, viewProduct, fil;

  ProductsRegister({
    Key key,
    this.changeView,
    this.addView,
    this.index,
    this.viewProduct,
    this.fil,
  }) : super(key: key);

  @override
  _ProductsRegisterState createState() => _ProductsRegisterState(
      changeView: this.changeView,
      addView: this.addView,
      index: this.index,
      userView: this.viewProduct);
}

class _ProductsRegisterState extends State<ProductsRegister> {
  final addView, changeView, index, userView;
  final ProductModel newProduct = ProductModel();
  final usersCollection =
      FirebaseFirestore.instance.collection('products').snapshots();
  final formKey = GlobalKey<FormState>();

  String filter = "";

  Stream productsCollection(filter) {
    var coll = FirebaseFirestore.instance
        .collection('products')
        .orderBy('lowerName')
        .startAt([filter.toLowerCase()]).endAt(
            [filter.toLowerCase() + '\uf8ff']).snapshots();
    return coll;
  }

  _ProductsRegisterState(
      {this.changeView, this.addView, this.index, this.userView});

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
          newProduct.name = value;
          newProduct.lowerName = value.toLowerCase();
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
            return "El campo Url Producto no puede estar vacio";
          }
          if (!Uri.parse(value).isAbsolute) {
            return "El Url no es valido";
          }
          newProduct.urlImg = value;
          return null;
        },
        decoration: formDecoration(),
      );
    }

    Widget _buildCategoryField({String category}) {
      String selected;
      return DropdownButtonFormField<String>(
        decoration: formDecoration(),
        value: selected,
        items: [
          "Tops",
          "Pantalones",
          'Zapatos',
          'Bufandas',
          'Cinturones',
          'Sombreros',
          'Vestidos',
          'Trajes de baño',
          'Perfumes'
        ]
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
            return "No ha seleccionado una Categoria";
          }
          newProduct.category= value;
          return null;
        },
      );
    }

    Widget _buildBrandField() {
      String selected;
      return DropdownButtonFormField<String>(
        decoration: formDecoration(),
        value: selected,
        items: ["Adidas", "Nike", 'Arturo Calle', 'Leonisa', 'Koaj', 'Bossi']
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
            return "No ha seleccionado una Marca";
          }
          newProduct.brand = value;
          return null;
        },
      );
    }

    Widget _buildDescriptionField({String description}) {
      return TextFormField(
        keyboardType: TextInputType.text,
        initialValue: (addView) ? description : "",
        validator: (String value) {
          if (value.isEmpty) {
            return "La descripción no puede estar vacia";
          }
          newProduct.description = value;
          return null;
        },
        decoration: formDecoration(),
      );
    }

    Widget _buildPriceField({String price}) {
      return TextFormField(
        keyboardType: TextInputType.number,
        initialValue: (addView) ? price : "",
        validator: (value) {
          if (value.isEmpty) {
            return "El precio no puede estar vacia";
          }
          newProduct.price = value;
          return null;
        },
        decoration: formDecoration(),
      );
    }

    Widget _buildQuantityField({String quantity}) {
      return TextFormField(
        keyboardType: TextInputType.number,
        initialValue: (addView) ? quantity : "",
        validator: (value) {
          if (value.isEmpty) {
            return "La cantidad no puede estar vacia";
          }
          newProduct.quantity = value;
          return null;
        },
        decoration: formDecoration(),
      );
    }

    Widget _buildColorsField() {
      String selected;
      return DropdownButtonFormField<String>(
        decoration: formDecoration(),
        value: selected,
        items: [
          "Azul",
          "Verde",
          "Morado",
          "Gris",
          "Rosa",
          "Rojo",
          "Negro",
          "Blanco",
          "Naranja",
          "Marrón",
          "Turquesa",
          "Beige",
          "Magenta",
          "Lavanda",
          "Amarillo"
        ]
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
            return "No ha seleccionado un color";
          }
          newProduct.colors = value;
          return null;
        },
      );
    }

    Widget _buildSizesField({sizes}) {
      return TextFormField(
        keyboardType: TextInputType.text,
        initialValue: (addView) ? sizes : "",
        validator: (value) {
          if (value.isEmpty) {
            return "La talla no pueden estar vacia";
          }
          newProduct.sizes = value;
          return null;
        },
        decoration: formDecoration(),
      );
    }

    Widget _buildOnSaleField() {
      String selected;
      return DropdownButtonFormField<String>(
        decoration: formDecoration(),
        value: selected,
        items: [
          "Disponible",
          "No Disponible",
        ]
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
          newProduct.onSale = value;
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
              stream: productsCollection(widget.fil),
              builder: (context, snapshot) => snapshot.hasData
                  ? (snapshot.data.docs.length != 0)
                      ? Column(
                          children: [
                            _entryField(
                              "Url Imagen",
                              _buildUrlField(
                                  url: snapshot.data.docs[index].get('urlImg')),
                            ),
                            _entryField(
                              "Nombre",
                              _buildNameField(
                                  name: snapshot.data.docs[index].get('name')),
                            ),
                            _entryField(
                              "Categoria",
                              _buildCategoryField(
                                  category:
                                      snapshot.data.docs[index].get('name')),
                            ),
                            _entryField(
                              "Marca",
                              _buildBrandField(),
                            ),
                            _entryField(
                              "Descripción",
                              _buildDescriptionField(
                                  description: snapshot.data.docs[index]
                                      .get('description')),
                            ),
                            _entryField(
                              "Precio",
                              _buildPriceField(
                                  price:
                                      snapshot.data.docs[index].get('price')),
                            ),
                            _entryField(
                              "Cantidad",
                              _buildQuantityField(
                                  quantity: snapshot.data.docs[index]
                                      .get('quantity')),
                            ),
                            _entryField(
                              "Colores",
                              _buildColorsField(),
                            ),
                            _entryField(
                              "Tallas",
                              _buildSizesField(
                                  sizes:
                                      snapshot.data.docs[index].get('sizes')),
                            ),
                            _entryField(
                              "Disponibilidad",
                              _buildOnSaleField(),
                            ),
                          ],
                        )
                      : Text('El usuario no existe')
                  : CircularProgressIndicator(),
            )
          : Column(
              children: [
                _entryField(
                  "Url Imagen",
                  _buildUrlField(),
                ),
                _entryField(
                  "Nombre",
                  _buildNameField(),
                ),
                _entryField(
                  "Categoria",
                  _buildCategoryField(),
                ),
                _entryField(
                  "Marca",
                  _buildBrandField(),
                ),
                _entryField(
                  "Descripción",
                  _buildDescriptionField(),
                ),
                _entryField(
                  "Precio",
                  _buildPriceField(),
                ),
                _entryField(
                  "Cantidad",
                  _buildQuantityField(),
                ),
                _entryField(
                  "Colores",
                  _buildColorsField(),
                ),
                _entryField(
                  "Tallas",
                  _buildSizesField(),
                ),
                _entryField(
                  "Disponibilidad",
                  _buildOnSaleField(),
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
      // newProduct.urlImg = 'https://i.ibb.co/nQmsyrH/Poker.png';
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildBtn(
              (addView) ? "Editar" : "Agregar",
              (addView)
                  ? () async {
                      if (formKey.currentState.validate()) {
                        ProductServices()
                            .updateProduct(newProduct, newProduct.name);
                        (userView != null) ? userView(1) : changeView(1);
                      }
                    }
                  : () async {
                      if (formKey.currentState.validate()) {
                        ProductServices().addProduct(newProduct);
                        (ResponsiveLayout.isPhone(context))
                            // ignore: unnecessary_statements
                            ? ((userView != null) ? userView(1) : changeView(1))
                            : changeView(ViewProducts(
                                inCustomerView: false,
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
                    // ignore: unnecessary_statements
                    ? ((addView) ? changeView(4) : changeView(1))
                    : changeView(ViewProducts(
                        inCustomerView: false,
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
