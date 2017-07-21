//#include <TimerOne.h>
#include<Wire.h>
#include <ps2.h>
// declare all current position variables
PS2 mouse(2, 3);

#include <NewPing.h>

#define TRIGGER_PIN  5  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     4  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 500 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.

NewPing sonar(TRIGGER_PIN, ECHO_PIN, MAX_DISTANCE); // NewPing setup of pins and maximum distance.

int wristp , elbowp , basep , basemotorp; 
int wristpnew , elbowpnew , basepnew , basemotorpnew; 
int temp , x1 , x2 , z1 , z2;
boolean gripp= false;  // false is ungrip and true is grip. 
// we'll update motor positions everytime 
# define gsens 131.000
# define asens 16384.000
int value1,value2;
const int MPU = 0x68 ;  // I2C address of the MPU-6050
//float waste ; // for wasting gyro data
float GyZ, GZ = 0.00 ;

char mstat;
char mx;
char my;    
    
int x=0 , z=0  , orientation=0;  
byte driver = 0xFF ;

int mode=0;

// mode 0 moving forward 
//      1 turn left 
//      2 turn right 
//      3 picking or placing
// elbow -90             0        912
// elbow +135           225       277
// base vertical  135   135       568
// base vertical  0      0        108
// base horizontal 0     0        68
// base horizontal 90   90        324 

void setup()
{ 

  Serial.begin(9600);
  Wire.begin();
  //Timer1.initialize(100000); // set a timer of length 100000 microseconds
  //Timer1.attachInterrupt( timerIsr ); // attach the service routine here
  mouse_init();
 // pinMode(,INPUT);
  for(int i= 13;i>=6;i--)
  pinMode(i,OUTPUT);
}


void loop ()
{
  if(Serial.available() == 5)
    {
    temp = Serial.read();
    x1 = Serial.read() * temp ;
    x2 = Serial.read() * temp ;
    z1 = Serial.read() * temp * 2 ;
    z2 = Serial.read() * temp * 2 ;
        
    if(x1 > 0 )// positive means initial position of object to the right 
    {  
      turnRight(90);
      moveForward(abs(x1));
      turnLeft(90);    
    }
    else if(x1 < 0)
    {
      turnLeft(90);
      moveForward(abs(x1));
      turnRight(90);
    }
    
    
        
    // verify object distance with ultrasonic sensor
    
    unsigned int uS = sonar.ping(); // Send ping, get ping time in microseconds (uS).
    uS=uS / US_ROUNDTRIP_CM ;// Convert ping time to distance in cm and print result (0 = outside set distance range)
    
    //if(abs(uS-z1) < 5)
    
      moveForward(z1);
      Object('P');
      
      if(x2 > x1 )// positive means initial position of object to the right 
      turnRight(90);    
      else if(x1 > x2)
      turnLeft(90);
    
    moveForward(abs(x1-x2));
    
    Object('R');
    // send a confirmation to master   
    //Serial.println('Y');
      
    
    //else Serial.println('N');

    






}//if(Serial.available() == 5)
  
}// loop 
/******************************************  functions *************************************************************/

void Object(char temp1)
{
readAdc();
for(int temp1=0;temp1<5;temp1++)
{
  readAdc();
  elbowpnew=90;
  basepnew=90;
  //basemotorpnew=45;
  elbow();
  base();
  //basemotor();
  delay(200);
}

if(temp1=='P')
grip(true);
else if(temp1=='R')
grip(false);

readAdc();

for(int temp1=0;temp1<5;temp1++)
{
  readAdc();
  elbowpnew=135;
  basepnew=110;
  //basemotorpnew=45;
  elbow();
  base();
  //basemotor();
  delay(200);
}


}



void turnLeft(int angle)
{ 
  int temp1=0;
  while(temp1 >= angle)
  {
    leftMotor('R',100);
    rightMotor('F', 100);
    Wire.beginTransmission(MPU);
    Wire.write(0x47);  // starting with register 0x3B (gyro_zOUT_H)
    Wire.endTransmission(false);
    Wire.requestFrom(MPU,2,true);  
    GyZ=((Wire.read()<<8|Wire.read())+191)/gsens;  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
    temp1=temp1+GyZ*0.01+0.0000;
    
    delay(10);
  }
  leftMotor('S',100);
  rightMotor('S', 100);
    
  orientation -=90;
}
void moveForward(int distance)
{  int temp2=millis(),temp1;
   while((millis() - temp1) < distance)
    {
      Wire.beginTransmission(MPU);
    Wire.write(0x47);  // starting with register 0x3B (gyro_zOUT_H)
    Wire.endTransmission(false);
    Wire.requestFrom(MPU,2,true);  
    GyZ=((Wire.read()<<8|Wire.read())+191)/gsens;  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
    temp1=temp1+GyZ*0.01+0.0000;
    leftMotor ('F', 100 + temp1 * 20);
    rightMotor('F', 100 - temp1 * 20);
     /*   
    mouse.write(0xeb);  // give me data!
    mouse.read();      // ignore ack
    mstat = mouse.read();
    mx = mouse.read();
    my = mouse.read();
    if(orientation = 90)
    x+=my;
    
    if(orientation = -90)
    x-=my;*/
    
    delay(10);
    }
    //if(abs(distance- x)<10)
    leftMotor ('S', 100 );
    rightMotor('S', 100 );
    
    
}




void turnRight(int angle)
{ 
  
  int temp1=0;
  while(temp1 < angle)
  {
    leftMotor('F',100);
    rightMotor('R', 100);
    int temp1=0;
    Wire.beginTransmission(MPU);
    Wire.write(0x47);  // starting with register 0x3B (gyro_zOUT_H)
    Wire.endTransmission(false);
    Wire.requestFrom(MPU,2,true);  
    GyZ=((Wire.read()<<8|Wire.read())+191)/gsens;  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
    temp1=temp1+GyZ*0.01+0.0000;
    
    delay(10);
  }
    leftMotor('S',100);
    rightMotor('S', 100);
         
    orientation += 90;

}

void leftMotor(char temp1, int velocity )
{
  analogWrite(11, velocity);
  if( temp1== 'F' )
  {
    digitalWrite(8,HIGH);
    digitalWrite(9,LOW);
  }
  if( temp1== 'R' )
  {
    digitalWrite(9,HIGH);
    digitalWrite(8,LOW);
  }
  if( temp1== 'S' )
  {
    digitalWrite(8,HIGH);
    digitalWrite(9,HIGH);
  }
}
// check motor pins
void rightMotor(char temp1, int velocity )
{
  analogWrite(6, velocity);
  if( temp1== 'F' )
  {
    digitalWrite(12,HIGH);
    digitalWrite(7,LOW);
  }
  if( temp1== 'R' )
  {
    digitalWrite(7,HIGH);
    digitalWrite(12,LOW);
  }
  if( temp1== 'S' )
  {
    digitalWrite(12,HIGH);
    digitalWrite(7,HIGH);
  }
}


void readAdc()
{
Wire.beginTransmission(90);
Wire.write(0x04);
Wire.endTransmission();
Wire.requestFrom(90,5);
  
basemotorp = Wire.read();
basemotorp = Wire.read();// repeat due to adc sends it twice
basep=Wire.read();// dump this value
elbowp = Wire.read();
basep=Wire.read();
 //conveting to angles
 basep = map(basep, 100 , 580 , 0 , 135 );
 basemotorp = map(basemotorp, 55 , 340 , 0 , 90 );
 elbowp= map(elbowp, 930 , 260 , 0 , 225);


}

void driverwrite(byte driver)
{
  Wire.beginTransmission(32); // transmit to device #4
  Wire.write(driver);              // sends one byte  
  Wire.endTransmission(); 
}   // stop transmitting}

void resetarm()
{
//wrist(60);
 for(int temp1=0;temp1<5;temp1++)
{
  readAdc();
  elbowpnew=135;
  basepnew=110;
  basemotorpnew=45;
  elbow();
  base();
  basemotor();
  delay(200);
}
grip(false);
}

void elbow()
{
  // elbow motor reset at 150

  if(abs(elbowp - elbowpnew)<5)
  {  driver=driver||0x0C;
     driverwrite(driver);
  }
  else if(elbowp>elbowpnew)
{

  //rotate forward

driver=driver&&0xFB;
 driver=driver||0x08;
 driverwrite(driver);
 

}
else if(elbowp<elbowpnew)
{
  //rotate reverse
  driver=driver&&0xF7;
 driver=driver||0x04;
 driverwrite(driver);
 
  
}

}

void base()
{// base vertival motor reset at 90
if( abs(basep - basepnew)<5 )
    {
      driver=driver||0x30;
      driverwrite(driver);
    }
else if(basep>basepnew)
{
  //rotate forward
 driver=driver&&0xEF;
 driver=driver||0x20;
 driverwrite(driver);
 
  
}
else if(basep<basepnew)
{
  //rotate reverse
  driver=driver&&0xDF;
 driver=driver||0x10;
 driverwrite(driver);
 
  //condition
    
}
// base vertical motor position


}

//horizontal base motor
void basemotor()
{ 
   if(abs(basemotorp-basemotorpnew)<5)
  {
      driver=driver||0xC0;
      driverwrite(driver);
  } 
else if(basemotorp>basemotorpnew)
{
  //rotate forward
  driver=driver&&0xBF;
 driver=driver||0x80;
 driverwrite(driver);
 

}
else  if(basemotorp<basemotorpnew)
{
  //rotate reverse
 driver=driver&&0x7F;
 driver=driver||0x40;
 driverwrite(driver);
//conditon
   
}

}

void mouse_init()
{
  mouse.write(0xff);  // reset
  mouse.read();  // ack byte
  mouse.read();  // blank */
  mouse.read();  // blank */
  mouse.write(0xf0);  // remote mode
  mouse.read();  // ack
  delayMicroseconds(100);
}
void grip(boolean temp)// wrist motor reset at 60
{
  if(temp==true && gripp==false)
{
  gripp=true;
  //rotate forward
 driver=driver&&0xFE;
 driver=driver||0x02;
 driverwrite(driver);
 delay(200);
driver=driver||0x03;
driverwrite(driver);

}
if(temp==false && gripp==true)
{
  //rotate reverse
 driver=driver&&0xFD;
 driver=driver||0x01;
 driverwrite(driver);
 
  delay(200);
driver=driver||0x03;
driverwrite(driver);
}

}
