import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:examen_cmo/services/product_service.dart';
import 'package:examen_cmo/models/productos.dart';

/// Pantalla que muestra la lista de productos con opciones para ver detalles, editar y eliminar
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Productos')),
      body:
          productService.isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: productService.products.length,
                itemBuilder: (context, index) {
                  final product = productService.products[index];
                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(10),
                      leading: SizedBox(
                        width: 60,
                        height: 60,
                        child:
                            (product.productImage.isEmpty ||
                                    !product.productImage.startsWith('http'))
                                ? Image.asset('assets/no-image.png')
                                : Image.network(
                                  product.productImage,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Image.asset('assets/no-image.png');
                                  },
                                ),
                      ),
                      title: Text(product.productName),
                      subtitle: Text('\$${product.productPrice}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Botón para ver detalles de producto
                          IconButton(
                            icon: const Icon(Icons.visibility),
                            onPressed: () {
                              _showProductDialog(
                                context,
                                product,
                                readOnly: true,
                              );
                            },
                          ),
                          // Botón para editar producto
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              _showProductDialog(context, product);
                            },
                          ),
                          // Botón para eliminar producto
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final productService =
                                  Provider.of<ProductService>(
                                    context,
                                    listen: false,
                                  );
                              await productService.deleteProduct(
                                product,
                                context,
                              );
                              await productService
                                  .loadProducts(); // Refrescar lista
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      // Botón flotante para crear un nuevo producto
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final newProduct = Listado(
            productId: 0,
            productName: '',
            productPrice: 0,
            productImage: '',
            productState: 'Activo',
          );
          _showProductDialog(context, newProduct);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Muestra un diálogo para crear, editar o ver detalles de un producto
  /// 
  /// Parámetros:
  /// - [context] Contexto de la aplicación
  /// - [product] Producto a mostrar o editar
  /// - [readOnly] Si es true, solo permite ver los detalles sin editar
  void _showProductDialog(
    BuildContext context,
    Listado product, {
    bool readOnly = false,
  }) {
    final nameController = TextEditingController(text: product.productName);
    final priceController = TextEditingController(
      text: product.productPrice.toString(),
    );
    final imageController = TextEditingController(text: product.productImage);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            readOnly
                ? 'Detalle del producto'
                : product.productId == 0
                ? 'Nuevo producto'
                : 'Editar producto',
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  // Campo para el nombre del producto
                  TextFormField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                    readOnly: readOnly,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'El nombre es obligatorio';
                      }
                      return null;
                    },
                  ),
                  // Campo para el precio del producto
                  TextFormField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Precio'),
                    keyboardType: TextInputType.number,
                    readOnly: readOnly,
                    validator: (value) {
                      final parsed = int.tryParse(value ?? '');
                      if (parsed == null || parsed < 0) {
                        return 'Ingrese un precio válido';
                      }
                      return null;
                    },
                  ),
                  // Campo para la URL de imagen del producto
                  TextFormField(
                    controller: imageController,
                    decoration: const InputDecoration(
                      labelText: 'URL de imagen',
                    ),
                    readOnly: readOnly,
                    validator: (value) {
                      if (value == null || value.isEmpty) return null;
                      if (!value.startsWith('http')) {
                        return 'La URL debe comenzar con http';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            if (!readOnly)
              TextButton(
                child: const Text('Guardar'),
                onPressed: () async {
                  if (!formKey.currentState!.validate()) return;

                  // Actualiza el producto con los datos del formulario
                  final updatedProduct =
                      product.copy()
                        ..productName = nameController.text
                        ..productPrice = int.tryParse(priceController.text) ?? 0
                        ..productImage = imageController.text;

                  final productService = Provider.of<ProductService>(
                    context,
                    listen: false,
                  );
                  await productService.editOrCreateProduct(updatedProduct);
                  await productService.loadProducts(); // Refrescar lista
                  Navigator.of(context).pop();
                },
              ),
          ],
        );
      },
    );
  }
}
