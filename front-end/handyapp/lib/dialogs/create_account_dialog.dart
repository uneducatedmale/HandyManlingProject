import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

/*
  File: create_account_dialog.dart
  Purpose:
  - Handles the creation of new user accounts for the Handyman app.
  - Provides a user interface for entering personal details and creating an account.
  
  How It Works:
  - Displays a form with input fields for first name, last name, email, and password.
  - Validates user input to ensure all fields are filled.
  - Sends account creation details to the backend via the `AuthController`'s `createAccount` method.
  - Displays feedback on the success or failure of the account creation process.

  Features:
  - Real-time feedback for incomplete form submissions.
  - Dynamic UI updates using `Obx` to switch between the form and the account creation process.
  - Success or error messages displayed to inform the user about the status of their request.

  Files It Interacts With:
  - **`dependencies.dart`**: Uses `AuthController` for backend communication.
  - **`sign_in_dialog.dart`**: Complements the sign-in dialog by enabling account creation.
  - **Backend API**: Sends account creation requests and handles responses.

  Notes:
  - Ensure backend API endpoints for account creation are functioning correctly.
  - Proper validation of the email and password format may be added for enhanced security.
*/

class CreateAccountDialog extends StatefulWidget {
  const CreateAccountDialog({super.key});

  @override
  State<CreateAccountDialog> createState() => _CreateAccountDialogState();
}

class _CreateAccountDialogState extends State<CreateAccountDialog> {
  RxString status = 'enter-details'.obs;

  var firstNameController = TextEditingController();
  var lastNameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  Widget detailsWidget() {
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
        const Text('Create Handyman Account'),
        const SizedBox(height: 30),
        SizedBox(
          width: 300,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'First Name',
            ),
            controller: firstNameController,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 300,
          child: TextFormField(
            decoration: const InputDecoration(
              hintText: 'Last Name',
            ),
            controller: lastNameController,
          ),
        ),
        const SizedBox(height: 20),
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
              child: const Text('Create'),
              onPressed: () {
                if (firstNameController.text.isNotEmpty &&
                    lastNameController.text.isNotEmpty &&
                    emailController.text.isNotEmpty &&
                    passwordController.text.isNotEmpty) {
                  status.value = 'creating-account';
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: const Text(
                          'Fill in all the details',
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

  Widget creatingAccountWidget() {
    return FutureBuilder(
      future: Get.find<dependencies.AuthController>().createAccount(
        firstNameController.text,
        lastNameController.text,
        emailController.text,
        passwordController.text,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Creating Account'),
                SizedBox(height: 30),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else {
          if (snapshot.data == 'success') {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                      'Account created successfully. You can now sign in.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
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
                          status.value = 'enter-details';
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
        () => status.value == 'enter-details'
            ? detailsWidget()
            : status.value == 'creating-account'
                ? creatingAccountWidget()
                : const SizedBox(),
      ),
    );
  }
}
