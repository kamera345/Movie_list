import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'home_screen.dart';
import 'login_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  String password1 = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/back.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Heading of the page
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          // Creating the TextFields to take the user
                          // input in order to make the user regristation

                          //This is to enter the email address of the user
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: TextField(
                              onChanged: (value) {
                                email = value;
                              },
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  size: 20.0,
                                ),
                                filled: true,
                                fillColor: Colors.black12,
                                hintText: 'Enter Email Address',
                              ),
                            ),
                          ),
                          // This is to enter the password
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: TextField(
                              onChanged: (value) {
                                password = value;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.enhanced_encryption,
                                  size: 20.0,
                                ),
                                suffixIcon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                filled: true,
                                fillColor: Colors.black12,
                                hintText: 'Enter Password',
                              ),
                            ),
                          ),
                          // This is to confirm the password
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: TextField(
                              onChanged: (value) {
                                password1 = value;
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.enhanced_encryption,
                                  size: 20.0,
                                ),
                                suffixIcon: Icon(
                                  Icons.remove_red_eye_outlined,
                                  color: Colors.white,
                                  size: 20.0,
                                ),
                                filled: true,
                                fillColor: Colors.black12,
                                hintText: 'Confirm Password',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () async {
                                final progress = ProgressHUD.of(context);
                                setState(() {
                                  progress!.show();
                                });

                                if (password == password1) {
                                  try {
                                    final user = await _firebaseAuth
                                        .createUserWithEmailAndPassword(
                                            email: email, password: password);
                                    if (user != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
                                      );
                                      setState(() {
                                        progress!.dismiss();
                                      });
                                    }
                                  } catch (e) {}
                                } else {}
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      'Sign Up',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 20.0),
                                child: Text('Already a user ?'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginScreen()),
                                  );
                                },
                                child: Text(
                                  'Sign In',
                                  style: TextStyle(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.all(0.0),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
