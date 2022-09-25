import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:happy_mucher_frontend/provider/dark_theme_provider.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const keyDarkMode = 'key-dark-mode';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: buildAppBar(context, "Settings"),
        body: SafeArea(
            child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            SettingsGroup(title: 'GENERAL', children: <Widget>[
              buildDarkMode(context),
            ])
          ],
        )),
      );

  Widget buildDarkMode(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SwitchSettingsTile(
      settingKey: keyDarkMode,
      leading: const Icon(
        Icons.dark_mode,
        color: Color.fromARGB(255, 150, 66, 154),
      ),
      title: 'Dark Mode',
      onChange: (isDarkMode) {
        themeChange.darkTheme = isDarkMode;
        //print(isDarkMode);
      },
    );
  }
}
