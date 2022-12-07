import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tienda_rosita/Model/Product.dart';

class ProductServices {
  CollectionReference productsCollection =
      FirebaseFirestore.instance.collection('products');

  Future<void> addProduct(ProductModel product) {
    return productsCollection.add(product.toMap());
  }

  Future<void> updateProduct(ProductModel newProduct, String name) {
    return productsCollection
        .where('name', isEqualTo: name)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.update({
          'name': newProduct.name,
          'lowerName': newProduct.lowerName,
          'urlImg': newProduct.urlImg,
          'price': newProduct.price,
          'category': newProduct.category,
          'brand': newProduct.brand,
          'quantity': newProduct.quantity,
          'colors': newProduct.colors,
          'sizes': newProduct.sizes,
          'onSale': newProduct.onSale,
        });
      });
    }).catchError((err) => print("Failed to update Product: $err"));
  }

  Future<void> deleteProduct(String name) {
    return productsCollection
        .where('name', isEqualTo: name)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    }).catchError((err) => print("Failed to delete product: $err"));
  }
}
