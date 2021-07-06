import 'package:carpoolapp/screens/authenticate/verify.dart';
import 'package:flutter/material.dart';
import 'package:carpoolapp/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pinput/pin_put/pin_put.dart';

class VerifyPhone extends StatefulWidget {
  @override
  _VerifyPhoneState createState() => _VerifyPhoneState();
}

class _VerifyPhoneState extends State<VerifyPhone> {

  final _formKey = GlobalKey<FormState>();

  String verificationCode;

  String otp;
  bool send = true;

  final AuthService _auth = AuthService();
  User user = FirebaseAuth.instance.currentUser;

  final TextEditingController _pinPutController = TextEditingController();
  final FocusNode _pinPutFocusNode = FocusNode();

  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.lightBlue),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  @override
  Widget build(BuildContext context) {

    user.reload();
    user = FirebaseAuth.instance.currentUser;

    if(user.phoneNumber == null) {
      sendVerification();
    }

    return (user.phoneNumber != null) ? Verification() : Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 150.0,horizontal: 50.0),
            child: Column(
              children: <Widget>[
                Image.asset("images/AppLogo.png",fit: BoxFit.contain, scale: 2.0,),
                SizedBox(height: 40.0),
                Text("An OTP has been sent on your number."),
                SizedBox(height: 20.0),
          PinPut(
            fieldsCount: 6,
            onChanged: (String pin){
              setState(() {
                otp = pin;
              });
            },
            focusNode: _pinPutFocusNode,
            controller: _pinPutController,
            submittedFieldDecoration: _pinPutDecoration.copyWith(
              borderRadius: BorderRadius.circular(20.0),
            ),
            selectedFieldDecoration: _pinPutDecoration,
            followingFieldDecoration: _pinPutDecoration.copyWith(
              borderRadius: BorderRadius.circular(5.0),
              border: Border.all(
                color: Colors.lightBlue.withOpacity(.5),
              ),
            ),
          ),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: RaisedButton(
                      color: Colors.deepOrangeAccent,
                      onPressed: () async {
                        if(otp != null){
                          PhoneAuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationCode, smsCode: otp);
                          user.linkWithCredential(credential);
                        }
                        await user.reload();
                        setState(() {
                          send = !send;
                          user.phoneNumber;
                        });
                      },
                      child: Text('Validate', style: TextStyle(color: Colors.white))),
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

  Future<bool> sendVerification() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: await FirebaseFirestore.instance.collection('users').doc(user.uid).get().then<dynamic>((DocumentSnapshot snapshot) async {
      if(snapshot.data()['phone'] == null){
        print('No phone number exists');
      }
      else {
        return snapshot.data()['phone'];
      }
      }),
      verificationCompleted: (PhoneAuthCredential credential) {
        print('VERIFIED');
        user.linkWithCredential(credential);
        setState(() {

        });
      },
      verificationFailed: (FirebaseAuthException e) {
      },
      codeSent: (String verificationId, int resendToken) {
        print('Code Sent');
        setState(() {
          verificationCode = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        setState(() {
          verificationCode = verificationId;
        });
      },
      timeout: Duration(seconds: 60),
    );
  }

}
