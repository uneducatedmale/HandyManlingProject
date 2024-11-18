import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

/*
  File: sign_out_dialog.dart
  Purpose:
  - Provides a confirmation dialog for signing out of the Handyman App.

  Functionality:
  - Displays a simple confirmation message: "Sign out?"
  - Includes two buttons:
    - "Yes" button: Signs the user out by calling the `signOut` method from `AuthController`.
    - "Cancel" button: Closes the dialog without any action.
  - Uses a centered button layout for improved visual alignment.

  How It Works:
  - This dialog is triggered when the user initiates a sign-out action.
  - Upon confirmation, it interacts with the `AuthController` to clear session data and navigate to the home page.

  Files It Interacts With:
  - `dependencies.dart`: Provides access to the `AuthController` for managing the sign-out process.
  - `home_page.dart`: The destination page after signing out.
*/

class SignOutDialog extends StatelessWidget {
  const SignOutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Text(
        'Sign out?',
        textAlign: TextAlign.center,
      ),
      actions: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Yes'),
                onPressed: () {
                  Get.find<dependencies.AuthController>().signOut();
                },
              ),
              const SizedBox(width: 20), // Add spacing between buttons
              ElevatedButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
