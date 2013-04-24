////////////////////////////////////////////////////////
// THE YELLOW GHOST
////////////////////////////////////////////////////////
class GhostC
{

  
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // ghost related
  float ghostC_X;               // ghost X
  float ghostC_Y;               // ghost Y
  float ghostC_VX;              // ghost velocity in the X
  float ghostC_VY;              // ghost velocity in the Y
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
GhostC()
{
  // classes
  myDoggy = new DoggyGhost();
  
  // floats
  ghostC_X = int( random(100, width-100) );
  ghostC_Y = int( random(100, height-100) );
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
  if(ghostC_X < kittyRefX+100 && ghostC_X > kittyRefX-100 && ghostC_Y < kittyRefY+100 && ghostC_Y > kittyRefY-100)
  {
    ghostC_X = int( random(100, width-100) );
    ghostC_Y = int( random(100, height-100) );
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
  myDoggy.spawn(ghostC_X,ghostC_Y,color(237,250,66),color(201,211,68));
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MAKE OUR GHOST MOVE!
////////////////////////////////////////////////////////
void updateGhost()
{
  float attractionToTarget = 0.3; 
  float desireToTraceHill = 3.6;
  float dx = kittyRefX - ghostC_X + myDoggy.doggyW/2; 
  float dy = kittyRefY - ghostC_Y + myDoggy.doggyW/2; 
  float dh = sqrt(dx*dx + dy*dy); 

  if (dh > 0) 
  { 
    // add in the force due to attraction
    float fx = (dx / dh) * attractionToTarget; 
    float fy = (dy / dh) * attractionToTarget; 
    ghostC_VX = ghostC_VX + fx; 
    ghostC_VY = ghostC_VY + fy;
  }

  // extract 9 terrain values, from my neighborhood
  int terrainArea = 10;  
  pixelValues[0] = getTerrainValue (ghostC_X - terrainArea,   ghostC_Y - terrainArea); 
  pixelValues[1] = getTerrainValue (ghostC_X,                 ghostC_Y - terrainArea); 
  pixelValues[2] = getTerrainValue (ghostC_X + terrainArea,   ghostC_Y - terrainArea); 
  pixelValues[3] = getTerrainValue (ghostC_X - terrainArea,   ghostC_Y);  
  pixelValues[4] = getTerrainValue (ghostC_X,                 ghostC_Y); 
  pixelValues[5] = getTerrainValue (ghostC_X + terrainArea,   ghostC_Y); 
  pixelValues[6] = getTerrainValue (ghostC_X - terrainArea,   ghostC_Y + terrainArea);
  pixelValues[7] = getTerrainValue (ghostC_X,                 ghostC_Y + terrainArea); 
  pixelValues[8] = getTerrainValue (ghostC_X + terrainArea,   ghostC_Y + terrainArea); 

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
    
    ghostC_VX = ghostC_VX + hx; 
    ghostC_VY = ghostC_VY + hy; 
    line (ghostC_X, ghostC_Y, ghostC_X+hx, ghostC_Y+hy); 
  }
  
  ghostC_VX = ghostC_VX * 0.70;
  ghostC_VY = ghostC_VY * 0.70;             // lose our energy on each frame
  ghostC_X = ghostC_X + ghostC_VX;          // integration
  ghostC_Y = ghostC_Y + ghostC_VY;
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
