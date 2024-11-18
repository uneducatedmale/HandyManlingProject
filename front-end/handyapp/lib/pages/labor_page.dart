import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;
import 'package:handyapp/dialogs/add_laborer_dialog.dart';
import 'package:handyapp/dialogs/edit_laborer_dialog.dart';
import 'package:handyapp/dialogs/delete_laborer_dialog.dart';

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
