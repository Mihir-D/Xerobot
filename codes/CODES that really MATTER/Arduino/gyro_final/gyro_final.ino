#include<Wire.h>
# define gsens 131.000
# define asens 16384.000

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
  Wire.write(0x47);  // starting with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU,2,true);  // request a total of 14 registers
  GyZ=((Wire.read()<<8|Wire.read())+180)/gsens;  // 0x47 (GYRO_ZOUT_H) & 0x48 (GYRO_ZOUT_L)
  delay(10);
  
  GZ=GZ+GyZ*0.01-0.00025;//-0002*GZL-0.002*GZLL; 0.0105 is best
  

  Serial.println(GZ);


}
