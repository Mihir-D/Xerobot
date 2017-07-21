boolean ledstate=HIGH;
void setup()
{
  pinMode(A0,INPUT);
  pinMode(8,OUTPUT);
  Serial.begin(9600);
}
void loop()
{ledstate=!ledstate;
  digitalWrite(8,ledstate);
  Serial.println(analogRead(A0));
  delay(1000);
}
