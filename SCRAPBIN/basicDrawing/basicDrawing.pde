import SimpleOpenNI.*;
SimpleOpenNI kinect;

int closestValue;
int closestX;
int closestY;

void setup()
{
  size(640, 480);
  kinect = new SimpleOpenNI(this);
  kinect.enableDepth();
  
  // start out with a black background
  background(0);
}

void draw()
{
  println(frameRate);
  closestValue = 1000;
  
  kinect.update();

  int[] depthValues = kinect.depthMap();
  
    for(int y = 0; y < 480; y++){
      for(int x = 0; x < 640; x++){
        
        // reverse x by moving in from
        // the right side of the image
        int reversedX = x;
        
        // use reversedX to calculate
        // the array index
        int i = reversedX + y * 640;
        int currentDepthValue = depthValues[i];
      
        // only look for the closestValue within a range
        // 610 (or 2 feet) is the minimum
        // 1525 (or 5 feet) is the maximum
        if(currentDepthValue > 300 && currentDepthValue < 450 && currentDepthValue < closestValue){
            
          closestValue = currentDepthValue;
          closestX = x;
          closestY = y;
        }
      }
    }
  
  image(kinect.depthImage(),0,0);
  fill(255,0,0);
  ellipse(closestX, closestY, 20, 20);

}
