import 'package:antbike/settings_page.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:usb_serial/usb_serial.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_indicator/battery_indicator.dart';

class EVControlPage extends StatefulWidget {
  @override
  _EVControlPageState createState() => _EVControlPageState();
}

class _EVControlPageState extends State<EVControlPage> {
  bool _isForward = true;
  bool _isHeadlightOn = false;
  bool _isPowerOn = true;
  int _speed = 0;

  void _toggleDirection() {
    setState(() {
      _isForward = !_isForward;
    });
    _sendToArduino();
  }

  void _toggleHeadlight() {
    setState(() {
      _isHeadlightOn = !_isHeadlightOn;
    });
    _sendToArduino();
  }

  void _togglePower() {
    setState(() {
      _isPowerOn = !_isPowerOn;
    });
  }

  Future<void> _sendToArduino() async {
    List<UsbDevice> devices = await UsbSerial.listDevices();
    if (devices.isEmpty) {
      print('No USB devices found');
      return;
    }

    UsbPort port;
    if (devices.length == 0) {
      return;
    }
    port = (await devices[0].create())!;
    bool openResult = await port.open();
    if (!openResult) {
      print("Failed to open");
      return;
    }

    await port.setDTR(true);
    await port.setRTS(true);
    port.setPortParameters(
        115200, UsbPort.DATABITS_8, UsbPort.STOPBITS_1, UsbPort.PARITY_NONE);

    Uint8List dataToSend = Uint8List.fromList([
      _isForward ? 1 : 0, // Send 1 for Forward, 0 for Reverse (D3)
      _isHeadlightOn
          ? 1
          : 0 // Send 1 for Headlight ON, 0 for Headlight OFF (D4)
    ]);

    await port.write(dataToSend);

    // await Future.delayed(Duration(seconds: 1));
    await port.close();
  }

  Future<LatLng> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
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
            Positioned.fill(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                            Text(
                              '$_speed' + ' kmph',
                              style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Dimensions'),
                            ),
                          ],
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
                              return FutureBuilder(
                                future: _getCurrentLocation(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<LatLng> snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      width: 300,
                                      height: 300,
                                      child: FlutterMap(
                                        options: MapOptions(
                                          center: snapshot.data,
                                          zoom: 13.0,
                                        ),
                                        layers: [
                                          TileLayerOptions(
                                            urlTemplate:
                                                'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                            subdomains: ['a', 'b', 'c'],
                                          ),
                                          MarkerLayerOptions(
                                            markers: [
                                              Marker(
                                                width: 100.0,
                                                height: 160.0,
                                                point: snapshot.data!,
                                                builder: (ctx) => Container(
                                                  child: Icon(
                                                    Icons.location_on,
                                                    color: Colors.red,
                                                    size: 40.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  }
                                  return CircularProgressIndicator();
                                },
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            FloatingActionButton(
                              heroTag: 'directionButton',
                              onPressed: () async {
                                await _toggleDirection;
                                AudioCache cache = new AudioCache();
                                await cache.play('assets/gear.mp3');
                              },
                              child: Text(_isForward ? 'F' : 'R'),
                            ),
                            FloatingActionButton(
                              heroTag: 'headlightButton',
                              onPressed: _toggleHeadlight,
                              backgroundColor:
                                  _isHeadlightOn ? Colors.yellow : null,
                              child: Icon(Icons.light_rounded),
                            ),
                            FloatingActionButton(
                              heroTag: 'mapsButton',
                              onPressed: _openGoogleMaps,
                              child: Icon(Icons.map),
                            ),
                          ],
                        ),
                      ],
                    ),
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
                    heroTag: 'powerButton',
                    onPressed: _togglePower,
                    backgroundColor: _isPowerOn ? Colors.green : Colors.red,
                    child: Icon(Icons.power_settings_new),
                  ),
                  SizedBox(height: 10),
                  FloatingActionButton(
                    heroTag: 'settingsButton',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SettingsPage()),
                      );
                    },
                    child: Icon(Icons.settings),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: Column(
                children: [
                  BatteryIndicator(
                    style: BatteryIndicatorStyle.values[0],
                    colorful: true,
                    showPercentNum: true,
                    mainColor: Colors.red,
                    size: 50,
                    ratio: 4,
                    showPercentSlide: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
