import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Sign up",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              _buildNameField(),
              SizedBox(height: 20),
              _buildEmailField(),
              SizedBox(height: 20),
              _buildPasswordField(),
              SizedBox(height: 20),
              _buildSignUpButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      child: TextField(
        decoration: InputDecoration(
          labelText: "Name",
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          labelText: "Email",
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Container(
      child: TextField(
        obscureText: _hidePassword,
        decoration: InputDecoration(
          labelText: "Password",
          suffixIcon: IconButton(
            icon: Icon(_hidePassword ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _hidePassword = !_hidePassword;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        child: Text("Sign up"),
        onPressed: () {
          // perform sign-up action
        },
      ),
    );
  }
}
