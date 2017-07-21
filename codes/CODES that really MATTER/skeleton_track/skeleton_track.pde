import SimpleOpenNI.*;
SimpleOpenNI kinect;
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
fill(255,0,0);
ellipse(convertedRightHand.x, convertedRightHand.y, 10, 10);
println(confidence);


//doing it for head now
PVector head = new PVector();
// put the position of the left hand into that vector
float confidence_head = kinect.getJointPositionSkeleton(userId,SimpleOpenNI.SKEL_HEAD,head);
// convert the detected hand position
// to "projective" coordinates
// that will match the depth image
PVector convertedHEAD = new PVector();
kinect.convertRealWorldToProjective(head, convertedHEAD);
// and display it
fill(255,0,0);
ellipse(convertedHEAD.x, convertedHEAD.y, 50, 50);



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
