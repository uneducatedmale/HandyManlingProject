import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart';

/*
  File: delete_material_dialog.dart
  Purpose:
  - Provides a confirmation dialog for deleting a material from a project in the Handyman app.
  - Allows users to confirm or cancel the deletion process.

  How It Works:
  - Displays a dialog with a warning message and two options: "Cancel" and "Delete."
  - On confirmation, calls the `deleteMaterial` method from `AuthController` to remove the material from the specified project.
  - Displays feedback via a snackbar to indicate the success or failure of the operation.

  Features:
  - User confirmation ensures that accidental deletions are avoided.
  - Provides real-time feedback on the result of the deletion request.
  - Automatically closes the dialog upon a successful operation.

  Files It Interacts With:
  - **`dependencies.dart`**: Uses `AuthController` to handle material deletion requests.
  - **Backend API**: Sends the deletion request for the specified material in a project.
  - **`materials_page.dart`**: Triggers this dialog as part of its "Delete" action for materials.

  Notes:
  - Ensure the backend deletion endpoint is implemented correctly and handles errors gracefully.
  - The dialog uses a straightforward interface with clear options for user actions.
*/

class DeleteMaterialDialog extends StatelessWidget {
  final String projectId;
  final String materialId;

  const DeleteMaterialDialog({
    required this.projectId,
    required this.materialId,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete Material'),
      content: const Text('Are you sure you want to delete this material?'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final response = await Get.find<AuthController>().deleteMaterial(projectId, materialId);
            if (response == 'success') {
              Get.back(); // Close the dialog
              Get.snackbar(
                'Success',
                'Material deleted successfully.',
                snackPosition: SnackPosition.BOTTOM,
              );
            } else {
              Get.snackbar(
                'Error',
                'Failed to delete material.',
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
