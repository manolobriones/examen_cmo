/// Modelo para representar una categoría de productos
class Category {
  int id;
  String name;
  String state;

  Category({required this.id, required this.name, required this.state});

  /// Crea una instancia de Category desde un Map JSON
  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["category_id"],
    name: json["category_name"],
    state: json["category_state"] ?? "Activa",
  );

  /// Convierte la instancia actual a un Map JSON
  Map<String, dynamic> toJson() => {
    "category_id": id,
    "category_name": name,
    "category_state": state,
  };
}
