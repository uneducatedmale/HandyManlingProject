import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;
import 'package:handyapp/dialogs/add_material_dialog.dart';
import 'package:handyapp/dialogs/delete_material_dialog.dart'; // Import for delete dialog
import 'package:handyapp/dialogs/edit_material_dialog.dart'; // Import for edit dialog

/*
  File: materials_page.dart
  Purpose:
  - Manages and displays the materials required for each project.
  - Allows users to add, edit, or delete materials for any specific project.

  Functionality:
  - Fetches project and material data from the `AuthController` using the `GetX` state management package.
  - Displays materials in a tabular format, including their name, quantity, value, and total value.
  - Provides buttons for adding a new material, editing existing materials, or deleting them.

  How It Works:
  - Projects are listed as cards, and each card contains a table showing the materials tied to the project.
  - Data updates dynamically using `Obx`, reflecting real-time changes in the state.
  - Includes a gradient background for visual consistency with the rest of the app.

  Files It Interacts With:
  - `dependencies.dart`: Supplies the `AuthController` for state management and project data.
  - `add_material_dialog.dart`: Handles the dialog for adding new materials.
  - `edit_material_dialog.dart`: Handles the dialog for editing material details.
  - `delete_material_dialog.dart`: Handles the dialog for deleting materials.
*/

class MaterialsPage extends StatelessWidget {
  const MaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Materials'),
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
                  Color(0xff1679ab), // Blue starting color
                  Colors.white, // Fading into white
                ],
              ),
            ),
          ),
          Center(
            child: Obx(() {
              // Get the list of projects from the controller
              final projects = Get.find<dependencies.AuthController>().projects;

              if (projects.isEmpty) {
                // Display message if no projects exist
                return const Center(
                  child: Text(
                    'No projects yet. Add a project to see materials.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: projects.map<Widget>((project) {
                      final materials = project['materials'] ?? [];

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0), // Adds gap between cards
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Card(
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            color: Colors.white,
                            elevation: 5,
                            surfaceTintColor: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  // Project name
                                  Text(
                                    project['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  // Table header
                                  const Row(
                                    children: [
                                      Expanded(
                                        flex: 5, // Increased flex for Materials column
                                        child: Text(
                                          "Materials",
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "#",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Value",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Total Value",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      SizedBox(width: 20), // Space between Total Value and Actions
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "Actions",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Divider(thickness: 1.5),
                                  // Table rows for each material
                                  if (materials.isEmpty)
                                    const Text(
                                      'No materials yet.',
                                      style: TextStyle(fontSize: 14, color: Colors.grey),
                                    )
                                  else
                                    ...materials.map<Widget>((material) {
                                      final totalValue = material['quantity'] * material['value'];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                                        child: Row(
                                          children: [
                                            Expanded(flex: 5, child: Text(material['name'] ?? '')), // Adjusted flex
                                            Expanded(flex: 2, child: Text(material['quantity'].toString(), textAlign: TextAlign.center)),
                                            Expanded(flex: 2, child: Text('\$${material['value'].toStringAsFixed(2)}', textAlign: TextAlign.center)),
                                            Expanded(flex: 3, child: Text('\$${totalValue.toStringAsFixed(2)}', textAlign: TextAlign.center)),
                                            SizedBox(width: 20), // Space between Total Value and Action buttons
                                            Expanded(
                                              flex: 3,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: [
                                                  IconButton(
                                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                                    onPressed: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return EditMaterialDialog(
                                                            projectId: project['_id'],
                                                            materialId: material['_id'], // Pass material ID
                                                            materialName: material['name'],
                                                            quantity: material['quantity'],
                                                            value: material['value'],
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
                                                          return DeleteMaterialDialog(
                                                            projectId: project['_id'],
                                                            materialId: material['_id'], // Pass material ID
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
                                  // Add Material Button
                                  IconButton(
                                    icon: const Icon(Icons.add),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return AddMaterialDialog(
                                            projectId: project['_id'], // Pass project ID to dialog
                                            projectName: project['name'], // Pass project name to dialog
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

