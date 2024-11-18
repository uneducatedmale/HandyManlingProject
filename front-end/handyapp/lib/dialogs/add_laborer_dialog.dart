import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;

class AddLaborerDialog extends StatefulWidget {
  final String projectId;
  final String projectName;

  const AddLaborerDialog({
    required this.projectId,
    required this.projectName,
    super.key,
  });

  @override
  State<AddLaborerDialog> createState() => _AddLaborerDialogState();
}

class _AddLaborerDialogState extends State<AddLaborerDialog> {
  final nameController = TextEditingController();
  final jobController = TextEditingController();
  final hourlyWageController = TextEditingController();
  final hoursWorkedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Laborer to ${widget.projectName}'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: jobController,
              decoration: const InputDecoration(labelText: 'Job'),
            ),
            TextField(
              controller: hourlyWageController,
              decoration: const InputDecoration(labelText: 'Hourly Wage'),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            TextField(
              controller: hoursWorkedController,
              decoration: const InputDecoration(labelText: 'Hours Worked'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            final name = nameController.text.trim();
            final job = jobController.text.trim();
            final hourlyWage = double.tryParse(hourlyWageController.text.trim()) ?? 0.0;
            final hoursWorked = int.tryParse(hoursWorkedController.text.trim()) ?? 0;

            if (name.isEmpty || job.isEmpty || hourlyWage <= 0 || hoursWorked <= 0) {
              Get.snackbar('Error', 'All fields must be valid and filled.');
              return;
            }

            final result = await Get.find<dependencies.AuthController>().addLaborer(
              widget.projectId,
              name,
              job,
              hourlyWage,
              hoursWorked,
            );

            if (result == 'success') {
              Get.back(); // Close dialog
            } else {
              Get.snackbar('Error', result);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}