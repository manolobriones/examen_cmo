// lib/services/provider_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/provider_model.dart';

class ProviderService {
  final String _baseUrl = "143.198.118.203:8100";
  final String _user = "test";
  final String _pass = "test2023";

  String get _basicAuth => 'Basic ${base64Encode(utf8.encode('$_user:$_pass'))}';
  Map<String, String> get _headers => {
        'authorization': _basicAuth,
        'Content-Type': 'application/json; charset=UTF-8',
      };

  Future<List<ProviderModel>> getProviders() async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_list_rest/');
    try {
      final response = await http.get(url, headers: _headers);
      if (response.statusCode == 200) {
        final decodedData = json.decode(response.body);
        final providerResponse = ProviderResponse.fromJson(decodedData);
        return providerResponse.proveedoresListado;
      } else {
        print('Error fetching providers: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load providers (Status Code: ${response.statusCode})');
      }
    } catch (e) {
      print('Exception caught in getProviders: $e');
      throw Exception('Failed to load providers: $e');
    }
  }

  Future<bool> addProvider(ProviderModel provider) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_add_rest/');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(provider.toJsonForAdd()), // Usar toJsonForAdd
      );
      if (response.statusCode == 200 || response.statusCode == 201) { // A veces 201 para CREATED
        print('Provider added successfully: ${response.body}');
        return true;
      } else {
        print('Error adding provider: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception caught in addProvider: $e');
      return false;
    }
  }

  Future<bool> editProvider(ProviderModel provider) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_edit_rest/');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode(provider.toJson()), // toJson incluye provider_id
      );
      if (response.statusCode == 200) {
         print('Provider edited successfully: ${response.body}');
        return true;
      } else {
        print('Error editing provider: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception caught in editProvider: $e');
      return false;
    }
  }

  Future<bool> deleteProvider(int providerId) async {
    final url = Uri.http(_baseUrl, 'ejemplos/provider_del_rest/');
    try {
      final response = await http.post(
        url,
        headers: _headers,
        body: json.encode({'provider_id': providerId}),
      );
      if (response.statusCode == 200) {
        print('Provider deleted successfully: ${response.body}');
        return true;
      } else {
        print('Error deleting provider: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Exception caught in deleteProvider: $e');
      return false;
    }
  }
}