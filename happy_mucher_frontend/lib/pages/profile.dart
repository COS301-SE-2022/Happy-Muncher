import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/changemail.dart';
import 'package:happy_mucher_frontend/pages/changepassword.dart';
import 'package:happy_mucher_frontend/pages/changeusername.dart';

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
    final uid = FirebaseAuth.instance.currentUser?.displayName;

    final email = FirebaseAuth.instance.currentUser?.email;
    final creationTime =
        FirebaseAuth.instance.currentUser?.metadata.creationTime;
    /*if (uid == null) {
      uid = FirebaseAuth.instance.currentUser!.uid;
    }*/
    return Scaffold(
      //appBar: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            CircleAvatar(
              radius: 80,
              child: Icon(Icons.person),
            ),
            SizedBox(height: 60),
            Row(children: [
              Text(
                'Username: $uid',
                style: TextStyle(fontSize: 18.0),
              ),
              TextButton.icon(
                  onPressed: () async => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChangeUsername()))
                      },
                  icon: Icon(Icons.edit),
                  label: Text(''))
            ]),
            Row(
              children: [
                Text(
                  'Email: $email',
                  style: TextStyle(fontSize: 18.0),
                ),
                user!.emailVerified
                    ? Text(
                        'verified',
                        style:
                            TextStyle(fontSize: 18.0, color: Colors.blueGrey),
                      )
                    : TextButton(
                        onPressed: () => {verifyEmail()},
                        child: Text('Verify Email')),
                TextButton.icon(
                    onPressed: () async => {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChangeEmail()))
                        },
                    icon: Icon(Icons.edit),
                    label: Text(''))
              ],
            ),
            TextButton.icon(
                onPressed: () async => {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChangePassword()))
                    },
                label: Text('Change Password'),
                icon: Icon(Icons.edit)),
          ],
        ),
      ),
    );
  }
}
