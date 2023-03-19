import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signup.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidePassword = true;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<bool> _checkUserCredentials(String email, String password) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String existingUsersJson = prefs.getString('users') ?? json.encode({});
  Map<String, dynamic> existingUsers = json.decode(existingUsersJson);
  return existingUsers[email] == password;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "Login",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 50),
              _buildEmailField(),
              SizedBox(height: 20),
              _buildPasswordField(),
              SizedBox(height: 20),
              _buildLoginButton(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        child: ElevatedButton(
          child: Text("Create a new account!",
              style: TextStyle(color: Colors.white, fontSize: 18)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SignUpPage()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmailField() {
    return Container(
      child: TextField(
        controller: _emailController,
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
        controller: _passwordController,
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

  Widget _buildLoginButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        child: Text("Login"),
        onPressed: () async {
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();
          if (email.isNotEmpty && password.isNotEmpty) {
            bool isAuthenticated = await _checkUserCredentials(email, password);
            if (isAuthenticated) {
              // Show a success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Successfully logged in!')),
              );
              // Navigate to another screen after a delay
              Future.delayed(Duration(seconds: 2), () {
                // Replace the following line with the desired screen
                // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => YourNextScreen()));
              });
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Invalid email or password')),
              );
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please fill all fields')),
            );
          }
        },
      ),
    );
  }
}
