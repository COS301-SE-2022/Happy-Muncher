import 'dart:async';

import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/dashboard.dart';
import 'package:happy_mucher_frontend/pages/forgotpassword.dart';
import 'package:provider/provider.dart';

import 'signuppage.dart';
import '../models/authentication.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  Map<String, String> _authData = {'email': '', 'password': ''};

  void _showErrorDialog(String msg) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('An Error Occured'),
              content: Text(msg),
              actions: <Widget>[
                TextButton(
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
      /*print(_authData['email']!);
      print(_authData['password']!);*/
      await Provider.of<Authentication>(context, listen: false)
          .logIn(_authData['email']!, _authData['password']!);

      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _authData['email']!, password: _authData['password']!);

      Timer(Duration(seconds: 2), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => DashboardPage()));
      });
    } catch (error) {
      var errorMessage = 'Authentication Failed. Invalid email or password.';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(height: size.height * 0.03),
          Center(
            /*child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
*/
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      //email
                      SizedBox(height: size.height * 0.03),
                      TextFormField(
                        key: const Key("Email"),
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                          labelText: 'Email',
                        ),
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
                        key: const Key("Password"),
                        style: const TextStyle(fontSize: 20),
                        decoration:
                            const InputDecoration(labelText: 'Password'),
                        obscureText: true,
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            style: TextButton.styleFrom(
                              primary: Color.fromARGB(255, 150, 66, 154),
                            ),
                            child: Text('Forgot Password?'),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                            ),
                          ),
                        ],
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
                            'Log In',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                        onPressed: () async {
                          _submit();
                        },
                      ),
                      SizedBox(height: size.height * 0.02),
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

                      SizedBox(height: size.height * 0.02),
                      ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            minimumSize: const Size(300, 50),
                            onPrimary: const Color.fromARGB(255, 150, 66, 154),
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
                          label: const Text(
                            "Log in with Google",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 20),
                          )),

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
                                        builder: (context) => SignupScreen()),
                                  ),
                              child: const Text(
                                  "Don't have an account? Sign up here"))
                        ],
                      )

                      /*ElevatedButton(
                        onPressed: () {
                          signup(context);
                        },
                        child: Image.asset('assets/images/google_logo.png'),
                      ),*/

                      //GoogleSignupButtonWidget(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //         Container(
          //           width: double.infinity,
          //           height: size.height,
          //           child: Stack(
          //             alignment: Alignment.center,
          //             children: <Widget>[
          //               Positioned(
          //                 top: 0,
          //                 right: 0,
          //                 child:
          //                     Image.asset("assets/images/top1.png", width: size.width),
          //               ),
          //               Positioned(
          //                 top: 0,
          //                 right: 0,
          //                 child: Image.asset("assets/images/top2.png",
          //                     width: size.width, height: 330),
          //               ),
          //               SizedBox(height: size.height * 0.03),
          //               Positioned(
          //                 bottom: 0,
          //                 right: 0,
          //                 child: Image.asset("assets/images/bottom1.png",
          //                     width: size.width, height: 300),
          //               ),
          //               Positioned(
          //                 bottom: 0,
          //                 right: 0,
          //                 child: Image.asset("assets/images/bottom2.png",
          //                     width: size.width),
          //               ),
          //             ],
          //           ),
          //         ),
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

  /* Widget buildSignUp() => Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              final provider = Provider.of<GoogleSignInProvider>(context);
              if (provider.isSigningIn) {
                return buildLoading();
              } else if (snapshot.hasData) {
                return MyHomePage();
              } else {
                return SignUpWidget();
              }
            },
          ),
        ),
      );*/
  /*Widget buildLoading() => Stack(
        fit: StackFit.expand,
        children: [
          //CustomPaint(painter: BackgroundPainter()),
          Center(child: CircularProgressIndicator()),
        ],
      );*/
}
