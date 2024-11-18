import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

class EditMaterialDialog extends StatefulWidget {
  final String projectId;
  final String materialId;
  final String materialName;
  final int quantity;
  final double value;

  const EditMaterialDialog({
    required this.projectId,
    required this.materialId,
    required this.materialName,
    required this.quantity,
    required this.value,
    super.key,
  });

  @override
  State<EditMaterialDialog> createState() => _EditMaterialDialogState();
}

class _EditMaterialDialogState extends State<EditMaterialDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _valueController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.materialName);
    _quantityController = TextEditingController(text: widget.quantity.toString());
    _valueController = TextEditingController(text: widget.value.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Material'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Material Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a material name.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty || int.tryParse(value) == null) {
                  return 'Please enter a valid quantity.';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _valueController,
              decoration: const InputDecoration(labelText: 'Value per Unit'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty || double.tryParse(value) == null) {
                  return 'Please enter a valid value.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final result = await Get.find<dependencies.AuthController>().editMaterial(
                widget.projectId,
                widget.materialId,
                _nameController.text,
                int.parse(_quantityController.text),
                double.parse(_valueController.text),
              );
              if (result == 'success') {
                Get.snackbar('Success', 'Material updated successfully.');
              } else {
                Get.snackbar('Error', 'Failed to update material.');
              }
              Navigator.of(context).pop(); // Close the dialog
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
