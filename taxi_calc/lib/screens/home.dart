import 'package:flutter/material.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';
import 'package:taxi_calc/screens/add_entry.dart';
import 'package:taxi_calc/screens/daily.dart';
import 'package:taxi_calc/screens/monthly.dart';
import 'package:taxi_calc/screens/yearly.dart';
import 'package:taxi_calc/widgets/animated_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return MasterScreen(
      title: strings.homeTitle,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.08,
          children: [
            AnimatedCard(
              title: strings.daily,
              color: const Color(0xFF3A7DFF),
              icon: Icons.today,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const DailyScreen()),
              ),
            ),
            AnimatedCard(
              title: strings.monthly,
              color: const Color(0xFFF28A2E),
              icon: Icons.calendar_month,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MonthlyScreen()),
              ),
            ),
            AnimatedCard(
              title: strings.yearly,
              color: const Color(0xFF21A67A),
              icon: Icons.insights_outlined,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const YearlyScreen()),
              ),
            ),
            AnimatedCard(
              title: strings.addEntry,
              color: const Color(0xFFE35D5D),
              icon: Icons.post_add,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const AddEntryScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
