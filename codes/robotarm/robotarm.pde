/* OWI Robotic Arm Control

This sketch demonstrates all the functions you need to set up your OWI Robotic Arm with Arduino reading four sensors and driving four motors.
What it does is move to base motor to a set position, then prints out all the sensor readings. Then it waits for you to hit "enter" in your serial
terminal, then moves all the motors by a small amount, and prints the new sensor readings. Then, after you hit "enter" again, it moves the arms back. 

What this shows you is:

1) How to move multiple motors
2) How to read sensors
3) How to set up a "closed loop" arm control, where the motor moves until a set sensor position is reached
4) How to get input from the keyboard if desired

From this foundation, it's easy to script repeatable arm movement involving all four joints. Your sensors and motor hook-ups will differ so
this sketch will allow you to calibrate the code for your own system. 
*/


#include <AFMotor.h>

AF_DCMotor motor1(1);  // Instantiate all the motors
AF_DCMotor motor2(2);
AF_DCMotor motor3(3);
AF_DCMotor motor4(4);
int val0 = 0;           // variable to store the Arm 1 sensor
int val1 = 0;           // variable to store the Arm 2 sensor
int val2 = 0;           // variable to store the Arm 3 sensor
int val3 = 0;           // variable to store the Arm 4 sensor


void input()    // this is the subroutine that waits for the user to hit enter
  {
  int incomingByte = 0;	// for incoming serial data
  motor1.setSpeed(0);     // stop the motor
  Serial.println("Hit return for next motion");   
  while (incomingByte != 13)  // 13 is the ASCII code for "enter"
    {
	if (Serial.available() > 0) 
         {   
		// read the incoming byte:
		incomingByte = Serial.read();

		// say what you got:
		Serial.print("I received: ");
		Serial.println(incomingByte, DEC);
	 }
     }
  }

void setup() {
  Serial.begin(9600);           // set up Serial library at 9600 bps
  Serial.println("Robot arm test!");
  motor1.setSpeed(100);     // set the speed to 100/255
  motor2.setSpeed(100);     // do the same for the others...
  motor3.setSpeed(100);    
  motor4.setSpeed(100);
}

void loop()

  {
  start:
  
  // Start by displaying all the current sensor values
  Serial.println("Start!");
  val0 = analogRead(0);    // read the input pin 0
  val1 = analogRead(1);    // read the input pin 0
  val2 = analogRead(2);    // read the input pin 0
  val3 = analogRead(3);    // read the input pin 0
        
  Serial.print("1 = ");
  Serial.print(val0);             // debug value
  Serial.print("  2 = ");
  Serial.print(val1);             // debug value
  Serial.print("  3 = ");
  Serial.print(val2);             // debug value
  Serial.print("  4 = ");
  Serial.println(val3);             // debug value
  delay(100);
  
 if (val0 > 500)          // If base is not at end, move to end
  {
    while (val0 > 500)
     {
      val0 = analogRead(0);    // read the input pin 0
      Serial.print("Value = ");
      Serial.println(val0);             // debug value
      motor1.setSpeed(100);     // set the speed to 100/255
      motor1.run(FORWARD);
      delay(100);
     }
  }
  
  input();  // wait for user to hit return
  
  
  // Now we're going to move all the motors forward a bit so we can see how the motor direction and sensor direction correlate
  
  motor1.setSpeed(100);     // set the speed to 100/255
  motor1.run(FORWARD);
  motor2.setSpeed(100);     // set the speed to 100/255
  motor2.run(FORWARD);
  motor3.setSpeed(100);     // set the speed to 100/255
  motor3.run(FORWARD);
  motor4.setSpeed(100);     // set the speed to 100/255
  motor4.run(FORWARD);
  delay (1000);
  motor1.setSpeed(0);       // turn off motors
  motor2.setSpeed(0);   
  motor3.setSpeed(0);    
  motor4.setSpeed(0);   
  
  // Now read the sensors to see how they changed

  val0 = analogRead(0);    // read the input pin 0
  val1 = analogRead(1);    // read the input pin 1
  val2 = analogRead(2);    // read the input pin 2
  val3 = analogRead(3);    // read the input pin 3
        
  Serial.print("1 = ");    // report the new readings
  Serial.print(val0);             
  Serial.print("  2 = ");
  Serial.print(val1);             
  Serial.print("  3 = ");
  Serial.print(val2);            
  Serial.print("  4 = ");
  Serial.println(val3);          
  delay(100);

  input();  // wait for user to hit return
  
    // Now we're going to move all the motors back to where they started
  
  motor1.setSpeed(100);     // set the speed to 100/255
  motor1.run(BACKWARD);
  motor2.setSpeed(100);     // set the speed to 100/255
  motor2.run(BACKWARD);
  motor3.setSpeed(100);     // set the speed to 100/255
  motor3.run(BACKWARD);
  motor4.setSpeed(100);     // set the speed to 100/255
  motor4.run(BACKWARD);
  delay (1000);
  motor1.setSpeed(0);       // turn off motors
  motor2.setSpeed(0);   
  motor3.setSpeed(0);    
  motor4.setSpeed(0);   
  
  // Now read the sensors to see how they changed

  val0 = analogRead(0);    // read the input pin 0
  val1 = analogRead(1);    // read the input pin 1
  val2 = analogRead(2);    // read the input pin 2
  val3 = analogRead(3);    // read the input pin 3
        
  Serial.print("1 = ");    // report the new readings
  Serial.print(val0);             
  Serial.print("  2 = ");
  Serial.print(val1);             
  Serial.print("  3 = ");
  Serial.print(val2);            
  Serial.print("  4 = ");
  Serial.println(val3);          
  delay(100);

  input();  // wait for user to hit return

  goto start;
  }


