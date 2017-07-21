import SimpleOpenNI.*;
SimpleOpenNI kinect;
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
PImage edge;
float avgx,avgy;

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
image(depth, 0, 0);
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
println(confidence);
avgx=avgx-rightHandx[count]/10.0;
avgy=avgy-rightHandy[count]/10.0;
rightHandx[count] = convertedRightHand.x;
rightHandy[count] = convertedRightHand.y;
avgx=avgx+rightHandx[count]/10.0;
avgy=avgy+rightHandy[count]/10.0; // averaging filter :-p
fill(255,0,0);
ellipse(avgx, avgy, 10, 10);

 
 ref_depth=(int)depthValues[(int)avgx+(int)avgy*640].z;
noFill();
rect((int)avgx-25,(int)avgy-25,50,50);
if(confidence==1.0 ) // only executed if skeleton is detected perfectly
{
  xmax=(int)avgx;xmin=(int)avgx;ymax=(int)avgy;ymin=(int)avgy;

  for(int i=(int)avgx-30;    i< (int)avgx+30 ;   i++)
    for(int j=(int)avgy-30;   j<(int)avgy+30;  j++)
      {
        int index=i + j*640;      
        if(abs((int)depthValues[index].z-ref_depth)<20) // pixels in the vicinity of 1.5 centimeters               
          {
            if((blue(edge.pixels[index]) - red(edge.pixels[index]) > 10)  &&  (blue(edge.pixels[index]) - green(edge.pixels[index]))> 10)
            blue_count++;            
          
           if((red(edge.pixels[index]) - blue(edge.pixels[index]) > 10)  &&  (red(edge.pixels[index]) - green(edge.pixels[index]))> 10)
            red_count++;
          
           if((green(edge.pixels[index]) - red(edge.pixels[index]) > 10)  &&  (green(edge.pixels[index]) - blue(edge.pixels[index]))> 10)
            green_count++;
          palmx=palmx+i;
          palmy=palmy+j;
          object_area++;  
           // remembering only the color properties . 
           //cosidering other pixels we'll have to take acccount of other pixels 
           //which are around the object which will change according to depth 
            if(i<xmin) {
              xmin=i;
              d1 = j;
            }
            if(i>xmax) {
              xmax=i;
              d2 = j;
            }
            if(j<ymin) {
              ymin=j; 
              d3 = i;
            }
            if(j>ymax) {
              ymax=j;  
              d4 = i;
            }           
        }
          
      }
palmx=palmx/object_area;
palmy=palmy/object_area;
noFill();
rect(palmx-(xmax-xmin)/2,palmy-(ymax-ymin)/2,xmax-xmin,ymax-ymin);
//println(" red  "+red_count +"  green  " +green_count +"  blue  "+blue_count +"  area  "+ (object_area));///100*ref_depth/100*ref_depth/100 )/10  );
//println("expected area = "+ (xmax-xmin)*(ymax-ymin));


//println(" xmax "+xmax +"  xmin  " +xmin +"  ymin  "+ ymin +"  ymax  "+ ymax  ); // awesome results :D
//println(" xmax "+(int)depthValues[xmax+d2*640].x +"  xmin  " +(int)depthValues[xmin+d1*640].x +"  ymin  "+ (int)depthValues[d3+ymin*640].y +"  ymax  "+ (int)depthValues[d4+ymax*640].y  );
//println(" x "+((int)depthValues[xmax+d2*640].x-(int)depthValues[xmin+d1*640].x) +"  y  "+ ((int)depthValues[d3+ymin*640].y -(int)depthValues[d4+ymax*640].y)  );
PVector p1 = new PVector((int)depthValues[xmin+d1*640].x,(int)depthValues[xmin+d1*640].y,0);
PVector p3 = new PVector((int)depthValues[xmax+d2*640].x,(int)depthValues[xmax+d2*640].y,0);
PVector p4 = new PVector((int)depthValues[d3+ymin*640].x,(int)depthValues[d3+ymin*640].y,0);
PVector p2 = new PVector((int)depthValues[d4+ymax*640].x,(int)depthValues[d4+ymax*640].y,0);
PVector legth=PVector.sub(p1,p2);
PVector breath=PVector.sub(p2,p3);

//println("length= " + (int)(depthValues[xmin+3+d1*640].x - depthValues[d4+(ymax-3)*640].x) + "  breath= " + (int)breath.mag() + "  " + ref_depth);
if(fcount==0)
{
  minl=((int)depthValues[xmax+d2*640].x-(int)depthValues[xmin+d1*640].x);
  minb=((int)depthValues[d3+ymin*640].y -(int)depthValues[d4+ymax*640].y) ;
  maxl=((int)depthValues[xmax+d2*640].x-(int)depthValues[xmin+d1*640].x);
  maxb=((int)depthValues[d3+ymin*640].y -(int)depthValues[d4+ymax*640].y) ;
}// initiallisation
if(fcount>=1)
{
  if(minl>((int)depthValues[xmax+d2*640].x-(int)depthValues[xmin+d1*640].x))
  minl=((int)depthValues[xmax+d2*640].x-(int)depthValues[xmin+d1*640].x);
  if(minb>((int)depthValues[d3+ymin*640].y -(int)depthValues[d4+ymax*640].y) )
  minb=((int)depthValues[d3+ymin*640].y -(int)depthValues[d4+ymax*640].y) ;
  if(maxl<((int)depthValues[xmax+d2*640].x-(int)depthValues[xmin+d1*640].x))
  maxl=((int)depthValues[xmax+d2*640].x-(int)depthValues[xmin+d1*640].x);
  if(maxb<((int)depthValues[d3+ymin*640].y -(int)depthValues[d4+ymax*640].y) )
  maxb=((int)depthValues[d3+ymin*640].y -(int)depthValues[d4+ymax*640].y) ;
  
}fcount++;
if(fcount==10)
{
  avglength=(minl+maxl)/2;
  avgbreadth=(minb+maxb)/2;
println(" breadth" + avglength + " length  " + avgbreadth  );
// test for object detection 
if(abs(avglength-150)<15 && abs(avgbreadth-100)<15)//dimension test 
{
  println("0000000000000000000000000");
  if(((float)green_count/ (float)red_count)<0.1  && ((float)blue_count/ (float)red_count)<0.1);
  println("dmm is detected");
}
else println("no object found");
fcount=0;
}

}//if (confidence=1)



count++;
if (count==10)
  count=0;

blue_count=0;red_count=0;green_count=0;object_area=0;

}}}


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
