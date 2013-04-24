//------------------------------------------------------------------------------------------//
// Learning Processing
// Daniel Shiffman
// http://www.learningprocessing.com
// Example 16-11: Simple color tracking
// Example 16-12: Simple background removal
//------------------------------------------------------------------------------------------//

// import libraries
import processing.video.*;

// variables
Capture video;
color trackColor;          // color variable we are tracking 
float circleX;
float circleY;
float circleE = 0.05;


//------------------------------------------------------------------------------------------//
void setup() 
{
  size(640,480);
  smooth();
  
  video = new Capture(this,640,480);
  trackColor = color(51,62,47);       // color we are tracking
}
//------------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------------//
void draw() 
{ 
  // LOCAL VARIABLES  
  float worldRecord = 500;   // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
  int closestX = 0;          // X coordinate of closest color
  int closestY = 0;          // Y coordinate of closest color
  
  // CAPTURE THE VIDEO
  video.start();
  if (video.available()) 
  {
    video.read();
  }
  
  // SHOW LIVE CAMERA FEED
  image(video, 0, 0, width, height);

  // BEGIN LOOP TO WALK THROUGH EVERY PIXEL
  video.loadPixels();
  for (int x = 0; x < video.width; x ++ ) 
  {
    for (int y = 0; y < video.height; y ++ ) 
    {
      int loc = x + y*video.width;                     // id of pixel
      color currentColor = video.pixels[loc];          // what is current color
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      float d = dist(r1,g1,b1,r2,g2,b2);               // compare the current color with the color we are tracking.

      // if current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord) 
      {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
    }
  }  

  // We only consider the color found if its color distance is less than the threshold
  if (worldRecord < 2) 
  { 
    float dx = closestX - circleX;
    float dy = closestY - circleY;
    if(abs(dx) > 1) 
    {
      circleX += dx * circleE;
    }
    if(abs(dy) > 1) 
    {
      circleY += dy * circleE;
    }
  }
  
  fill(trackColor);
  strokeWeight(4.0);
  stroke(0);
  ellipse(circleX, circleY, 30, 30);
  
}
//------------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------------//
void mousePressed() 
{
  // Save color where the mouse is clicked in trackColor variable
  int loc = mouseX + mouseY*video.width;
  trackColor = video.pixels[loc];
}
//------------------------------------------------------------------------------------------//

