import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:antbike/login.dart';
import 'package:antbike/signup.dart';
import 'package:flutter/services.dart';

// Initialize the method channel

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkTheme = false;
  TextEditingController _pidController = TextEditingController();
  TextEditingController _vidController = TextEditingController();
  static const platform = MethodChannel('com.example.antbike/deviceFilter');

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
      _vidController.text = (prefs.getString('VID') ?? '');
    });
  }

  _saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkTheme', _darkTheme);
    prefs.setString('PID', _pidController.text);
    prefs.setString('VID', _vidController.text);

    // Call the native Android function to update the USB device filter
    try {
      await platform.invokeMethod('updateDeviceFilter', {
        "vendorID": _vidController.text,
        "productID": _pidController.text,
      });
    } on PlatformException catch (e) {
      // Handle the error if any
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: _darkTheme ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Settings'),
          backgroundColor: Color.fromARGB(255, 116, 29, 132),
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
              controller: _vidController,
              decoration: InputDecoration(labelText: 'VID'),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 116, 29, 132)),
              onPressed: null,
              // () {
              //   _saveSettings();
              //   ScaffoldMessenger.of(context).showSnackBar(
              //     SnackBar(content: Text('Settings saved')),
              //   );
              // },
              child: Text('Save VID and PID'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 116, 29, 132)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: Text('Login'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 116, 29, 132)),
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
