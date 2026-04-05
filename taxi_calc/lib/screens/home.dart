import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:taxi_calc/layout_screen.dart/master_screen.dart';
import 'package:taxi_calc/screens/daily.dart';
import 'package:taxi_calc/screens/monthly.dart';
import 'package:taxi_calc/screens/weekly.dart';
import 'package:taxi_calc/widgets/animated_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MasterScreen(
      title: "Earnings Calculator",
      child: Center(
        child: GridView(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
          ),
          children: [
            AnimatedCard(
              title: 'Daily',
              color: const Color(0xFF5B8DEF),
              icon: Icons.today,
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => DailyScreen())),
            ),
            AnimatedCard(
              title: 'Weekly',
              color: const Color(0xFF6FCF97),
              icon: Icons.date_range,
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => WeeklyScreen())),
            ),
            AnimatedCard(
              title: 'Monthly',
              color: const Color(0xFFF2A65A),
              icon: Icons.calendar_month,
              onTap: () => Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => MonthlyScreen())),
            ),
          ],
        ),
      ),
    );
  }
}
