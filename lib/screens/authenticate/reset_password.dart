import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PasswordReset extends StatefulWidget {
  @override
  _PasswordResetState createState() => _PasswordResetState();
}

class _PasswordResetState extends State<PasswordReset> {

  final _auth = FirebaseAuth.instance;

  final _formKey = GlobalKey<FormState>();

  String email = '';
  String error = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 150.0,horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  Image.asset("images/AppLogo.png",fit: BoxFit.contain, scale: 2.0,),
                  SizedBox(height: 40.0),
                  TextFormField(
                    validator: (val)  => val.isEmpty ? 'Enter your email' : null,
                    cursorColor: Colors.redAccent,
                    decoration: new InputDecoration(
                        fillColor: Colors.lightBlueAccent,
                        filled: true,
                        border: new OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(
                              width: 0,
                              style: BorderStyle.none
                          ),
                        ),
                        contentPadding: EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Enter your E-mail",
                        hintStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)
                    ),
                    onChanged: (val){
                      setState(() => email = val);
                    },
                  ),
                  SizedBox(height: 20.0,),
                  RaisedButton(
                      color: Colors.deepOrange,
                      child: Text(
                        'Send Password Reset Email',
                        style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                      ),
                      onPressed: () async {
                        if(_formKey.currentState.validate()){
                          _auth.sendPasswordResetEmail(email: email);
                          Navigator.pop(context);
                        }
                        else{
                          setState(() => error = 'Enter a valid Email');
                        }
                      }
                  ),
                  SizedBox(height: 12.0,),
                  Text(
                    error,
                    style: TextStyle(color: Colors.red, fontSize: 14.0,fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )//symmetric padding
        ),
      ),
    );
  }
}
