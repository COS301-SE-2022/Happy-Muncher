import 'package:flutter/material.dart';
import 'package:happy_mucher_frontend/pages/forgotpassword.dart';
import 'package:provider/provider.dart';

import 'signuppage.dart';
import '../models/authentication.dart';
import 'package:happy_mucher_frontend/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    try {
      print(_authData['email']!);
      print(_authData['password']!);
      await Provider.of<Authentication>(context, listen: false)
          .logIn(_authData['email']!, _authData['password']!);
      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _authData['email']!, password: _authData['password']!);

      Navigator.of(context).pushReplacementNamed(MyHomePage.routeName);
    } catch (error) {
      var errorMessage = 'Authentication Failed. Invalid email or password.';
      _showErrorDialog(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[Text('Signup'), Icon(Icons.person_add)],
            ),
            textColor: Colors.white,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => SignupScreen()),
            ),
          )
        ],
      ),
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
                        style: TextStyle(fontSize: 25),
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
                        style: TextStyle(fontSize: 25),
                        decoration: InputDecoration(labelText: 'Password'),
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
                            child: Text('Forgot Password?'),
                            onPressed: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ForgotPassword()),
                            ),
                          )
                        ],
                      ),

                      SizedBox(height: size.height * 0.03),
                      RaisedButton(
                        child: Container(
                          alignment: Alignment.center,
                          height: 50.0,
                          width: size.width * 0.5,
                          decoration: new BoxDecoration(
                              borderRadius: BorderRadius.circular(80.0),
                              gradient: new LinearGradient(colors: [
                                Color.fromARGB(255, 255, 136, 34),
                                Color.fromARGB(255, 255, 177, 41)
                              ])),
                          padding: const EdgeInsets.all(0),
                          child: Text(
                            'Submit',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        onPressed: () {
                          _submit();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(80),
                        ),
                        color: Colors.blue,
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(0),
                      ),
                      ElevatedButton(
                          child: Text('Home'),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyHomePage()));
                          }),
                      //SizedBox(height: 30, width: 80),
                      /*Container(
                        height: 30.0,
                        width: 30.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image:
                                  AssetImage('assets/images/google_logo.png'),
                              fit: BoxFit.cover),
                          shape: BoxShape.circle,
                        ),
                      ),*/
                      SizedBox(
                        width: 20,
                      ),
                      //Text("Sign in with Google"),
                      TextButton.icon(
                          onPressed: () {
                            signup(context);
                          },
                          icon: Image.asset(
                            'assets/images/google_logo.png',
                            height: 50,
                            width: 50,
                          ),
                          label: Text(
                            "Sign in with Google",
                            style: TextStyle(fontSize: 20),
                          )),

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
          Container(
            width: double.infinity,
            height: size.height,
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                Positioned(
                  top: 0,
                  right: 0,
                  child:
                      Image.asset("assets/images/top1.png", width: size.width),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Image.asset("assets/images/top2.png",
                      width: size.width, height: 330),
                ),
                SizedBox(height: size.height * 0.03),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset("assets/images/bottom1.png",
                      width: size.width, height: 300),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image.asset("assets/images/bottom2.png",
                      width: size.width),
                ),
              ],
            ),
          ),
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
            context, MaterialPageRoute(builder: (context) => MyHomePage()));
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
