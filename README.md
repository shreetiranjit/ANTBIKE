# ANT BIKE

A Flutter application to control an electric vehicle using Arduino Uno R3. The app allows you to change the vehicle's direction, toggle the headlights, and monitor the vehicle's speed.



## Features

- Toggle vehicle direction (Forward/Reverse)
- Toggle headlights (On/Off)
- Display vehicle speed (kmph)
- Integration with Google Maps
- Settings page

## Requirements

- Flutter SDK
- Android Studio or VS Code with Flutter plugin
- Arduino Uno R3 board
- USB OTG cable (to connect the Arduino board to the mobile device)
- 2-channel relay module

## Setup

1. Clone the repository:

git clone https://github.com/shreetiranjit/ANTBIKE/

2. Navigate to the project folder:

cd ev-control-app

3. Install the dependencies:

flutter pub get

4. Connect your Android device or open the Android emulator.

5. Run the app:

flutter run

## Arduino

Upload the Arduino code provided in this repository to your Arduino Uno R3 board. 
The file is called arduino_sketch.ino in the main branch.
Connect the 2-channel relay module to the Arduino board with the following connections:

- Direction Relay: Pin D3
- Headlight Relay: Pin D4




