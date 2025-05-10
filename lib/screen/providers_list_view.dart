import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/provider_model.dart';
import '../../providers/providers_provider.dart';

class ProvidersListView extends StatelessWidget {
  const ProvidersListView({super.key});

  @override
  Widget build(BuildContext context) {
    final providersProvider = Provider.of<ProvidersProvider>(context);
    final providers = providersProvider.providers;

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Proveedores')),
      body: ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: providers.length,
        itemBuilder: (context, index) {
          final provider = providers[index];
          return Card(
            elevation: 3,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              title: Text('${provider.providerName} ${provider.providerLastName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Email: ${provider.providerMail}'),
                  Text('Estado: ${provider.providerState}'),
                ],
              ),
              trailing: Wrap(
                spacing: 4,
                children: [
                  IconButton(
                    icon: const Icon(Icons.visibility),
                    onPressed: () => _showDetailsFullScreenDialog(context, provider),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showAddEditProviderDialog(
                      context,
                      provider: provider,
                      providersProvider: providersProvider,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteConfirmationDialog(
                      context,
                      provider,
                      providersProvider,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEditProviderDialog(
          context,
          providersProvider: providersProvider,
        ),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDetailsFullScreenDialog(BuildContext context, ProviderModel provider) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: const Text('Detalles del Proveedor'),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailTextField('ID', provider.providerid.toString(), readOnly: true),
                      _buildDetailTextField('Nombre', provider.providerName, readOnly: true),
                      _buildDetailTextField('Apellido', provider.providerLastName, readOnly: true),
                      _buildDetailTextField('Email', provider.providerMail, readOnly: true),
                      _buildDetailTextField('Estado', provider.providerState, readOnly: true),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailTextField(String label, String value, {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: TextEditingController(text: value),
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
          filled: true,
          fillColor: Colors.grey[200],
        ),
        readOnly: readOnly,
        style: TextStyle(
          fontSize: 16,
          color: Colors.black.withOpacity(0.7),
        ),
      ),
    );
  }

  void _showAddEditProviderDialog(
  BuildContext context, {
  ProviderModel? provider,
  required ProvidersProvider providersProvider,
  }) {
    final isEditing = provider != null;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: provider?.providerName ?? '');
    final lastNameController = TextEditingController(text: provider?.providerLastName ?? '');
    final mailController = TextEditingController(text: provider?.providerMail ?? '');
    final stateController = TextEditingController(text: provider?.providerState ?? '');

    showGeneralDialog(
      context: context,
      barrierDismissible: !isEditing,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (BuildContext buildContext, Animation<double> animation, Animation<double> secondaryAnimation) {
        return Material(
          type: MaterialType.transparency,
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.85,
              decoration: BoxDecoration(
                color: Theme.of(context).dialogBackgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(
                    isEditing
                        ? 'Editar Proveedor'
                        : 'Nuevo Proveedor',
                    style: const TextStyle(fontSize: 18),
                  ),
                  centerTitle: true,
                  automaticallyImplyLeading: false,
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        _buildTextField(nameController, 'Nombre', 'Ingrese un nombre'),
                        _buildTextField(lastNameController, 'Apellido', 'Ingrese un apellido'),
                        _buildTextField(mailController, 'Email', 'Ingrese un email', email: true),
                        _buildTextField(stateController, 'Estado', 'Ingrese un estado'),
                      ],
                    ),
                  ),
                ),
                bottomNavigationBar: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton.icon(
                    icon: Icon(isEditing ? Icons.save : Icons.add),
                    label: Text(isEditing ? 'Guardar Cambios' : 'Agregar Proveedor'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      if (!formKey.currentState!.validate()) return;

                      final newProvider = ProviderModel(
                        providerid: provider?.providerid ?? 0,
                        providerName: nameController.text.trim(),
                        providerLastName: lastNameController.text.trim(),
                        providerMail: mailController.text.trim(),
                        providerState: stateController.text.trim(),
                      );

                      if (isEditing) {
                        providersProvider.updateProvider(newProvider);
                      } else {
                        providersProvider.createProvider(newProvider);
                      }

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    String errorMsg, {
    bool email = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label),
        validator: (value) {
          if (value == null || value.trim().isEmpty) return errorMsg;
          if (email && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) return 'Email inválido';
          return null;
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    ProviderModel provider,
    ProvidersProvider providersProvider,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar Proveedor'),
        content: Text('¿Está seguro que desea eliminar a "${provider.providerName} ${provider.providerLastName}"?'),
        actions: [
          TextButton(child: const Text('Cancelar'), onPressed: () => Navigator.of(context).pop()),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar'),
            onPressed: () {
              providersProvider.removeProvider(provider.providerid);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}


