import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

class AddPayDialog extends StatelessWidget {
  final String projectId;
  final String projectName;

  const AddPayDialog({
    required this.projectId,
    required this.projectName,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final payController = TextEditingController();

    return AlertDialog(
      title: Text('Add Pay to $projectName'),
      content: TextField(
        controller: payController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          labelText: 'Enter Pay Amount',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            final payAmount = double.tryParse(payController.text) ?? 0.0;
            if (payAmount > 0) {
              final result = await Get.find<dependencies.AuthController>().updateProjectPay(
                projectId,
                payAmount,
              );
              if (result == 'success') {
                Get.snackbar('Success', 'Pay added successfully.');
              } else {
                Get.snackbar('Error', result);
              }
              Navigator.of(context).pop(); // Close the dialog
            } else {
              Get.snackbar('Error', 'Enter a valid pay amount.');
            }
          },
          child: const Text('Add Pay'),
        ),
      ],
    );
  }
}
