import 'dart:convert';

/// Convierte una cadena JSON en un objeto ProviderResponse
ProviderResponse providerResponseFromJson(String str) =>
    ProviderResponse.fromJson(json.decode(str));

/// Convierte un objeto ProviderResponse en una cadena JSON
String providerResponseToJson(ProviderResponse data) =>
    json.encode(data.toJson());

/// Clase para manejar la respuesta de la API que contiene la lista de proveedores
class ProviderResponse {
  List<ProviderModel> proveedoresListado;

  ProviderResponse({required this.proveedoresListado});

  /// Crea una instancia de ProviderResponse desde un Map JSON
  factory ProviderResponse.fromJson(Map<String, dynamic> json) =>
      ProviderResponse(
        proveedoresListado: List<ProviderModel>.from(
          json["Proveedores Listado"].map((x) => ProviderModel.fromJson(x)),
        ),
      );

  /// Convierte la instancia actual a un Map JSON
  Map<String, dynamic> toJson() => {
    "Proveedores Listado": List<dynamic>.from(
      proveedoresListado.map((x) => x.toJson()),
    ),
  };
}

/// Modelo para representar un proveedor individual
class ProviderModel {
  int providerid;
  String providerName;
  String providerLastName;
  String providerMail;
  String providerState;

  ProviderModel({
    required this.providerid,
    required this.providerName,
    required this.providerLastName,
    required this.providerMail,
    required this.providerState,
  });

  /// Crea una instancia de ProviderModel desde un Map JSON
  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
    providerid: json["providerid"],
    providerName: json["provider_name"],
    providerLastName: json["provider_last_name"],
    providerMail: json["provider_mail"],
    providerState: json["provider_state"],
  );

  /// Convierte la instancia actual a un Map JSON para operaciones generales
  Map<String, dynamic> toJson() => {
    "provider_id": providerid, // Usado para editar y eliminar
    "provider_name": providerName,
    "provider_last_name": providerLastName,
    "provider_mail": providerMail,
    "provider_state": providerState,
  };

  /// Convierte la instancia a un Map JSON específico para añadir un nuevo proveedor
  Map<String, dynamic> toJsonForAdd() => {
    "provider_name": providerName,
    "provider_last_name": providerLastName,
    "provider_mail": providerMail,
    "provider_state": providerState,
  };
}
