import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
import 'package:happy_mucher_frontend/pages/loginpage.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';
import 'package:happy_mucher_frontend/widgets/appbar_widget.dart';

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final _formKey = GlobalKey<FormState>();
  var newUsername = "";
  final newUsernameController =
      TextEditingController(); // var user = UserData.myUser;

  @override
  void dispose() {
    newUsernameController.dispose();
    super.dispose();
  }

  final FirebaseAuth firebaseAuth = GetIt.I.get();
  User? get currentUser => firebaseAuth.currentUser;

  changeUsername() async {
    try {
      await currentUser!.updateDisplayName(newUsername);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.grey,
            content: Text(
              'Your Username has been Changed',
              style: TextStyle(fontSize: 18.0),
            )),
      );
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context, "Change Username"),
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
                          key: const Key('usernameText'),
                          // Handles Form Validation
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please Enter Username';
                            }
                            return null;
                          },
                          controller: newUsernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                        ))),
                Padding(
                    padding: const EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () async => {
                              newUsername = newUsernameController.text,
                              changeUsername(),
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
