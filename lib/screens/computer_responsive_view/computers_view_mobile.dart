import 'package:flutter/material.dart';
import '../../constants.dart';

class ComputersViewMobile extends StatefulWidget {
  const ComputersViewMobile({super.key});

  @override
  State<ComputersViewMobile> createState() => _ComputersViewMobileState();
}

class _ComputersViewMobileState extends State<ComputersViewMobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
      appBar: myAppBar(context),
      drawer: myDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        // Aquí puedes colocar el contenido específico de ComputersViewMobile si es necesario
      ),
    );
  }
}


