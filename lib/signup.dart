import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool _hidePassword = true;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _storeUserData(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> newUser = {email: password};
    String existingUsersJson = prefs.getString('users') ?? json.encode({});
    Map<String, dynamic> existingUsers = json.decode(existingUsersJson);
    existingUsers.addAll(newUser);
    await prefs.setString('users', json.encode(existingUsers));
  }

  Future<void> printStoredData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String usersJson = prefs.getString('users') ?? 'No users found';
    print('Stored users: $usersJson');
  }

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
        controller: _nameController,
        decoration: InputDecoration(
          labelText: "Name",
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

  Widget _buildSignUpButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        child: Text("Sign up"),
        onPressed: () async {
          String name = _nameController.text.trim();
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();
          if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
            await _storeUserData(email, password);
            await printStoredData();
            // Show a success message
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Successfully signed up!')),
            );
            // Navigate back to the login page after a delay
            Future.delayed(Duration(seconds: 2), () {
              Navigator.pop(context);
            });
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
