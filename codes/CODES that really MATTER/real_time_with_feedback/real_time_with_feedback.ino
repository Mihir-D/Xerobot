int i, check = 0;
int elbowp = 180, basemotorp = 90 ;
int elbowpnew,basemotorpnew; // motor positions to be written on eeprom earlier
int duration;

void setup() 
{
// put your setup code here, to run once:
Serial.begin(9600);
pinMode(13,OUTPUT); //this just to check the program
for (i=2;i<=5;i++)
  pinMode(i,OUTPUT);
i=0;
}

void loop() {
  // put your main code here, to run repeatedly:
//Serial.print(250);
//Serial.print(0);


while (Serial.available()<6);

if(Serial.read() == 201) //basemotor
{
  basemotorpnew = Serial.read();
  if(basemotorpnew > basemotorp)
    startMotor(2,3);
  else
    startMotor(3,2);
}
if(Serial.read() == 202) //basemotor
{
  shouldermotorpnew = Serial.read();
  if(basemotorpnew > basemotorp)
    startMotor(4,5);
  else
    startMotor(5,4);
}
if(Serial.read() == 203) //basemotor
{
  elbowmotorpnew = Serial.read();
  if(basemotorpnew > basemotorp)
    startMotor(6,7);
  else
    startMotor(7,6);
}


if(abs(basemotorpnew - basemotor) < 5){
  stopMotor(2,3);
}
if(abs(shouldermotorpnew - basemotor) < 5){
  stopMotor(4,5);
}
if(abs(elbowmotorpnew - basemotor) < 5){
  stopMotor(6,7);
}



}//loop


void startMotor(int a, int b)     // stops any motor
{
  digitalWrite(a,HIGH);
  digitalWrite(b,LOW);
}

void stopMotor(int a, int b)     // stops any motor
{
  digitalWrite(a,HIGH);
  digitalWrite(b,HIGH);
}


