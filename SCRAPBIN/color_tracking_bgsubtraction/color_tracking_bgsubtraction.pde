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
PImage backgroundImage;    // saved background
float threshold = 20;      // how different must a pixel be to be a foreground pixel?


//------------------------------------------------------------------------------------------//
void setup() 
{
  size(640,480);
  smooth();
  
  video = new Capture(this,width,height);
  trackColor = color(51,62,47);       // color we are tracking
  backgroundImage = createImage(video.width,video.height,RGB);
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
  
  loadPixels();
  video.loadPixels();
  backgroundImage.loadPixels();
  
  // SHOW LIVE CAMERA FEED
  image(video,0,0);

  // BEGIN LOOP TO WALK THROUGH EVERY PIXEL
  for (int x = 0; x < video.width; x ++ ) 
  {
    for (int y = 0; y < video.height; y ++ ) 
    {
      int loc = x + y*video.width;                     // id of pixel
      color currentColor = video.pixels[loc];          // what is current color
      color fgColor = video.pixels[loc];               // what is the foreground color?
      color bgColor = backgroundImage.pixels[loc];     // what is the background color?      
      
      // FOR COLOR TRACKING
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);
      float d = dist(r1,g1,b1,r2,g2,b2);
      
      // FOR BACKGROUND SUBTRACTION
      float bg_r1 = red(fgColor);
      float bg_g1 = green(fgColor);
      float bg_b1 = blue(fgColor);
      float bg_r2 = red(bgColor);
      float bg_g2 = green(bgColor);
      float bg_b2 = blue(bgColor);
      float bg_diff = dist(bg_r1, bg_g1, bg_b1, bg_r2, bg_g2, bg_b2);
      
      // if current color is more similar to tracked color than
      // closest color, save current location and current difference
      if (d < worldRecord) 
      {
        worldRecord = d;
        closestX = x;
        closestY = y;
      }
      
      // if the foreground color is different than the background color?
      if(bg_diff > threshold)
      {
        pixels[loc] = fgColor;                       // if so, display the foreground color
      }
      
      updatePixels();
    }
  }

  // We only consider the color found if its color distance is less than 10. 
  // This threshold of 10 is arbitrary and you can adjust this number depending on how accurate you require the tracking to be.
  if (worldRecord < 50) 
  { 
    // Draw a circle at the tracked pixel
    fill(trackColor);
    strokeWeight(4.0);
    stroke(0);
    ellipse(closestX,closestY,16,16);
  }
}
//------------------------------------------------------------------------------------------//


//------------------------------------------------------------------------------------------//
void mousePressed()
{
  backgroundImage.copy(video,0,0,video.width,video.height,0,0,video.width,video.height);
  backgroundImage.updatePixels();
}
//------------------------------------------------------------------------------------------//
