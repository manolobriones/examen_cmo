import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryProvider extends ChangeNotifier {
  final CategoryService _service = CategoryService();
  List<Category> categories = [];

  Future<void> loadCategories() async {
    categories = await _service.getCategories();
    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    await _service.addCategory(name);
    await loadCategories();
  }

  Future<void> updateCategory(Category category) async {
    await _service.editCategory(category);
    await loadCategories();
  }

  Future<void> removeCategory(int id) async {
    await _service.deleteCategory(id);
    await loadCategories();
  }
}
