import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
import 'package:happy_mucher_frontend/pages/loginpage.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';

class ChangeEmail extends StatefulWidget {
  const ChangeEmail({Key? key}) : super(key: key);

  @override
  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {
  final _formKey = GlobalKey<FormState>();

  var newEmail = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final newEmailController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newEmailController.dispose();
    super.dispose();
  }

  final FirebaseAuth firebaseAuth = GetIt.I.get();

  User? get currentUser => firebaseAuth.currentUser;
  changeEmail() async {
    try {
      await currentUser!.updateEmail(newEmail);
      firebaseAuth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.grey,
          content: Text(
            'Your Email has been Changed. Login again!',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context, "Change Email"),
        body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  width: 320,
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          key: const Key('emailText'),
                          // Handles Form Validation
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Email';
                            }
                            return null;
                          },
                          controller: newEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                          ),
                        ))),
                Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          key: const Key('emailButton'),
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async => {
                              newEmail = newEmailController.text,
                              changeEmail(),
                            },
                            child: const Text(
                              'Change',
                              style: TextStyle(fontSize: 20),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(150, 50),
                              shape: const StadiumBorder(),
                              onPrimary:
                                  const Color.fromARGB(255, 150, 66, 154),
                              side: BorderSide(
                                  color:
                                      const Color.fromARGB(255, 150, 66, 154),
                                  width: 3.0),
                            ),
                          ),
                        )))
              ]),
        ));
  }
}
