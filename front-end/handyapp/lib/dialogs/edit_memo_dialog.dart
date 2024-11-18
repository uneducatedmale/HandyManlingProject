import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

class EditMemoDialog extends StatefulWidget {
  final int index; // The index of the project to edit
  final String currentMemo; // Current memo of the project
  final String projectName; // Current project name

  const EditMemoDialog({
    required this.index,
    required this.currentMemo,
    required this.projectName,
    super.key,
  });

  @override
  State<EditMemoDialog> createState() => _EditMemoDialogState();
}

class _EditMemoDialogState extends State<EditMemoDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _memoController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.projectName);
    _memoController = TextEditingController(text: widget.currentMemo);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _memoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Project'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Project Name Field
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Project Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Project name cannot be empty';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Memo Field
            TextFormField(
              controller: _memoController,
              decoration: const InputDecoration(
                labelText: 'Memo',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Memo cannot be empty';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        // Cancel Button
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Save Button
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              final authController = Get.find<dependencies.AuthController>();

              final result = await authController.editProjectMemo(
                widget.index,
                _nameController.text.trim(),
                _memoController.text.trim(),
              );

              if (result == 'success') {
                Get.snackbar(
                  'Success',
                  'Project updated successfully',
                  snackPosition: SnackPosition.BOTTOM,
                );
                Navigator.of(context).pop();
              } else {
                Get.snackbar(
                  'Error',
                  result,
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
