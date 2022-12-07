class ProductModel {
  String name,
      lowerName,
      urlImg,
      category,
      brand,
      description,
      colors,
      sizes,
      onSale,
      price,
      quantity;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'lowerName': lowerName,
      'urlImg': urlImg,
      'category': category,
      'brand': brand,
      'description': description,
      'price': price,
      'quantity': quantity,
      'colors': colors,
      'sizes': sizes,
      'onSale': onSale,
    };
  }

  ProductModel(
      {this.name,
      this.lowerName,
      this.urlImg,
      this.category,
      this.brand,
      this.description,
      this.price,
      this.quantity,
      this.colors,
      this.sizes,
      this.onSale});
}
