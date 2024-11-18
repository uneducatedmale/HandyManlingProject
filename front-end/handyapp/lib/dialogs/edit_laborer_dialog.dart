import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

/*
  File: edit_laborer_dialog.dart
  Purpose:
  - Provides a dialog for editing laborer details within a specific project in the Handyman app.
  - Allows users to update laborer information such as name, job, hourly wage, and hours worked.

  How It Works:
  - Pre-populates the fields with the current laborer details using `TextEditingController`.
  - Users can modify the details and save the changes, which triggers the `editLaborer` method from `AuthController`.
  - Sends the updated data to the backend via an API call and provides real-time feedback.

  Features:
  - Pre-filled fields for easy editing.
  - Validates numeric input for wage and hours.
  - Displays success or error notifications after saving.

  Files It Interacts With:
  - **`dependencies.dart`**: Uses `AuthController` to handle laborer editing.
  - **Backend API**: Sends the update request for laborer data.
  - **`labor_page.dart`**: Calls this dialog to update laborer details within a project.

  Notes:
  - Ensure proper error handling in the backend for update requests.
  - Validate user input thoroughly to prevent invalid data submission.
*/

class EditLaborerDialog extends StatefulWidget {
  final String projectId;
  final String laborerId;
  final String workerName;
  final String job;
  final double hourlyWage;
  final int hoursWorked;

  const EditLaborerDialog({
    super.key,
    required this.projectId,
    required this.laborerId,
    required this.workerName,
    required this.job,
    required this.hourlyWage,
    required this.hoursWorked,
  });

  @override
  State<EditLaborerDialog> createState() => _EditLaborerDialogState();
}

class _EditLaborerDialogState extends State<EditLaborerDialog> {
  late TextEditingController nameController;
  late TextEditingController jobController;
  late TextEditingController wageController;
  late TextEditingController hoursController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.workerName);
    jobController = TextEditingController(text: widget.job);
    wageController = TextEditingController(text: widget.hourlyWage.toString());
    hoursController = TextEditingController(text: widget.hoursWorked.toString());
  }

  @override
  void dispose() {
    nameController.dispose();
    jobController.dispose();
    wageController.dispose();
    hoursController.dispose();
    super.dispose();
  }

  Future<void> _updateLaborer() async {
    final response = await Get.find<dependencies.AuthController>().editLaborer(
      widget.projectId,
      widget.laborerId,
      nameController.text.trim(),
      jobController.text.trim(),
      double.tryParse(wageController.text.trim()) ?? 0.0,
      int.tryParse(hoursController.text.trim()) ?? 0,
    );

    if (response == 'success') {
      Get.back(); // Close the dialog
      Get.snackbar(
        'Success',
        'Laborer updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to update laborer: $response',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Laborer'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: jobController,
              decoration: const InputDecoration(labelText: 'Job'),
            ),
            TextField(
              controller: wageController,
              decoration: const InputDecoration(labelText: 'Hourly Wage'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: hoursController,
              decoration: const InputDecoration(labelText: 'Hours Worked'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _updateLaborer,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
