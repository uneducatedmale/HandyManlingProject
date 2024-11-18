import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:handyapp/utilities/dependencies.dart' as dependencies;
import 'package:handyapp/dialogs/add_pay_dialog.dart'; // Import added

class FinancesPage extends StatelessWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Finances'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Yellow gradient background
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 1,
                colors: [
                  Color(0xFFFFFF00), // Yellow starting color
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
                    'No projects yet. Add a project to see finances.',
                    style: TextStyle(fontSize: 16),
                  ),
                );
              }

              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    children: projects.map((project) {
                      // Calculate finances dynamically
                      final materials = (project['materials'] as List<dynamic>?)
                              ?.map((m) => (m['quantity'] ?? 0) * (m['value'] ?? 0.0))
                              .fold(0.0, (sum, cost) => sum + cost) ??
                          0.0;
                      final wages = (project['laborers'] as List<dynamic>?)
                              ?.map((l) =>
                                  (l['hourlyWage'] ?? 0.0) * (l['hoursWorked'] ?? 0.0))
                              .fold(0.0, (sum, cost) => sum + cost) ??
                          0.0;
                      final pay = project['jobPay'] ?? 0.0;
                      final grossIncome = pay - (materials + wages);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0), // Adds gap between cards
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 650),
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
                                    project['name'] ?? 'Unnamed Project',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  // Finance table header
                                  const Row(
                                    children: [
                                      Expanded(flex: 3, child: Text("Materials", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 3, child: Text("Wages", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 3, child: Text("Project Pay", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 3, child: Text("Gross Income", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                  const Divider(thickness: 1.5),
                                  // Finance values
                                  Row(
                                    children: [
                                      Expanded(flex: 3, child: Text("\$${materials.toStringAsFixed(2)}")),
                                      Expanded(flex: 3, child: Text("\$${wages.toStringAsFixed(2)}", textAlign: TextAlign.center)),
                                      Expanded(flex: 3, child: Text("\$${pay.toStringAsFixed(2)}", textAlign: TextAlign.center)),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          "\$${grossIncome.toStringAsFixed(2)}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: grossIncome < 0
                                                ? Colors.red
                                                : grossIncome > 0
                                                    ? Colors.green
                                                    : Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20), // Extra space at the bottom of the card
                                  // Edit Pay Button
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue), // Blue pencil icon
                                    onPressed: () {
                                      Get.dialog(AddPayDialog(
                                        projectId: project['_id'],
                                        projectName: project['name'],
                                      ));
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
