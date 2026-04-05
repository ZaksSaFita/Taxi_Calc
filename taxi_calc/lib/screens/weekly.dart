import 'package:flutter/material.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Weekly Earnings',
      showBackButton: true,
      child: Center(child: Text('Weekly Screen')),
    );
  }
}
