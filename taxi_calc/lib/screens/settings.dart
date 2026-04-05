import 'package:flutter/material.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Product List",
      child: Center(child: Column(children: [const Text("Services Screen")])),
    );
  }
}
