//9029011813  stay strong nepal
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


void resetarm()
{
//wrist(60);
elbowpnew=45;
basepnew=20;
basemotorpnew=20;

}

void elbow()
{
  // elbow motor reset at 150

  if(abs(elbowp - elbowpnew)<5)
  {  
    digitalWrite(4,HIGH);
    digitalWrite(5,HIGH);
  }
  else if(elbowp>elbowpnew)
{

  //rotate forward

    digitalWrite(4,LOW);
    digitalWrite(5,HIGH);
  

}
else if(elbowp<elbowpnew)
{
  //rotate reverse
    digitalWrite(4,HIGH);
    digitalWrite(5,LOW);
 }

}

void base()
{// base vertival motor reset at 90
if( abs(basep - basepnew)<5 )
    {
      digitalWrite(2,HIGH);
      digitalWrite(3,HIGH);    
    }
else if(basep>basepnew)
{
  //rotate forward
      digitalWrite(2,HIGH);
      digitalWrite(3,LOW);     
  
}
else if(basep<basepnew)
{
  //rotate reverse
      digitalWrite(2,LOW);
      digitalWrite(3,HIGH);     
  //condition
    
}
// base vertical motor position


}

//horizontal base motor
void basemotor()
{ 
   if(abs(basemotorp-basemotorpnew)<5)
  {
      digitalWrite(6,HIGH);
      digitalWrite(7,HIGH);    
  } 
else if(basemotorp>basemotorpnew)
{
  //rotate forward
      digitalWrite(6,HIGH);
      digitalWrite(7,LOW);    
 

}
else  if(basemotorp<basemotorpnew)
{
  //rotate reverse
      digitalWrite(6,LOW);
      digitalWrite(7,HIGH);    
   
}

}


boolean led=true;
void setup()
{
  Serial.begin(9600);
  Wire.begin(); // join i2c bus 
  //readAdc();
  //resetarm();
  pinMode(13,OUTPUT);
pinMode(A0,INPUT);
pinMode(A1,INPUT);
pinMode(A2,INPUT);
pinMode(13,OUTPUT);

}
void loop()
{
  readAdc();
  
  if(Serial.available() > 2 )
 { 
    basemotorpnew = Serial.read() ;
    elbowpnew = Serial.read() ;  
    basemotor();   
    elbow();
  }
  else resetarm();

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

