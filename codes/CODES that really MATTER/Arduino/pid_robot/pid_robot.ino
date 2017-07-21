#include<Wire.h>
# define gsens 131.000
# define asens 16384.000
int value1,value2;
int angle;
# define filter 26  //low pas filter config address
// write 0x02 for filtering 
//increase value for lower cut off
const int MPU=0x68;  // I2C address of the MPU-6050
float AcX,AcY,AcZ,Tmp,GyX,GyY,GyZ;
float GZ=0.00;
float AZ=0;
float anglez=0;
void setup()
{
 pinMode(3,OUTPUT);
 pinMode(5,OUTPUT);
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
}
void loop()
{ 
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,14,true);  // request a total of 14 registers
  AcX=(Wire.read()<<8|Wire.read());  // 0x3B (ACCEL_XOUT_H) & 0x3C (ACCEL_XOUT_L)     
  AcY=(Wire.read()<<8|Wire.read());  // 0x3D (ACCEL_YOUT_H) & 0x3E (ACCEL_YOUT_L)
  AcZ=(Wire.read()<<8|Wire.read());  // 0x3F (ACCEL_ZOUT_H) & 0x40 (ACCEL_ZOUT_L)
  Tmp=Wire.read()<<8|Wire.read();  // 0x41 (TEMP_OUT_H) & 0x42 (TEMP_OUT_L)
  GyX=(Wire.read()<<8|Wire.read());  // 0x43 (GYRO_XOUT_H) & 0x44 (GYRO_XOUT_L)
  GyY=(Wire.read()<<8|Wire.read());  // 0x45 (GYRO_YOUT_H) & 0x46 (GYRO_YOUT_L)
  GyZ=((Wire.read()<<8|Wire.read())+191)/gsens;  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)



  delay(10);
  
  GZ=GZ+GyZ*0.01+0.0000;//-0002*GZL-0.002*GZLL; 0.0105 is best
  // original    
  // equation   
//  Serial.println(GZ);

angle=GZ;
value1 =100+ angle*5;
value2 = 100-angle*5;
analogWrite(3,value1);
analogWrite(5,value2);

Serial.print(value1);
Serial.print("   ");
Serial.print(value2);
Serial.print("   ");
Serial.println(GZ);


}
