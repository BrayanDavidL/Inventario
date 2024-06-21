import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List<Map<String, dynamic>>> getComputers() async {
  List<Map<String, dynamic>> computers = [];
  QuerySnapshot queryComputer = await db.collection('Computers').get();

  for (var documento in queryComputer.docs) {
    Map<String, dynamic> data = documento.data() as Map<String, dynamic>;
    data['id'] = documento.id;  // Agrega el id del documento a los datos
    computers.add(data);
  }

  return computers;
}
//Agregar Equipo
Future<void> addComputers(String marca, String modelo, int linea, String ubicacion, String usuario, DateTime fecha_compra) async {
  await FirebaseFirestore.instance.collection("Computers").add({
    'marca': marca,
    'modelo': modelo,
    'linea': linea,
    'ubicacion': ubicacion,
    'usuario': usuario,
    'fecha_compra': Timestamp.fromDate(fecha_compra),
  });
}

//Actualizar Equipo
Future<void> updateComputers(String id, String marca, String modelo, int linea, String ubicacion, String usuario, DateTime fecha_compra) async {
  try {
    await db.collection('Computers').doc(id).update({
      'marca': marca,
      'modelo': modelo,
      'linea': linea,
      'ubicacion': ubicacion,
      'usuario': usuario,
      'fecha_compra': Timestamp.fromDate(fecha_compra),
    });
    print('Equipo actualizado correctamente');
  } catch (e) {
    print('Error al actualizar equipo: $e');
    throw e;
  }
}

//Eliminar equipo
Future<void> deleteComputer(String id) async {
  try {
    await db.collection('Computers').doc(id).delete();
    print('Equipo eliminado correctamente');
  } catch (e) {
    print('Error al eliminar equipo: $e');
    throw e;
  }
}

//Traer el total de equipos registrados
Future<int> getTotalEquipos() async {
  QuerySnapshot query = await FirebaseFirestore.instance.collection('Computers').get();
  return query.size;
}

//Traer los registros mas recientes
Future<List<Map<String, dynamic>>> getRecentComputers() async {
  List<Map<String, dynamic>> computers = [];

  try {
    QuerySnapshot querySnapshot = await db
        .collection('Computers')
        .orderBy('fecha_compra', descending: true)
        .get();

    querySnapshot.docs.forEach((doc) {
      computers.add({
        'id': doc.id,
        ...doc.data() as Map<String, dynamic>,
      });
    });
  } catch (e) {
    print('Error fetching computers: $e');
  }

  return computers;
}
