
char check;

void setup() {
  pinMode(2,OUTPUT);
  pinMode(3,OUTPUT);
  pinMode(5,OUTPUT);
  pinMode(6,OUTPUT);
  pinMode(7,OUTPUT);
  pinMode(8,OUTPUT);
  Serial.begin(9600);
}

// the loop routine runs over and over again forever:
void loop() {
  if(Serial.available())
  {
check= Serial.read();
switch(check)
{
case 'k': digitalWrite(2,HIGH);
        digitalWrite(3,LOW);
        delay(1000);
        digitalWrite(2,HIGH);
        digitalWrite(3,HIGH);
        break;
case 'p': digitalWrite(2,LOW);
        digitalWrite(3,HIGH);
        delay(1000);
        digitalWrite(2,HIGH);
        digitalWrite(3,HIGH);
        break;
case 'm': digitalWrite(7,HIGH);
        digitalWrite(8,LOW);
        delay(1000);
        digitalWrite(7,HIGH);
        digitalWrite(8,HIGH);
        break;
case 'j':digitalWrite(7,LOW);
        digitalWrite(8,HIGH);
        delay(1000);
        digitalWrite(2,HIGH);
        digitalWrite(3,HIGH);
        break;
case 'l':digitalWrite(5,HIGH);
        digitalWrite(6,LOW);
        delay(1000);
        digitalWrite(5,HIGH);
        digitalWrite(6,HIGH);
        break;
case 'r':digitalWrite(5,HIGH);
        digitalWrite(6,LOW);
        delay(1000);
        digitalWrite(5,HIGH);
        digitalWrite(6,HIGH);
        break;
}
}
}
