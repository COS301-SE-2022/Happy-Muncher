import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';

AppBar buildAppBar(BuildContext context, String title) {
  var profile = FirebaseAuth.instance.currentUser?.photoURL;
  if (profile == null) {
    profile ??=
        'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png';
  }
  ;

  return AppBar(
      title: new Text(
        title,
        style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: new Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            key: Key('Profile'),
            radius: 100,
            backgroundColor: Color(0xFF965BC8),
            child: CircleAvatar(
                backgroundImage: NetworkImage(profile) as ImageProvider,
                radius: 50,
                child: InkWell(onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Profile()));
                })),
          )),
      actions: <Widget>[
        Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DashboardPage()));
              },
              child: Icon(
                Icons.dashboard,
                size: 26.0,
                color: Colors.black,
              ),
            ))
      ]);
}
