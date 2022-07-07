import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/pages/changemail.dart';
import 'package:happy_mucher_frontend/pages/changepassword.dart';
import 'package:happy_mucher_frontend/pages/changeusername.dart';
import 'package:happy_mucher_frontend/pages/loginpage.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';
import 'package:happy_mucher_frontend/pages/settings_page.dart';

class NavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.displayName;

    final email = FirebaseAuth.instance.currentUser?.email;
    final creationTime =
        FirebaseAuth.instance.currentUser?.metadata.creationTime;
    /*if (uid == null) {
      uid = FirebaseAuth.instance.currentUser!.uid;
    }*/
    return Drawer(
      child: ListView(
        // Remove padding
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(uid.toString()),
            accountEmail: Text(email.toString()),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
              backgroundColor: Colors.white,
            ),
            decoration: BoxDecoration(
              color: Colors.grey,
              /*image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),*/
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
              title: Text('Logout'),
              leading: Icon(Icons.exit_to_app),
              onTap: () async => {
                    await FirebaseAuth.instance.signOut(),
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName)
                  }),
        ],
      ),
    );
  }
}
