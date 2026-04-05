import 'package:flutter/material.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class DailyScreen extends StatelessWidget {
  const DailyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Daily Earnings',
      showBackButton: true,
      child: Center(child: Text('Daily Screen')),
    );
  }
}
