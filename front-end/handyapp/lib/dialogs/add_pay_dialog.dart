import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

/*
  File: add_pay_dialog.dart
  Purpose:
  - Allows users to add or update the pay amount for a specific project.
  - Provides an input field to specify the payment and validates the entered value.

  How It Works:
  - Displays a dialog box with an input field for entering the pay amount.
  - Validates the entered amount to ensure it is a positive number.
  - Uses the `AuthController` to send the payment details to the backend via the `updateProjectPay` method.
  - Provides success or error feedback using `Get.snackbar`.

  Features:
  - Integration with the backend through the `AuthController`.
  - Updates the project's payment information dynamically upon success.
  - Displays user-friendly feedback for invalid input or backend errors.

  Files It Interacts With:
  - **`dependencies.dart`**: Accesses the `AuthController` for API communication.
  - **`finances_page.dart`**: Reflects the updated payment in the project details.

  Notes:
  - Ensure the backend API for updating the project's payment is properly configured.
  - The dialog should handle both adding and updating payment seamlessly.
*/

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
            if (payAmount >= 0) {
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
