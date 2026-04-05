import 'package:flutter/material.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class WeeklyScreen extends StatelessWidget {
  const WeeklyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return MasterScreen(
      title: strings.weeklyTitle,
      showBackButton: true,
      child: Center(child: Text(strings.weeklyScreenPlaceholder)),
    );
  }
}
