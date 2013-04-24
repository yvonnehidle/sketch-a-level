////////////////////////////////////////////////////////
// DRAWS AND MOVES PACKITTY
////////////////////////////////////////////////////////
class pacKitty
{
  // cat movement
  float kittyX; // x
  float kittyY; // y
  float kittyVX; // velocity in the x
  float kittyVY; // velocity in the y
  float kittyE; // kitty velocity when not on a hill
  boolean isCatHighRef;
  
  // cat appearance
  PShape packitty; // cat svg file
  float kittyW; // width
  float kittyH; // height
  float lipBottom; // lip angle top
  float lipTop; // lip angle bottom
  boolean lipBottomClosed; // is packitty's bottom lip closed?
  boolean lipTopClosed; // is packitty's top lip closed?
  
  // map related
  color mapPixels[]; // colors in collision map
  int n_mapPixels; // number of pixels in collison map
  float pixelValues[]; // neighborhood for the pixels
  
  ////////////////////////////////////////////////////////
  // THE CONSTRUCTOR
  ////////////////////////////////////////////////////////
  pacKitty()
  {
    // cat movement
    kittyX=width/2;
    kittyY=height/2;
    kittyE=0.05;
    
    // cat appearance
    packitty = loadShape("packitty.svg");
    kittyW=50;
    kittyH=kittyW;
    lipBottom=radians(30);
    lipTop=radians(330);
    lipBottomClosed=false; // is packitty's bottom lip closed?
    lipTopClosed=false; // is packitty's top lip closed?
    
    // check for problems!
    //println("LOAD ONCE: Kitty constructor");
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
    
    // check for problems!
    //println("LOAD ONCE: Kitty map calibrated");
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAWING AND MOVING kitty
  ////////////////////////////////////////////////////////
  void play()
  {
    updateCat();
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAWING PACKITTY
  ////////////////////////////////////////////////////////
  void renderCat()
  {
    // general parameters
    fill(137, 172, 191);
    shapeMode(CENTER);
    
    
    // OPEN AND CLOSE PACKITTY'S MOUTH SMOOTHLY
    // bottom lip
    if (lipBottom > radians(0) && lipBottomClosed == false)
    {
      lipBottom=lipBottom-radians(1);
    }
    
    if (lipBottom < radians(0))
    {
      lipBottomClosed=true;
    }
    
    if (lipBottomClosed == true)
    {
      lipBottom=lipBottom+radians(1);
    }
    
    if (lipBottom > radians(30))
    {
      lipBottomClosed=false;
    }
    
    // top lip
    if (lipTop < radians(360) && lipTopClosed == false)
    {
      lipTop=lipTop+radians(1);
    }
    
    if (lipTop > radians(360))
    {
      lipTopClosed=true;
    }
    
    if (lipTopClosed == true)
    {
      lipTop=lipTop-radians(1);
    }
    
    if (lipTop < radians(330))
    {
      lipTopClosed=false;
    }
    
    
    // IS THE CAT HIGGGHHHHHS
    if (isCatHighRef == true)
    {
      // make the cat grow!
      float grow = 1.25;
      
      // packitty's body & mouth
      fill(137, 172, 191);
      arc(0, 0, kittyW*grow, kittyH*grow, lipBottom, lipTop);
      
      // packitty's accessories!
      shapeMode(CENTER);
      shape(packitty, -7, -3, 100*grow, 100*grow);
    }
    
    // ELSE THE CAT IS NORMAL
    else
    {
      // packitty's body & mouth
      fill(137, 172, 191);
      arc(0, 0, kittyW, kittyH, lipBottom, lipTop);
      
      // packitty's accessories!
      shapeMode(CENTER);
      shape(packitty, -7, -3, 100, 100);
    }
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // MAKE OUR CAT MOVE!
  ////////////////////////////////////////////////////////
  void updateCat()
  {
    float attractionToTarget = 0.3;
    float desireToTraceHill = 3.6;
    float dx = mouseX - kittyX + kittyW/2;
    float dy = mouseY - kittyY + kittyW/2;
    float dh = sqrt(dx*dx + dy*dy);
  
    if (dh > 0)
    {
      // add in the force due to attraction
      float fx = (dx / dh) * attractionToTarget;
      float fy = (dy / dh) * attractionToTarget;
      kittyVX = kittyVX + fx;
      kittyVY = kittyVY + fy;
    }
  
    // extract 9 terrain values, from my neighborhood
    int terrainArea = 5;
    pixelValues[0] = getTerrainValue (kittyX - terrainArea, kittyY - terrainArea);
    pixelValues[1] = getTerrainValue (kittyX, kittyY - terrainArea);
    pixelValues[2] = getTerrainValue (kittyX + terrainArea, kittyY - terrainArea);
    pixelValues[3] = getTerrainValue (kittyX - terrainArea, kittyY);
    pixelValues[4] = getTerrainValue (kittyX, kittyY);
    pixelValues[5] = getTerrainValue (kittyX + terrainArea, kittyY);
    pixelValues[6] = getTerrainValue (kittyX - terrainArea, kittyY + terrainArea);
    pixelValues[7] = getTerrainValue (kittyX, kittyY + terrainArea);
    pixelValues[8] = getTerrainValue (kittyX + terrainArea, kittyY + terrainArea);
  
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
    
    // ON THE HILL GRADIENT
    if (Gh > 0) {
      float Gorientation = atan2 (Gy, Gx);
      float avoidCrossing = pow(pixelValues[4], 0.001);
      float hx = avoidCrossing * desireToTraceHill * sin (Gorientation);
      float hy = avoidCrossing * desireToTraceHill * cos (Gorientation);
      float hh = sqrt(hx*hx + hy*hy); // hill force magnitude
      //if (hh > 1.0){
      // hx = hx / hh;
      // hy = hy / hh;
      //}
      
      kittyVX = kittyVX + hx;
      kittyVY = kittyVY + hy;
      
      // lose our energy on each frame
      kittyVX = kittyVX * 0.7;
      kittyVY = kittyVY * 0.7;
      
      kittyX = kittyX + kittyVX;
      kittyY = kittyY + kittyVY;
      //println("I AM ON THE HILL. YAYYY!");
    }
    
    
    // NOT ON THE HILL GRADIENT
    else
    {
      float fingerX = mouseX;
      float fingerY = mouseY;
      float distanceX = fingerX - kittyX;
      float distanceY = fingerY - kittyY;
  
      if(abs(distanceX) > 1)
      {
        kittyX += distanceX * kittyE;
      }
      if(abs(distanceY) > 1)
      {
        kittyY += distanceY * kittyE;
      }
      //println("I am not on the hill :(");
    }
    
    
    // CONSTRAIN KITTY TO THE BOUNDS OF THE MAP
    if(kittyY < 0 || kittyY > height)
    {
      kittyY = 0;
    }
    if(kittyX < 0 || kittyX > width)
    {
      kittyX = 0;
    }
    
    
    // ROTATE THE CAT ACCORDINGLY
    // cat looks left
    if(mouseX < kittyX)
    {
      pushMatrix();
        translate(kittyX,kittyY);
        scale(-1, 1);
        renderCat();
      popMatrix();
    }
    
    // else cat looks right
    else if(mouseX > kittyX)
    {
      pushMatrix();
        translate(kittyX,kittyY);
        renderCat();
      popMatrix();
    }
    
    // else cat looks up
    else if(mouseY < kittyY)
    {
      pushMatrix();
        translate(kittyX,kittyY);
        rotate(radians(-90));
        renderCat();
      popMatrix();
    }
    
    // else cat looks down
    else if(mouseY > kittyX)
    {
      pushMatrix();
        translate(kittyX,kittyY);
        rotate(radians(90));
        renderCat();
      popMatrix();
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
