import SimpleOpenNI.*;

SimpleOpenNI  context;
int k=1,startPointX,startPointY;
int[][] matrix = new int[640][480];
int i, j, index;
color []array= new color [307200];
PImage edge;
 long lastTime = 0;
 color c;
int[] gradArray = new int [50000];
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
     //if(((blue(edge.pixels[index]) - red(edge.pixels[index]) > 10)  &&  ((blue(edge.pixels[index]) - green(edge.pixels[index])) > 10))){
     //if((2*blue(edge.pixels[index]) - red(edge.pixels[index]) - green(edge.pixels[index]))/blue(edge.pixels[index])> 0.5) //normalisation
     if(2*blue(edge.pixels[index]) - red(edge.pixels[index]) - green(edge.pixels[index])> 75)
       edge.pixels[index] = color(0,0,255);
       
     else
       edge.pixels[index] = color(0,0,0);
    }
    
     //else
       //edge.pixels[index] = color(0);
   //}
  }
 for(i = 1; i < 640; i++){
    for(j = 1; j < 480; j++){
     index = i + j*640;
     array[index]=edge.pixels[index];
     
}}

  for(i = 1; i < 639; i++){
   for(j = 1; j < 479; j++){
     index = i + j*640;
     if((abs(blue(array[index+1]) - blue(array[index-1])) + abs(blue(array[index+640]) - blue(array[index-640]))) > 100.0)
       edge.pixels[index] = color(255);
     else
       edge.pixels[index] = color(0);
    }
  }
// scan full image for starting point
while(mousePressed==false);
startPointX = mouseX;
startPointY = mouseY;
i = startPointX;
j = startPointY;
int gradi = 0;
do{
   // index = getIndex(i,j);
   gradArray[gradi] = getGrad(i,j);
    if(brightness(edge.pixels[getIndex(i+1,j)]) == 255)
      i++;
    else if(brightness(edge.pixels[getIndex(i+1,j-1)])){
      i++; j--;
    }
    else{
      i++;
      j++;
    }
    }while()  
      




  updatePixels();   // to load original image with changed values
  image(edge,0,0);
  //println(edge.pixels[10000]);

 
}

int getIndex(int i, int j){
  return (i+j*640);
}
