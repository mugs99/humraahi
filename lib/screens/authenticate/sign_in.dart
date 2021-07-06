import 'package:carpoolapp/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:carpoolapp/shared/loading.dart';
import 'reset_password.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  // Declare an AuthService variable to acccess AuthService functions
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
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
                  validator: (val)  => val.isEmpty ? 'Enter an email' : null,
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
                SizedBox(height: 20.0),
                TextFormField(
                  validator: (val)  => val.isEmpty ? 'Enter your password' : null,
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
                      hintText: "Enter your Password",
                      hintStyle: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic),
                  ),
                  obscureText: true,
                  onChanged: (val){
                    setState(() => password = val);
                  },
                ),
                SizedBox(height: 20.0,),
                RaisedButton(
                  color: Colors.deepOrange,
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if(_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmailAndPassword(email, password);
                      if(result == null){
                        setState(() => loading = false);
                        setState(() => error = 'Error signing in! Check your credentials');
                      }
                    }
                  }
                ),
                SizedBox(height: 12.0,),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14.0,fontWeight: FontWeight.bold),
                ),
                FlatButton.icon(onPressed: () => widget.toggleView(), icon: Icon(Icons.person), label: Text('Don\'t have an account?')),
                FlatButton.icon(onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordReset()));}, icon: Icon(Icons.lock), label: Text('Forgot Password?')),
              ],
            ),
          )//symmetric padding
        ),
      ),
    );
  }
}
