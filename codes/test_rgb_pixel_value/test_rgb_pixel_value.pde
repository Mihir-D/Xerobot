import SimpleOpenNI.*;
SimpleOpenNI kinect;
PVector []depthValues = new PVector[307200];
void setup()
{
size(640*2, 480);
kinect = new SimpleOpenNI(this);
kinect.enableDepth();
kinect.enableRGB();
}

void draw()
{
kinect.update();
PImage depthImage = kinect.depthImage();
PImage rgbImage = kinect.rgbImage();
depthValues = kinect.depthMapRealWorld();

//image(depthImage, 0, 0);
image(rgbImage, 0, 0);
}
void mousePressed(){
color c = get(mouseX, mouseY);
//int []depthValues = kinect.depthMap();
println(depthValues[mouseX+640*mouseY].x  + " X "+ mouseX   + " Y " + mouseY );

//println("r: " + red(c) + " g: " + green(c) + " b: " + blue(c));
}
