import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FinancesPage extends StatelessWidget {
  const FinancesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy data for project finances with dates
    final List<Map<String, dynamic>> projects = [
      {'name': 'Project 1', 'materials': 1000, 'wages': 1000, 'pay': 4000, 'date': DateTime(2024, 11, 6)},
      {'name': 'Project 2', 'materials': 1500, 'wages': 2000, 'pay': 6000, 'date': DateTime(2024, 11, 7)},
      {'name': 'Project 3', 'materials': 2000, 'wages': 2500, 'pay': 7000, 'date': DateTime(2024, 11, 8)},
      {'name': 'Project 4', 'materials': 1200, 'wages': 1800, 'pay': 5000, 'date': DateTime(2024, 11, 9)},
    ];

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
                  Colors.white,      // Fading into white
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  children: projects.map((project) {
                    // Calculate Gross Income as Project Pay - (Materials + Wages)
                    final grossIncome = project['pay'] - (project['materials'] + project['wages']);
                    final formattedDate = DateFormat.yMEd().add_jm().format(project['date']);

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
                                // Centered timestamp and project name
                                Text(formattedDate, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                                Text(
                                  project['name'],
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                // Finance data in a row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(flex: 3, child: Text("Materials: \$${project['materials']}")),
                                    Expanded(flex: 3, child: Text("Wages: \$${project['wages']}")),
                                    Expanded(flex: 3, child: Text("Project Pay: \$${project['pay']}")),
                                    Expanded(flex: 3, child: Text("Gross Income: \$${grossIncome}")),
                                  ],
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
