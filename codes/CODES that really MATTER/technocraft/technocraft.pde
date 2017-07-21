
//In this code we are averaging the x and y coordinates of different joints from 10 frames.
import processing.serial.*;

Serial myPort;  // Create object from Serial class
int i=0;
import SimpleOpenNI.*;
SimpleOpenNI kinect;
float avgx=0,avgy=0;
int temp=240;
float[] rightHandx = {0,0,0,0,0,0,0,0,0,0};
float[] rightHandy = {0,0,0,0,0,0,0,0,0,0};
float[] rightShoulderx = {0,0,0,0,0};
float[] rightShouldery = {0,0,0,0,0};
float[] rightElbowx = {0,0,0,0,0};
float[] rightElbowy = {0,0,0,0,0};
int count = 0;  //this counter is used for averaging the x and y coordinates of different joints
float basemotor,elbowmotor=35;
void setup() {
size(640, 480);
kinect = new SimpleOpenNI(this);
kinect.enableDepth();
// turn on user tracking
kinect.enableUser();

  String portName = Serial.list()[0]; //change the 0 to a 1 or 2 etc. to match your port
  println( Serial.list() );
  myPort = new Serial(this, portName, 9600);

}
void draw() {

kinect.update();
PImage depth = kinect.depthImage();
image(depth, 0, 0);

// make a vector of ints to store the list of users
IntVector userList = new IntVector();
// write the list of detected users
// into our vector
kinect.getUsers(userList);
// if we found any users
if (userList.size() > 0) {
// get the first user
int userId = userList.get(0);
// if we’re successfully calibrated
if ( kinect.isTrackingSkeleton(userId)) {


  // make a vector to store the right hand
PVector rightHand = new PVector();
// put the position of the right hand into that vector
float confidenceRightHand = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
// convert the detected hand position
// to "projective" coordinates
// that will match the depth image
PVector convertedrightHand = new PVector();
kinect.convertRealWorldToProjective(rightHand, convertedrightHand);
avgx=avgx-rightHandx[count]/10.0;
avgy=avgy-rightHandy[count]/10.0;
rightHandx[count] = convertedrightHand.x;
rightHandy[count] = convertedrightHand.y;
avgx=avgx+rightHandx[count]/10.0;
avgy=avgy+rightHandy[count]/10.0; // averaging filter :-p
// and display it
fill(255,0,0);
ellipse(avgx, avgy, 10, 10);


  // make a rightElbowector to store the right hand
PVector rightElbow = new PVector();
// put the position of the right hand into that vector
float confidenceRightElbow = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,rightElbow);
// convert the detected hand position
// to "projective" coordinates
// that will match the depth image
PVector convertedrightElbow = new PVector();
kinect.convertRealWorldToProjective(rightElbow, convertedrightElbow);
// and display it

fill(255,0,0);
ellipse(convertedrightElbow.x, convertedrightElbow.y, 10, 10);


  // make a rightShoulderwector to store the right hand
PVector rightShoulder = new PVector();
// put the position of the right hand into that vector
float confidencerightShoulder = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder);
// convert the detected hand position
// to "projective" coordinates
// that will match the depth image
PVector convertedrightShoulder = new PVector();
kinect.convertRealWorldToProjective(rightShoulder, convertedrightShoulder);
// and display it
fill(255,0,0);
ellipse(convertedrightShoulder.x, convertedrightShoulder.y, 10, 10);
/*
if(myPort.available()>0)
  println((char)myPort.read());
*/
basemotor=avgx-convertedrightElbow.x;
if(basemotor>100)
basemotor=100;
else if(basemotor<-100)
basemotor=-100;
basemotor=((basemotor+100)/200.0 * 180 );
basemotor=basemotor/4;
println("basemotor "  + basemotor);
myPort.write((int)basemotor);
// elbow is still to be calibrated ie d range
elbowmotor=avgy-convertedrightElbow.y;
if(elbowmotor>100)
  elbowmotor=100;
else if(elbowmotor<-100)
  elbowmotor=-100;
elbowmotor=((elbowmotor+100)/200.0 * 180 );
elbowmotor=elbowmotor/2;
elbowmotor=90-elbowmotor;
//if( millis() % 200 == 0)
{
  myPort.write((int)elbowmotor);
  println(elbowmotor);
}

//println(elbowmotor);
//myPort.write(temp); // this signifies next byte is elbowmotor
/*myPort.write((int)elbowmotor);
//myPort.write(i);
println(elbowmotor);
*/   /**************************    last edit  ****************************************/
}
}
count++;
if (count==10)
  count=0;
i++;

//myPort.write(i);

}




// user-tracking callbacks!
void onNewUser(SimpleOpenNI kinect, int userID){
  println("Start skeleton tracking");
  kinect.startTrackingSkeleton(userID);
}
void onEndCalibration(int userId, boolean successful) {
if (successful) {
println(" User calibrated !!!");
kinect.startTrackingSkeleton(userId);
} else {
println(" Failed to calibrate user !!!");
 kinect.startTrackingSkeleton(userId);
}
}
void onStartPose(String pose, int userId) {
println("Started pose for user");
kinect.stopTrackingSkeleton(userId);
//kinect.requestCalibrationSkeleton(userId);
}
