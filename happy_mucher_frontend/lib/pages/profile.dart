import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
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
  final FirebaseAuth firebaseAuth = GetIt.I.get();

  User? get user => firebaseAuth.currentUser;

  verifyEmail() async {
    //print(uid);
    if (user != null && !user!.emailVerified) {
      await user!.sendEmailVerification();
      print('Verification Email has been sent');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
    var uid = user?.displayName;
    var profile = user?.photoURL;
    var email = user?.email;
    final creationTime = user?.metadata.creationTime;
    if (uid == null) {
      uid = "User";
    }
    if (profile == null) {
      profile ??=
          'https://blogifs.azureedge.net/wp-content/uploads/2019/03/Guest_Blogger_v1.png';
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
              await firebaseAuth.signOut(),
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginScreen())),
            },
            child: const Text(
              "Log out",
              style: TextStyle(fontSize: 20),
            ),
            style: ElevatedButton.styleFrom(
              minimumSize: Size(150, 50),
              shape: const StadiumBorder(),
              onPrimary: const Color.fromARGB(255, 150, 66, 154),
              side: BorderSide(
                  color: const Color.fromARGB(255, 150, 66, 154), width: 3.0),
            ),
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
                Icon(t, color: Color.fromARGB(255, 150, 66, 154)),
                SizedBox(
                  height: 1,
                ),
                Expanded(
                  child: Container(
                      width: 350,
                      height: 60,
                      decoration: BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                        color: Color.fromARGB(255, 150, 66, 154),
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
                                    fontSize: 18,
                                    height: 1.4,
                                  ),
                                ))),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.keyboard_arrow_right,
                            color: Color.fromARGB(255, 150, 66, 154),
                            size: 30.0,
                          ),
                        )
                      ])),
                )
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
