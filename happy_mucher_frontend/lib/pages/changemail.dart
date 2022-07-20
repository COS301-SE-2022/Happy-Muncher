import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/loginpage.dart';

Future addEmailDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => const ChangeEmail());
}

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

  final currentUser = FirebaseAuth.instance.currentUser;

  changeEmail() async {
    try {
      await currentUser!.updateEmail(newEmail);
      FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
    return AlertDialog(
        key: _formKey,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 10.0),
              child: TextFormField(
                autofocus: false,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'New Email: ',
                  hintText: 'Enter New Email',
                  labelStyle: TextStyle(fontSize: 20.0),
                  border: OutlineInputBorder(),
                  errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
                ),
                controller: newEmailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter Email';
                  }
                  return null;
                },
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              // Validate returns true if the form is valid, otherwise false.
              /*if (_formKey.currentState.validate()) {
                  setState(() {});
                }*/
              newEmail = newEmailController.text;
              changeEmail();
            },
            child: Text(
              'Change',
              style: TextStyle(fontSize: 18.0),
            ),
          ),
        ]);
  }
}
