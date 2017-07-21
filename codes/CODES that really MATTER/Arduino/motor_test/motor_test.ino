
// IN 5 sec. bot moves 180cm
#include<Wire.h>
#include <ps2.h>
// declare all current position variables
# define filter 26  //low pas filter config address
/*#include <NewPing.h>

#define TRIGGER_PIN  5  // Arduino pin tied to trigger pin on the ultrasonic sensor.
#define ECHO_PIN     4  // Arduino pin tied to echo pin on the ultrasonic sensor.
#define MAX_DISTANCE 500 // Maximum distance we want to ping for (in centimeters). Maximum sensor distance is rated at 400-500cm.
*/


int wristp , elbowp , basep , basemotorp; 
int wristpnew , elbowpnew , basepnew , basemotorpnew; 
int temp , x1 , x2 , z1 , z2;
int corr;
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
 
 // pinMode(,INPUT);
  for(int i= 13;i>=6;i--)
  pinMode(i,OUTPUT);
  delay(2000);
  
  int time =  millis();
  //while(!(Serial.available() == 5));
    {
    //temp = Serial.read();
    x1 = 367;//Serial.read() * temp ;
    x2 = -216;//Serial.read() * temp ;
    z1 = 196;//Serial.read() * temp * 2 ;
    z2 = 0;//Serial.read() * temp * 2 ;
     
     moveForward(z1); 

    if(x1 < 0 )// positive means initial position of object to the right 
    {  
      turnRight();
      moveForward(abs(x1));
       
       delay(2000);
      if( x2 < x1)
         moveForward(abs(x2-x1));
      
      else if(x2 > x1)
       {
         turnLeft();
         turnLeft();
         moveForward(x2-x1);
       }
       delay(2000);
    }
    else if(x1 > 0)
    {
      turnLeft();
      moveForward(abs(x1));
      
      if( x2 < x1 )
        {  
          turnRight();
          turnRight();
          moveForward(abs(x2-x1));
        }
      else if(x2 > x1)
       {
         
         moveForward(x2-x1);
       }
       delay(2000);
    
      
      
    }
    
  ////

  delay(2000);
    // object picking here
     
  
    
  
  /* while((millis()-time <27.7778 * 114))
  {
    leftMotor('F', 118 );
    rightMotor('F',200 );
  }*/ 
      
    
    }
}

void Object(char temp1)
{
//readAdc();
for(int temp1=0;temp1<5;temp1++)
{
//  readAdc();
  elbowpnew=90;
  basepnew=90;
  //basemotorpnew=45;
 // elbow();
  //base();
  //basemotor();
  delay(200);
}

if(temp1=='P')
grip(true);
else if(temp1=='R')
grip(false);

//readAdc();

for(int temp1=0;temp1<5;temp1++)
{
 // readAdc();
  elbowpnew=135;
  basepnew=110;
  //basemotorpnew=45;
  //elbow();
  //base();
  //basemotor();
  delay(200);
}


}

void grip(boolean temp)// wrist motor reset at 60
{
  if(temp==true && gripp==false)
{
  gripp=true;
  //rotate forward
 //
 delay(200);
//
}
if(temp==false && gripp==true)
{
  //rotate reverse
 
  delay(200);
//
}

}
void moveForward(int distance)
{  int time=millis();
  while((millis()-time <27.7778 * distance))
    {
    
      leftMotor('F', 118 );
      rightMotor('F',200 );
    
    }
    leftMotor('S', 118 );
    rightMotor('S',200 );
}
void turnLeft()
{ 
  leftMotor('R', 118 );
  rightMotor('F',200 );
    delay(1100);
}
void turnRight()
{ 
  leftMotor('F', 118 );
  rightMotor('R',200 );
  
  delay(1100);
}
void loop ()
{
  leftMotor('S',200);
  rightMotor('S',200);
  //leftMotor('F',200);
  //rightMotor('F',200);
}// loop 

void leftMotor(char temp1, int velocity )
{
  
  if( temp1== 'F' )
  {
    analogWrite(11, velocity);
    digitalWrite(8,HIGH);
    digitalWrite(9,LOW);
  }
  if( temp1== 'R' )
  {
    analogWrite(11, velocity);
    digitalWrite(9,HIGH);
    digitalWrite(8,LOW);
  }
  if( temp1== 'S' )
  {
    digitalWrite(8,HIGH);
    digitalWrite(9,HIGH);
  }
}

void rightMotor(char temp1, int velocity )
{
  
  if( temp1== 'F' )
  {
    analogWrite(6, velocity);
    digitalWrite(12,HIGH);
    digitalWrite(7,LOW);
  }
  if( temp1== 'R' )
  {
    analogWrite(6, velocity);
    digitalWrite(7,HIGH);
    digitalWrite(12,LOW);
  }
  if( temp1== 'S' )
  {
    digitalWrite(12,HIGH);
    digitalWrite(7,HIGH);
  }
}
/////**************************************** gggggggggggggggggyyyyyyyyyyyyyyyyyrrrrrrrrrrrrrrrrrrrrroooooooooooooooooooo *****************************////////////////
/*Wire.beginTransmission(MPU);
    Wire.write(0x47);  // starting with register 0x3B (ACCEL_XOUT_H)
    Wire.endTransmission(false);
    Wire.requestFrom(MPU,2,true);  // request a total of 14 registers
    GyZ=((Wire.read()<<8|Wire.read())+180)/gsens;  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
    
    GZ=GZ+GyZ*0.01-0.00032;//-0002*GZL-0.002*GZLL; 0.0105 is best
    corr = GZ * 10;
    if(200 + corr > 255)
     {
       corr = 55;
     }
     else if (110 - corr < 0)
       corr = 110;
      leftMotor('F', 110 - corr);
      rightMotor('F',200 + corr);
    
    delay(10);*/
    /////////////***********************    *******************///////////
  /*   Wire.begin();
  Wire.beginTransmission(MPU);
  Wire.write(0x6B);  // PWR_MGMT_1 register
  Wire.write(0);     // set to zero (wakes up the MPU-6050)
  Wire.endTransmission(true);
  // SET LOW PASS FILTER
  Wire.beginTransmission(MPU);
  Wire.write(filter); 
  Wire.write(04);     
  Wire.endTransmission(true);
  Serial.begin(9600);
  Wire.begin();
  //Timer1.initialize(100000); // set a timer of length 100000 microseconds
  //Timer1.attachInterrupt( timerIsr ); // attach the service routine here
*/
