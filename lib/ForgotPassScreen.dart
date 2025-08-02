import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String email = '';
  TextEditingController emailController = TextEditingController();

  reset(String email) async {
    try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Password Reset link sent to email' , style: TextStyle(color: Colors.white),) , backgroundColor: Colors.blue,));
      Navigator.of(context).pop();
    }on FirebaseAuthException catch(e){
      if(e.code == 'user-not-found'){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Check your email or SignUp with this email' , style: TextStyle(color: Colors.white),) , backgroundColor: Colors.blue,));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.message ?? 'Check your email or SignUp with this email' , style: TextStyle(color: Colors.white),) , backgroundColor: Colors.blue,));
      }
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: BackButton(color: Colors.white,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            Text(
              'Reset Password',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Enter your email to send Password reset link',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16,),
            TextField(
              controller: emailController,
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'E-mail',
                fillColor: Colors.white,
                filled: true,
              ),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (email == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Enter your email to send Reset Link',
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  print('Not working');
                } else {
                  print('Working===========================');
                  reset(email);
                }
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: Colors.white,
              ),
              child: Text('Send', style: TextStyle(color: Colors.black)),
            ),
            
          ],
        ),
      ),
    );
  }
}
