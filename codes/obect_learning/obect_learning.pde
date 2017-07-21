
//In this code we are averaging the x and y coordinates of different joints from 10 frames.
import processing.serial.*;

Serial myPort;  // Create object from Serial class
int i=0, j, index, palmIndex, iavg=0,javg=0, avgIndex = 0;
int xMin=0,yMin=0, xMax=0, yMax=0;
int objArea, objPixels, rectArea, rectPixels;
int d1, d2, d3, d4;
color []array= new color [307200];
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
float basemotor,elbowmotor;


void setup() {
size(640, 480);
kinect = new SimpleOpenNI(this);
kinect.enableDepth();
kinect.enableRGB();
// turn on user tracking
kinect.enableUser();

}
void draw() {

kinect.update();
PImage edge;
int []depthValues = kinect.depthMap();

//edge.loadPixels();
//image(edge, 0, 0);



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

}
}


//palmIndex = (int)avgx + 640*(int)avgy;
//println(depthValues[palmIndex]);
//println(brightness(edge.pixels[index])); // each value equals 3mm
/*
if(avgx < 50) //temporary
  avgx = 50;
if(avgy < 50)  //temporary
  avgy = 50;

for(i = (int)avgx-50; i < (int)avgx+50; i++){
   for(j = (int)avgy-50; j < (int)avgy+50; j++){
     index = i + j*640;
     
       if(brightness(edge.pixels[index]) - brightness(edge.pixels[palmIndex]) < 20 && brightness(edge.pixels[index]) - brightness(edge.pixels[palmIndex]) > 0){
         //edge.pixels[index] = color(0,0,255);
         objPixels++;
         iavg+=i;
         javg+=j;
         //avgIndex=avgIndex-avgIndex/count + index/count;
       }
    }
   }
   if(objPixels > 0){
   iavg=iavg/objPixels; //wtf????????????????????
   javg/= objPixels;
   }
   else {
     iavg = 0;
     javg = 0;
   }
   avgIndex = iavg+640*javg;
   //image(edge,0,0);
   fill(255,0,0);
   rect((float)iavg, (float)javg, 10.0, 10.0);
   println(objPixels);
*/

//All reseting of variables to be done here

/*******------- Blue Object Detection --------------*************/
edge = kinect.rgbImage();
  edge.loadPixels();
  //println(int(brightness(edge.pixels[10000])));
  int k = 0;
  for(i = 1; i < 640; i++){
    for(j = 1; j < 480; j++){
     index = i + j*640;
     array[index]=edge.pixels[index];
     
}}

  for(i = 1; i < 639; i++){
   for(j = 1; j < 479; j++){
     index = i + j*640;
     //if(((blue(edge.pixels[index]) - red(edge.pixels[index]) > 10)  &&  ((blue(edge.pixels[index]) - green(edge.pixels[index])) > 10))){
     //if((2*blue(edge.pixels[index]) - red(edge.pixels[index]) - green(edge.pixels[index]))/blue(edge.pixels[index])> 0.5) //normalisation
     if(2*blue(edge.pixels[index]) - red(edge.pixels[index]) - green(edge.pixels[index])> 75){
       if(depthValues[index] > 700 && depthValues[index] < 1000){
         edge.pixels[index] = color(0,0,255);
         objPixels++;
         if(xMax == 0 && xMin == 0){
           xMin = i;
           xMax = i;
           yMin = j;
           yMax = j;
         }
         else if(i < xMin){
           xMin = i;
           d1 = j;
         }
         else if(i > xMax){
           xMax = i;
           d2 = j;
         }
         else if(j < yMin){
           yMin = j;
           d3 = i;
         }
         else if(j > yMax){
           yMax = j;
           d4 = i;
         }
         //iavg+=i;
         //javg+=j;
         //avgIndex=avgIndex-avgIndex/count + index/count;
       
     }
       else
         edge.pixels[index] = color(0,0,0);
     }
       
     else
       edge.pixels[index] = color(0,0,0);
    }
   }
   
   edge = kinect.depthImage();
   edge.loadPixels();
   image(edge, 0, 0);
   PVector p1 = new PVector(xMax,d1,depthValues[xMax + 640*d2]);
   PVector p2 = new PVector(xMin,d1,depthValues[xMax + 640*d2]);
   PVector diff = PVector.sub(p1,p2);
   float delx = diff.mag();
   float dely = (delx * (yMax - yMin)) / (xMax - xMin);
   rectPixels = (xMax - xMin)*(yMax - yMin);
   rectArea = (int)(delx * dely); 
   if(rectPixels != 0)
     objArea = (rectArea * objPixels)/rectPixels;  //multiplication should be done first
   println(objArea);
   //println(depthValues[(xMin+xMax + 640*(yMin+yMax))/2 ]  + "  " + (xMax-xMin) );

count++;
if (count==10)
  count=0;
i++;

objPixels = 0;
xMin = 0;
xMax = 0;
yMin = 0;
yMax = 0;
} //draw loop





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
