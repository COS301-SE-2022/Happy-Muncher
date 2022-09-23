import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/loginpage.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';
import 'package:happy_mucher_frontend/pages/changemail.dart';
import 'package:happy_mucher_frontend/pages/changepassword.dart';
import 'package:happy_mucher_frontend/pages/changeprofile.dart';
import 'package:happy_mucher_frontend/pages/changeusername.dart';
import 'package:happy_mucher_frontend/pages/display_image_widget.dart';
import 'package:happy_mucher_frontend/pages/settings_page.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const routeName = '/profile';
  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async {
    //print(uid);
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification Email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
            'Verification Email has been sent',
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var uid = FirebaseAuth.instance.currentUser?.displayName;
    var profile = FirebaseAuth.instance.currentUser?.photoURL;
    var email = FirebaseAuth.instance.currentUser?.email;
    final creationTime =
        FirebaseAuth.instance.currentUser?.metadata.creationTime;
    if (uid == null) {
      uid = "User";
    }
    if (profile == null) {
      profile ??=
          'https://www.seekpng.com/png/detail/115-1150053_avatar-png-transparent-png-royalty-free-default-user.png';
    }

    return Scaffold(
      appBar: buildAppBar(context, "Profile"),
      body: Column(
        children: [
          InkWell(
              onTap: () {
                navigateSecondPage(ChangeProfile());
              },
              child: DisplayImage(
                imagePath: profile,
                onPressed: () {},
              )),
          SizedBox(height: 40),
          buildUserInfoDisplay(uid, Icons.person, ChangeUsername()),
          buildUserInfoDisplay(email.toString(), Icons.email, ChangeEmail()),
          buildUserInfoDisplay('Change Password', Icons.lock, ChangePassword()),
          buildUserInfoDisplay('Settings', Icons.settings, SettingsPage()),
          ElevatedButton(
            onPressed: () async => {
              await FirebaseAuth.instance.signOut(),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen())),
            },
            child: const Text(
              'Log out',
              style: TextStyle(fontSize: 15),
            ),
            style: ElevatedButton.styleFrom(
                primary: Colors.white,
                shape: StadiumBorder(),
                onPrimary: Colors.black),
          ),

          /*Expanded(
            child: buildAbout(user),
            flex: 4,
          )*/
        ],
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildUserInfoDisplay(String getValue, IconData t, Widget editPage) =>
      Padding(
          padding: EdgeInsets.only(bottom: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [
                SizedBox(
                  width: 20,
                ),
                Icon(
                  t,
                  color: Colors.grey,
                ),
                SizedBox(
                  height: 1,
                ),
                Container(
                    width: 350,
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ))),
                    child: Row(children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                navigateSecondPage(editPage);
                              },
                              child: Text(
                                getValue,
                                style: TextStyle(
                                    fontSize: 20,
                                    height: 1.4,
                                    color: Colors.black),
                              ))),
                      Icon(
                        Icons.keyboard_arrow_right,
                        color: Colors.grey,
                        size: 30.0,
                      )
                    ]))
              ])
            ],
          ));

  // Widget builds the About Me Section
  /*Widget buildAbout(User user) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tell Us About Yourself',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 1),
          Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
              child: Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          navigateSecondPage(EditDescriptionFormPage());
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  user.aboutMeDescription,
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ))))),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
                )
              ]))
        ],
      ));*/

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }
}
