import 'package:flutter/material.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';

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
              buildDarkMode(),
              buildLanguage(),
              buildLocation(),
            ])
          ],
        )),
      );

  Widget buildDarkMode() => SwitchSettingsTile(
        settingKey: keyDarkMode,
        leading: Icon(Icons.dark_mode),
        title: 'Dark Mode',
        onChange: (isDarkMode) {/* NOOP */},
      );

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
