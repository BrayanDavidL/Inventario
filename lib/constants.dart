import 'package:flutter/material.dart';
import 'main.dart';

var defaultBackgroundColor = Colors.grey[300];
var appBarColor = Colors.grey[300];
var myDefaultBackground = Colors.grey[300];
var drawerTextColor = const TextStyle(
  color: Colors.white,
);

var tilePadding = const EdgeInsets.only(left: 8.0, right: 8, top: 8);

var myAppBar = (BuildContext context) => AppBar(
  backgroundColor: appBarColor,
  leading: Builder(
    builder: (BuildContext context) {
      return Row(
        children: [
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.home),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const MyApp()),
                    (Route<dynamic> route) => false,
              );
            },
          ),
        ],
      );
    },
  ),
  actions: const [
    Row(
      children: [
        SizedBox(width: 8),
        Text(
          'Nombre de Usuario',
          style: TextStyle(color: Colors.black), // Color del texto
        ),
        CircleAvatar(
          backgroundImage: NetworkImage(
              'https://www.example.com/user_image.jpg'), // URL de la imagen del usuario
        ),
        SizedBox(width: 16), // Espacio entre el texto y el borde del AppBar
      ],
    ),
  ],
);


var myDrawer = (BuildContext context) => Drawer(
      backgroundColor: Colors.black,
      elevation: 0,
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(
              Icons.favorite,
              color: Colors.white,
              size: 64,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(
                8.0), // Ajusta el padding según tus necesidades
            child: ListTile(
              leading:
                  const Icon(Icons.desktop_mac_outlined, color: Colors.white),
              title: const Text(
                'Equipos',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/computers');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.settings, color: Colors.white),
              title: const Text(
                'Seguridad',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Define the route and push here
                // Navigator.pushNamed(context, '/security');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.print, color: Colors.white),
              title: const Text(
                'Impresoras',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Define the route and push here
                // Navigator.pushNamed(context, '/printers');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.devices, color: Colors.white),
              title: const Text(
                'Accesorios',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Define the route and push here
                // Navigator.pushNamed(context, '/accessories');
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              leading: const Icon(Icons.assignment, color: Colors.white),
              title: const Text(
                'Asignaciones',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                // Define the route and push here
                // Navigator.pushNamed(context, '/assignments');
              },
            ),
          ),
        ],
      ),
    );
