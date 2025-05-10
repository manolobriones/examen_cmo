// lib/providers/providers_provider.dart
import 'package:flutter/material.dart';
import '../models/provider_model.dart';
import '../services/provider_service.dart';

class ProvidersProvider extends ChangeNotifier {
  final ProviderService _providerService = ProviderService();
  List<ProviderModel> _providers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ProviderModel> get providers => _providers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  ProvidersProvider() {
    fetchProviders();
  }

  Future<void> fetchProviders() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _providers = await _providerService.getProviders();
    } catch (e) {
      _errorMessage = e.toString();
      _providers = []; // Limpiar proveedores en caso de error
      print("Error in fetchProviders (ProvidersProvider): $e");
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createProvider(ProviderModel provider) async {
    _isLoading = true;
    notifyListeners();
    bool success = false;
    try {
        success = await _providerService.addProvider(provider);
        if (success) {
            await fetchProviders(); // Recargar la lista si fue exitoso
        }
    } catch (e) {
        _errorMessage = e.toString();
        print("Error in createProvider (ProvidersProvider): $e");
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> updateProvider(ProviderModel provider) async {
    _isLoading = true;
    notifyListeners();
    bool success = false;
    try {
        success = await _providerService.editProvider(provider);
        if (success) {
            await fetchProviders(); // Recargar la lista
        }
    } catch (e) {
        _errorMessage = e.toString();
        print("Error in updateProvider (ProvidersProvider): $e");
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }

  Future<bool> removeProvider(int providerId) async {
    _isLoading = true;
    notifyListeners();
    bool success = false;
    try {
        success = await _providerService.deleteProvider(providerId);
        if (success) {
            _providers.removeWhere((provider) => provider.providerid == providerId);
            // o fetchProviders() si prefieres recargar desde el servidor
        }
    } catch (e) {
        _errorMessage = e.toString();
        print("Error in removeProvider (ProvidersProvider): $e");
    }
    _isLoading = false;
    notifyListeners();
    return success;
  }
}