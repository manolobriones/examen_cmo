import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../models/category.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<CategoryProvider>(context, listen: false);
    _loadFuture = provider.loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Categorías"),
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder(
        future: _loadFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: provider.categories.length,
            itemBuilder: (_, i) {
              final category = provider.categories[i];
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(category.name),
                  subtitle: Text('Estado: ${category.state}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed:
                            () => _showCategoryDialog(
                              context,
                              category,
                              readOnly: true,
                            ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showCategoryDialog(context, category),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await provider.removeCategory(category.id);
                          setState(() {
                            _loadFuture =
                                provider
                                    .loadCategories(); // Recarga luego de borrar
                          });
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCategoryDialog(context, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCategoryDialog(
    BuildContext context,
    Category? category, {
    bool readOnly = false,
  }) {
    final nameController = TextEditingController(text: category?.name ?? '');
    final state = category?.state ?? 'Activa';

    showGeneralDialog(
      context: context,
      barrierDismissible: !readOnly,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (
        BuildContext buildContext,
        Animation<double> animation,
        Animation<double> secondaryAnimation,
      ) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: Text(
                    readOnly
                        ? 'Ver Categoría'
                        : (category == null
                            ? 'Nueva Categoría'
                            : 'Editar Categoría'),
                    style: const TextStyle(fontSize: 18),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: readOnly,
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar:
                    !readOnly
                        ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: ElevatedButton.icon(
                            icon: Icon(
                              category == null ? Icons.add : Icons.save,
                            ),
                            label: Text(
                              category == null
                                  ? 'Agregar Categoría'
                                  : 'Guardar Cambios',
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              textStyle: const TextStyle(fontSize: 16),
                            ),
                            onPressed: () async {
                              final provider = Provider.of<CategoryProvider>(
                                context,
                                listen: false,
                              );
                              if (category == null) {
                                await provider.addCategory(
                                  nameController.text.trim(),
                                );
                              } else {
                                await provider.updateCategory(
                                  Category(
                                    id: category.id,
                                    name: nameController.text.trim(),
                                    state: state,
                                  ),
                                );
                              }
                              if (buildContext.mounted) {
                                Navigator.of(buildContext).pop();
                                setState(() {
                                  _loadFuture = provider.loadCategories();
                                });
                              }
                            },
                          ),
                        )
                        : null,
              ),
            ),
          ),
        );
      },
    );
  }
}
