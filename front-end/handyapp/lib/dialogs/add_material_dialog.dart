import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

/*
  File: add_material_dialog.dart
  Purpose:
  - Provides a user interface for adding a new material to a specific project.
  - Collects and validates input data for the material (name, quantity, and value per unit).

  How It Works:
  - Displays an `AlertDialog` with input fields for material details.
  - Validates the input:
    - Name must not be empty.
    - Quantity and value must be positive numbers.
  - Sends the input data to the `AuthController` via the `addMaterial` method.
  - Provides user feedback:
    - Shows a snackbar for errors or success.
    - Closes the dialog upon successful addition.

  Features:
  - Integration with the backend through the `AuthController`.
  - Real-time input validation to ensure accuracy.
  - Automatic updates to the materials list on success.

  Files It Interacts With:
  - **`dependencies.dart`**: Accesses the `AuthController` for API communication.
  - **`materials_page.dart`**: Updates the materials list dynamically after a material is added.

  Notes:
  - Designed for use in material management functionality.
  - Ensure proper API setup for material addition.
*/

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
