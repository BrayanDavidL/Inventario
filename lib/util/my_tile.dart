import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:inventary/services/firebase_services.dart';

class MyTile extends StatelessWidget {
  const MyTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder<List<Map<String, dynamic>>>(
        future: getRecentComputers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles.'));
          } else {
            return Container(
              height: 400, // Ajusta la altura según necesites
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[200],
              ),
              child: ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final computer = snapshot.data![index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Marca: ${computer['marca'] ?? ''}'),
                          Text('Modelo: ${computer['modelo'] ?? ''}'),
                          Text('Línea: ${computer['linea']?.toString() ?? ''}'),
                          Text('Ubicación: ${computer['ubicacion'] ?? ''}'),
                          Text('Usuario: ${computer['usuario'] ?? ''}'),
                          Text(
                            'Fecha: ${computer['fecha_compra'] != null
                                ? DateFormat('dd-MM-yyyy').format(
                                (computer['fecha_compra'] as Timestamp).toDate())
                                : ''}',
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
