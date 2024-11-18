import 'package:flutter/material.dart';
import 'package:handyapp/dialogs/sign_in_dialog.dart';
import 'package:handyapp/dialogs/create_account_dialog.dart';

/*
  File: home_page.dart
  Purpose: 
  - Serves as the entry point for the Handyman App, providing the initial UI for users to either sign in or create an account.
  
  Functionality:
  - Displays the app's name and a tagline at the center of the screen.
  - Includes buttons for signing in and creating a new account, which trigger respective dialogs (`SignInDialog` and `CreateAccountDialog`) upon interaction.
  - Implements a visually appealing radial gradient background for aesthetic consistency.
  
  How It Works:
  - The `HomePage` is a stateful widget, which uses Flutter's `Scaffold` widget to provide structure and layout.
  - The UI consists of a `Stack` with a gradient `Container` and a `Center` widget for alignment of app name, tagline, and buttons.

  Files It Interacts With:
  - `sign_in_dialog.dart`: Handles the sign-in dialog functionality.
  - `create_account_dialog.dart`: Handles the account creation dialog functionality.
*/
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1,
                colors: [
                  Colors.white,
                  Color(0xff5debd7),
                  Colors.white,
                ],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Handyman App',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 20), // Slightly increased spacing
                const Text(
                  '"For the handiest of men (and women too!)"',
                  style: TextStyle(
                    fontSize: 22, // Slightly larger
                    fontWeight: FontWeight.bold, // Bold text
                    fontStyle: FontStyle.italic, // Fancy style
                    fontFamily: 'Serif', // A fancier font
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  child: const Text('Sign In'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const SignInDialog();
                      },
                    );
                  },
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  child: const Text('Create Account'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const CreateAccountDialog();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
