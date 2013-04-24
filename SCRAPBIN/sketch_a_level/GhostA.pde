////////////////////////////////////////////////////////
// THE RED GHOST
// Ghost tries to be at the same point PacKitty is
// Predictable, constant
////////////////////////////////////////////////////////
class GhostA
{

  
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // ghost related
  float ghostA_X;               // ghost X
  float ghostA_Y;               // ghost Y
  float ghostA_VX;              // ghost velocity in the X
  float ghostA_VY;              // ghost velocity in the Y
  float kittyRefX;              // kitty's X
  float kittyRefY;              // kitty's Y
  
  // map related
  color mapPixels[];             // colors in collision map
  int n_mapPixels;               // number of pixels in collison map
  float pixelValues[];           // neighborhood for the pixels
  
  // classes
  DoggyGhost myDoggy;
////////////////////////////////////////////////////////

  
////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
GhostA()
{
  // classes
  myDoggy = new DoggyGhost();
  
  // floats
  ghostA_X = int( random(100, width-100) );
  ghostA_Y = int( random(100, height-100) );
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// SETUP: RUN THIS ONLY ONCE!
////////////////////////////////////////////////////////
void setup()
{
  // blur our collision map!
  visibleMap.filter(BLUR, 5);        // blur our collision map
  visibleMap.loadPixels();           // load the pixels of our map, just once!
  mapPixels = visibleMap.pixels;     // get those pixels!
  pixelValues = new float[9];        // we want a neighborhood of 9 pixels
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// INTIALIZE STARTING POSITION
////////////////////////////////////////////////////////
void startPos()
{
  if(ghostA_X < kittyRefX+100 && ghostA_X > kittyRefX-100 && ghostA_Y < kittyRefY+100 && ghostA_Y > kittyRefY-100)
  {
    ghostA_X = int( random(100, width-100) );
    ghostA_Y = int( random(100, height-100) );
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DRAWING AND MOVING GHOST
////////////////////////////////////////////////////////
void play()
{
  renderGhost();
  updateGhost(); 
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// RENDER OUR GHOST
////////////////////////////////////////////////////////
void renderGhost()
{
  // draw ghost using doggyghost class
  myDoggy.spawn(ghostA_X,ghostA_Y,color(255,0,0),color(108,37,37));
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MAKE OUR GHOST MOVE!
////////////////////////////////////////////////////////
void updateGhost()
{
  float attractionToTarget = 0.3; 
  float desireToTraceHill = 3.6;
  float dx = kittyRefX - ghostA_X + myDoggy.doggyW/2; 
  float dy = kittyRefY - ghostA_Y + myDoggy.doggyW/2; 
  float dh = sqrt(dx*dx + dy*dy); 

  if (dh > 0) 
  { 
    // add in the force due to attraction
    float fx = (dx / dh) * attractionToTarget; 
    float fy = (dy / dh) * attractionToTarget; 
    ghostA_VX = ghostA_VX + fx; 
    ghostA_VY = ghostA_VY + fy;
  }

  // extract 9 terrain values, from my neighborhood
  int terrainArea = 10;  
  pixelValues[0] = getTerrainValue (ghostA_X - terrainArea,   ghostA_Y - terrainArea); 
  pixelValues[1] = getTerrainValue (ghostA_X,                 ghostA_Y - terrainArea); 
  pixelValues[2] = getTerrainValue (ghostA_X + terrainArea,   ghostA_Y - terrainArea); 
  pixelValues[3] = getTerrainValue (ghostA_X - terrainArea,   ghostA_Y);  
  pixelValues[4] = getTerrainValue (ghostA_X,                 ghostA_Y); 
  pixelValues[5] = getTerrainValue (ghostA_X + terrainArea,   ghostA_Y); 
  pixelValues[6] = getTerrainValue (ghostA_X - terrainArea,   ghostA_Y + terrainArea);
  pixelValues[7] = getTerrainValue (ghostA_X,                 ghostA_Y + terrainArea); 
  pixelValues[8] = getTerrainValue (ghostA_X + terrainArea,   ghostA_Y + terrainArea); 

  // refer to:
  // http://homepages.inf.ed.ac.uk/rbf/HIPR2/sobel.htm
  float xKernel[] = 
  {
    -1, 0, 1, -2, 0, 2, -1, 0, 1
  };
  float yKernel[] = 
  { 
    1, 2, 1, 0, 0, 0, -1, -2, -1
  };

  float Gx = 0;
  float Gy = 0;
  for (int i=0; i<9; i++)
  {
    Gx += xKernel[i] * pixelValues[i]; 
    Gy += yKernel[i] * pixelValues[i];
  }
  float Gh = sqrt(Gx*Gx + Gy*Gy); 
  
  if (Gh > 0) {
    float Gorientation = atan2 (Gy, Gx);
    float avoidCrossing = pow(pixelValues[4], 0.5);
    float hx =   avoidCrossing * desireToTraceHill * sin (Gorientation);
    float hy =   avoidCrossing * desireToTraceHill * cos (Gorientation);
    float hh = sqrt(hx*hx + hy*hy);  // hill force magnitude
    //if (hh > 1.0){
    //  hx = hx / hh;
    //  hy = hy / hh;
    //}
    
    ghostA_VX = ghostA_VX + hx; 
    ghostA_VY = ghostA_VY + hy; 
    line (ghostA_X, ghostA_Y, ghostA_X+hx, ghostA_Y+hy); 
  }
  
  ghostA_VX = ghostA_VX * 0.70;
  ghostA_VY = ghostA_VY * 0.70;             // lose our energy on each frame
  ghostA_X = ghostA_X + ghostA_VX;          // integration
  ghostA_Y = ghostA_Y + ghostA_VY;
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GET THE "TERRAIN" VALUES FOR THE COLLISION MAP
// Returns terrain of image
// Dark = 1
// Light = 0
////////////////////////////////////////////////////////
float getTerrainValue (float x, float y) 
{
  // get the width and height of our collison map
  int imgW = visibleMap.width; 
  int imgH = visibleMap.height; 
  
  // the number of pixels in our collison map
  n_mapPixels = imgW*imgH; 
  
  // constrain to keep the values within the bounds of the image
  int testPointX = (int) constrain(round(x), 0, imgW-1); 
  int testPointY = (int) constrain(round(y), 0, imgH-1);
  
  // what's the ID of this pixel?
  int testIndex = (testPointY * imgW) + testPointX; 
  
  // what is the color of the above pixel?
  color testColor = mapPixels[testIndex]; 
  
  // map the brightness so it is a valye between 1 and 0, instead of 255 and 0
  float hillValue = map(brightness(testColor), 0, 255, 1, 0); 
  
  // return the value generated
  return hillValue;
}
////////////////////////////////////////////////////////

}
