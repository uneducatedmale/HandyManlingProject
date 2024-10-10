import 'package:flutter/material.dart';
import 'package:handyapp/dialogs/sign_in_dialog.dart';
import 'package:handyapp/dialogs/create_account_dialog.dart';

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
                const SizedBox(height: 10),
                Image.asset(
                  'images/favicon.png',
                  height: 70,
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
