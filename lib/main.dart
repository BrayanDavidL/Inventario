import 'package:flutter/material.dart';
import 'package:inventary/responsive/desktop_scaffold.dart';
import 'package:inventary/responsive/mobile_scaffold.dart';
import 'package:inventary/responsive/responsive_layout.dart';
import 'package:inventary/responsive/tablet_scaffold.dart';
import 'package:inventary/screens/computer_responsive_view/computers_view_desktop.dart';

import 'screens/computer_responsive_view/computers_view_mobile.dart';
import 'screens/computer_responsive_view/computers_view_tablet.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => ResponsiveLayout(
          mobileScaffold: const MobileScaffold(),
          tabletScaffold: const TabletScaffold(),
          desktopScaffold: const DesktopScaffold(),
        ),
        '/computers': (context) => ResponsiveLayout_Computer(
          computers_view_mobile: const ComputersViewMobile(),
          computers_view_tablet: const ComputersViewTablet(),
          computers_view_desktop: const ComputersViewDesktop(),
        ),
      },
    );
  }
}