import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;
import 'package:handyapp/dialogs/add_memo_dialog.dart';
import 'package:handyapp/dialogs/delete_memo_dialog.dart';
import 'package:handyapp/dialogs/edit_memo_dialog.dart'; // Import for edit memo dialog
import 'package:handyapp/dialogs/sign_out_dialog.dart';
import 'package:intl/intl.dart';

/*
  File: memo_page.dart
  Purpose:
  - Displays a list of projects with their associated memos and creation timestamps.
  - Allows users to create, edit, or delete projects and their memos.

  Functionality:
  - Fetches project data from the `AuthController` using the `GetX` state management package.
  - Displays project memos with creation dates in card format.
  - Supports adding a new project via the `AddProjectDialog`.
  - Enables editing project details via the `EditMemoDialog`.
  - Provides deletion functionality for projects using the `DeleteProjectDialog`.

  How It Works:
  - Project data is dynamically updated using `Obx` to observe state changes.
  - A timestamp is shown in local time for each project and remains static post-creation.
  - Navigation to other pages (Finances, Materials, Labor) is available via icons in the app bar.
  - Includes a gradient background for visual consistency with the rest of the app.

  Files It Interacts With:
  - `dependencies.dart`: Supplies the `AuthController` for state management and project data.
  - `add_memo_dialog.dart`: Handles the creation of new projects and their memos.
  - `edit_memo_dialog.dart`: Handles the editing of project details and memos.
  - `delete_memo_dialog.dart`: Handles the deletion of projects.
  - `sign_out_dialog.dart`: Provides sign-out functionality from the app.
*/

class MemoCard extends StatelessWidget {
  final String timeStamp;
  final String name;
  final String memo;
  final int index;
  final Function scrollToBottom;

  const MemoCard({
    required this.timeStamp,
    required this.name,
    required this.memo,
    required this.index,
    required this.scrollToBottom,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      color: Colors.white,
      elevation: 5,
      surfaceTintColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  timeStamp.isNotEmpty
                      ? DateFormat.yMEd().add_jm().format(
                        (DateTime.tryParse(timeStamp)?.toLocal()) ?? DateTime.now(),
                      )
                      : 'Unknown Date',
                ),
                const SizedBox(width: 30),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue), // Blue edit button
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return EditMemoDialog(
                          index: index,
                          currentMemo: memo, // Pass current memo content to edit
                          projectName: name, // Pass current project name
                        );
                      },
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red), // Red delete button
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return DeleteProjectDialog(
                          index: index,
                          scrollToBottom: scrollToBottom,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            // Display project name directly
            Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(memo),
          ],
        ),
      ),
    );
  }
}

class MemoPage extends StatefulWidget {
  const MemoPage({super.key});

  @override
  State<MemoPage> createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  var scrollController = ScrollController();

  void scrollToBottom() {
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        if (!Get.find<dependencies.AuthController>().isSignedIn.value) {
          Get.toNamed('/home_page');
        }
        if (Get.find<dependencies.AuthController>().projects.isNotEmpty) {
          scrollController.jumpTo(scrollController.position.maxScrollExtent);
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: InkWell(
              child: const Row(
                children: [
                  Text('Sign Out'),
                  SizedBox(width: 10),
                  Icon(Icons.logout),
                ],
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return const SignOutDialog();
                  },
                );
              },
            ),
          ),
        ],
        title: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(Get.find<dependencies.AuthController>().signedInEmail.value),
              const SizedBox(width: 20),
              IconButton(
                icon: const Icon(Icons.attach_money),
                onPressed: () {
                  Get.toNamed('/finances_page'); // Navigate to finances page
                },
              ),
              IconButton(
                icon: const Icon(Icons.build), // Hammer icon for materials page
                onPressed: () {
                  Get.toNamed('/materials_page'); // Navigate to materials page
                },
              ),
              IconButton(
                icon: const Icon(Icons.people),
                onPressed: () {
                  Get.toNamed('/labor_page'); // Navigate to labor page
                },
              ),
            ],
          ),
        ),
      ),
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
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Obx(
                () => Get.find<dependencies.AuthController>().projects.isEmpty
                    ? const Center(
                        child: Text('No projects yet'),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.only(
                          top: 20,
                          bottom: 130,
                        ),
                        itemCount: Get.find<dependencies.AuthController>()
                            .projects
                            .length,
                        itemBuilder: (context, index) {
                          final project = Get.find<dependencies.AuthController>()
                              .projects[index];
                          return MemoCard(
                            timeStamp: project['timeStamp'] ?? 'Unknown Date', // No fallback to current date
                            name: project['name'],
                            memo: project['memo'],
                            index: index,
                            scrollToBottom: scrollToBottom,
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.only(
          top: 5,
          left: 5,
          right: 5,
          bottom: 20,
        ),
        child: IconButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(
              Colors.white,
            ),
            foregroundColor: MaterialStatePropertyAll(
              Colors.black,
            ),
          ),
          icon: const Icon(
            Icons.add,
            size: 50,
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AddProjectDialog(
                  scrollToBottom: scrollToBottom,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
