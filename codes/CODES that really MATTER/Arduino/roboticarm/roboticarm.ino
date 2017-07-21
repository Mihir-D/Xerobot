#include<Wire.h>
#include <EEPROM.h>
// declare all current position variables
int wristp , elbowp , basep , basemotorp; 
int wristpnew , elbowpnew , basepnew , basemotorpnew; 

boolean gripp= false;  // false is ungrip and true is grip. 
// we'll update motor positions everytime 
byte driver=0xFF;

// elbow -90             0        912
// elbow +135           225       277
// base vertical  135   135       568
// base vertical  0      0        108
// base horzontal 0      0        68
// base horzontal 90     90       324 

void readAdc()
{
Wire.beginTransmission(90);
Wire.write(0x04);
Wire.endTransmission();
Wire.requestFrom(90,5);
  
basemotorp = Wire.read();
basemotorp = Wire.read();// repeat due to adc sends it twice
basep=Wire.read();
elbowp = Wire.read();
wristp=Wire.read();
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
elbowpnew=90;
basepnew=90;
basemotorpnew=45;
}

void elbow()
{
  // elbow motor reset at 150
if(elbowp>elbowpnew)
{
  //rotate forward
driver=driver&&0xFB;
 driver=driver||0x08;
 driverwrite(driver);
 
if(elbowp>elbowpnew)  
  {  driver=driver||0x0C;
     driverwrite(driver);  
  }

}
if(elbowp<elbowpnew)
{
  //rotate reverse
  driver=driver&&0xF7;
 driver=driver||0x04;
 driverwrite(driver);
 
  if(elbowp>elbowpnew)
  {  driver=driver||0x0C;
     driverwrite(driver);
  }
}

}

void base()
{// base vertival motor reset at 90
if(basep>basepnew)
{
  //rotate forward
 driver=driver&&0xEF;
 driver=driver||0x20;
 driverwrite(driver);
 
  if(basep<basepnew)   
  {  driver=driver||0x30;
     driverwrite(driver);
  }
}
if(basep<basepnew)
{
  //rotate reverse
  driver=driver&&0xDF;
 driver=driver||0x10;
 driverwrite(driver);
 
  //condition
    if( basep >basepnew )
    {
      driver=driver||0x30;
      driverwrite(driver);
    }
}
// base vertical motor position


}

//horizontal base motor
void basemotor()
{ 
    
  if(basemotorp>basemotorpnew)
{
  //rotate forward
  driver=driver&&0xBF;
 driver=driver||0x80;
 driverwrite(driver);
 
if(basemotorp<basemotorpnew)
  {
      driver=driver||0xC0;
      driverwrite(driver);
  }
}
if(basemotorp<basemotorpnew)
{
  //rotate reverse
 driver=driver&&0x7F;
 driver=driver||0x40;
 driverwrite(driver);
//conditon
    if(basemotorp>basemotorpnew)
     {
       driver=driver||0xC0;
       driverwrite(driver);
     }

}

}



void setup()
{
  Serial.begin(9600);
  Wire.begin(); // join i2c bus 
  readAdc();
  resetarm();
}
void loop()
{
  readAdc();
  if(Serial.available()>3)
  basemotorpnew=Serial.read();
  basepnew=Serial.read();
  elbowpnew=Serial.read();
  basemotor();
  base();
  elbow();  


}
/*
void grip(boolean temp)// wrist motor reset at 60
{
  if(temp===true && gripp==false)
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
if(temp===false && gripp==true)
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
*/

