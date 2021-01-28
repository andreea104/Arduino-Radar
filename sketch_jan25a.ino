#include <Servo.h>
// Pinii trig si echo ai senzorului ultrasonic
const int trigPin = 10;
const int echoPin = 11;
// variabile pt disanta si durata
long duration;
int distance;
Servo myServo; // obiect necesar pt functionarea servomotor

void setup() {
  pinMode(trigPin, OUTPUT); // marchez trigpin output
  pinMode(echoPin, INPUT); // iar echopin input
  Serial.begin(9600);
  myServo.attach(12); // pinul la care atasez servomotor
}

class Project{
  private:
      int dist;
  public:
      Project()
      {
        dist = 0;
      }

      Project(int dist)
      {
        this -> dist = dist;
      }
      
      int calculateDistance()
      { 
        digitalWrite(trigPin, LOW); 
        delayMicroseconds(2);
        // Sets the trigPin on HIGH state for 10 micro seconds
        digitalWrite(trigPin, HIGH); 
        delayMicroseconds(10);
        digitalWrite(trigPin, LOW);
        duration = pulseIn(echoPin, HIGH); // Reads the echoPin, returns the sound wave travel time in microseconds
        dist = duration * 0.034/2;
          
        return dist;
      }

      ~Project()
      {
        
      }
};

void loop() 
{
  Project obj;
  // roteste servomotor de la 0 la 180 grade
  for(int i=0;i<=180;i++)
  {  
    myServo.write(i);
    delay(30);
    distance = obj.calculateDistance();// apelul functiei ce calculeaza distanta masurata de senzor pentru fiecare grad din intervalul[0,180] 
    Serial.print(i); // trimite gradel masurate la serial port
    Serial.print(",");
    Serial.print(distance); // trimite valoarea distantei la serial port
    Serial.print("."); // 
  }
  // se repeta procesul anterior in ordine inversa
  for(int i = 180; i > 0; i--)
  {  
    myServo.write(i);
    delay(30);
    distance = obj.calculateDistance();
    Serial.print(i);
    Serial.print(",");
    Serial.print(distance);
    Serial.print(".");
  }
}
