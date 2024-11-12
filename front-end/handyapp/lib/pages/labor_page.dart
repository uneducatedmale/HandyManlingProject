import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaborPage extends StatelessWidget {
  const LaborPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String timeStamp = DateFormat.yMEd().add_jm().format(DateTime.now());

    // Dummy data for projects and workers
    final List<Map<String, dynamic>> projects = [
      {
        'name': 'Project 1',
        'workers': [
          {'worker': 'Bob Smith', 'job': 'Carpenter', 'wage': 20.75, 'hours': 10},
          {'worker': 'Alice Johnson', 'job': 'Electrician', 'wage': 25.5, 'hours': 8},
          {'worker': 'John Doe', 'job': 'Plumber', 'wage': 22.0, 'hours': 12},
          {'worker': 'Emily Clark', 'job': 'Painter', 'wage': 18.0, 'hours': 15},
          {'worker': 'Jake White', 'job': 'Roofer', 'wage': 21.0, 'hours': 10},
        ],
      },
      {
        'name': 'Project 2',
        'workers': [
          {'worker': 'Tom Baker', 'job': 'Foreman', 'wage': 30.0, 'hours': 7},
          {'worker': 'Sara King', 'job': 'Carpenter', 'wage': 20.0, 'hours': 9},
          {'worker': 'Mike Ross', 'job': 'Electrician', 'wage': 26.5, 'hours': 11},
          {'worker': 'Linda Green', 'job': 'Laborer', 'wage': 15.0, 'hours': 20},
          {'worker': 'Steve Brown', 'job': 'Operator', 'wage': 28.0, 'hours': 6},
        ],
      },
      {
        'name': 'Project 3',
        'workers': [
          {'worker': 'Paul Harris', 'job': 'Engineer', 'wage': 35.5, 'hours': 8},
          {'worker': 'Nancy Lee', 'job': 'Welder', 'wage': 24.0, 'hours': 12},
          {'worker': 'George Hill', 'job': 'Mechanic', 'wage': 22.5, 'hours': 15},
          {'worker': 'Jessica Martin', 'job': 'Inspector', 'wage': 32.0, 'hours': 9},
          {'worker': 'Henry Scott', 'job': 'Surveyor', 'wage': 27.0, 'hours': 10},
        ],
      },
      {
        'name': 'Project 4',
        'workers': [
          {'worker': 'Laura Adams', 'job': 'Architect', 'wage': 40.0, 'hours': 6},
          {'worker': 'Kevin Lewis', 'job': 'Bricklayer', 'wage': 18.5, 'hours': 14},
          {'worker': 'Sophia Carter', 'job': 'Painter', 'wage': 19.0, 'hours': 10},
          {'worker': 'Eric Murphy', 'job': 'Laborer', 'wage': 15.0, 'hours': 20},
          {'worker': 'Anna Turner', 'job': 'Operator', 'wage': 28.5, 'hours': 7},
        ],
      },
    ];

    return Theme(
      data: Theme.of(context).copyWith(
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xffab2a2a), // Override bottom sheet with gradient start color
          surfaceTintColor: Colors.transparent,
        ),
      ),
      child: Scaffold(
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
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20.0), // Adds gap between cards
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 650), // Slightly wider for better spacing
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
                                  Text(timeStamp, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                                  Text(
                                    project['name'],
                                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  // Table header with additional spacing
                                  const Row(
                                    children: [
                                      Expanded(flex: 5, child: Text("Worker", style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 5, child: Text("Job", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 4, child: Text("Hourly Wage", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 2, child: Text("Hours", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                      Expanded(flex: 3, child: Text("Total Pay", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                    ],
                                  ),
                                  const Divider(thickness: 1.5),
                                  // Table rows for each worker
                                  ...project['workers'].map<Widget>((worker) {
                                    final totalPay = worker['wage'] * worker['hours'];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                                      child: Row(
                                        children: [
                                          Expanded(flex: 5, child: Text(worker['worker'])),
                                          Expanded(flex: 5, child: Text(worker['job'], textAlign: TextAlign.center)),
                                          Expanded(flex: 4, child: Text('\$${worker['wage'].toStringAsFixed(2)}', textAlign: TextAlign.center)),
                                          Expanded(flex: 2, child: Text(worker['hours'].toString(), textAlign: TextAlign.center)),
                                          Expanded(flex: 3, child: Text('\$${totalPay.toStringAsFixed(2)}', textAlign: TextAlign.center)),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                  const SizedBox(height: 20), // Extra space at the bottom of the card
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
        // Bottom IconButton
        bottomSheet: Padding(
          padding: const EdgeInsets.only(
            top: 5,
            left: 5,
            right: 5,
            bottom: 20,
          ),
          child: IconButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(
                Colors.white,
              ),
              foregroundColor: WidgetStatePropertyAll(
                Colors.black,
              ),
            ),
            icon: const Icon(
              Icons.add,
              size: 50,
            ),
            onPressed: () {
              // Add worker action
            },
          ),
        ),
      ),
    );
  }
}
