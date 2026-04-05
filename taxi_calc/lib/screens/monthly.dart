import 'package:flutter/material.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class MonthlyScreen extends StatelessWidget {
  const MonthlyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MasterScreen(
      title: 'Monthly Earnings',
      showBackButton: true,
      child: Center(child: Text('Monthly Screen')),
    );
  }
}
