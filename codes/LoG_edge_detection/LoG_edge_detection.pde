import SimpleOpenNI.*;

SimpleOpenNI  context;

int[][] matrix = new int[640][480];
int i, j, index;
float check;
color []array= new color [307200];
PImage edge;
 long lastTime = 0;
 color c;

void setup()
{
  context = new SimpleOpenNI(this);
   long lastTime = 0;
  lastTime = millis();

  // enable depthMap generation 
  context.enableDepth();
  
  // enable camera image generation
  context.enableRGB();
 
  //background(200,0,0);
  //size(context.depthWidth() + context.rgbWidth() + 10, context.rgbHeight()); 
  size(640,480);
  edge = loadImage("F:/Color_Bars_640x480.gif");
}

void draw()
{
  // update the cam
  context.update();
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  
  // draw camera
  //image(context.rgbImage(),context.depthWidth() + 10,0);
  
  edge = context.depthImage();
  edge.loadPixels();
  int depthImg[] = context.depthMap(); // getting depth values in array pixel by pixel
  int k = 0;
  for(i = 1; i < 640; i++){
    for(j = 1; j < 480; j++){
     index = i + j*640;
  array[index]=edge.pixels[index];
  }
}
  //laplacian of Gaussian filter (Low pass filter)
  for(i = 2; i < 638; i++){
   for(j = 2; j < 478; j++){
     index = i + j*640;
     check =(int) (abs(-2*brightness(array[index+1])-2*brightness(array[index-1])-brightness(array[index+2])-brightness(array[index-2])
     -2*brightness(array[index+640])-2*brightness(array[index-640])-brightness(array[index+1280])-brightness(array[index-1280])
     -brightness(array[index+641])-brightness(array[index-641])
     -brightness(array[index+639])-brightness(array[index-639])+6*brightness(array[index]))/10);
     if((check) > 100.0)
       edge.pixels[index] = color(255);
     else
       edge.pixels[index] = color(0);
    
  }
  }
for(i = 1; i < 640; i++){
    for(j = 1; j < 480; j++){
     index = i + j*640;
  array[index]=edge.pixels[index];
  }
}  
  
  //laplacian filter (High Pass Filter)
  for(i = 1; i < 639; i++){
   for(j = 1; j < 479; j++){
     index = i + j*640;
     check = abs(brightness(array[index+1]) + brightness(array[index-1]) +brightness(array[index+640]) + brightness(array[index-640]) - 4*brightness(array[index]));
     if((check) > 5.0)
       edge.pixels[index] = color(255);
     else
       edge.pixels[index] = color(0);
    }
  }
  
  
  //println(int(brightness(c)));
  updatePixels();   // to load original image with changed values
  image(edge,0,0);
  //println(pixels.size());
  //stroke(matrix)
  /*if ( millis() - lastTime > 1000 ) {

    lastTime = millis();
  }*/
}
