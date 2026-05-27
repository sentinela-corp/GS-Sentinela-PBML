// C++ code
//

#include <Servo.h>



Servo servoBase;

Servo servoGarra;

const int ledPin = 13;



int posBase = 90;

int posGarra = 90;



void setup() {
  Serial.begin(9600);
  delay(500); // <-- O segredo: Dá tempo para o Tinkercad abrir o monitor
  
  servoBase.attach(9);
  servoGarra.attach(10);
  pinMode(ledPin, OUTPUT);
  
  digitalWrite(ledPin, HIGH); 
  servoBase.write(posBase);
  servoGarra.write(posGarra);
  
  Serial.println("--- Sistema MMA-01 Online ---");
  Serial.println("Comandos: U, D, O, C");
}



void loop() {

  if (Serial.available() > 0) {

    char comando = Serial.read();

    

    digitalWrite(ledPin, LOW); 

    delay(50);

    digitalWrite(ledPin, HIGH);



    switch(comando) {

      case 'U':

        posBase = constrain(posBase + 15, 0, 180);

        servoBase.write(posBase);

        Serial.println("Base: UP");

        break;

      case 'D':

        posBase = constrain(posBase - 15, 0, 180);

        servoBase.write(posBase);

        Serial.println("Base: DOWN");

        break;

      case 'O':

        posGarra = 90;

        servoGarra.write(posGarra);

        Serial.println("Garra: ABERTA");

        break;

      case 'C':

        posGarra = 0;

        servoGarra.write(posGarra);

        Serial.println("Garra: FECHADA");

        break;

      case '\n': case '\r': break;

      default:

        Serial.println("Comando Invalido");

    }

  }

}