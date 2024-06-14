import 'package:flutter/material.dart';
import '../../constants.dart';

class ComputersViewDesktop extends StatefulWidget {
  const ComputersViewDesktop({super.key});

  @override
  State<ComputersViewDesktop> createState() => _ComputersViewDesktopState();
}

class _ComputersViewDesktopState extends State<ComputersViewDesktop> {
  void _showAddEquipmentModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar equipo',style: TextStyle(
            fontWeight: FontWeight.bold,)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  decoration: InputDecoration(hintText: 'Marca'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Modelo'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Línea'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Ubicación'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Usuario'),
                ),
                TextField(
                  decoration: InputDecoration(hintText: 'Fecha'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Guardar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                // Acción para guardar el formulario
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: defaultBackgroundColor,
        drawer: myDrawer(context),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // open drawer
              myDrawer(context),

              // AppBar and main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // AppBar
                    myAppBar(context),

                    // Title
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'Equipos',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                     SizedBox(height: 30),
                    // Search and Add Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Search Field
                          const SizedBox(
                            width: 200, // Ancho fijo para el campo de búsqueda
                            child: TextField(
                              controller: null,
                              decoration: InputDecoration(
                                fillColor: Colors.white, filled: true,
                                hintText: 'Buscar...',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.search),

                              ),
                            ),
                          ),

                          const SizedBox(width: 30),

                          // Add Button
                          ElevatedButton.icon(
                            icon: const Icon(Icons.add, color: Colors.white,),
                            label: const Text('Agregar equipo',
                              style: TextStyle(color: Colors.white),),
                            onPressed: () => _showAddEquipmentModal(context),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Main content area with Table
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DataTable(
                              headingRowHeight: 56.0,

                              columns: const [
                                DataColumn(label: Text('Marca')),
                                DataColumn(label: Text('Modelo')),
                                DataColumn(label: Text('Línea')),
                                DataColumn(label: Text('Ubicación')),
                                DataColumn(label: Text('Usuario')),
                                DataColumn(label: Text('Fecha')),
                                DataColumn(label: Text('Acciones')),
                              ],
                              rows: const [
                                DataRow(cells: [
                                  DataCell(Text('Marca 1')),
                                  DataCell(Text('Modelo 1')),
                                  DataCell(Text('Línea 1')),
                                  DataCell(Text('Ubicación 1')),
                                  DataCell(Text('Usuario 1')),
                                  DataCell(Text('Fecha 1')),
                                  DataCell(Text('Acciones')),
                                ]),
                                DataRow(cells: [
                                  DataCell(Text('Marca 2')),
                                  DataCell(Text('Modelo 2')),
                                  DataCell(Text('Línea 2')),
                                  DataCell(Text('Ubicación 2')),
                                  DataCell(Text('Usuario 2')),
                                  DataCell(Text('Fecha 2')),
                                  DataCell(Text('Acciones')),
                                ]),
                                // Add more DataRows as needed
                              ],
                              dividerThickness: 0, // Removes the division between columns
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
}