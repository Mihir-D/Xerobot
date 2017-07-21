import SimpleOpenNI.*;

SimpleOpenNI  context;

int[][] matrix = new int[640][480];
int i, j, index;
color []array= new color [307200];
PImage edge;
 long lastTime = 0;
 color c;
 float delx, dely,grad; // delta x and delta y to find gradient

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
     delx = blue(array[index+1]) - blue(array[index-1]);
     dely = blue(array[index+640]) - blue(array[index-640]);
     if((abs(delx) + abs(dely)) > 100.0)
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

    for(i = 1; i < 639; i++){
     for(j = 1; j < 479; j++){
       index = i + j*640;
        if(brightness(array[index]) == 255){
          if(brightness(array[index-640]) == 255){
            if(brightness(array[index-1]) == 255){
              if(brightness(array[index+1]) == 0 && brightness(array[index+640]) ==0 && brightness(array[index+641]) == 0)
                 edge.pixels[index] = color(255);       
             }
             else if(brightness(array[index+1]) == 255 && brightness(array[index+640]) == 0 && brightness(array[index+639]) == 0)
             { edge.pixels[index] = color(255);}
             else
               edge.pixels[index] = color(0);
          }
          
          else{
           if(brightness(array[index+1]) == 0){
            if(brightness(array[index-1]) == 255 && brightness(array[index+640]) == 255 && brightness(array[index-639]) == 0)
              edge.pixels[index] = color(255);
           }
             else if(brightness(array[index-1]) == 0 && brightness(array[index+640]) == 255 && brightness(array[index-641]) == 0)
               edge.pixels[index] = color(255);
             else
                edge.pixels[index] = color(0);
          }
             
        }
        
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

    for(i = 1; i < 639; i++){
     for(j = 1; j < 479; j++){
       index = i + j*640;
        if(brightness(array[index]) == 255){
          if(brightness(array[index-640]) == 255){
            if(brightness(array[index-1]) == 255){
              if(brightness(array[index+1]) == 0 && brightness(array[index+640]) ==0 && brightness(array[index+641]) == 0)
                 edge.pixels[index] = color(255);       
             }
             else if(brightness(array[index+1]) == 255 && brightness(array[index+640]) == 0 && brightness(array[index+639]) == 0)
             { edge.pixels[index] = color(255);}
             else
               edge.pixels[index] = color(0);
          }
          
          else{
           if(brightness(array[index+1]) == 0){
            if(brightness(array[index-1]) == 255 && brightness(array[index+640]) == 255 && brightness(array[index-639]) == 0)
              edge.pixels[index] = color(255);
           }
             else if(brightness(array[index-1]) == 0 && brightness(array[index+640]) == 255 && brightness(array[index-641]) == 0)
               edge.pixels[index] = color(255);
             else
                edge.pixels[index] = color(0);
          }
             
        }
        
        else
           edge.pixels[index] = color(0);
    
     }
    
  }
  

  /*for(i = 1; i < 639; i++){
   for(j = 1; j < 479; j++){
     index = i + j*640;
     delx = blue(array[index+1]) - blue(array[index-1]);
     dely = blue(array[index+640]) - blue(array[index-640]);
     //if((abs(delx) + abs(dely))) > 100.0)
       //edge.pixels[index] = color(255);
     //else
       //edge.pixels[index] = color(0);
     if(delx != 0){
       grad = dely/delx;
       if(grad>50 || grad<-50)
         edge.pixels[index] = color(255);
       else
         edge.pixels[index] = color(0);
     }
    }
  }*/
  
  
  //println(int(brightness(c)));
  
  updatePixels();   // to load original image with changed values
  image(edge,0,0);
  //println(edge.pixels[10000]);
  //stroke(matrix)
  /*if ( millis() - lastTime > 1000 ) {

    lastTime = millis();
  }*/
}
