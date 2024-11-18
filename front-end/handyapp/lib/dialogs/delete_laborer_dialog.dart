import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

/*
  File: delete_laborer_dialog.dart
  Purpose:
  - Provides a confirmation dialog for deleting a laborer from a project in the Handyman app.
  - Allows users to confirm or cancel the deletion process.

  How It Works:
  - Displays a dialog with a warning message and two options: "Cancel" and "Delete."
  - On confirmation, calls the `deleteLaborer` method from `AuthController` to remove the laborer from the specified project.
  - Shows feedback via a snackbar to indicate whether the operation succeeded or failed.

  Features:
  - Confirmation to prevent accidental deletions.
  - Feedback to the user about the success or failure of the operation.
  - Smooth UI flow with automatic dialog closure upon success.

  Files It Interacts With:
  - **`dependencies.dart`**: Uses `AuthController` to handle laborer deletion requests.
  - **Backend API**: Sends the deletion request for the specified laborer in a project.
  - **`labor_page.dart`**: Initiates this dialog as part of its "Delete" action for laborers.

  Notes:
  - Ensure the backend endpoint for laborer deletion is implemented and returns meaningful error messages if any issues occur.
  - The dialog uses a red "Delete" button to emphasize the action's importance.
*/

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
