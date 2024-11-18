import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;
import 'package:handyapp/dialogs/add_laborer_dialog.dart';
import 'package:handyapp/dialogs/edit_laborer_dialog.dart';
import 'package:handyapp/dialogs/delete_laborer_dialog.dart';

/*
  File: labor_page.dart
  Purpose:
  - Displays and manages the labor details for each project.
  - Allows users to add, edit, or delete laborers associated with a project.

  Functionality:
  - Fetches project and labor data from the `AuthController` using the `GetX` state management package.
  - Presents laborers in a tabular format, including their name, job, hourly wage, hours worked, and total pay.
  - Provides buttons for adding a new laborer, editing existing laborers, or deleting them.

  How It Works:
  - Projects are listed as cards, and each card contains a table showing the laborers tied to the project.
  - Data updates dynamically using `Obx`, reflecting real-time changes in the state.
  - Background gradient and other UI elements maintain visual consistency with the rest of the app.

  Files It Interacts With:
  - `dependencies.dart`: Supplies the `AuthController` for state management and project data.
  - `add_laborer_dialog.dart`: Handles the dialog for adding new laborers.
  - `edit_laborer_dialog.dart`: Handles the dialog for editing laborer details.
  - `delete_laborer_dialog.dart`: Handles the dialog for deleting laborers.
*/

class LaborPage extends StatelessWidget {
  const LaborPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Labor'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1,
                colors: [
                  Color(0xffab2a2a), // Red starting color
                  Colors.white, // Fading into white
                ],
              ),
            ),
          ),
          Center(
            child: Obx(() {
              // Fetch the projects from the controller
              final projects = Get.find<dependencies.AuthController>().projects;

              if (projects.isEmpty) {
                // Display message if no projects exist
                return const Center(
                  child: Text(
                    'No projects yet. Add a project to see labor details.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: projects.map<Widget>((project) {
                      final workers = project['laborers'] ?? [];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0), // Adds gap between cards
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700), // Adjusted for more space
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.white,
                            elevation: 5,
                            surfaceTintColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  // Centered project name
                                  Text(
                                    project['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  // Table header with additional spacing
                                  const Row(
                                    children: [
                                      Expanded(flex: 5, child: Text("Worker", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 5, child: Text("Job", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 4, child: Text("Hourly Wage", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 3, child: Text("Hours", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 4, child: Text("Total Pay", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                      SizedBox(width: 30), // Increased space between Total Pay and Actions
                                      Expanded(flex: 4, child: Text("Actions", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                  const Divider(thickness: 1.5),
                                  // Table rows for each worker
                                  if (workers.isEmpty)
                                    const Text(
                                      'No workers yet.',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    )
                                  else
                                    ...workers.map<Widget>((worker) {
                                      final totalPay = worker['hourlyWage'] * worker['hoursWorked'];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(flex: 5, child: Text(worker['name'] ?? '')),
                                            Expanded(flex: 5, child: Text(worker['job'] ?? '', textAlign: TextAlign.center)),
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                '\$${worker['hourlyWage'].toStringAsFixed(2)}',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Text(
                                                worker['hoursWorked'].toString(),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                '\$${totalPay.toStringAsFixed(2)}',
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            SizedBox(width: 30), // Space between Total Pay and Action buttons
                                            Expanded(
                                              flex: 4,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return EditLaborerDialog(
                                                            projectId: project['_id'],
                                                            laborerId: worker['_id'], // Pass worker ID
                                                            workerName: worker['name'],
                                                            job: worker['job'],
                                                            hourlyWage: worker['hourlyWage'],
                                                            hoursWorked: worker['hoursWorked'],
                                                          );
                                                        },
                                                      );
                                                    },
                                                  ),
                                                  IconButton(
                                                    icon: const Icon(Icons.delete, color: Colors.red),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return DeleteLaborerDialog(
                                                            projectId: project['_id'],
                                                            laborerId: worker['_id'], // Pass worker ID
                                                          );
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
                                    }).toList(),
                                  const SizedBox(height: 20), // Extra space at the bottom of the card
                                  // Add Laborer Button
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AddLaborerDialog(
                                            projectId: project['_id'],
                                            projectName: project['name'],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
