////////////////////////////////////////////////////////
// MAP GENERATION SCREEN
// this is a drawing program where you draw your map
////////////////////////////////////////////////////////
class mapGenerator
{   
  // menu images
  PImage menu_save_this_map;
  PImage menu_start_game;
  PImage menu_walls;
  PImage menu_eraser;
  PImage menu_clearall;
  PImage menu_portals;
  PImage menu_deathtraps;
  PImage menu_walljump;
  
  // booleans for menu
  boolean is_map_drawn;
  boolean is_map_ready;
  boolean is_walls;
  boolean is_eraser;
  boolean is_clearall;
  boolean is_portals;
  boolean is_deathtraps;
  boolean is_walljump;
  
  // portals
  final int portalsMax = 3;
  int[] portalX = new int[portalsMax];
  int[] portalY = new int[portalsMax];
  float portalSize;
  
  // death traps
  final int trapsMax = 3;
  int[] trapX = new int[trapsMax];
  int[] trapY = new int[trapsMax];
  float trapSize;
  
  // wall jumps
    
  ////////////////////////////////////////////////////////
  // THE CONSTRUCTOR
  ////////////////////////////////////////////////////////
  mapGenerator()
  {      
    // menu images
    menu_save_this_map = loadImage("menu_save-this-map.png");        // save map button
    menu_start_game = loadImage("menu_blank.png");                   // start menu button
    menu_walls = loadImage("menu_walls-selected.png");               // walls button
    menu_eraser = loadImage("menu_eraser.png");                      // eraser button
    menu_clearall = loadImage("menu_clearall.png");                  // clear all button
    menu_portals = loadImage("menu_portals-selected.png");           // portals button
    menu_deathtraps = loadImage("menu_deathtraps.png");              // traps button
    menu_walljump = loadImage("menu_walljump.png");                  // wall jump button
    
    // booleans for map making
    is_map_drawn = false;
    is_map_ready = false;
    
    // booleans for menu
    is_walls = true;
    is_eraser = false;
    is_clearall = false;
    is_portals = false;
    is_deathtraps = false;
    is_walljump = false;
    
    // portals
    portalX[0] = width-400;
    portalY[0] = 100;
    portalX[1] = width-500;
    portalY[1] = 100;
    portalX[2] = width-600;
    portalY[2] = 100;
    portalSize = 50;
    
    // deathtraps
    trapX[0] = width-100;
    trapY[0] = 100;
    trapX[1] = width-200;
    trapY[1] = 100;
    trapX[2] = width-300;
    trapY[2] = 100;
    trapSize = 50;
    
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
    if(mouseY > 100) 
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
    if(mouseY > 100) 
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
      println("Directory Made");
      
      // crop and save our drawing in the new directory
      save("//sdcard/PacKitty/map.jpg");
      println("Map Saved");
      
      // load the new drawing as our new maze
      drawnMap = loadImage("//sdcard/PacKitty/map.jpg");
      println("Map Loaded");
      
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
      // is_map_drawn must be reset to false
      is_map_drawn = false;
      menu_start_game = loadImage("menu_blank.png");
      // change map to previous
      menu_save_this_map = loadImage("menu_save-this-map.png");
      
      // switch phases
      gamePhase = 2;
      // make sure portals are ready to be used
      is_portals = true; 
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
      
    // DRAWING BUTTONS
    if(is_portals == true)
    {
      drawPortals();
    }
    else if(is_deathtraps == true)
    {
      drawDeathtraps();
    }
    else if(is_walljump == true)
    {
      drawWalljump();
    }
    
    // KEEP OUR SYMBOLS ON SCREEN
    for(int i=0; i<trapsMax; i++)
    {
      pushStyle();      
        // portals
        stroke(0,174,239);
        fill(255);
        strokeWeight(5);
        ellipse(portalX[i], portalY[i], portalSize, portalSize);
        
        // death traps
        rectMode(CENTER);
        noStroke();
        fill(255,0,0);
        rect(trapX[i], trapY[i], trapSize, trapSize);
      popStyle();
    }
    
    // CHECK FOR PROBLEMS
    println(trapX);
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // MENU FOR SYMBOL PLACING TOOL
  ////////////////////////////////////////////////////////
  void symbolsMenu()
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
      // change the menu to reflect the image has been saved
      menu_save_this_map = loadImage("menu_map-saved.png");
      menu_start_game = loadImage("menu_start-game.png");
      
      // we now have a map, therefore is_map_drawn is true
      is_map_ready = true;
    }
    
    
    // PLAY THE GAME
    // if the start button is pressed, go to next gamephase
    if(
    mousePressed == true &&
    mouseX > menu_save_this_map.width + 50 &&
    mouseX < menu_save_this_map.width + 50 + menu_start_game.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height &&
    is_map_ready == true
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
      is_map_ready = false;
      is_map_drawn = false;
    }
    
    
    // ALL THE DRAWING TOOLS
    // if the portals button is pressed
    if(
    mousePressed == true &&
    mouseX > width - menu_walljump.width - menu_deathtraps.width - menu_portals.width - 40 &&
    mouseX < width - menu_walljump.width - menu_deathtraps.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      println("Portals Button");
      is_portals = true;
      is_deathtraps = false;
      is_walljump = false;
      
      if(is_portals == true)
      {
        menu_portals = loadImage("menu_portals-selected.png");
        menu_deathtraps = loadImage("menu_deathtraps.png");
        menu_walljump = loadImage("menu_walljump.png");
      }
    }
    // if the deathtraps button is pressed
    else if(
    mousePressed == true &&
    mouseX > width - menu_walljump.width - menu_deathtraps.width - 20 &&
    mouseX < width - menu_walljump.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      println("Deathtraps Button");
      is_portals = false;
      is_deathtraps = true;
      is_walljump = false;
      
      if(is_deathtraps == true)
      {
        menu_portals = loadImage("menu_portals.png");
        menu_deathtraps = loadImage("menu_deathtraps-selected.png");
        menu_walljump = loadImage("menu_walljump.png");
      }
    }
    // if the walljump button is pressed
    else if(
    mousePressed == true &&
    mouseX > width - menu_walljump.width &&
    mouseX < width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      println("Walljump Button");
      is_portals = false;
      is_deathtraps = false;
      is_walljump = true;
      
      if(is_walljump == true)
      {
        menu_portals = loadImage("menu_portals.png");
        menu_deathtraps = loadImage("menu_deathtraps.png");
        menu_walljump = loadImage("menu_walljump-selected.png");
      }
    }
    
    
    // MENU BUTTONS   
    // save map
    image(menu_save_this_map, 10, 0);
    // portals
    image(menu_portals, width - menu_walljump.width - menu_deathtraps.width - menu_portals.width - 40, 0);
    // deathtraps
    image(menu_deathtraps, width - menu_walljump.width - menu_deathtraps.width - 20, 0);
    // walljump
    image(menu_walljump, width - menu_walljump.width,0);    
    // start game
    image(menu_start_game, menu_save_this_map.width + 50, 0);
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAW PORTALS
  // portals allow you to teleport from one point to the next
  ////////////////////////////////////////////////////////
  void drawPortals()
  {
//    if(mouseY > 100 && mousePressed == true)
//    {
//      
//      // shift array location
//      for(int i=0; i<portalX.length-1; i++)
//      {
//        portalX[i] = portalX[i+1];
//        portalY[i] = portalY[i+1];
//      }
//      
//      // new location is the x and the y
//      portalX[portalX.length-1] = mouseX;
//      portalY[portalY.length-1] = mouseY;      
//    }

    // move trap, drag and drop?
    int[] movePortal = new int[portalsMax];
    for(int i=0; i<portalsMax; i++)
    {
      movePortal[i] = int( dist(mouseX, mouseY, portalX[i], portalY[i]) );
     
     if (movePortal[i] < portalSize && mousePressed == true)
     {
       portalX[i] = mouseX;
       portalY[i] = mouseY;
     }
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
//    if(mouseY > 100 && mousePressed == true)
//    {
//      
//      // shift array location
//      for(int i=0; i<trapX.length-1; i++)
//      {
//        trapX[i] = trapX[i+1];
//        trapY[i] = trapY[i+1];
//      }
//      
//      // new location is the x and the y
//      trapX[trapX.length-1] = mouseX;
//      trapY[trapY.length-1] = mouseY;      
//    }
    
    
    // move trap, drag and drop?
    int[] moveTrap = new int[trapsMax];
    for(int i=0; i<trapsMax; i++)
    {
      moveTrap[i] = int( dist(mouseX, mouseY, trapX[i], trapY[i]) );
     
     if (moveTrap[i] < trapSize && mousePressed == true)
     {
       trapX[i] = mouseX;
       trapY[i] = mouseY;
     }
    }
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // WALL JUMP
  // wall jump lets you jump over a wall for a period of time
  ////////////////////////////////////////////////////////
  void drawWalljump()
  {
  }
  ////////////////////////////////////////////////////////  
}
