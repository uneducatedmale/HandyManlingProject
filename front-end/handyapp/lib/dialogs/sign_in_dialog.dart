import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

/*
  File: sign_in_dialog.dart
  Purpose:
  - Provides a user interface for signing in to the Handyman app.
  - Handles user credential input and sends authentication requests to the backend.

  How It Works:
  - Presents a form with fields for email and password.
  - Validates that both fields are filled before attempting to sign in.
  - Uses `AuthController` from `dependencies.dart` to perform the sign-in process.
  - Displays a loading indicator during the sign-in attempt and handles success or failure responses.

  Features:
  - Redirects users to the Memo page (`/memo_page`) upon successful sign-in.
  - Shows error messages in case of failed authentication or missing credentials.
  - Provides a "Try Again" button on failure for reattempting sign-in.

  Files It Interacts With:
  - **`dependencies.dart`**: Utilizes `AuthController` to manage authentication and API interactions.
  - **Backend API**: Sends user credentials to the server for authentication.
  - **`routes.dart`**: Redirects to the Memo page upon successful sign-in.

  Notes:
  - Ensure robust validation for email and password fields on both the frontend and backend.
  - Feedback messages should clearly communicate the reason for any errors.
*/

class SignInDialog extends StatefulWidget {
  const SignInDialog({super.key});

  @override
  State<SignInDialog> createState() => _SignInDialogState();
}

class _SignInDialogState extends State<SignInDialog> {
  RxString status = 'credentials'.obs;
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Widget credentialsWidget() {
    return Column(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        const SizedBox(height: 50),
        Text(
          'Sign In to Handyman Account',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 50),
        SizedBox(
          width: 300,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            controller: emailController,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
            controller: passwordController,
          ),
        ),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Sign In'),
              onPressed: () {
                if (emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  status.value = 'signing-in';
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text(
                          'Fill in all the credentials',
                          textAlign: TextAlign.center,
                        ),
                        actions: [
                          ElevatedButton(
                            child: const Text('Close'),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget signingInWidget() {
    return FutureBuilder(
      future: Get.find<dependencies.AuthController>().signIn(
        emailController.text,
        passwordController.text,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Signing In'),
                SizedBox(height: 30),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else {
          if (snapshot.data == 'success') {
            Future.delayed(
              const Duration(seconds: 1),
              () {
                Get.offNamed('/memo_page');
              },
            );
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Successfully signed in'),
                  SizedBox(height: 20),
                  CircularProgressIndicator(),
                ],
              ),
            );
          } else {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(snapshot.data!),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        child: const Text('Try Again'),
                        onPressed: () {
                          status.value = 'credentials';
                        },
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        child: const Text('Close'),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
          }
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => status.value == 'credentials'
            ? credentialsWidget()
            : status.value == 'signing-in'
                ? signingInWidget()
                : const SizedBox(),
      ),
    );
  }
}
