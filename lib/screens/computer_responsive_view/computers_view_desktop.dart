import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventary/services/firebase_services.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class ComputersViewDesktop extends StatefulWidget {
  const ComputersViewDesktop({Key? key}) : super(key: key);

  @override
  State<ComputersViewDesktop> createState() => _ComputersViewDesktopState();
}

class _ComputersViewDesktopState extends State<ComputersViewDesktop> {
  late Future<List<Map<String, dynamic>>> futureComputers;

  @override
  void initState() {
    super.initState();
    futureComputers = getComputers();
  }

  //Controladores para los campos de texto
  TextEditingController textMarcaController = TextEditingController(text: "");
  TextEditingController textModeloController = TextEditingController();
  TextEditingController textLineaController = TextEditingController();
  TextEditingController textUbicacionController = TextEditingController();
  TextEditingController textUsuarioController = TextEditingController();
  TextEditingController textFechaController = TextEditingController();
  late DateTime _selectedDate;

  void _showAddEquipmentModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar equipo',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: textMarcaController,
                  decoration: const InputDecoration(hintText: 'Marca'),
                ),
                TextField(
                  controller: textModeloController,
                  decoration: const InputDecoration(hintText: 'Modelo'),
                ),
                TextField(
                  controller: textLineaController,
                  decoration: const InputDecoration(hintText: 'Línea'),
                ),
                TextField(
                  controller: textUbicacionController,
                  decoration: const InputDecoration(hintText: 'Ubicación'),
                ),
                TextField(
                  controller: textUsuarioController,
                  decoration: const InputDecoration(hintText: 'Usuario'),
                ),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 100),
                      lastDate: DateTime(DateTime.now().year + 1),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          _selectedDate = selectedDate;
                          textFechaController.text =
                              DateFormat('MMMM d, yyyy').format(selectedDate);
                        });
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: textFechaController,
                      decoration: const InputDecoration(
                        labelText: 'Selecciona Fecha',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
                child: const Text('Guardar',
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  // Acción para guardar el formulario
                  String marca = textMarcaController.text;
                  String modelo = textModeloController.text;
                  int linea = int.tryParse(textLineaController.text) ?? 0;
                  String ubicacion = textUbicacionController.text;
                  String usuario = textUsuarioController.text;

                  addComputers(marca, modelo, linea, ubicacion, usuario,
                          _selectedDate)
                      .then((value) {
                    Navigator.of(context).pop();
                    setState(() {
                      futureComputers = getComputers();
                    });
                  });
                }),
          ],
        );
      },
    );
  }

  void _showEditEquipmentModal(
      BuildContext context, Map<String, dynamic> computer) {
    textMarcaController.text = computer['marca'] ?? '';
    textModeloController.text = computer['modelo'] ?? '';
    textLineaController.text = computer['linea']?.toString() ?? '';
    textUbicacionController.text = computer['ubicacion'] ?? '';
    textUsuarioController.text = computer['usuario'] ?? '';
    textFechaController.text = computer['fecha_compra'] != null
        ? DateFormat('dd-MM-yyyy')
            .format((computer['fecha_compra'] as Timestamp).toDate())
        : '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Editar equipo',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: textMarcaController,
                  decoration: const InputDecoration(hintText: 'Marca'),
                ),
                TextField(
                  controller: textModeloController,
                  decoration: const InputDecoration(hintText: 'Modelo'),
                ),
                TextField(
                  controller: textLineaController,
                  decoration: const InputDecoration(hintText: 'Línea'),
                ),
                TextField(
                  controller: textUbicacionController,
                  decoration: const InputDecoration(hintText: 'Ubicación'),
                ),
                TextField(
                  controller: textUsuarioController,
                  decoration: const InputDecoration(hintText: 'Usuario'),
                ),
                GestureDetector(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 100),
                      lastDate: DateTime(DateTime.now().year + 1),
                    ).then((selectedDate) {
                      if (selectedDate != null) {
                        setState(() {
                          _selectedDate = selectedDate;
                          textFechaController.text =
                              DateFormat('MMMM d, yyyy').format(selectedDate);
                        });//Cambia el formato de la fecha para firebase
                      }
                    });
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      controller: textFechaController,
                      decoration: const InputDecoration(
                        labelText: 'Selecciona Fecha',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Guardar', style: TextStyle(color: Colors.black)),
              onPressed: () async {
                if (textFechaController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor selecciona una fecha'),
                    ),
                  );
                  return;
                }
                // Envia para actualizar el formulario
                String marca = textMarcaController.text;
                String modelo = textModeloController.text;
                int linea = int.tryParse(textLineaController.text) ?? 0;
                String ubicacion = textUbicacionController.text;
                String usuario = textUsuarioController.text;

                updateComputers(computer['id'], marca, modelo, linea, ubicacion,
                        usuario, _selectedDate)
                    .then((value) {
                  Navigator.of(context).pop();
                  setState(() {
                    futureComputers = getComputers();
                  });
                });
              },
            ),
          ],
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, String id, String equipo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Eliminar $equipo',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              )),
          content:
              const Text('¿Estás seguro de que deseas eliminar este equipo?'),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child:
                  const Text('Eliminar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                deleteComputer(id);
                Navigator.of(context).pop();
                setState(() {
                  futureComputers = getComputers();
                });
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
                  const SizedBox(height: 30),
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
                              fillColor: Colors.white,
                              filled: true,
                              hintText: 'Buscar...',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),

                        const SizedBox(width: 30),

                        // Add Button
                        ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                          label: const Text(
                            'Agregar equipo',
                            style: TextStyle(color: Colors.white),
                          ),
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
                      child: FutureBuilder<List<Map<String, dynamic>>>(
                        future: getComputers(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          if (!snapshot.hasData || snapshot.data!.isEmpty) {
                            return const Center(
                                child: Text('No hay datos disponibles.'));
                          }

                          // Construye la tabla con los datos obtenidos
                          return SingleChildScrollView(
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
                                rows: snapshot.data!.map((computer) {
                                  return DataRow(cells: [
                                    DataCell(Text(computer['marca'] ?? '')),
                                    DataCell(Text(computer['modelo'] ?? '')),
                                    DataCell(Text(
                                        computer['linea']?.toString() ?? '')),
                                    DataCell(Text(computer['ubicacion'] ?? '')),
                                    DataCell(Text(computer['usuario'] ?? '')),
                                    DataCell(Text(
                                      computer['fecha_compra'] != null
                                          ? DateFormat('dd-MM-yyyy').format(
                                              (computer['fecha_compra']
                                                      as Timestamp)
                                                  .toDate())
                                          : '',
                                    )),
                                    DataCell(Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () =>
                                              _showEditEquipmentModal(
                                                  context, computer), //Envia datos al modal de editar por medio del computer
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            _confirmDelete(
                                                context,
                                                computer['id'],
                                                computer['marca']);
                                          },
                                        ),
                                      ],
                                    )),
                                  ]);
                                }).toList(),
                                dividerThickness:
                                    0, // Removes the division between columns
                              ),
                            ),
                          );
                        },
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
