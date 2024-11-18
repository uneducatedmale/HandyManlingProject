import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

/*
  File: delete_memo_dialog.dart
  Purpose:
  - Provides a dialog for users to confirm the deletion of a project (memo) in the Handyman app.
  - Handles the deletion process and updates the project list in the app.

  How It Works:
  - Displays a confirmation dialog with options to either "Delete" or "Cancel."
  - If confirmed, triggers the `deleteProject` method from `AuthController` to delete the project at the specified index.
  - Provides real-time feedback, including progress indicators and success/error messages.

  Features:
  - Prevents accidental deletions by requiring user confirmation.
  - Automatically updates the project list and scrolls to the bottom if projects remain after deletion.
  - Uses asynchronous operations to handle backend API calls and ensures a responsive UI.

  Files It Interacts With:
  - **`dependencies.dart`**: Uses `AuthController` to handle project deletion.
  - **Backend API**: Sends the delete request for the specified project.
  - **`memo_page.dart`**: Calls this dialog for project deletion.

  Notes:
  - Ensure proper error handling in the backend for deletion requests.
  - The dialog uses a stateful approach to manage different UI states during the deletion process.
*/

class DeleteProjectDialog extends StatefulWidget {
  final int index;
  final Function scrollToBottom;
  const DeleteProjectDialog({
    required this.index,
    required this.scrollToBottom,
    super.key,
  });

  @override
  State<DeleteProjectDialog> createState() => _DeleteProjectDialogState();
}

class _DeleteProjectDialogState extends State<DeleteProjectDialog> {
  RxString status = 'delete-project'.obs;

  Widget deleteProjectWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Delete this project?',
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Delete'),
                onPressed: () {
                  status.value = 'deleting-project';
                },
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                child: const Text('Cancel'),
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

  Widget deletingProjectWidget() {
    return FutureBuilder(
      future: Get.find<dependencies.AuthController>().deleteProject(
        widget.index,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Deleting project'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (snapshot.data == 'success') {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              if (Get.find<dependencies.AuthController>().projects.isNotEmpty) {
                widget.scrollToBottom();
              }
              Navigator.pop(context);
            },
          );
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Project deleted successfully'),
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
                ElevatedButton(
                  child: const Text('Close'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => status.value == 'delete-project'
            ? deleteProjectWidget()
            : status.value == 'deleting-project'
                ? deletingProjectWidget()
                : const SizedBox(),
      ),
    );
  }
}
