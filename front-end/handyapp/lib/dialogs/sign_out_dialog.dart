import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

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
        ElevatedButton(
          child: const Text('Yes'),
          onPressed: () {
            Get.find<dependencies.AuthController>().signOut();
          },
        ),
        ElevatedButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
