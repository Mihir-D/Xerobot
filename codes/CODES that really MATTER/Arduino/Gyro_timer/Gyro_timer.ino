#include<TimerOne.h>
#include<Wire.h>
# define gsens 131.000
# define asens 16384.000

# define filter 26  //low pas filter config address
// write 0x02 for filtering 
//increase value for lower cut off
const int MPU=0x68;  // I2C address of the MPU-6050
float AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;
float GZ=0.00,GZL=0.00,GZLL=0.00;
float AZ=0;
float anglez=0;

void setup() 
{
  // Initialize the digital pin as an output.
  // Pin 13 has an LED connected on most Arduino boards
  //pinMode(13, OUTPUT);    
 Wire.begin();
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
  Timer1.initialize(100000); // set a timer of length 100000 microseconds (or 0.1 sec - or 10Hz => the led will blink 5 times, 5 cycles of on-and-off, per second)
  Timer1.attachInterrupt( timerIsr ); // attach the service routine here
}
 
void loop()
{
  // Main code loop
  // TODO: Put your regular (non-ISR) logic here
Serial.println(GZ);
}
 
/// --------------------------
/// Custom ISR Timer Routine
/// --------------------------
void timerIsr()
{
   Wire.beginTransmission(MPU);
  Wire.write(0x3B);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,14,true);  // request a total of 14 registers
  AcX=(Wire.read()<<8|Wire.read())/asens;  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)     
  AcY=(Wire.read()<<8|Wire.read())/asens;  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  AcZ=(Wire.read()<<8|Wire.read())/asens;  // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
  Tmp=Wire.read()<<8|Wire.read();  // 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L)
  GyX=(Wire.read()<<8|Wire.read())/gsens;  // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  GyY=(Wire.read()<<8|Wire.read())/gsens;  // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  GyZ=(Wire.read()<<8|Wire.read())/gsens;  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
  // Serial.print("AcX = "); Serial.print(AcX);
  // Serial.print(" | AcY = "); Serial.print(AcY);
  // Serial.print(" | AcZ = "); Serial.print(AcZ);
  // Serial.print(" | Tmp = "); Serial.print(Tmp/340.00+36.53);  //equation for temperature in degrees C from datasheet
  // Serial.print(" | GyX = "); Serial.print(GyX);
  // Serial.print(" | GyY = "); Serial.println(GyY/gsens);
  //Serial.println("\n");
  //Serial.print(" | GyZ = "); Serial.println(GyZ/gsens);
  
  GZ=GZL+GyZ*0.01+0.010105;//-0.002*GZL-0.002*GZLL; 
  // original    
  // equation    
  GZLL=GZL;
  GZL=GZ;



    
}
