import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
import 'package:happy_mucher_frontend/pages/loginpage.dart';
import 'package:happy_mucher_frontend/pages/profile.dart';

Future addUsernameDialog(BuildContext context) {
  return showDialog(context: context, builder: (_) => const ChangeUsername());
}

class ChangeUsername extends StatefulWidget {
  const ChangeUsername({Key? key}) : super(key: key);

  @override
  _ChangeUsernameState createState() => _ChangeUsernameState();
}

class _ChangeUsernameState extends State<ChangeUsername> {
  final _formKey = GlobalKey<FormState>();

  var newUsername = "";
  // Create a text controller and use it to retrieve the current value
  // of the TextField.

  final newUsernameController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    newUsernameController.dispose();
    super.dispose();
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  changeUsername() async {
    try {
      await currentUser!.updateDisplayName(newUsername);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Profile()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
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
    return AlertDialog(
      /*appBar: AppBar(
        title: Text('Change Username'),
      ),*/
      key: _formKey,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'New Username: ',
                hintText: 'Enter New Username',
                labelStyle: TextStyle(fontSize: 20.0),
                border: OutlineInputBorder(),
                errorStyle: TextStyle(color: Colors.redAccent, fontSize: 15),
              ),
              controller: newUsernameController,
              /*validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please Enter Username';
                }
                return null;
              },*/
            ),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            // Validate returns true if the form is valid, otherwise false.
            /*if (_formKey.currentState!.validate()) {
                  setState(() {
                    newUsername = newUsernameController.text;
                  });
                  
                }*/
            newUsername = newUsernameController.text;
            changeUsername();
          },
          child: Text(
            'Change',
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ],
    );
  }
}
