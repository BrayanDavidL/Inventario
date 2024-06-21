import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inventary/services/firebase_services.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

class ComputersViewMobile extends StatefulWidget {
  const ComputersViewMobile({Key? key}) : super(key: key);

  @override
  State<ComputersViewMobile> createState() => _ComputersViewMobileState();
}

class _ComputersViewMobileState extends State<ComputersViewMobile> {
  late Future<List<Map<String, dynamic>>> futureComputers;

  @override
  void initState() {
    super.initState();
    futureComputers = getComputers();
  }

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
                // Acción para actualizar el formulario
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
      appBar: myAppBar(context),
      drawer: myDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Equipos',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Search and Add Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Search Field
                  const SizedBox(
                    width: 150,
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
                  const SizedBox(width: 20),

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

            // Main content area with ListView
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: getComputers(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No hay datos disponibles.'));
                    }

                    // Construye la lista con los datos obtenidos
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var computer = snapshot.data![index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            title: Text(computer['marca'] ?? ''),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Modelo: ${computer['modelo'] ?? ''}'),
                                Text('Línea: ${computer['linea']?.toString() ?? ''}'),
                                Text('Ubicación: ${computer['ubicacion'] ?? ''}'),
                                Text('Usuario: ${computer['usuario'] ?? ''}'),
                                Text(
                                  'Fecha: ${computer['fecha_compra'] != null ? DateFormat('dd-MM-yyyy').format((computer['fecha_compra'] as Timestamp).toDate()) : ''}',
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () => _showEditEquipmentModal(context, computer),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    _confirmDelete(context, computer['id'], computer['marca']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
