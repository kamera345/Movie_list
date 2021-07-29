import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  //const String name = 'Login_page';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String email = '';
  String password = '';
  bool value = true;
  Future? checkIfLoggedIn;

  void check() async {
    if (await FirebaseAuth.instance.currentUser! != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {}
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProgressHUD(
        child: Builder(
          builder: (context) => Container(
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
                //This is the card which contains all the required fields
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Card(
                    elevation: 5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black54,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          //Heaing of the page
                          Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.0,
                              ),
                            ),
                          ),
                          // Creating the TextFields to take the user
                          // input in order to make the user login
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
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: TextField(
                              onChanged: (value) {
                                password = value;
                              },
                              obscureText: value,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.enhanced_encryption,
                                  size: 20.0,
                                ),
                                suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      value = false;
                                    });
                                  },
                                  child: Icon(
                                    Icons.remove_red_eye_outlined,
                                    color: Colors.white,
                                    size: 20.0,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.black12,
                                hintText: 'Enter Password',
                              ),
                            ),
                          ),

                          // This is the sign in button to let the user in
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            child: GestureDetector(
                              onTap: () async {
                                final progress = ProgressHUD.of(context);
                                setState(() {
                                  progress!.show();
                                });

                                if (email != null && password != null) {
                                  try {
                                    final user = await _firebaseAuth
                                        .signInWithEmailAndPassword(
                                            email: email, password: password);
                                    if (user != null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomeScreen()),
                                      );
                                    }

                                    setState(() {
                                      progress!.dismiss();
                                    });
                                  } catch (e) {}
                                } else if (email == null && password == null) {
                                  setState(() {
                                    progress!.dismiss();
                                  });
                                }
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
                                      'Sign In',
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

                          Padding(
                            padding: EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text('New to MyMovies ?'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUpScreen()),
                                    );
                                  },
                                  child: Text(
                                    'Sign Up',
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
