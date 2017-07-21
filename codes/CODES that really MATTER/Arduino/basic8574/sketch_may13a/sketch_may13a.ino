#include<Wire.h>

// declare all current position variables
int wristp , elbowp , basep , basemotorp; 
int wristpnew , elbowpnew , basepnew , basemotorpnew; 

boolean gripp= false;  // false is ungrip and true is grip. 
// we'll update motor positions everytime 
byte driver= 0xFF;

// elbow -90             0        912
// elbow +135           225       277
// base vertical  135   135       568
// base vertical  0      0        108
// base horzontal 0      0        68
// base horzontal 90     90       324 

void readAdc()
{
/*Wire.beginTransmission(0x4F);
Wire.write(0x04);
Wire.endTransmission();
Wire.requestFrom(0x4F,5);
*/
//basemotorp = Wire.read();
basemotorp =analogRead(A2);// repeat due to adc sends it twice
basep=analogRead(A1);
elbowp =analogRead(A0);
//wristp=Wire.read();
 //conveting to angles
 basep = map(basep, 454 , 286 , 0 , 45 );
 basemotorp = map(basemotorp, 90 , 320 , 0 , 90  );
 elbowp= map(elbowp, 450, 800 , 0 , 90) ;


}

void driverwrite(byte driver)
{
  Wire.beginTransmission(39); // transmit to device #4
  Wire.write(driver);              // sends one byte  
  Wire.endTransmission(); 
}   // stop transmitting}

void resetarm()
{
//wrist(60);
elbowpnew=0;
basepnew=0;
basemotorpnew=45;

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

driver=driver&0xFB;
 driver=driver||0x08;
 driverwrite(driver);
 

}
else if(elbowp<elbowpnew)
{
  //rotate reverse
  driver=driver&0xF7;
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


boolean led=true;
void setup()
{
  Serial.begin(9600);
  Wire.begin(); // join i2c bus 
  //readAdc();
  //resetarm();
  
pinMode(A0,INPUT);
pinMode(A1,INPUT);
pinMode(A2,INPUT);
pinMode(13,OUTPUT);
  driverwrite(0x00);
}
void loop()
{
  readAdc();
  
  if(Serial.available()  )
 { 
   //basemotorpnew=Serial.read();
  // basemotorpnew=40;
   //basepnew=Serial.read();
   //if((elbowpnew+10)==45)
   //digitalWrite(13,LOW);
  //else digitalWrite(13,HIGH);
   elbowpnew=Serial.read();
  //Serial.println(elbowpnew); 
   //basemotor();
  //base();
   if(elbowpnew > elbowp){
     digitalWrite(13, HIGH);
   }  
   else
     digitalWrite(13, HIGH);
  }
    //driverwrite(0x00);
//Serial.println(elbowp);
//Serial.println(basep);
//Serial.println(basemotorp);

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

