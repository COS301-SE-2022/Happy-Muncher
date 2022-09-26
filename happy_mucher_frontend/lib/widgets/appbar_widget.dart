import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';

AppBar buildAppBar(BuildContext context, String title) {
  final FirebaseAuth firebaseAuth = GetIt.I.get();

  var profile = firebaseAuth.currentUser?.photoURL;
  profile ??=
      'https://blogifs.azureedge.net/wp-content/uploads/2019/03/Guest_Blogger_v1.png';

  return AppBar(
      title: Text(
        title,
        //style: TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      backgroundColor: Colors.transparent,
      leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            key: const Key('Profile'),
            radius: 100,
            backgroundColor: const Color.fromARGB(255, 150, 66, 154),
            child: CircleAvatar(
                backgroundImage: NetworkImage(profile),
                radius: 50,
                child: InkWell(onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Profile()));
                })),
          )),
      actions: <Widget>[
        Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DashboardPage()));
              },
              child: const Icon(
                Icons.dashboard,
                size: 26.0,
              ),
            ))
      ]);
}
