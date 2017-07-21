import SimpleOpenNI.*;

SimpleOpenNI  context;

int[][] matrix = new int[640][480];
int i, j, index;
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
}

void draw()
{
  // update the cam
  context.update();
  
  // draw depthImageMap
  //image(context.depthImage(),0,0);
  
  // draw camera
  //image(context.rgbImage(),context.depthWidth() + 10,0);
  
  edge = context.rgbImage();
  edge.loadPixels();
  //println(int(brightness(edge.pixels[10000])));
  int k = 0;
  for(i = 1; i < 640; i++){
    for(j = 1; j < 480; j++){
     index = i + j*640;
     array[index]=edge.pixels[index];
     
}}

  /*for(i = 1; i < 640; i++){
    for(j = 1; j < 480; j++){
     index = i + j*640;
     if(array[index] < 10)
       array[index] = 0;
    
    }
  }*/
  for(i = 1; i < 639; i++){
   for(j = 1; j < 479; j++){
     index = i + j*640;
     if((abs(brightness(array[index+1]) - brightness(array[index-1])) + abs(brightness(array[index+640]) - brightness(array[index-640]))) > 50.0)
       edge.pixels[index] = color(255);
       
     else
       edge.pixels[index] = color(0);
    }
  }
  
  c = edge.pixels[200];
  //println(int(brightness(c)));
  
  updatePixels();   // to load original image with changed values
  image(edge,0,0);
  //println(edge.pixels[10000]);
  //stroke(matrix)
  /*if ( millis() - lastTime > 1000 ) {

    lastTime = millis();
  }*/
}
