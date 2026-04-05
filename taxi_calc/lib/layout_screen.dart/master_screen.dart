import 'package:flutter/material.dart';
import 'package:taxi_calc/core/localization/app_strings.dart';
import 'package:taxi_calc/screens/documents.dart';
import 'package:taxi_calc/screens/home.dart';
import 'package:taxi_calc/screens/services.dart';
import 'package:taxi_calc/screens/settings.dart';

class MasterScreen extends StatefulWidget {
  const MasterScreen({
    super.key,
    required this.child,
    required this.title,
    this.showBackButton = false,
  });
  final Widget child;
  final String title;
  final bool showBackButton;

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isDrawerOpen = false;

  void _toggleDrawer() {
    if (_isDrawerOpen) {
      Navigator.of(context).pop();
      return;
    }

    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings.of(context);

    return Scaffold(
      key: _scaffoldKey,
      onDrawerChanged: (isOpen) {
        setState(() {
          _isDrawerOpen = isOpen;
        });
      },
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(
            widget.showBackButton
                ? Icons.arrow_back
                : (_isDrawerOpen ? Icons.close : Icons.menu),
          ),
          onPressed: () {
            if (widget.showBackButton) {
              if (Navigator.of(context).canPop()) {
                Navigator.of(context).pop();
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                );
              }
              return;
            }
            _toggleDrawer();
          },
        ),
      ),
      drawer: widget.showBackButton
          ? null
          : Drawer(
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.close),
                    title: Text(strings.menuClose),
                    onTap: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: Text(strings.menuHome),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomeScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.build),
                    title: Text(strings.menuServices),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ServicesScreen(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.description),
                    title: Text(strings.menuDocuments),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => DocsScreen()),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.settings),
                    title: Text(strings.menuSettings),
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
      body: widget.child,
    );
  }
}
