 
import 'package:antbike/ev_control.dart'; 
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 
 


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
      debugShowCheckedModeBanner: false,
      title: 'EV Control App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: EVControlPage(),
    );
  }
}




