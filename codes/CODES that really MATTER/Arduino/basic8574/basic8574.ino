#include <Wire.h>

void setup()
{
  Wire.begin(); // join i2c bus (address optional for master)
}

byte data = 0x10; //1101 0101
//byte driver= 0xFF;

void loop()
{
  
driverwrite(data);
 // data=data^0xFF;
  delay(500);
}

void driverwrite(byte temp)
{
  Wire.beginTransmission(39); // transmit to device #4
  Wire.write(temp);              // sends one byte  
  Wire.endTransmission();    // stop transmitting
}
