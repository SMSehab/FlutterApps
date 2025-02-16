import 'package:flutter/material.dart';
import 'package:kinbo/services/auth.dart';
import 'package:kinbo/views/shared/input_decoration.dart';

class RegisterPage extends StatefulWidget {
  //const RegisterPage({ Key? key }) : super(key: key);

  final Function? toggleView;
  RegisterPage({this.toggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
        title: Text("Sign up"),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person,
            color: Colors.white,),
            label: Text('Sign in',
            style: TextStyle(
             color: Colors.white,
            ),),
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
                decoration: textInputDecoration("Email"),
                validator: (val) => val!.isEmpty ? 'Enter email ' : null,
                onChanged: (val) {
                  setState(() => email = val);
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              TextFormField(
                decoration: textInputDecoration("Password"),
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
                  'Sign up',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        email, password);
                    if (result == null) {
                      setState(() =>
                          error = 'please supply a valid email & password');
                    }
                  }
                },
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
