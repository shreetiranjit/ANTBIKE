import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antbike/login.dart';
import 'package:antbike/signup.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkTheme = false;
  TextEditingController _pidController = TextEditingController();
  TextEditingController _uidController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _darkTheme = (prefs.getBool('darkTheme') ?? false);
      _pidController.text = (prefs.getString('PID') ?? '');
      _uidController.text = (prefs.getString('UID') ?? '');
    });
  }

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', _darkTheme);
    prefs.setString('PID', _pidController.text);
    prefs.setString('UID', _uidController.text);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 16),
          children: <Widget>[
            ListTile(
              title: Text('Dark theme'),
              trailing: Switch(
                value: _darkTheme,
                onChanged: (bool value) {
                  setState(() {
                    _darkTheme = value;
                  });
                  _saveSettings();
                },
              ),
            ),
            TextField(
              controller: _pidController,
              decoration: InputDecoration(labelText: 'PID'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextField(
              controller: _uidController,
              decoration: InputDecoration(labelText: 'UID'),
            ),
            ElevatedButton(
              onPressed: () {
                _saveSettings();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Settings saved')),
                );
              },
              child: Text('Save PID and UID'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Login'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpPage()),
                    );
                  },
                  child: Text('Signup'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
