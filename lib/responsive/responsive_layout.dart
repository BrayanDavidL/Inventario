import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileScaffold;
  final Widget tabletScaffold;
  final Widget desktopScaffold;
  
  const ResponsiveLayout({
   required this.mobileScaffold,
   required this.tabletScaffold,
   required this.desktopScaffold,
});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 500) {
            return mobileScaffold;
          } else if (constraints.maxWidth < 1100){
            return tabletScaffold;
          } else {
            return desktopScaffold;
          }
        }
    );
  }
}

class ResponsiveLayout_Computer extends StatelessWidget {
  final Widget computers_view_desktop;
  final Widget computers_view_mobile;
  final Widget computers_view_tablet;


  ResponsiveLayout_Computer({
    required this.computers_view_desktop,
    required this.computers_view_mobile,
    required this.computers_view_tablet,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 500) {
            return computers_view_mobile;
          } else if (constraints.maxWidth < 1100){
            return computers_view_tablet;
          } else {
            return computers_view_desktop;
          }
        }
    );
  }
}
