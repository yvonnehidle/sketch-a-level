////////////////////////////////////////////////////////
// MAP GENERATION SCREEN
// this is a drawing program where you draw your map
////////////////////////////////////////////////////////
class mapGenerator
{   
  // map related
  color srcPixels[];
  color dstPixels[];
  PImage startingMap;

  // menu images
  PImage menu_save_this_map;
  PImage menu_format_map;
  PImage menu_start_game;
  PImage menu_walls;
  PImage menu_eraser;
  PImage menu_clearall;
  
  // platforms
  PImage platform_cat;
  PImage platform_ghost;
  
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
  final int trapsMax = 5;
  int[] trapX = new int[trapsMax];
  int[] trapY = new int[trapsMax];
  float trapSize;
  PImage character_deathtrap;
  
  // wall shrink
  final int shrinkMax = 1;
  int[] shrinkX = new int[shrinkMax];
  int[] shrinkY = new int[shrinkMax];
  float shrinkSize;
  PImage character_shrink;
    
  ////////////////////////////////////////////////////////
  // THE CONSTRUCTOR
  ////////////////////////////////////////////////////////
  mapGenerator()
  { 
    // map related
    dstPixels = new color[width * height];
    
    // menu images
    menu_save_this_map = loadImage("menu_save-this-map.png");        // save map button
    menu_format_map = loadImage("menu_blank.png");                   // format menu button
    menu_start_game = loadImage("menu_blank.png");                   // start menu button
    menu_walls = loadImage("menu_walls-selected.png");               // walls button
    menu_eraser = loadImage("menu_eraser.png");                      // eraser button
    menu_clearall = loadImage("menu_clearall.png");                  // clear all button
    
    // platforms
    platform_cat = loadImage("platform_cat.png");
    platform_ghost = loadImage("platform_ghost.png");
    
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
    trapX[3] = width-200;
    trapY[3] = 20;
    trapX[4] = width-150;
    trapY[4] = 20;
    trapSize = 30;
    character_deathtrap = loadImage("character_deathtrap.png");
    
    // shrink
    shrinkX[0] = width-50;
    shrinkY[0] = 20;
    shrinkSize = 30;
    character_shrink = loadImage("character_shrink.png");
    
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
    
    // PLATFORMS
    image(platform_ghost, width/2, height/2);
    image(platform_cat, width-150, height-200);
   
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
    if(mouseY > 50 && mousePressed == true) 
    { 
//      pushStyle();
//        stroke(0,255);
//        strokeWeight(20);
//        line(pmouseX,pmouseY,mouseX,mouseY);
//      popStyle();

      pushStyle();
        stroke(50,1);
        strokeWeight(130);
          line(pmouseX,pmouseY,mouseX,mouseY);
        stroke(50,3);
        strokeWeight(100);
          line(pmouseX,pmouseY,mouseX,mouseY);
        stroke(50,5);
        strokeWeight(80);
          line(pmouseX,pmouseY,mouseX,mouseY);
        stroke(50,5);
        strokeWeight(60);
          line(pmouseX,pmouseY,mouseX,mouseY);
        stroke(50,5);
        strokeWeight(40);
          line(pmouseX,pmouseY,mouseX,mouseY);
        stroke(50,50);
        strokeWeight(20);
          line(pmouseX,pmouseY,mouseX,mouseY);
        stroke(0,255);
        strokeWeight(10);
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
    if(mouseY > 50 && mousePressed == true) 
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
      println("Directory created");
          
      // crop and save our drawing in the new directory
      save("//sdcard/PacKitty/map.jpg");
      println("Saved map");
          
      // load the new drawing as our new maze
      startingMap = loadImage("//sdcard/PacKitty/map.jpg");
      println("Image loaded to startingMap");
          
      // change the menu to reflect the image has been saved
      menu_save_this_map = loadImage("menu_map-saved.png");
      menu_format_map = loadImage("menu_format-map.png");
          
      // we now have a map, therefore is_map_drawn is true
      is_map_drawn = true;
    }
    
    
    // FORMAT THE MAP
    // if the format map button is pressed, blur our map
    if(
    mousePressed == true &&
    mouseX > menu_save_this_map.width + 50 &&
    mouseX < menu_save_this_map.width + 50 + menu_format_map.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    { 
      // change the button, map is formatted
      menu_format_map = loadImage("menu_formatting.png");
      image(menu_format_map, menu_save_this_map.width + 50, 0);

      // blur map
      println("Blurring map");
      blurMap();
      
      // show blurred map
      background(startingMap);
      
      // change the button, map is formatted
      menu_format_map = loadImage("menu_map-formatted.png");
        
      // show our proceed button
      menu_start_game = loadImage("menu_proceed.png");
    }
    
    
    // GO TO SYMBOLS MENU
    // get things ready to change screens
    if(
    mousePressed == true &&
    mouseX > menu_save_this_map.width + 50 + menu_format_map.width + 50 &&
    mouseX < menu_save_this_map.width + 50 + menu_format_map.width + 50 + menu_start_game.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {   
        // crop and save our drawing in the new directory
        save("//sdcard/PacKitty/map.jpg");
        println("Image saved");
            
        // load the new drawing as our new maze
        drawnMap = loadImage("//sdcard/PacKitty/map.jpg");
        print("Image loaded to drawnMap");
      
        // is_map_drawn must be reset to false
        is_map_drawn = false;
        
        // make our images blank again
        menu_start_game = loadImage("menu_blank.png");
        menu_format_map = loadImage("menu_blank.png");
        startingMap = loadImage("blankmap.png");
        
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
    // format map
    image(menu_format_map, menu_save_this_map.width + 50, 0);
    // start game
    image(menu_start_game, menu_save_this_map.width + 50 + menu_format_map.width + 50, 0);
    
    // draw walls
    image(menu_walls, width - menu_clearall.width - menu_eraser.width - menu_walls.width - 60, 0);
    // eraser
    image(menu_eraser, width - menu_clearall.width - menu_eraser.width - 40, 0);
    // clear screen
    image(menu_clearall, width - menu_clearall.width - 20,0);
    
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
    startingMap.loadPixels(); 
    srcPixels = startingMap.pixels;
    int nPasses = 5; 
    
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
  
    startingMap.updatePixels();
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
    drawWallshrink();
    
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
  // WALL shrink
  // wall shrink lets you shrink for a period of time
  ////////////////////////////////////////////////////////
  void drawWallshrink()
  {
    imageMode(CENTER);
    int[] moveshrink = new int[shrinkMax];
    
    // move the portals by dragging and dropping
    for(int i=0; i<shrinkMax; i++)
    {
      moveshrink[i] = int( dist(mouseX, mouseY, shrinkX[i], shrinkY[i]) );
     
     // lock to mouseX and mouseY
     if (moveshrink[i] < shrinkSize && mousePressed == true)
     {
       shrinkX[i] = mouseX;
       shrinkY[i] = mouseY;
     }
     
     // shrink traps when they are on the menu
     if(shrinkY[i] > 50)
     {
       shrinkSize = 50;
     }
     else
     {
       shrinkSize=30;
     }
     
      // show the portals
      image(character_shrink,shrinkX[i],shrinkY[i],shrinkSize,shrinkSize);
    }
  }
  ////////////////////////////////////////////////////////  
}
