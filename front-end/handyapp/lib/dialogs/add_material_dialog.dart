import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

class AddMaterialDialog extends StatefulWidget {
  final String projectId;
  final String projectName;

  const AddMaterialDialog({
    required this.projectId,
    required this.projectName,
    super.key,
  });

  @override
  State<AddMaterialDialog> createState() => _AddMaterialDialogState();
}

class _AddMaterialDialogState extends State<AddMaterialDialog> {
  final nameController = TextEditingController();
  final quantityController = TextEditingController();
  final valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Material to ${widget.projectName}'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Material Name'),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(labelText: 'Quantity'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: valueController,
              decoration: const InputDecoration(labelText: 'Value (per unit)'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final name = nameController.text.trim();
            final quantity = int.tryParse(quantityController.text.trim()) ?? 0;
            final value = double.tryParse(valueController.text.trim()) ?? 0.0;

            if (name.isEmpty || quantity <= 0 || value <= 0.0) {
              Get.snackbar('Error', 'All fields must be valid and filled.');
              return;
            }

            final result = await Get.find<dependencies.AuthController>()
                .addMaterial(widget.projectId, name, quantity, value);

            if (result == 'success') {
              Get.back(); // Close dialog
            } else {
              Get.snackbar('Error', result);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
