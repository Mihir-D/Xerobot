
learnObject();

if(object is near right hand)
  trackObject();
  get delx;
  get dely;
  get delz;
  //The above three variables are the change in position of object from its previous position
  only store the extreme points of delx, dely and delz
  
  
//Action copying part:
findObject();
calibrate the base car and arm motors from the distance of the object from kinect and accordingly reach the object and pick it up.
if(obect is picked up)
  from delx, calibrate arm motors accordingly
  from dely, control the motion of elbow motor
  from delz, move the base car
