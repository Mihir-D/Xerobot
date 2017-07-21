import SimpleOpenNI.*;

SimpleOpenNI  context;

int[][] matrix = new int[640][480];
int i, j, index,lastIndex=0,count = 1,iavg=0,javg=0;
int avgIndex = 0;
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
  lastTime=millis();
  // update the cam
  context.update();
  int[] depthValues = context.depthMap();
 
  
  edge = context.rgbImage();
  edge.loadPixels();
  //println(int(brightness(edge.pixels[10000])));
  int k = 0;
  for(i = 1; i < 640; i++){
    for(j = 1; j < 480; j++){
     index = i + j*640;
     array[index]=edge.pixels[index];
     
}}

  for(i = 1; i < 639; i++){
   for(j = 1; j < 479; j++){
     index = i + j*640;
     //if(((blue(edge.pixels[index]) - red(edge.pixels[index]) > 10)  &&  ((blue(edge.pixels[index]) - green(edge.pixels[index])) > 10))){
     //if((2*blue(edge.pixels[index]) - red(edge.pixels[index]) - green(edge.pixels[index]))/blue(edge.pixels[index])> 0.5) //normalisation
     if(2*blue(edge.pixels[index]) - red(edge.pixels[index]) - green(edge.pixels[index])> 75){
       if(depthValues[index] > 700 && depthValues[index] < 1000){
         edge.pixels[index] = color(0,0,255);
         count++;
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
   iavg=iavg/count; //wtf????????????????????
   javg/=count;
   avgIndex = iavg+640*javg;
   edge.pixels[avgIndex] = color(255, 0, 0);
    
  
//println(avgIndex);
  
  //println(int(brightness(c)));
  
  updatePixels();   // to load original image with changed values
  image(edge,0,0);
  fill(255,0,0);
 rect((float)iavg, (float)javg, 10.0, 10.0);
  
  //println(edge.pixels[10000]);
  //stroke(matrix)
/*  while ( (millis() - lastTime) < 1000 ) ;

    lastTime = millis();
  */
  
   count = 1;
  avgIndex = 0;
  iavg=0;
  javg=0;

println(millis()-lastTime);

}


