import 'package:flutter/material.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    return MasterScreen(
      title: strings.documentsTitle,
      child: Center(child: Text(strings.documentsScreenPlaceholder)),
    );
  }
}
