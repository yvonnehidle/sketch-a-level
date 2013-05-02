////////////////////////////////////////////////////////
// DRAWS AND MOVES PACKITTY
////////////////////////////////////////////////////////
class pacKitty
{
  // cat movement
  float kittyX; // x
  float kittyY; // y
  float kittyXstart; // starting x position
  float kittyYstart; // starting y position
  float kittyS; // velocity
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
  int darknessThreshold;
  float fingerX;
  float fingerY;
  float distanceX;
  float distanceY;
  
  ////////////////////////////////////////////////////////
  // THE CONSTRUCTOR
  ////////////////////////////////////////////////////////
  pacKitty()
  {
    // cat movement
    kittyXstart = width-90;
    kittyYstart = height-130;
    kittyX = kittyXstart;
    kittyY = kittyYstart;
    kittyS = 5;
    kittyE = 0.05;
    
    // cat appearance
    packitty = loadShape("character_packitty.svg");
    kittyW=50;
    kittyH=kittyW;
    lipBottom=radians(30);
    lipTop=radians(330);
    lipBottomClosed=false; // is packitty's bottom lip closed?
    lipTopClosed=false; // is packitty's top lip closed?
    
    // map related
    darknessThreshold = 20;
    
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
    
    // check for problems!
    println("LOAD ONCE: Kitty map calibrated");
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
    
    // IS CAT SHRUNK?
    else if(isShrunk == true)
    {
      //make the cat shrink!
      float shrink = .7;
      
      // packitty's body & mouth
      fill(137, 172, 191);
      arc(0, 0, kittyW*shrink, kittyH*shrink, lipBottom, lipTop);
      
      // packitty's accessories!
      shapeMode(CENTER);
      shape(packitty, -7, -3, 100*shrink, 100*shrink);
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
    // what is the pixel number in the array?
    int loc = int( kittyX + kittyY * drawnMap.width );
    // target our finger
    fingerX = mouseX;
    fingerY = mouseY;
    distanceX = fingerX - kittyX;
    distanceY = fingerY - kittyY;
    
    // ON WALL
    // if the brightness of the pixel is less than our darkness threshold
    // then do not move the kitty
     if(brightness(drawnMap.pixels[loc]) < darknessThreshold)
     {
       if(mousePressed == true)
       {
         if(distanceX > 0)
         {
           kittyX = kittyX - kittyW/2;
         }
         else if(distanceX < 0)
         {
           kittyX = kittyX + kittyW/2;
         }
         if(distanceY > 0)
         {
           kittyY = kittyY - kittyW/2;
         }
         else if(distanceY < 0)
         {
           kittyY = kittyY + kittyW/2;
         }
       }
     }
  
   // NOT ON WALL
   // else always move the kitty
   else
   {
     if(mousePressed == true)
     {
       if(abs(distanceX) > 1)
       {
         kittyX += distanceX * kittyE;
       }
       if(abs(distanceY) > 1)
       {
         kittyY += distanceY * kittyE;
       }
     }
   }


// // EASY CONTROL FOR TESTING PURPOSES
// if(mousePressed == true)
// {
//   if(abs(distanceX) > 1)
//   {
//     kittyX += distanceX * kittyE;
//   }
//   if(abs(distanceY) > 1)
//   {
//     kittyY += distanceY * kittyE;
//   }
// }
    
    
    // CONSTRAIN KITTY TO THE BOUNDS OF THE MAP
    // if too far up
    if(kittyY-kittyW/2 < 50)
    {
      kittyY = height-kittyW/2;
    }
    // if too far down
    else if(kittyY+kittyW/2 > height)
    {
      kittyY = 100+kittyW/2;
    }
    // if too far left
    else if(kittyX-kittyW/2 < 0)
    {
      kittyX = width-kittyW/2;
    }
    // if too far right
    else if(kittyX+kittyW/2 > width)
    {
      kittyX = kittyW/2;
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
    else
    {
      pushMatrix();
        translate(kittyX,kittyY);
        renderCat();
      popMatrix();
    }
  }
  ////////////////////////////////////////////////////////
  
}
