import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usb_serial/usb_serial.dart';
import 'login.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EV Control App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: EVControlPage(),
    );
  }
}

class EVControlPage extends StatefulWidget {
  @override
  _EVControlPageState createState() => _EVControlPageState();
}

class _EVControlPageState extends State<EVControlPage> {
  bool _isForward = true;
  bool _isHeadlightOn = false;
  bool _isPowerOn = true;
  int _speed = 0;

  // this method to communicate with the Arduino Uno
  Future<void> _sendMessage(String message) async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      print('No USB devices found');
      return;
    }
    UsbPort? port = await devices[0].create();
    if (port == null) {
      print('Failed to create a port');
      return;
    }

    bool openResult = await port.open();
    if (!openResult) {
      print("Failed to open");
      return;
    }

    await port.setDTR(true);
    await port.setRTS(true);

    port.setPortParameters(
        9600, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    await port.write(Uint8List.fromList(message.codeUnits));
    await port.close();
  }

  void _toggleDirection() {
    setState(() {
      _isForward = !_isForward;
    });
    _sendMessage(_isForward ? 'F' : 'R'); // Add this line
  }

  void _toggleHeadlight() {
    setState(() {
      _isHeadlightOn = !_isHeadlightOn;
    });
    _sendMessage(_isHeadlightOn ? 'H_ON' : 'H_OFF'); // Add this line
  }

  void _togglePower() {
    setState(() {
      _isPowerOn = !_isPowerOn;
    });
  }

  Future<void> _openGoogleMaps() async {
    const url = 'https://maps.google.com/';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_speed',
                        style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Dimensions'),
                      ),
                      Text(
                        'kmph',
                        style: TextStyle(fontSize: 24),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AspectRatio(
                        aspectRatio:
                            1.0, // Adjust the aspect ratio as needed for your image
                        child: LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints constraints) {
                            return Container(
                              width: constraints.maxWidth,
                              height: constraints.maxHeight,
                              child: Image.asset('assets/car_top_view.png',
                                  fit: BoxFit.contain),
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FloatingActionButton(
                            onPressed: _toggleDirection,
                            child: Text(_isForward ? 'F' : 'R'),
                          ),
                          FloatingActionButton(
                            onPressed: _toggleHeadlight,
                            backgroundColor:
                                _isHeadlightOn ? Colors.yellow : null,
                            child: Icon(Icons.light_rounded),
                          ),
                          FloatingActionButton(
                            onPressed: _openGoogleMaps,
                            child: Icon(Icons.map),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      FloatingActionButton(
                        onPressed: _togglePower,
                        backgroundColor: _isPowerOn ? Colors.green : Colors.red,
                        child: Icon(Icons.power_settings_new),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          );
                        },
                        child: Icon(Icons.settings),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('Dark theme'),
            trailing: Switch(
              value: _darkTheme,
              onChanged: (bool value) {
                setState(() {
                  _darkTheme = value;
                });
              },
            ),
          ),
          ListTile(
            title: Text('Login as user'),
            onTap: () {
              LoginPage();
            },
          ),
        ],
      ),
    );
  }
}
