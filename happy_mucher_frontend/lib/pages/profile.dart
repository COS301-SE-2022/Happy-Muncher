import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/changemail.dart';
import 'package:happy_mucher_frontend/pages/changepassword.dart';
import 'package:happy_mucher_frontend/pages/changeprofile.dart';
import 'package:happy_mucher_frontend/pages/changeusername.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);
  static const routeName = '/profile';
  @override
  State<Profile> createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  final uid = FirebaseAuth.instance.currentUser!.uid;
  final email = FirebaseAuth.instance.currentUser!.email;
  final creationTime = FirebaseAuth.instance.currentUser!.metadata.creationTime;

  User? user = FirebaseAuth.instance.currentUser;

  verifyEmail() async {
    print(uid);
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
    return Scaffold(
      //appBar: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      appBar: AppBar(
        title: Text('Profile'),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[Text('Home'), Icon(Icons.home)],
            ),
            textColor: Colors.white,
            onPressed: () async => {
              Navigator.of(context).pushReplacementNamed(MyHomePage.routeName)
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            CircleAvatar(
              radius: 100,
              backgroundImage: NetworkImage(profile.toString()),
            ),
            /*BoxDecoration(
              color: Colors.grey,
              /*image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      'https://oflutter.com/wp-content/uploads/2021/02/profile-bg3.jpg')),*/
            ),*/
            TextButton.icon(
                onPressed: () async => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangeProfile()))
                    },
                icon: Icon(Icons.edit),
                label: Text('')),
            SizedBox(height: 60),
            Row(
              children: [
                Text(
                  'Username: $uid',
                  style: TextStyle(fontSize: 25.0),
                ),
                TextButton.icon(
                    onPressed: () => addUsernameDialog(context),
                    icon: Icon(Icons.edit),
                    label: Text(''))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 25.0),
                ),
                user!.emailVerified
                    ? Text(
                        '  verified',
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                      )
                    : TextButton(
                        onPressed: () => {verifyEmail()},
                        child: Text('  Verify Email')),
                TextButton.icon(
                    onPressed: () => addEmailDialog(context),
                    icon: Icon(Icons.edit),
                    label: Text(''))
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            SizedBox(height: 30),
            TextButton.icon(
                onPressed: () async => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()))
                    },
                label:
                    Text('Change Password', style: TextStyle(fontSize: 25.0)),
                icon: Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }
}
