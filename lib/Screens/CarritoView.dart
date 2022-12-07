import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tienda_rosita/Model/Cart.dart';

class CarritoView extends StatefulWidget {
  final changeData;
  CarritoView({this.changeData});
  @override
  _CarritoViewState createState() =>
      _CarritoViewState(changeData: this.changeData);
}

class _CarritoViewState extends State<CarritoView> {
  var currentIndex;
  final changeData;

  _CarritoViewState({this.changeData});

  int agendaView = 1;

  changeView(view) {
    this.setState(() {
      agendaView = view;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget _buildDescription(int index) {
      final descriptionWidget = Column(children: <Widget>[
        Text(
          "${misCarts[index].nombre}",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: 30.0,
        ),
        Row(
          children: [
            Column(children: <Widget>[
              Text('Cantidad', style: GoogleFonts.poppins()),
              SizedBox(
                height: 18.0,
              ),
              Row(
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      //padding: EdgeInsets.all(1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        localMisCarts[index].cantidad =
                            localMisCarts[index].cantidad + 1;
                        totalPriceP += localMisCarts[index].precio;
                      });
                    },
                    child: Icon(Icons.add, size: 21.0, color: Colors.black),
                  ),
                  Text("${localMisCarts[index].cantidad}",
                      style: Theme.of(context).textTheme.headline5),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      //padding: EdgeInsets.all(1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(13),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        //Resta cantidad al producto
                        if (localMisCarts[index].cantidad > 0) {
                          localMisCarts[index].cantidad =
                              localMisCarts[index].cantidad - 1;

                          totalPriceP -= localMisCarts[index].precio;
                        }
                        if (localMisCarts[index].cantidad == 0) {
                          localMisCarts.remove(localMisCarts[index]);
                        }
                      });
                    },
                    child: Icon(Icons.remove, size: 21.0, color: Colors.black),
                  )
                ],
              ),
            ]),
            Expanded(
                child: Column(
              children: [
                Text('Total', style: GoogleFonts.poppins()),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                    "\$${localMisCarts[index].cantidad * localMisCarts[index].precio}",
                    style: Theme.of(context).textTheme.subtitle1)
              ],
            )),
          ],
        )
      ]);
      return descriptionWidget;
    }

    Widget _buildListProduct() {
      if (localMisCarts.length != 0) {
        final liprod = ListView.builder(
          itemCount: localMisCarts.length,
          itemBuilder: (BuildContext context, int index) => Column(
            children: [
              Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0,
                                top: 16.0,
                                right: 8.0,
                                bottom: 16.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image(
                                height: 150,
                                width: 150,
                                image: localMisCarts[index].img != null
                                    ? NetworkImage(localMisCarts[index].img)
                                    : NetworkImage(
                                        'https://i.ibb.co/0Jmshvb/no-image.png'),
                              ),
                            ),
                          ),
                        ),
                        Expanded(flex: 3, child: _buildDescription(index)),
                        IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () => this.setState(() {
                                  totalPriceP -= localMisCarts[index].cantidad *
                                      localMisCarts[index].precio;
                                  localMisCarts.remove(localMisCarts[index]);
                                })),
                      ],
                    ),
                  )),
            ],
          ),
        );
        return liprod;
      } else {
        return Center(
          child: Text("No hay nada en el carrito :c",
              style: Theme.of(context).textTheme.headline6),
        );
      }
    }

    Widget _buildTotalPrice() {
      final totalPrice = Column(children: <Widget>[
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              'Precio Total',
              style: Theme.of(context).textTheme.headline6,
            ),
            Text("\$$totalPriceP", style: Theme.of(context).textTheme.headline6)
          ],
        )
      ]);
      return totalPrice;
    }

    Widget _buildBtn(String title) {
      return Container(
        width: 200,
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            elevation: 5,
            padding: EdgeInsets.all(15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            primary: Color(0xFF8063D4),
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

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.shopping_cart, color: Color(0xFFB4AEE8)),
            Text(
              'Mi Carrito',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                color: Colors.black,
              ),
            ),
          ],
        ),
        elevation: 0.0,
        backgroundColor: Color(0xFFFAFAFA),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 05.0,
          ),
          Expanded(
            child: _buildListProduct(),
          ),
          _buildTotalPrice(),
          SizedBox(
            height: 5.0,
          ),
          _buildBtn('Continuar'),
          SizedBox(
            height: 5.0,
          ),
        ],
      ),
    );
  }
}
