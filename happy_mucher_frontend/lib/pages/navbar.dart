import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/pages/budget.dart';
import 'package:happy_mucher_frontend/pages/changemail.dart';
import 'package:happy_mucher_frontend/pages/changepassword.dart';
import 'package:happy_mucher_frontend/pages/changeusername.dart';
import 'package:happy_mucher_frontend/pages/dashboard.dart';
import 'package:happy_mucher_frontend/pages/loginpage.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';
import 'package:happy_mucher_frontend/pages/settings_page.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser?.displayName;
    var profile = FirebaseAuth.instance.currentUser?.photoURL;
    final email = FirebaseAuth.instance.currentUser?.email;
    final creationTime =
        FirebaseAuth.instance.currentUser?.metadata.creationTime;
    if (uid == null) {
      uid = "User";
    }
    if (profile == null) {
      profile ??=
          'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png';
    }
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(uid.toString()),
            accountEmail: Text(email.toString()),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(profile.toString()),
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
              /*image: DecorationImage(
                  opacity: 0.3,
                  fit: BoxFit.fill,
                  image: NetworkImage(profile.toString())),*/
            ),
          ),
          ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () async => {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Profile()))
                  }),
          Divider(),
          ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () async => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage())),
                  }),
          Divider(),
          ListTile(
              key: const ValueKey("Logout"),
              title: Text('Logout'),
              leading: Icon(Icons.exit_to_app),
              onTap: () async => {
                    await FirebaseAuth.instance.signOut(),
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginScreen())),
                  }),
          Divider(),
          ListTile(
              leading: Icon(Icons.dashboard),
              title: Text('Dashboard'),
              onTap: () async => {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardPage())),
                  }),
        ],
      ),
    );
  }
}
