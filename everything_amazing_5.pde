/*
EVERYTHING INCREDIBLE 

included wm and timing in note

sketches for a piezo based album

Kawandeep Virdee
*/

float pitch = 1000;
int wm = 255;
int s=0;
float dur = 20;

void setup() {                
  // initialize the digital pin as an output.
  //  We connect the motor to pin 9
  pinMode(9, OUTPUT);  
  Serial.begin(9600);
  analogWrite(9, 0);
}

void loop() {
  
  s+=1;
  //define pitch 
  pitch = coolDoubleTriangles(s);
  
  //define width
  wm = prettyCool(s);
  
  //define dur
  dur = coolDoubleTriangles(s);
  
  
  //map it up
  pitch = map(pitch,0,42,1000,300);
  dur = map(dur, 0, 16, 100 ,10);
  wm = map(wm, 0,16,200,255);
  
  //play tone
  playTone();
  
  //serial
  serialPrint();
  
}

void playTone(){
  float x = 0.0;
  float len = dur/1000.0;
  while(x<len){
  x += 0.001*pitch/1000; //this fixes change in time between notes
  //LFO effect sweet interference patterns, 
  analogWrite(9, wm);
  delayMicroseconds(pitch); //its this delay that causes a pitch to be heard
  analogWrite(9, 0);
  delayMicroseconds(pitch);
  }
  
}

float LFO_pwm(float x){
  float y = 255.0 * ( 1.0 + sin(x) )/2.0; 
  return y;
}

void serialPrint(){
  //what comes out
  Serial.print(pitch);
    Serial.print(" ");
     Serial.print(dur);
    Serial.print(" ");
     Serial.println(wm);
}

int coolDoubleTriangles(int t){
  int out = abs(16-((t/2)<<1)%16)*(t%2); 
  out+= (((t/2)<<1)%16)*((t+1)%2);   
  return out;
}

int prettyCool(int t){
 return abs(16-(t^2)|(t%5)&t^2)%16;  
}

int slowIncrease(int t){
 int out =((5 + t%3)+ (t>>5) % 42) * (t%2); if(out==0){out=((t>>5)+1%42);}  
 return out;
}

int triangle(int t){
  int out = (t<<1) %16;
  return out;
}

int interfere(int t){
 int out = ((t<<1)%42 + ((t+t>>4)<<2)%42); 
 out%=42;
 return out;
}
