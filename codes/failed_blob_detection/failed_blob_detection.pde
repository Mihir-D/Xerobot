import blobDetection.*;

import SimpleOpenNI.*;

SimpleOpenNI  context;
BlobDetection theBlobDetection;

int[][] matrix = new int[640][480];
int i, j, index;
color []array= new color [307200];
PImage img;
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
  
  img = context.rgbImage();
  
  img.loadPixels();
  //println(int(brightness(img.pixels[10000])));
  int k = 0;
  for(i = 1; i < 640; i++){
    for(j = 1; j < 480; j++){
     index = i + j*640;
     array[index]=img.pixels[index];
     
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
     //if(((blue(img.pixels[index]) - red(img.pixels[index]) > 10)  &&  ((blue(img.pixels[index]) - green(img.pixels[index])) > 10))){
     //if((2*blue(img.pixels[index]) - red(img.pixels[index]) - green(img.pixels[index]))/blue(img.pixels[index])> 0.5) //normalisation
     if(2*blue(img.pixels[index]) - red(img.pixels[index]) - green(img.pixels[index])> 75)
       img.pixels[index] = color(255);
       
     else
       img.pixels[index] = color(0);
    }
    
     //else
       //img.pixels[index] = color(0);
   //}
  }
 /*for(i = 1; i < 640; i++){
    for(j = 1; j < 480; j++){
     index = i + j*640;
     array[index]=img.pixels[index];
     
}}

  for(i = 1; i < 639; i++){
   for(j = 1; j < 479; j++){
     index = i + j*640;
     if((abs(blue(array[index+1]) - blue(array[index-1])) + abs(blue(array[index+640]) - blue(array[index-640]))) > 100.0)
       img.pixels[index] = color(255);
     else
       img.pixels[index] = color(0);
    }
  }*/
  theBlobDetection = new BlobDetection(img.width, img.height);
  theBlobDetection.setPosDiscrimination(false);
  theBlobDetection.setThreshold(0.5f);
  theBlobDetection.computeBlobs(img.pixels);
  image(img, 0, 0, width, height);
 drawBlobsAndEdges(true,true);

  //println(int(brightness(c)));
  
  updatePixels();   // to load original image with changed values
  //image(img,0,0);
  //println(img.pixels[10000]);
  //stroke(matrix)
  /*if ( millis() - lastTime > 1000 ) {

    lastTime = millis();
  }*/
}
void drawBlobsAndimgs(boolean drawBlobs, boolean drawimgs)
{
  noFill();
  Blob b;
  imgVertex eA, eB;
  for (int n=0 ; n<theBlobDetection.getBlobNb() ; n++)
  {
    b=theBlobDetection.getBlob(n);
    if (b!=null)
    {
      // imgs
      if (drawimgs)
      {
        strokeWeight(2);
        stroke(0, 255, 0);
        for (int m=0;m<b.getimgNb();m++)
        {
          eA = b.getimgVertexA(m);
          eB = b.getimgVertexB(m);
          if (eA !=null && eB !=null)
            line(
            eA.x*width, eA.y*height, 
            eB.x*width, eB.y*height
              );
        }
      }

      // Blobs
      if (drawBlobs)
      {
        strokeWeight(1);
        stroke(255, 0, 0);
        rect(
        b.xMin*width, b.yMin*height, 
        b.w*width, b.h*height
          );
      }
    }
  }
}

