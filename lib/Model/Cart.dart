class Cart {
  String nombre;
  String img;
  String marca;
  String descripcion;
  String talla;
  String color;
  int precio;
  int cantidad;

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'img': img,
      'marca': marca,
      'descripcion':descripcion,
      'talla':talla,
      'color':color,
      'precio': precio,
      'cantidad': cantidad,
    };
  }

  Cart({this.nombre, this.img, this.marca,this.descripcion,this.talla, this.color, this.precio, this.cantidad});
}

List<Map> misMaps = [];
List<Cart> misCarts = [];
int totalPriceP = 0;
List<Map> mylistMap = [];
int id = 0;
int miValorTotal = 0;
List<Cart> localMisCarts = misCarts;