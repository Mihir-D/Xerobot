void setup()
{
  pinMode(A0,INPUT);
  Serial.begin(9600);
}

void loop()
{
  //Serial.println(analogRead(A2)); // horizontal 90 750  0 900
  //Serial.println(analogRead(A1)); // vertical  0  556 45 750
  Serial.println(analogRead(A0)); // elbow  0  580 90 231
  delay(100);
  
  
}
