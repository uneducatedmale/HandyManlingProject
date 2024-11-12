import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MaterialsPage extends StatelessWidget {
  const MaterialsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String timeStamp = DateFormat.yMEd().add_jm().format(DateTime.now());

    // Dummy data for projects and materials
    final List<Map<String, dynamic>> projects = [
      {
        'name': 'Project 1',
        'materials': [
          {'material': "2x4x8' Plank", 'quantity': 10, 'value': 4.25},
          {'material': "Nails (1 lb)", 'quantity': 5, 'value': 3.75},
          {'material': "Cement Bag", 'quantity': 2, 'value': 7.50},
          {'material': "Drywall Sheets", 'quantity': 15, 'value': 12.0},
          {'material': "Wood Glue", 'quantity': 3, 'value': 5.5},
        ],
      },
      {
        'name': 'Project 2',
        'materials': [
          {'material': "PVC Pipes", 'quantity': 20, 'value': 2.5},
          {'material': "Concrete Blocks", 'quantity': 30, 'value': 1.75},
          {'material': "Rebar (6 ft)", 'quantity': 10, 'value': 8.0},
          {'material': "Sandbags", 'quantity': 50, 'value': 0.6},
          {'material': "Tarps", 'quantity': 8, 'value': 10.5},
        ],
      },
      {
        'name': 'Project 3',
        'materials': [
          {'material': "Paint (1 gal)", 'quantity': 5, 'value': 25.0},
          {'material': "Brushes", 'quantity': 10, 'value': 2.5},
          {'material': "Rollers", 'quantity': 6, 'value': 3.75},
          {'material': "Masking Tape", 'quantity': 4, 'value': 1.5},
          {'material': "Drop Cloth", 'quantity': 3, 'value': 8.0},
        ],
      },
      {
        'name': 'Project 4',
        'materials': [
          {'material': "Shingles", 'quantity': 20, 'value': 3.25},
          {'material': "Roof Nails", 'quantity': 200, 'value': 0.02},
          {'material': "Underlayment", 'quantity': 10, 'value': 15.0},
          {'material': "Sealant", 'quantity': 5, 'value': 7.5},
          {'material': "Vent Caps", 'quantity': 2, 'value': 12.0},
        ],
      },
    ];

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
                                // Centered timestamp and project name
                                Text(timeStamp, style: const TextStyle(fontSize: 16), textAlign: TextAlign.center),
                                Text(
                                  project['name'],
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                // Table header
                                const Row(
                                  children: [
                                    Expanded(flex: 4, child: Text("Materials", style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 2, child: Text("#", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 2, child: Text("Value", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                    Expanded(flex: 3, child: Text("Total Value", textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold))),
                                  ],
                                ),
                                const Divider(thickness: 1.5),
                                // Table rows for each material
                                ...project['materials'].map<Widget>((material) {
                                  final totalValue = material['quantity'] * material['value'];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                                    child: Row(
                                      children: [
                                        Expanded(flex: 4, child: Text(material['material'])),
                                        Expanded(flex: 2, child: Text(material['quantity'].toString(), textAlign: TextAlign.center)),
                                        Expanded(flex: 2, child: Text('\$${material['value'].toStringAsFixed(2)}', textAlign: TextAlign.center)),
                                        Expanded(flex: 3, child: Text('\$${totalValue.toStringAsFixed(2)}', textAlign: TextAlign.center)),
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
            // Add material action
          },
        ),
      ),
    );
  }
}
