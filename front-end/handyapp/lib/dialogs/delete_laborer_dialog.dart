import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

class DeleteLaborerDialog extends StatelessWidget {
  final String projectId;
  final String laborerId;

  const DeleteLaborerDialog({
    super.key,
    required this.projectId,
    required this.laborerId,
  });

  Future<void> _deleteLaborer() async {
    final response = await Get.find<dependencies.AuthController>().deleteLaborer(
      projectId,
      laborerId,
    );

    if (response == 'success') {
      Get.back(); // Close the dialog
      Get.snackbar(
        'Success',
        'Laborer deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        'Error',
        'Failed to delete laborer: $response',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Laborer'),
      content: const Text('Are you sure you want to delete this laborer?'),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _deleteLaborer,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
