import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

import 'package:happy_mucher_frontend/provider/dark_theme_provider.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  static const keyDarkMode = 'key-dark-mode';
  static const keyLocation = 'key-location';
  static const keyLanguage = 'key-language';

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            SettingsGroup(title: 'GENERAL', children: <Widget>[
              buildDarkMode(context),
              buildLanguage(),
              buildLocation(),
            ])
          ],
        )),
      );

  Widget buildDarkMode(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return SwitchSettingsTile(
      settingKey: keyDarkMode,
      leading: Icon(
        Icons.dark_mode,
        color: Colors.deepPurpleAccent,
      ),
      title: 'Dark Mode',
      onChange: (isDarkMode) {
        themeChange.darkTheme = isDarkMode;
        //print(isDarkMode);
      },
    );
  }

  Widget buildLanguage() => DropDownSettingsTile(
        title: 'Language',
        leading: Icon(Icons.language),
        settingKey: keyLanguage,
        selected: 1,
        values: <int, String>{
          1: 'English',
          2: 'Spanish',
          3: 'Chinese',
          4: 'Hindi',
        },
        onChange: (language) {/* NOOP */},
      );

  Widget buildLocation() => TextInputSettingsTile(
        settingKey: keyLocation,
        title: 'Location',
        initialValue: 'South Africa',
        onChange: (location) {/* NOOP */},
      );
}
