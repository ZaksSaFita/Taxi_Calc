import 'package:flutter/material.dart';
import 'package:taxi_calc/core/localization/app_settings_controller.dart';
import 'package:taxi_calc/core/localization/app_settings_scope.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);
    final settings = AppSettingsScope.of(context);

    return MasterScreen(
      title: strings.settingsTitle,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: ListTile(
            leading: const Icon(Icons.language),
            title: Text(strings.language),
            subtitle: Text(strings.languageHelp),
            trailing: DropdownButton<AppLanguage>(
              value: settings.language,
              onChanged: (value) async {
                if (value == null) {
                  return;
                }
                await settings.setLanguage(value);
              },
              items: AppLanguage.values
                  .map(
                    (lang) => DropdownMenuItem<AppLanguage>(
                      value: lang,
                      child: Text(lang.label),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
