import SimpleOpenNI.*;
SimpleOpenNI kinect;

//from Object Recognition
float[] rightHandx = {0,0,0,0,0,0,0,0,0,0};
float[] rightHandy = {0,0,0,0,0,0,0,0,0,0};
//float[] lengthdata=  {0,0,0,0,0,0,0,0,0,0};
//float[] breadthdata= {0,0,0,0,0,0,0,0,0,0};
int count = 0/*for averaging of hand*/, ref_depth, fcount=0, mode = 0 ;  //this counter is used for averaging the x and y coordinates of different joint
int blue_count=0,red_count=0,green_count=0,object_area=0;
int palmx=0,palmy=0;
int xmax,xmin,ymax,ymin;
int d1, d2, d3, d4;
float avglength=0,avgbreadth=0;
int minl,maxl,minb,maxb;
float avgx,avgy;

//from object detection
int[][] matrix = new int[640][480];
int i, j, index, index1, lastIndex=0, pixelCount = 1;
float iavg=0, javg=0;
int avgIndex = 0;
color []array= new color [307200];
PImage edge;
 long lastTime = 0;
 color c;

PVector leftHand = new PVector();
PVector leftElbow = new PVector();
PVector leftShoulder = new PVector();
PVector rightHand = new PVector();    // make a vector to store the left hand
PVector rightElbow = new PVector();
PVector rightShoulder = new PVector();
PVector head = new PVector();
PVector torso = new PVector();

// convert the detected hand position
// to "projective" coordinates
// that will match the depth image
PVector convertedLeftHand = new PVector();
PVector convertedLeftElbow = new PVector();
PVector convertedLeftShoulder = new PVector();
PVector convertedRightHand = new PVector();
PVector convertedRightElbow = new PVector();
PVector convertedRightShoulder = new PVector();
PVector convertedHead = new PVector();
PVector convertedTorso = new PVector();


/********* Extreme point variable declaration ************/ 

int xprev1 = 0, xprev2, xcurr = 0, yprev1 = 0, yprev2, ycurr = 0, zprev1 = 0, zprev2, zcurr = 0;
int xarr[] = new int[1000], yarr[] = new int[1000], zarr[] = new int[1000];

int x = 0, y = 0, z = 0; // index of iarr[]
int start = 0;

//Serial myPort;

void setup() {
size(640, 480);
kinect = new SimpleOpenNI(this);
kinect.enableDepth();
kinect.enableRGB();

// turn on user tracking
kinect.enableUser();

//myPort = new Serial(this, portName, 9600);
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
//PVector rightHand = new PVector();
// put the position of the left hand into that vector
float confidence = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
// convert the detected hand position
// to "projective" coordinates
// that will match the depth image
//PVector convertedRightHand = new PVector();
kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
// and display it
ellipse(convertedRightHand.x, convertedRightHand.y, 10, 10);
//println(confidence);

/*avgx=avgx-rightHandx[count]/10.0;
avgy=avgy-rightHandy[count]/10.0;
rightHandx[count] = convertedRightHand.x;
rightHandy[count] = convertedRightHand.y;
avgx=avgx+rightHandx[count]/10.0;
avgy=avgy+rightHandy[count]/10.0; // averaging filter :-p
*/

// put the position of the left hand into that vector
float confidence1 = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_HAND,leftHand);
float confidence2 = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_ELBOW,leftElbow);
float confidence3 = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_LEFT_SHOULDER,leftShoulder);
float confidence4 = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_HAND,rightHand);
float confidence5 = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_ELBOW,rightElbow);
float confidence6 = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_RIGHT_SHOULDER,rightShoulder);
float confidenceHead = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,head);
float confidenceTorso = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_TORSO,torso);

kinect.convertRealWorldToProjective(leftHand, convertedLeftHand);
kinect.convertRealWorldToProjective(leftElbow, convertedLeftElbow);
kinect.convertRealWorldToProjective(leftShoulder, convertedLeftShoulder);
kinect.convertRealWorldToProjective(rightHand, convertedRightHand);
kinect.convertRealWorldToProjective(rightElbow, convertedRightElbow);
kinect.convertRealWorldToProjective(rightShoulder, convertedRightShoulder);
kinect.convertRealWorldToProjective(head, convertedHead);
kinect.convertRealWorldToProjective(torso, convertedTorso);


avgx=convertedRightHand.x;
avgy=convertedRightHand.y;

index1 = abs((int)avgx+(int)avgy*640);  //abs() is needed otherwise index goes out of bounds(probably negative)

 if(index1 < 307199 && avgx>40 && avgx<600 && avgy>40 && avgy<430){   // exception handling+
 
// PUT EVERYTHING HERE
/***************************************************************** MODE 0 ***************************************************/

if(mode == 0){   // for checking mode of operation( default mode)
 // println("checking mode now");
 
   //gesture : The if condition below checks if both hands are up
    if(convertedLeftHand.y < convertedLeftShoulder.y && convertedLeftElbow.y < convertedLeftShoulder.y && convertedRightHand.y < convertedRightShoulder.y && convertedRightElbow.y < convertedRightShoulder.y){
        mode = 2;
        println("execution mode ");
    }

    //gesture : start learning mode- Right hand up
     else if(convertedRightHand.y < convertedRightShoulder.y && convertedRightElbow.y < convertedRightShoulder.y){
        mode = 1;
    println(" learning mode ");  
    }
}

/***************************************************************** MODE 1 ***************************************************/
else if(mode == 1){ // for learning mode
    ref_depth=(int)depthValues[index1].z;

if(confidence==1.0 ) // only executed if skeleton is detected perfectly
{
  for(i=(int)avgx-30;    i< (int)avgx+30 ;   i++){
    for(j=(int)avgy-30;   j<(int)avgy+30;  j++){
     index = i + j*640;
     if(((blue(edge.pixels[index]) - red(edge.pixels[index]) >40 )  &&  ((blue(edge.pixels[index]) - green(edge.pixels[index])) > 40))){
     //if((2*blue(edge.pixels[index]) - red(edge.pixels[index]) - green(edge.pixels[index]))/blue(edge.pixels[index])> 0.5) //normalisation
    // if(2*red(edge.pixels[index]) - blue(edge.pixels[index]) - green(edge.pixels[index])> 95){
       if(abs((int)(depthValues[index].z - ref_depth)) < 200){
         edge.pixels[index] = color(0,0,255);
         pixelCount++;
         iavg+=i;
         javg+=j;
         //avgIndex=avgIndex-avgIndex/count + index/count;
       
     }
       else
         edge.pixels[index] = color(0,0,0);
     }
       
     else
       edge.pixels[index] = color(0,0,0);
    }
   }
   
    //println(pixelCount);
   if ( pixelCount  > 300 )
  {
    
   iavg=iavg/pixelCount; //wtf????????????????????
   javg/=pixelCount;
   avgIndex = (int)iavg+640*(int)javg;
    
  
  //println(depthValues[index].z);
  
  
  //image(edge,0,0);
  //fill(255,0,0);
  //rect((float)iavg, (float)javg, 10.0, 10.0);
  updatePixels();   // to load original image with changed values
  
  /***************** Calucating Extreme Points ***************/
if(start == 0)
  {
  xprev1 = (int)depthValues[avgIndex].x; yprev1 = (int)depthValues[avgIndex].y; zprev1 = (int)depthValues[avgIndex].z;
  xprev2 = (int)depthValues[avgIndex].x; yprev2 = (int)depthValues[avgIndex].y; zprev2 = (int)depthValues[avgIndex].z;
  xcurr = (int)depthValues[avgIndex].x; ycurr = (int)depthValues[avgIndex].y; zcurr = (int)depthValues[avgIndex].z;
  xarr[x++] = xcurr;
  yarr[y++] = ycurr;
  zarr[z++] = zcurr;
  start = 1;
  println(avgIndex);
  println("X:" + xcurr + "Y:" + ycurr + "Z:" + zcurr);
  }
  
  xcurr = (int)depthValues[avgIndex].x;
  ycurr = (int)depthValues[avgIndex].y;
  zcurr = (int)depthValues[avgIndex].z;
  /*
  if( abs(xcurr - xprev1) > 10)
  {
    if(xprev1 - xprev2 < 0 && xcurr - xprev1 >0 || xprev1 - xprev2 > 0 && xcurr - xprev1 <0){
      xarr[x++] = xcurr;
      //println("X:" + xcurr);
    }
    xprev2 = xprev1;
    xprev1 = xcurr;
  }
  if( abs(ycurr - yprev1) > 10)
  {
    if(yprev1 - yprev1 < 0 && ycurr - yprev1 >0 || yprev1 - yprev2 > 0 && ycurr - yprev1 <0){
      yarr[y++] = ycurr;
      //println("Y:" + ycurr);
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
  }*/


  } // if ( pixelCount  >  )
  if(convertedLeftHand.y < convertedLeftShoulder.y && convertedLeftElbow.y < convertedLeftShoulder.y){
  mode = 0 ; start = 0;
  println(" stop mode ");
  println("X1:" + xcurr + "Y1:" + ycurr + "Z1:" + zcurr);
  xarr[1] = xcurr; yarr[1] = ycurr; zarr[1] = zcurr;
  }
  }//if (confidence=1)
}// mode 1


image(edge,0,0);
fill(0,255,0);
ellipse((float)avgx, (float)avgy, 10.0, 10.0);
if(pixelCount > 300){
fill(255,0,0);
ellipse((float)iavg, (float)javg, 10.0, 10.0);
}

//println(iavg + "  " + javg+ "  " + pixelCount);
count++;
if (count==10)
  count=0;
  
iavg = 0; javg = 0; pixelCount = 1;
blue_count=0;red_count=0;green_count=0;object_area=0;

}//exception if ends here

/***************************************************************** MODE 2 ***************************************************/

else if(mode == 2){  //for execution mode
 
 /*if(convertedLeftHand.y < convertedLeftShoulder.y && convertedLeftElbow.y < convertedLeftShoulder.y){
  mode = 2 ;*/

mode=0;

int scale = 10;  // The scale is used because processing can send values only upto 255. Thus larger values are scaled down.
/*myport.write(scale);
myport.write((int)(xarr[0]/scale));
myport.write((int)(zarr[0]/scale));
myport.write((int)(xarr[1]/scale/20));
myport.write((int)(zarr[1]/scale/20));
*/
println((int)(xarr[0]/scale));
println((int)(zarr[0]/scale));
println((int)(xarr[1]/scale/20));
println((int)(zarr[1]/scale/20));

/*
if(myPort.available())
  if(myPort.read() == 's')
    mode = 0;
    */
} 

  
  drawSkeleton(userId);  //Function written to draw skeleton

}// if kinect.isTrackingId
}// if userList

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


void drawSkeleton(int userId) {
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_HEAD,
SimpleOpenNI.SKEL_NECK);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_NECK,
SimpleOpenNI.SKEL_LEFT_SHOULDER);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_LEFT_SHOULDER,
SimpleOpenNI.SKEL_LEFT_ELBOW);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_LEFT_ELBOW,
SimpleOpenNI.SKEL_LEFT_HAND);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_NECK,
SimpleOpenNI.SKEL_RIGHT_SHOULDER);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_RIGHT_SHOULDER,
SimpleOpenNI.SKEL_RIGHT_ELBOW);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_RIGHT_ELBOW,
SimpleOpenNI.SKEL_RIGHT_HAND);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_LEFT_SHOULDER,
SimpleOpenNI.SKEL_TORSO);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_RIGHT_SHOULDER,
SimpleOpenNI.SKEL_TORSO);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_TORSO,
SimpleOpenNI.SKEL_LEFT_HIP);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_LEFT_HIP,
SimpleOpenNI.SKEL_LEFT_KNEE);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_LEFT_KNEE,
SimpleOpenNI.SKEL_LEFT_FOOT);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_TORSO,
SimpleOpenNI.SKEL_RIGHT_HIP);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_RIGHT_HIP,
SimpleOpenNI.SKEL_RIGHT_KNEE);
kinect.drawLimb(userId,
SimpleOpenNI.SKEL_RIGHT_KNEE,
SimpleOpenNI.SKEL_RIGHT_FOOT);
}
