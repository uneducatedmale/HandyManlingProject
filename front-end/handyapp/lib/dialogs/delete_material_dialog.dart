import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart';

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
