////////////////////////////////////////////////////////
// MAP GENERATION SCREEN
// this is a drawing program where you draw your map
////////////////////////////////////////////////////////
class mapGenerator
{   
  // map related
  color srcPixels[];
  color dstPixels[];

  // menu images
  PImage menu_save_this_map;
  PImage menu_start_game;
  PImage menu_walls;
  PImage menu_eraser;
  PImage menu_clearall;
  
  // booleans for menu
  boolean is_map_drawn;
  boolean is_walls;
  boolean is_eraser;
  boolean is_clearall;
  
  // portals
  final int portalsMax = 3;
  int[] portalX = new int[portalsMax];
  int[] portalY = new int[portalsMax];
  float portalSize;
  PImage character_portal;
  
  // death traps
  final int trapsMax = 3;
  int[] trapX = new int[trapsMax];
  int[] trapY = new int[trapsMax];
  float trapSize;
  PImage character_deathtrap;
  
  // wall jumps
  final int jumpsMax = 3;
  int[] jumpX = new int[jumpsMax];
  int[] jumpY = new int[jumpsMax];
  float jumpSize;
  PImage character_jump;
    
  ////////////////////////////////////////////////////////
  // THE CONSTRUCTOR
  ////////////////////////////////////////////////////////
  mapGenerator()
  { 
    // map related
    dstPixels = new color[width * height];
    
    // menu images
    menu_save_this_map = loadImage("menu_save-this-map.png");        // save map button
    menu_start_game = loadImage("menu_blank.png");                   // start menu button
    menu_walls = loadImage("menu_walls-selected.png");               // walls button
    menu_eraser = loadImage("menu_eraser.png");                      // eraser button
    menu_clearall = loadImage("menu_clearall.png");                  // clear all button
    
    // booleans for map making
    is_map_drawn = false;
    
    // booleans for menu
    is_walls = true;
    is_eraser = false;
    is_clearall = false;
    
    // portals
    // start position
    portalX[0] = width-550;
    portalY[0] = 20;
    portalX[1] = width-500;
    portalY[1] = 20;
    portalX[2] = width-450;
    portalY[2] = 20;
    portalSize = 30;
    character_portal = loadImage("character_portal.png");
    
    // deathtraps
    trapX[0] = width-350;
    trapY[0] = 20;
    trapX[1] = width-300;
    trapY[1] = 20;
    trapX[2] = width-250;
    trapY[2] = 20;
    trapSize = 30;
    character_deathtrap = loadImage("character_deathtrap.png");
    
    // jumps
    jumpX[0] = width-150;
    jumpY[0] = 20;
    jumpX[1] = width-100;
    jumpY[1] = 20;
    jumpX[2] = width-50;
    jumpY[2] = 20;
    jumpSize = 30;
    character_jump = loadImage("character_jump.png");
    
    // check for problems!
    //println("LOAD ONCE: Map generator constructor");
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAW THE MAP FIRST
  ////////////////////////////////////////////////////////
  void drawMap()
  {
    // GENERAL PARAMETERS
    noStroke();
    fill(0);
    imageMode(CORNER);
   
    // DRAWING MENU
    pushStyle();
      fill(0);
      rect(0,0,width,50);
    popStyle();
    mapMenu();
      
    // DRAWING BUTTONS
    if(is_walls == true)
    {
      drawWalls();
    }
    else if(is_eraser == true)
    {
      drawEraser();
    }
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAW WALLS
  // walls are boundaries
  ////////////////////////////////////////////////////////
  void drawWalls()
  {
    if(mouseY > 100 && mousePressed == true) 
    { 
      pushStyle();
        stroke(0,255);
        strokeWeight(20);
        line(pmouseX,pmouseY,mouseX,mouseY);
      popStyle();
    }
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAW ERASER
  // eraser deletes drawn walls
  ////////////////////////////////////////////////////////
  void drawEraser()
  {
    if(mouseY > 100 && mousePressed == true) 
    { 
      pushStyle();
        stroke(255,255);
        strokeWeight(50);
        line(pmouseX,pmouseY,mouseX,mouseY);
      popStyle();
    }
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // MENU FOR MAP DRAWING TOOL
  ////////////////////////////////////////////////////////
  void mapMenu()
  {     
    // SAVE THE MAP
    // if save button is pressed, save image to data folder
    if(  
    mousePressed == true &&
    mouseX > 10 && 
    mouseX < menu_start_game.width && 
    mouseY > 0 && 
    mouseY < menu_start_game.height
    )
    {        
      // make a new directory to save files
      File folder = new File("//sdcard/PacKitty/");
      folder.mkdirs();
          
      // crop and save our drawing in the new directory
      save("//sdcard/PacKitty/map.jpg");
          
      // load the new drawing as our new maze
      drawnMap = loadImage("//sdcard/PacKitty/map.jpg");
          
      // change the menu to reflect the image has been saved
      menu_save_this_map = loadImage("menu_map-saved.png");
      menu_start_game = loadImage("menu_proceed.png");
          
      // we now have a map, therefore is_map_drawn is true
      is_map_drawn = true;
    }
    
    
    // PROCEED TO SYMBOLS MENU!
    // if the start button is pressed, go to next gamephase
    if(
    mousePressed == true &&
    mouseX > menu_save_this_map.width + 50 &&
    mouseX < menu_save_this_map.width + 50 + menu_start_game.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    { 
        // blur map
        blurMap();
        
        // is_map_drawn must be reset to false
        is_map_drawn = false;
        menu_start_game = loadImage("menu_blank.png");
        
        // change map to previous
        menu_save_this_map = loadImage("menu_save-this-map.png");
        
        // switch phases
        gamePhase = 2;
    }
    
    
    // ALL THE DRAWING TOOLS
    // if the wall button is pressed
    if(
    mousePressed == true &&
    mouseX > width - menu_clearall.width - menu_eraser.width - menu_walls.width - 40 &&
    mouseX < width - menu_clearall.width - menu_eraser.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      println("Walls Button");
      is_walls = true;
      is_eraser = false;
      is_clearall = false;
      
      if(is_walls == true)
      {
        menu_walls = loadImage("menu_walls-selected.png");
        menu_eraser = loadImage("menu_eraser.png");
        menu_clearall = loadImage("menu_clearall.png");
      }
    }
    // if the eraser button is pressed
    else if(
    mousePressed == true &&
    mouseX > width - menu_clearall.width - menu_eraser.width - 20 &&
    mouseX < width - menu_clearall.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      println("Eraser Button");
      is_walls = false;
      is_eraser = true;
      is_clearall = false;
      
      if(is_eraser == true)
      {
        menu_walls = loadImage("menu_walls.png");
        menu_eraser = loadImage("menu_eraser-selected.png");
        menu_clearall = loadImage("menu_clearall.png");
      }
    }
    // if the clearall button is pressed
    else if(
    mousePressed == true &&
    mouseX > width - menu_clearall.width &&
    mouseX < width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      println("Clear All Button");
      is_walls = false;
      is_eraser = false;
      is_clearall = true;
      
      if(is_clearall == true)
      {
        menu_walls = loadImage("menu_walls.png");
        menu_eraser = loadImage("menu_eraser.png");
        menu_clearall = loadImage("menu_clearall-selected.png");
        
        // clear the background if mouse is pressed
        if(mousePressed == true)
        {
          pushStyle();
            fill(255);
            rect(0,50,width,height);
          popStyle();
        }
      }
    }
    
    
    // MENU BUTTONS   
    // save map
    image(menu_save_this_map, 10, 0);
    // draw walls
    image(menu_walls, width - menu_clearall.width - menu_eraser.width - menu_walls.width - 60, 0);
    // eraser
    image(menu_eraser, width - menu_clearall.width - menu_eraser.width - 40, 0);
    // clear screen
    image(menu_clearall, width - menu_clearall.width - 20,0);
    // start game
    image(menu_start_game, menu_save_this_map.width + 50, 0);
    
    //println(is_map_drawn);
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // BLUR DRAWN MAP
  ////////////////////////////////////////////////////////
  void blurMap()
  {
    drawnMap.loadPixels(); 
    srcPixels = drawnMap.pixels;
    int nPasses = 20; 
    
    // FOR THE X DIRECTION PLEASE
    for (int p=0; p<nPasses; p++) 
    {
      for (int y=0; y<height; y++) 
      {
        for (int x=0; x<width; x++) 
        {
          int row = (y*width) + x; 
          int i0 = row - 3;
          int i1 = row - 2;
          int i2 = row - 1;
          int i3 = row    ; 
          int i4 = row + 1;
          int i5 = row + 2;
          int i6 = row + 3;
    
          color c0 = (x < 3)        ? 255: srcPixels[i0];
          color c1 = (x < 2)        ? 255: srcPixels[i1];
          color c2 = (x < 1)        ? 255: srcPixels[i2];
          color c3 =                       srcPixels[i3];
          color c4 = (x >= width-1) ? 255: srcPixels[i4];
          color c5 = (x >= width-2) ? 255: srcPixels[i5];
          color c6 = (x >= width-3) ? 255: srcPixels[i6];
            
          float b0 =      (0xFF & c0); // extract the blue value
          float b1 = 6  * (0xFF & c1); 
          float b2 = 15 * (0xFF & c2); 
          float b3 = 20 * (0xFF & c3); 
          float b4 = 15 * (0xFF & c4); 
          float b5 = 6  * (0xFF & c5); 
          float b6 =      (0xFF & c6);
            
          int avg = (int)((b0+b1+b2+b3+b4+b5+b6)/64);
          dstPixels[i3] = color(avg);
        }
      } 
      int nPixels = width * height; 
      for (int i=0; i<nPixels; i++) 
      {
        srcPixels[i] = dstPixels[i];
      }
    }
  
    // FOR THE Y DIRECTION PLEASE
    for (int p=0; p<nPasses; p++) 
    {
      for (int y=0; y<height; y++) 
      {
        for (int x=0; x<width; x++) 
        {
          int j0 = (y-3)*width + x;
          int j1 = (y-2)*width + x;
          int j2 = (y-1)*width + x;
          int j3 = (y)*width + x;
          int j4 = (y+1)*width + x;
          int j5 = (y+2)*width + x;
          int j6 = (y+3)*width + x;
          
          color color0 = (y < 3)          ? 255: srcPixels[j0];
          color color1 = (y < 2)          ? 255: srcPixels[j1];
          color color2 = (y < 1)          ? 255: srcPixels[j2];
          color color3 =                         srcPixels[j3];
          color color4 = (y >= height-1)  ? 255: srcPixels[j4];
          color color5 = (y >= height-2)  ? 255: srcPixels[j5];
          color color6 = (y >= height-3)  ? 255: srcPixels[j6];
          
          float blue0 =      (0xFF & color0);
          float blue1 = 6  * (0xFF & color1);
          float blue2 = 15 * (0xFF & color2);
          float blue3 = 20 * (0xFF & color3);
          float blue4 = 15 * (0xFF & color4);
          float blue5 = 6  * (0xFF & color5);
          float blue6 =      (0xFF & color6);
          
          int avg2 = (int)((blue0+blue1+blue2+blue3+blue4+blue5+blue6)/64);
          dstPixels[j3] = color(avg2);
        }
      } 
      int nPixels = width * height; 
      for (int i=0; i<nPixels; i++) 
      {
        srcPixels[i] = dstPixels[i];
      }
    }
  
    drawnMap.updatePixels();
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAW THE SYMBOLS NEXT
  ////////////////////////////////////////////////////////
  void drawSymbols()
  {
    noStroke();
    fill(0);
    imageMode(CORNER);
    
    // SHOW THE MAP THAT WAS DRAWN
    background(drawnMap);
      
    // DRAWING MENU
    pushStyle();
      fill(0);
      rect(0,0,width,50);
    popStyle();
    symbolsMenu();
      
    drawPortals();
    drawDeathtraps();
    drawWalljump();
    
    // CHECK FOR PROBLEMS
    //println(trapX);
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // MENU FOR SYMBOL PLACING TOOL
  ////////////////////////////////////////////////////////
  void symbolsMenu()
  {     
    // SHOW THE START GAME BUTTON
    menu_start_game = loadImage("menu_start-game.png");
    
    // PLAY THE GAME
    // if the start button is pressed, go to next gamephase
    if(
    mousePressed == true &&
    mouseX > 10 &&
    mouseX < menu_start_game.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {      
      // change map to previous
      menu_save_this_map = loadImage("menu_save-this-map.png");
      menu_start_game = loadImage("menu_blank.png");
      // switch phases
      gamePhase = 3;
      // start timer
      startTime=millis();
      // is_map_drawn must be reset to false
      is_map_drawn = false;
    }
    
    // MENU BUTTONS   
    // start game
    image(menu_start_game, 10, 0);
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAW PORTALS
  // portals allow you to teleport from one point to the next
  ////////////////////////////////////////////////////////
  void drawPortals()
  {
    imageMode(CENTER);
    int[] movePortal = new int[portalsMax];
    
    // move portals by dragging and dropping
    for(int i=0; i<portalsMax; i++)
    {
      movePortal[i] = int( dist(mouseX, mouseY, portalX[i], portalY[i]) );
     
     // lock portal to mouseX and mouseY
     if(movePortal[i] < portalSize && mousePressed == true)
     {
       portalX[i] = mouseX;
       portalY[i] = mouseY;
     }
     
     // shrink portals when they are on the menu
     if(portalY[i] > 50)
     {
       portalSize = 50;
     }
     else
     {
       portalSize=30;
     }
     
     // show the portals
     image(character_portal,portalX[i],portalY[i],portalSize,portalSize);
    }
    
    // check for problems
    //println(portalX);
    //println(portalY);
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAW DEATH TRAPS
  // death traps kill you and the ghosts
  ////////////////////////////////////////////////////////
  void drawDeathtraps()
  {   
    imageMode(CENTER);
    int[] moveTrap = new int[trapsMax];
    
    // move the portals by dragging and dropping
    for(int i=0; i<trapsMax; i++)
    {
      moveTrap[i] = int( dist(mouseX, mouseY, trapX[i], trapY[i]) );
     
     // lock to mouseX and mouseY
     if (moveTrap[i] < trapSize && mousePressed == true)
     {
       trapX[i] = mouseX;
       trapY[i] = mouseY;
     }
     
     // shrink traps when they are on the menu
     if(trapY[i] > 50)
     {
       trapSize = 50;
     }
     else
     {
       trapSize=30;
     }
     
      // show the portals
      image(character_deathtrap,trapX[i],trapY[i],trapSize,trapSize);
    }
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // WALL JUMP
  // wall jump lets you jump over a wall for a period of time
  ////////////////////////////////////////////////////////
  void drawWalljump()
  {
    imageMode(CENTER);
    int[] moveJump = new int[jumpsMax];
    
    // move the portals by dragging and dropping
    for(int i=0; i<jumpsMax; i++)
    {
      moveJump[i] = int( dist(mouseX, mouseY, jumpX[i], jumpY[i]) );
     
     // lock to mouseX and mouseY
     if (moveJump[i] < jumpSize && mousePressed == true)
     {
       jumpX[i] = mouseX;
       jumpY[i] = mouseY;
     }
     
     // shrink traps when they are on the menu
     if(jumpY[i] > 50)
     {
       jumpSize = 50;
     }
     else
     {
       jumpSize=30;
     }
     
      // show the portals
      image(character_jump,jumpX[i],jumpY[i],jumpSize,jumpSize);
    }
  }
  ////////////////////////////////////////////////////////  
}
