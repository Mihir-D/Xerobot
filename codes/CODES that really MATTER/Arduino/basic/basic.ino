#include<Wire.h>
int basemotorp,basep,elbowp,wristp;
void setup()
{
Wire.begin();
Serial.begin(9600);
}
void loop()
{
  Wire.beginTransmission(0x4F);
Wire.write(0x04);
Wire.endTransmission();
Wire.requestFrom(0x4F,5);
  
basemotorp = Wire.read();
basemotorp = Wire.read();// repeat due to adc sends it twice
basep=Wire.read();
elbowp = Wire.read();
wristp=Wire.read();
//Serial.println(elbowp);
//Serial.println(basep);Serial.println(basemotorp);Serial.println(wristp);
Serial.println(basemotorp);

}
