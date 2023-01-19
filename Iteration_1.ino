#include "OmronD6T.h"

OmronD6T sensor;
#define echoPin 2 // attach pin D2 Arduino to pin Echo of HC-SR04
#define trigPin 3 //attach pin D3 Arduino to pin Trig of HC-SR04

// defines variables
long duration; // variable for the duration of sound wave travel
int distance; // variable for the distance measurement
unsigned long currenttime;
unsigned long previoustime=0;
unsigned long Allgoodtime=0;

void setup() {
  Serial.begin(9600);
  pinMode(7,OUTPUT);
  pinMode(13,OUTPUT);
  pinMode(trigPin, OUTPUT); // Sets the trigPin as an OUTPUT
  pinMode(echoPin, INPUT); // Sets the echoPin as an INPUT
  Serial.begin(9600); // // Serial Communication is starting with 9600 of baudrate speed
}

void loop() {
  // Clears the trigPin condition
  digitalWrite(trigPin, LOW);
  digitalWrite(13, HIGH);
  delayMicroseconds(2);
  // Sets the trigPin HIGH (ACTIVE) for 10 microseconds
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  // Reads the echoPin, returns the sound wave travel time in microseconds
  duration = pulseIn(echoPin, HIGH);
  // Calculating the distance
  distance = duration * 0.034 / 2; // Speed of sound wave divided by 2 (go and back)
  // Displays the distance on the Serial Monitor
  delay(500);
  float temperature = 0;
  sensor.scanTemp();
  int x, y;
  bool occupied = false;
  bool dooropen = true;
  
  if (distance<20){
    dooropen = false;
  }
  
  for (y = 0; y < 4; y++){
    for (x = 0; x < 4; x++){
      temperature = sensor.temp[x][y];
  
      if (temperature > 27){
        occupied = true;
      }
      
    }
   
  }

  currenttime=millis();


  if ( dooropen==false && occupied== false ){ 
    if ((currenttime-previoustime)<30000&&(currenttime-Allgoodtime)>10000){
    digitalWrite(7, LOW);
    }
    else{
      digitalWrite(7,HIGH);
    }
  }else{
    digitalWrite(7,HIGH);
    Allgoodtime=currenttime;
    previoustime=currenttime;
    
  }
  delay(100);
}
