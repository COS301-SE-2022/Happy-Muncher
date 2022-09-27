import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'homepage.dart';
import 'loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:happy_mucher_frontend/pages/dashboard.dart';

class SignupScreen extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _passwordController = new TextEditingController();

  Map<String, String> _authData = {'email': '', 'password': ''};

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured'),
              content: Text(msg),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )
              ],
            ));
  }

  Future<void> _submit() async {
    const CircularProgressIndicator();
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
//      print(FirebaseAuth.instance.currentUser!.uid);

      //final uid = FirebaseAuth.instance.currentUser!.uid;

      await Provider.of<Authentication>(context, listen: false)
          .signUp(_authData['email']!, _authData['password']!);
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _authData['email']!, password: _authData['password']!);

      Timer(Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      });
    } catch (error) {
      var errorMessage = 'Authentication Failed. Please try again later.';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(height: size.height * 0.05),
          Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //email
                      TextFormField(
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty || !value.contains('@')) {
                            return 'invalid email';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['email'] = value!;
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      //password
                      TextFormField(
                        key: const ValueKey("Email"),
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(labelText: 'Password'),
                        obscureText: true,
                        controller: _passwordController,
                        validator: (value) {
                          if (value!.isEmpty || value.length <= 5) {
                            return 'invalid password';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _authData['password'] = value!;
                        },
                      ),
                      SizedBox(height: size.height * 0.03),
                      //Confirm Password
                      TextFormField(
                        key: const ValueKey("Confirm Password"),
                        style: TextStyle(fontSize: 20),
                        decoration:
                            InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty ||
                              value != _passwordController.text) {
                            return 'invalid password';
                          }
                          return null;
                        },
                        onSaved: (value) {},
                      ),
                      SizedBox(height: size.height * 0.03),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: const Color.fromARGB(255, 150, 66, 154),
                          shape: const StadiumBorder(),
                          minimumSize: const Size(300, 50),
                          onPrimary: Colors.white,
                          side: const BorderSide(
                              color: Color.fromARGB(255, 150, 66, 154),
                              width: 3.0),
                        ),
                        key: const ValueKey("Submit"),
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: size.width * 0.5,
                          child: const Text(
                            'Sign up',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        onPressed: () {
                          _submit();
                        },
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      //Text("Sign in with Google"),
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 10),
                        child: const Text(
                          "OR",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 150, 66, 154)),
                        ),
                      ),
                      //Text("Sign in with Google"),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: StadiumBorder(),
                            minimumSize: Size(300, 50),
                            onPrimary: Color.fromARGB(255, 150, 66, 154),
                            side: const BorderSide(
                                color: Color.fromARGB(255, 150, 66, 154),
                                width: 3.0),
                          ),
                          onPressed: () {
                            signup(context);
                          },
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            height: 30,
                            width: 30,
                          ),
                          label: const Text("Sign in with Google",
                              style: TextStyle(fontSize: 20))),

                      SizedBox(height: size.height * 0.03),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                              style: TextButton.styleFrom(
                                primary:
                                    const Color.fromARGB(255, 150, 66, 154),
                              ),
                              onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  ),
                              child: const Text(
                                  "Already have an account? Log in here"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Container(
          //   width: double.infinity,
          //   height: size.height,
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: <Widget>[
          //       Positioned(
          //         top: 0,
          //         right: 0,
          //         child:
          //             Image.asset("assets/images/top1.png", width: size.width),
          //       ),
          //       Positioned(
          //         top: 0,
          //         right: 0,
          //         child: Image.asset("assets/images/top2.png",
          //             width: size.width, height: 330),
          //       ),
          //       Positioned(
          //         bottom: 0,
          //         right: 0,
          //         child: Image.asset("assets/images/bottom1.png",
          //             width: size.width, height: 300),
          //       ),
          //       Positioned(
          //         bottom: 0,
          //         right: 0,
          //         child: Image.asset("assets/images/bottom2.png",
          //             width: size.width),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<void> signup(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      final AuthCredential authCredential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      // Getting users credential
      UserCredential result = await auth.signInWithCredential(authCredential);
      User user = result.user!;

      if (result != null) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      } // if result not null we simply call the MaterialpageRoute,
      // for go to the HomePage screen
    }
  }
}
