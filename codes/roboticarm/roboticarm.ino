#include<Wire.h>
#include <EEPROM.h>
// declare all current position variables
int wristp=EEPROM.read(0); int elbowp=EEPROM.read(1); int basep=EEPROM.read(2);int basemotorp=EEPROM.read(3); // 120 300 180 270
boolean gripp= false;  // false is ungrip and true is grip. 
// we'll update motor positions everytime 
byte driver=0xFF;

void driverwrite(byte driver)
{
  Wire.beginTransmission(32); // transmit to device #4
  Wire.write(driver);              // sends one byte  
  Wire.endTransmission(); 
}   // stop transmitting}

void resetarm()
{
wrist(60);
elbow(150);
base(90);
basemotor(135);
}
void wrist(int wristpnew)// wrist motor reset at 60
{if(wristp>wristpnew)
{
  //rotate forward
 driver=driver&&0xFE;
 driver=driver||0x02;
 driverwrite(driver);
  delay((wristp-wristpnew)/120/*constant time*/);
driver=driver||0x03;
driverwrite(driver);
}
if(wristp<wristpnew)
{
  //rotate reverse
 driver=driver&&0xFD;
 driver=driver||0x01;
 driverwrite(driver);
 
  delay((wristpnew-wristp)/120/*constant time*/);
driver=driver||0x03;
driverwrite(driver);
}
wristp=wristpnew; // now update position variable
EEPROM.write(0,wristp);
}


void elbow(int elbowpnew)
{
  // elbow motor reset at 150
if(elbowp>elbowpnew)
{
  //rotate forward
driver=driver&&0xFB;
 driver=driver||0x08;
 driverwrite(driver);
 
  delay((elbowp-elbowpnew)/300/*constant time*/);
driver=driver||0x0C;
driverwrite(driver);

}
if(elbowp<elbowpnew)
{
  //rotate reverse
  driver=driver&&0xF7;
 driver=driver||0x04;
 driverwrite(driver);
 
  delay((elbowpnew-elbowp)/300/*constant time*/);
driver=driver||0x0C;
driverwrite(driver);
}
elbowp=elbowpnew; // update elbow motor position
EEPROM.write(1,elbowp);
}

void base(int basepnew)
{// base vertival motor reset at 90
if(basep>basepnew)
{
  //rotate forward
 driver=driver&&0xEF;
 driver=driver||0x20;
 driverwrite(driver);
 
  delay((basep-basepnew)/180/*constant time*/);
driver=driver||0x30;
driverwrite(driver);
}
if(basep<basepnew)
{
  //rotate reverse
  driver=driver&&0xDF;
 driver=driver||0x10;
 driverwrite(driver);
 
  delay((basepnew-basep)/180/*constant time*/);
driver=driver||0x30;
driverwrite(driver);
}
basep=basepnew; // update base vertical motor position

EEPROM.write(2,basep);
}


void basemotor(int basemotorpnew)
{
  if(basemotorp>basemotorpnew)
{
  //rotate forward
  driver=driver&&0xBF;
 driver=driver||0x80;
 driverwrite(driver);
 
  delay((basemotorp-basemotorpnew)/270/*constant time*/);
driver=driver||0xC0;
driverwrite(driver);
}
if(basemotorp<basemotorpnew)
{
  //rotate reverse
 driver=driver&&0x7F;
 driver=driver||0x40;
 driverwrite(driver);
 delay((basemotorpnew-basemotorp)/270/*constant time*/);
driver=driver||0xC0;
driverwrite(driver);
}
basemotorp=basemotorpnew; // update elbow motor position
EEPROM.write(3,basemotorp);

}



void setup()
{
  Wire.begin(); // join i2c bus 
}
void loop()
{}
