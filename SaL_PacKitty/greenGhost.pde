////////////////////////////////////////////////////////
// THE GREEN GHOST  
////////////////////////////////////////////////////////
class greenGhost
{
  // ghost movement
  float ghostX; // the x position of the ghost
  float ghostY; // the y position of the ghost
  float p_ghostX; // previous x position of the ghost
  float p_ghostY; // previous y position of the ghost
  float ghostVX; // ghost velocity in the X
  float ghostVY; // ghost velocity in the Y
  float ghostS;       // ghost speed when not on the hill
   
  // ghost appearance
  color green1;  // body color of the ghost
  color green2;  // ear color of the ghost
  skinGhosts mySkin; // appearance of ghosts
    
  // reference variables
  float kittyRefX; // kitty's X
  float kittyRefY; // kitty's Y
    
  // map related
  color mapPixels[]; // colors in collision map
  int n_mapPixels; // number of pixels in collison map
  float pixelValues[]; // neighborhood for the pixels
    
  ////////////////////////////////////////////////////////
  // THE CONSTRUCTOR
  ////////////////////////////////////////////////////////
  greenGhost()
  {
    // ghost movement
    ghostX = int( random(100, width-100) );
    ghostY = int( random(100, height-100) );
    ghostS = 5;
    
    // ghost appearance
    green1 = color(115,201,81);
    green2 = color(62,155,27);
    mySkin = new skinGhosts();
    
    // check for problems!
    //println("LOAD ONCE: Green ghost constructor");
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // RUN THIS ONLY ONCE!
  ////////////////////////////////////////////////////////
  void resetMap()
  {
    drawnMap.loadPixels(); // load the pixels of our map, just once!
    mapPixels = drawnMap.pixels; // get those pixels!
    pixelValues = new float[9]; // we want a neighborhood of 9 pixels
    
    float distance = dist(kittyRefX,kittyRefY,ghostX,ghostY);
    if( abs(distance) < 200 )
    {
      ghostX = int( random(100, width-100) );
      ghostY = int( random(100, height-100) );
      println("NEW VALUE: Green ghost");
    }
    
    // check for problems!
    println("LOAD ONCE: Green ghost map calibrated");
  }
  ////////////////////////////////////////////////////////

  ////////////////////////////////////////////////////////
  // DRAWING AND MOVING GHOST
  ////////////////////////////////////////////////////////
  void play()
  {
    updateGhost();
    renderGhost();
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // RENDER OUR GHOST
  ////////////////////////////////////////////////////////
  void renderGhost()
  {   
    // turn ghost left
    if(p_ghostX > ghostX)
    {
      pushMatrix();
        translate(ghostX,ghostY);
        scale(-1, 1);
        mySkin.makeGhost(0,0,green1,green2);
      popMatrix();
    }
    // else turn ghost right
    else
    {
      mySkin.makeGhost(ghostX,ghostY,green1,green2);
    }
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // MAKE OUR GHOST MOVE!
  ////////////////////////////////////////////////////////
  void updateGhost()
  {
    float attractionToTarget = 0.3;
    float desireToTraceHill = 3.6;
    float dx = kittyRefX - ghostX + mySkin.ghostW/2;
    float dy = kittyRefY - ghostY + mySkin.ghostW/2;
    float dh = sqrt(dx*dx + dy*dy);
  
    if (dh > 0)
    {
      // add in the force due to attraction
      float fx = (dx / dh) * attractionToTarget;
      float fy = (dy / dh) * attractionToTarget;
      ghostVX = ghostVX + fx;
      ghostVY = ghostVY + fy;
    }
  
    // extract 9 terrain values, from my neighborhood
    int terrainArea = 5;
    pixelValues[0] = getTerrainValue (ghostX - terrainArea, ghostY - terrainArea);
    pixelValues[1] = getTerrainValue (ghostX, ghostY - terrainArea);
    pixelValues[2] = getTerrainValue (ghostX + terrainArea, ghostY - terrainArea);
    pixelValues[3] = getTerrainValue (ghostX - terrainArea, ghostY);
    pixelValues[4] = getTerrainValue (ghostX, ghostY);
    pixelValues[5] = getTerrainValue (ghostX + terrainArea, ghostY);
    pixelValues[6] = getTerrainValue (ghostX - terrainArea, ghostY + terrainArea);
    pixelValues[7] = getTerrainValue (ghostX, ghostY + terrainArea);
    pixelValues[8] = getTerrainValue (ghostX + terrainArea, ghostY + terrainArea);
  
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
      float avoidCrossing = pow(pixelValues[4], 0.001);
      float hx = avoidCrossing * desireToTraceHill * sin (Gorientation);
      float hy = avoidCrossing * desireToTraceHill * cos (Gorientation);
      float hh = sqrt(hx*hx + hy*hy); // hill force magnitude
      ghostVX = ghostVX + hx;
      ghostVY = ghostVY + hy;
    }
    
    // STORE THE GHOST'S PREVIOUS POSITION
    p_ghostX = ghostX;
    p_ghostY = ghostY;
    
    // lose our energy on each frame
    ghostVX = ghostVX * 0.9;
    ghostVY = ghostVY * 0.9;
    // integration
    ghostX = ghostX + ghostVX;
    ghostY = ghostY + ghostVY;
    
    // CONSTRAIN GHOSTS TO MAP
    if(ghostY < 0 || ghostY > height)
    {
      ghostY = 0;
    }
    if(ghostX < 0 || ghostX > width)
    {
      ghostX = 0;
    }
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
    int imgW = drawnMap.width;
    int imgH = drawnMap.height;
    
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
