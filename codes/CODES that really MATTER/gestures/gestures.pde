
import SimpleOpenNI.*;
SimpleOpenNI kinect;

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

void setup() {
size(640, 480);
kinect = new SimpleOpenNI(this);
kinect.enableDepth();
// turn on user tracking
kinect.enableUser();
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
// and display it
//gesture3: start execution mode
//if(/*abs(convertedRightHand.x - convertedTorso.x) < 20 && abs(convertedRightHand.y - convertedTorso.y) < 20 &&*/ abs(convertedHead.y - convertedTorso.y) < 100){
  if(convertedLeftHand.y < convertedLeftShoulder.y && convertedLeftElbow.y < convertedLeftShoulder.y && convertedRightHand.y < convertedRightShoulder.y && convertedRightElbow.y < convertedRightShoulder.y){
  println("hands up");
}
//gesture1: stop action
else if(convertedLeftHand.y < convertedLeftShoulder.y && convertedLeftElbow.y < convertedLeftShoulder.y){
  println("stop");
}

//gesture2: start learning mode
 else if(convertedRightHand.y < convertedRightShoulder.y && convertedRightElbow.y < convertedRightShoulder.y){
  println("Start learning mode");
}


fill(255,0,0);
ellipse(convertedRightHand.x, convertedRightHand.y, 10, 10);
fill(255,0,0);
ellipse(convertedTorso.x, convertedTorso.y, 10, 10);
fill(255,0,0);
ellipse(convertedHead.x, convertedHead.y, 10, 10);
//println(confidence4 + " " +confidenceTorso + " " +confidenceHead);
println(convertedRightHand.y + " " +convertedRightElbow.y + " " +convertedRightShoulder.y);




}
}
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
