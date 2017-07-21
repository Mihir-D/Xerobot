
// Calculates the extreme points of right hand

import SimpleOpenNI.*;
SimpleOpenNI kinect;

//from Object Recognition
float[] rightHandx = {0,0,0,0,0,0,0,0,0,0};
float[] rightHandy = {0,0,0,0,0,0,0,0,0,0};
//float[] lengthdata=  {0,0,0,0,0,0,0,0,0,0};
//float[] breadthdata= {0,0,0,0,0,0,0,0,0,0};

int count = 0/*for averaging of hand*/, ref_depth, fcount=0;  //this counter is used for averaging the x and y coordinates of different joint
int blue_count=0,red_count=0,green_count=0,object_area=0;
int palmx=0,palmy=0;
int xmax,xmin,ymax,ymin;
int d1, d2, d3, d4;
float avglength=0,avgbreadth=0;
int minl,maxl,minb,maxb;
float avgx,avgy;

//from object detection
int[][] matrix = new int[640][480];
int i, j, index,lastIndex=0,pixelCount = 1,iavg=0,javg=0;
int avgIndex = 0;
color []array= new color [307200];
PImage edge;
 long lastTime = 0;
 color c;

/********* Extreme point variable declaration ************/ 

int xprev1 = 0, xprev2, xcurr = 0, yprev1 = 0, yprev2, ycurr = 0, zprev1 = 0, zprev2, zcurr = 0;
int xarr[] = new int[1000], yarr[] = new int[1000], zarr[] = new int[1000];
int x = 0, y = 0, z = 0; // index of iarr[]
int start = 0;

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
PImage depth = kinect.depthImage();
edge = kinect.rgbImage();

edge.loadPixels();
//image(depth, 0, 0);
PVector []depthValues = kinect.depthMapRealWorld();
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
// make a vector to store the left hand
PVector rightHand = new PVector();
// put the position of the left hand into that vector
float confidence = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,rightHand);
// convert the detected hand position
// to "projective" coordinates
// that will match the depth image
PVector convertedRightHand = new PVector();
kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
// and display it
ellipse(convertedRightHand.x, convertedRightHand.y, 10, 10);
//println(confidence);
avgx=convertedRightHand.x;
avgy=convertedRightHand.y;

index = abs((int)avgx+(int)avgy*640);  //abs() is needed otherwise index goes out of bounds(probably negative)

 if(index < 307199){   // exception handling+


if(confidence==1.0 ) // only executed if skeleton is detected perfectly
{
  
  
  /***************** Calucating Extreme Points ***************/
  if(start == 0)
  {
  xprev1 = (int)depthValues[index].x; yprev1 = (int)depthValues[index].y; zprev1 = (int)depthValues[index].z;
  xprev2 = (int)depthValues[index].x; yprev2 = (int)depthValues[index].y; zprev2 = (int)depthValues[index].z;
  xcurr = (int)depthValues[index].x; ycurr = (int)depthValues[index].y; zcurr = (int)depthValues[index].z;
  xarr[x++] = xcurr;
  yarr[y++] = ycurr;
  zarr[z++] = zcurr;
  start = 1;
  }
  
  xcurr = (int)depthValues[index].x;
  ycurr = (int)depthValues[index].y;
  zcurr = (int)depthValues[index].z;
  
  if( abs(xcurr - xprev1) > 10)
  {
    if(xprev1 - xprev2 < 0 && xcurr - xprev1 >0 || xprev1 - xprev2 > 0 && xcurr - xprev1 <0){
      xarr[x++] = xcurr;
      println("X:" + xcurr);
    }
    xprev2 = xprev1;
    xprev1 = xcurr;
  }
  if( abs(ycurr - yprev1) > 10)
  {
    if(yprev1 - yprev2 < 0 && ycurr - yprev1 >0 || yprev1 - yprev2 > 0 && ycurr - yprev1 <0){
      yarr[y++] = ycurr;
     // println("Y:" + ycurr);
    }
    yprev2 = yprev1;
    yprev1 = ycurr;
  }
  if( abs(zcurr - zprev1) > 10)
  {
    if(zprev1 - zprev2 < 0 && zcurr - zprev1 >0 || zprev1 - zprev2 > 0 && zcurr - zprev1 <0){
      zarr[z++] = zcurr;
      //println("Z:" + zcurr);
    }
    zprev2 = zprev1;
    zprev1 = zcurr;
  }


  }//exception if ends here
}//if (confidence=1)


}// if kinect.isTrackingId
}// if userList
image(edge,0,0);
fill(255,0,0);
ellipse(avgx, avgy, 10, 10);


  

}//draw loop


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
