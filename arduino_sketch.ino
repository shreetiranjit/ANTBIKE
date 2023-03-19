const int directionPin = 3;
const int headlightPin = 4;

void setup() {
  pinMode(directionPin, OUTPUT);
  pinMode(headlightPin, OUTPUT);
  Serial.begin(115200);
}

void loop() {
  if (Serial.available() >= 2) {
    int directionState = Serial.read();
    int headlightState = Serial.read();

    digitalWrite(directionPin, directionState);
    digitalWrite(headlightPin, headlightState);
  }
}
