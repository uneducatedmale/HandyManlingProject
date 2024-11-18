import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

class AddProjectDialog extends StatefulWidget {
  final Function scrollToBottom;

  const AddProjectDialog({
    required this.scrollToBottom,
    super.key,
  });

  @override
  State<AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  RxString status = 'type-project'.obs;
  var nameController = TextEditingController();
  var memoController = TextEditingController();

  Widget typeProjectWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                hintText: 'Enter project name...',
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 400,
            child: TextFormField(
              controller: memoController,
              decoration: const InputDecoration(
                hintText: 'Type a general memo for this project...',
              ),
              maxLines: null,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: const Text('Save'),
                onPressed: () {
                  status.value = 'adding-project';
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

  Widget addingProjectWidget() {
    return FutureBuilder(
      future: Get.find<dependencies.AuthController>().addProject(
        nameController.text,
        memoController.text,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Adding project...'),
                SizedBox(height: 20),
                CircularProgressIndicator(),
              ],
            ),
          );
        } else if (snapshot.data == 'success') {
          Future.delayed(
            const Duration(seconds: 1),
            () {
              widget.scrollToBottom();
              Navigator.pop(context);
            },
          );
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Project added successfully'),
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
        () => status.value == 'type-project'
            ? typeProjectWidget()
            : status.value == 'adding-project'
                ? addingProjectWidget()
                : const SizedBox(),
      ),
    );
  }
}
