import 'package:flutter/material.dart';
import 'package:carpoolapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carpoolapp/screens/home/home.dart';

class Verification extends StatefulWidget {
  @override
  _VerificationState createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    User user = FirebaseAuth.instance.currentUser;

    user.reload();
    _auth.verifyEmail(user);

    return user.emailVerified ? Home() : Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 150.0,horizontal: 50.0),
            child: Column(
              children: <Widget>[
                Image.asset("images/AppLogo.png",fit: BoxFit.contain, scale: 2.0,),
                SizedBox(height: 40.0),
                Text("A verification email has been sent. Kindly verify your email and then press the verify button on this tab."),
                SizedBox(height: 20.0),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: RaisedButton(
                      color: Colors.deepOrangeAccent,
                      onPressed: () async {
                        await user.reload();
                        print('User email verfied: ${user.emailVerified}');
                        setState(() {
                          user.emailVerified;
                        });
                      },
                      child: Text('I have verified my account', style: TextStyle(color: Colors.white))),
                ),
                SizedBox(height: 20.0),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: RaisedButton(
                      color: Colors.lightBlue,
                      onPressed: () async {
                        _auth.verifyEmail(user);
                      },
                      child: Text('Re-send verification email', style: TextStyle(color: Colors.white))),
                ),
                SizedBox(height: 20.0),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: RaisedButton(
                      color: Colors.red,
                      onPressed: () async {
                        await _auth.signOutUser();
                      },
                      child: Text('Sign Out', style: TextStyle(color: Colors.white))),
                ),
              ],
            )//symmetric padding
        ),
      ),
    );
  }
}
