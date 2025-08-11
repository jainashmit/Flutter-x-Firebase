import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfirebase/Home.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = '', username = '', pass = '';
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  registration(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Registered Successfully',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
    );
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => MyHomePage()));
    }on FirebaseAuthException catch(e){
      if(e.code == 'weak-password'){
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Provided Password is weak',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
    );
      }else if(e.code == 'email-already-in-use'){
        ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Email Already exixts. Please Sign-in',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
      ),
    );
      }else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.message ?? 'SignUp failed',
              style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ));
      }

      }
    }
  

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    'Hello, Welcome',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'SignUp To Continue',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Spacer(),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        username = value;
                      });
                    },
                    controller: usernameController,
                    decoration: InputDecoration(
                      hintText: 'Username',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'E-mail',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    onChanged: (value) {
                      setState(() {
                        pass = value;
                      });
                    },
                    controller: passController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      fillColor: Colors.white,
                      filled: true,
                    ),
                  ),

                  SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      if (email == '' || pass == '' || username == '') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Fill all fields')),
                        );
                      } else {
                        registration(email, pass);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      backgroundColor: Colors.white,
                    ),
                    child: Text(
                      'SignUp',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  Spacer(),
                  Text(
                    'Or sign up with',
                    style: TextStyle(color: Colors.white),
                  ),

                  SizedBox(height: 16),

                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/img/Google.png',
                              height: 22,
                              width: 22,
                            ),
                            SizedBox(width: 8),
                            Text('Sign up with Google'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  SizedBox(
                    height: 48,
                    width: double.infinity,
                    child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/img/Facebook.png',
                              height: 22,
                              width: 22,
                            ),
                            SizedBox(width: 8),
                            Text('Sign up with Facebook'),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have account ?',
                        style: TextStyle(color: Colors.white),
                      ),

                      SizedBox(),

                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          'Sign in ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
