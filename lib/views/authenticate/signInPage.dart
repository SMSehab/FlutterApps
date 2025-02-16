import 'package:flutter/material.dart';
import 'package:kinbo/services/auth.dart';
import 'package:kinbo/views/shared/input_decoration.dart';

class SignInPage extends StatefulWidget {
  //const SignInPage({ Key? key }) : super(key: key);
  final Function ? toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Text field form
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[300],
        elevation: 0.0,
        title: Text("Sign in "),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person,
            color: Colors.white,
            ),
            label: Text('Register', 
            style: TextStyle(
             color: Colors.white,
            ),
            ),
            onPressed: () {
              widget.toggleView!();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration('Email'),
                validator: (val) => val!.isEmpty ? 'Enter email ' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration('Password'),
                
                validator: (val) =>
                    val!.length < 6 ? 'Enter a password 6+ char long ' : null,
                obscureText: true,
                onChanged: (val) {
                  setState(() => password = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo[300],
                  ),
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.signInWithEmailAndPassword(
                          email, password);
                      if (result == null) {
                        setState(() =>
                            error = 'could not sign in with those credentials');
                      }
                    }
                  }
                ),
                SizedBox(
                height: 12.0,
              ),
              Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14.0,
                ),
              ) 
            ],
          ),
        ),
      ),
    );
  }
}
