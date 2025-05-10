import 'dart:convert';

/// Clase principal para manejar la lista de productos desde la API
class Product {
  Product({required this.listado});

  List<Listado> listado;

  /// Crea una instancia de Product desde una cadena JSON
  factory Product.fromJson(String str) => Product.fromMap(json.decode(str));

  /// Convierte la instancia actual a cadena JSON
  String toJson() => json.encode(toMap());

  /// Crea una instancia de Product desde un Map
  factory Product.fromMap(Map<String, dynamic> json) => Product(
    listado: List<Listado>.from(json["Listado"].map((x) => Listado.fromMap(x))),
  );

  /// Convierte la instancia actual a un Map
  Map<String, dynamic> toMap() => {
    "Listado": List<dynamic>.from(listado.map((x) => x.toMap())),
  };
}

/// Modelo para representar un producto individual
class Listado {
  Listado({
    required this.productId,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productState,
  });

  int productId;
  String productName;
  int productPrice;
  String productImage;
  String productState;

  /// Crea una instancia de Listado desde una cadena JSON
  factory Listado.fromJson(String str) => Listado.fromMap(json.decode(str));

  /// Convierte la instancia actual a cadena JSON
  String toJson() => json.encode(toMap());

  /// Crea una instancia de Listado desde un Map
  factory Listado.fromMap(Map<String, dynamic> json) => Listado(
    productId: json["product_id"],
    productName: json["product_name"],
    productPrice: json["product_price"],
    productImage: json["product_image"],
    productState: json["product_state"],
  );

  /// Convierte la instancia actual a un Map
  Map<String, dynamic> toMap() => {
    "product_id": productId,
    "product_name": productName,
    "product_price": productPrice,
    "product_image": productImage,
    "product_state": productState,
  };

  /// Crea una copia del producto actual
  Listado copy() => Listado(
    productId: productId,
    productName: productName,
    productPrice: productPrice,
    productImage: productImage,
    productState: productState,
  );
}
