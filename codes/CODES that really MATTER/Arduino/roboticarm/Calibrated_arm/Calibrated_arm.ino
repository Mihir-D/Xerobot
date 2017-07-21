#include<Wire.h>
int elbowp,basep,basemotorp; // current position
int elbowpnew,basepnew,basemotorpnew,temp;
boolean gripp= false; 
byte driver=0xFF;

void setup()
{
 Serial.begin(9600); 
 driverwrite(driver); // stop all motors in arm   
 update(); 
 resetarm();  
}

void loop()
{ 
  update();
  
  while(Serial.available() < 6); // not enough serial data wait here
  readserialdata();
      
  if(elbowp < elbowpnew )
   //rotate forward
  {
    driver=driver&&0xFB;
    driver=driver||0x08;
    driverwrite(driver);
  }
  if(elbowp > elbowpnew )
   //rotate backward
  {
    driver=driver&&0xF7;
    driver=driver||0x04;
    driverwrite(driver);
  }
  if(basemotorp < basemotorpnew ) 
   {
   //rotate forward
  driver=driver&&0xBF;
  driver=driver||0x80;
  driverwrite(driver);
   }
  
  if(basemotorp > basemotorpnew ) 
  {
   //rotate reverse
  driver=driver&&0x7F;
  driver=driver||0x40;
  driverwrite(driver);
  }

  if(basep<basepnew)
  { // rotate forward
    driver=driver&&0xEF;
  driver=driver||0x20;
  driverwrite(driver);
   }
  
   if(basep>basepnew)
  { // rotate reverse
    driver=driver&&0xDF;
  driver=driver||0x10;
  driverwrite(driver);
  }  
  
  delay(20);
  driverwrite(0xFF); 

}

void driverwrite(byte driver)
{
  Wire.beginTransmission(32); // transmit to device #4
  Wire.write(driver);              // sends one byte  
  Wire.endTransmission(); 
}

void update()
 {
  elbowp= readadc(0);
  elbowp= (elbowp-277)/225;
  
  basep=readadc(1);
  basep= (basep-68)/328;
  
  basemotorp=readadc(2);
  basemotorp=(basemotorp-108)/135;  
 }

 int readadc(int test)
 {
   // subroutine to read adc 4002 by i2c


 }
void readserialdata()
{
  if(Serial.read()==250 )// elbow data
  elbowpnew = Serial.read();
  if(Serial.read()== 240) // basep data
  basepnew = Serial.read();
  if(Serial.read() == 230) // basemotor vertical data
  basemotorpnew=Serial.read();

} 
void resetarm()
 {
  if(elbowp <45 )
   //rotate forward
  {
    driver=driver&&0xFB;
    driver=driver||0x08;
    driverwrite(driver);
    while(elbowp< 45)
    update();
  
  driver=driver||0x0C;
  driverwrite(driver);  
   }
 
  
  
  if(elbowp >45 )
   //rotate backward
  {
    driver=driver&&0xF7;
    driver=driver||0x04;
    driverwrite(driver);
    
    while(elbowp> 45)
    update();
  
    driver=driver||0x0C;
    driverwrite(driver);
  
   }
 
   
  if(basemotorp < 90 ) 
   {
   //rotate forward
  driver=driver&&0xBF;
  driver=driver||0x80;
  driverwrite(driver);
   while(basemotorp < 90 )
  update(); 
  driver=driver||0xC0;
  driverwrite(driver);

   }
  
  if(basemotorp > 90 ) 
  {
   //rotate reverse
  driver=driver&&0x7F;
  driver=driver||0x40;
  driverwrite(driver);
  while(basemotorp > 90 )
  update(); 
  
  driver=driver||0xC0;
  driverwrite(driver);
  
  }
  
  
  if(basep<45)
  { // rotate forward
    driver=driver&&0xEF;
  driver=driver||0x20;
  driverwrite(driver);
  while(basep<45)
  update();
  driver=driver||0x30;
  driverwrite(driver);
 
  }
  
   if(basep>45)
  { // rotate reverse
    driver=driver&&0xDF;
  driver=driver||0x10;
  driverwrite(driver);
  while(basep>45)
  update();
  driver=driver||0x30;
  driverwrite(driver);
 
  }
  
 }

