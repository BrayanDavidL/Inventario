import 'package:flutter/material.dart';
import '../constants.dart';
import '../util/my_box.dart';
import '../util/my_tile.dart';

class DesktopScaffold extends StatefulWidget {
  const DesktopScaffold({Key? key}) : super(key: key);

  @override
  State<DesktopScaffold> createState() => _DesktopScaffoldState();
}

class _DesktopScaffoldState extends State<DesktopScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultBackgroundColor,
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
                children: [
                  // AppBar
                  myAppBar(context),

                  // Main content
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          // first half of page
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                // first 4 boxes in grid
                                AspectRatio(
                                  aspectRatio: 4,
                                  child: SizedBox(
                                    width: double.infinity,
                                    child: GridView.builder(
                                      itemCount: 4,
                                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 4),
                                      itemBuilder: (context, index) {
                                        return MyBox();
                                      },
                                    ),
                                  ),
                                ),

                                // list of previous days
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: 7,
                                    itemBuilder: (context, index) {
                                      return const MyTile();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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