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
  PImage menu_portals;
  PImage menu_deathtraps;
  PImage menu_walljump;
  
  // booleans for menu
  boolean is_map_drawn;
  boolean is_walls;
  boolean is_eraser;
  boolean is_portals;
  boolean is_deathtraps;
  boolean is_walljump;
  
  // portal locations
  final int portalsMax = 3;
  int[] portalX = new int[portalsMax];
  int[] portalY = new int[portalsMax];
    
  ////////////////////////////////////////////////////////
  // THE CONSTRUCTOR
  ////////////////////////////////////////////////////////
  mapGenerator()
  {
    // map buttons
    menu_save_this_map = loadImage("menu_save-this-map.png");
    
    // start button
    menu_start_game = loadImage("menu_start-game.png");
    
    // walls
    menu_walls = loadImage("menu_walls-selected.png");
    
    // eraser
    menu_eraser = loadImage("menu_eraser.png");
    
    // portals
    menu_portals = loadImage("menu_portals.png");
    
    // deathtraps
    menu_deathtraps = loadImage("menu_deathtraps.png");
    
    // wall jumps
    menu_walljump = loadImage("menu_walljump.png");
    
    // booleans for menu
    is_map_drawn = false;
    is_walls = true;
    is_eraser = false;
    is_portals = false;
    is_deathtraps = false;
    is_walljump = false;
    
    // portal locations
    for(int i=0; i<portalX.length; i++)
    {
      portalX[i] = 0;
      portalY[i] = 0;
    }
    
    // check for problems!
    //println("LOAD ONCE: Map generator constructor");
  }
  ////////////////////////////////////////////////////////
  
  
  ////////////////////////////////////////////////////////
  // MAP GENERATOR GOES HERE
  ////////////////////////////////////////////////////////
  void drawNow()
  { 
    // BASIC DRAWING PARAMETERS
    noStroke();
    fill(0);
    imageMode(CORNER);
    
    // DRAWING MENU
    theMenu();
    
    // DRAWING BUTTONS
    if(is_walls == true)
    {
      drawWalls();
    }
    else if(is_eraser == true)
    {
      drawEraser();
    }
    else if(is_portals == true)
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
  // DRAW PORTALS
  // portals allow you to teleport from one point to the next
  ////////////////////////////////////////////////////////
  void drawPortals()
  {
    if(mouseY > 100)
    {
      // shift array location
      for(int i=0; i<portalX.length-1; i++)
      {
        portalX[i] = portalX[i+1];
        portalY[i] = portalY[i+1];
      }
      
      // new location is the x and the y
      portalX[portalX.length-1] = mouseX;
      portalY[portalY.length-1] = mouseY;
      
      for(int i=0; i<portalX.length; i++)
      {
        noStroke();
        fill(255,0,0);
        ellipse(portalX[i], portalY[i], 20, 20);
      }
    }
    
    // check for problems
    println(portalX);
    //println(portalY);
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // DRAW DEATH TRAPS
  // death traps kill you and the ghosts
  ////////////////////////////////////////////////////////
  void drawDeathtraps()
  {
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
  
  ////////////////////////////////////////////////////////
  // MAP GENERATOR GOES HERE
  ////////////////////////////////////////////////////////
  void theMenu()
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
      ////////////////////////////////////////////////////////// ENABLE FOR PC TESTING
      //drawnMap = get(0,50,width,height);
//      save("data/map.png");
//      drawnMap = loadImage("map.png");
      //////////////////////////////////////////////////////////
      
      ////////////////////////////////////////////////////////// ENABLE FOR ANDROID TESTING
      // make a new directory to save files
      File folder = new File("//sdcard/PacKitty/");
      folder.mkdirs();
      println("Directory Made");
      
      // crop and save our drawing in the new directory
      save("//sdcard/PacKitty/map.png");
      println("Map Saved");
      
      // load the new drawing as our new maze
      drawnMap = loadImage("//sdcard/PacKitty/map.png");
      println("Map Loaded");
      //////////////////////////////////////////////////////////
      
      // change the menu to reflect the image has been saved
      menu_save_this_map = loadImage("menu_map-saved.png");
      
      // we now have a map, therefore is_map_drawn is true
      is_map_drawn = true;
    }
    
    
    // PLAY THE GAME
    // if the start button is pressed, go to next gamephase
    if(
    mousePressed == true &&
    mouseX > menu_save_this_map.width + 50 &&
    mouseX < menu_save_this_map.width + 50 + menu_start_game.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      // switch phases
      gamePhase = 2;
      // start timer
      startTime=millis();
      // is_map_drawn must be reset to false
      is_map_drawn = false;
    }
    
    
    // ALL THE DRAWING TOOLS
    // if the wall button is pressed
    if(
    mousePressed == true &&
    mouseX > width - menu_walljump.width - menu_deathtraps.width - menu_portals.width - menu_eraser.width - menu_walls.width - 80 &&
    mouseX < width - menu_walljump.width - menu_deathtraps.width - menu_portals.width - menu_eraser.width - 30 &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      println("Wall Button");
      is_walls = true;
      is_eraser = false;
      is_portals = false;
      is_deathtraps = false;
      is_walljump = false;
      
      if(is_walls == true)
      {
        menu_walls = loadImage("menu_walls-selected.png");
        menu_eraser = loadImage("menu_eraser.png");
        menu_portals = loadImage("menu_portals.png");
        menu_deathtraps = loadImage("menu_deathtraps.png");
        menu_walljump = loadImage("menu_walljump.png");
      }
    }
    // if the eraser button is pressed
    else if(
    mousePressed == true &&
    mouseX > width - menu_walljump.width - menu_deathtraps.width - menu_portals.width - menu_eraser.width - 60 &&
    mouseX < width - menu_walljump.width - menu_deathtraps.width - menu_portals.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      println("Eraser Button");
      is_walls = false;
      is_eraser = true;
      is_portals = false;
      is_deathtraps = false;
      is_walljump = false;
      
      if(is_eraser == true)
      {
        menu_walls = loadImage("menu_walls.png");
        menu_eraser = loadImage("menu_eraser-selected.png");
        menu_portals = loadImage("menu_portals.png");
        menu_deathtraps = loadImage("menu_deathtraps.png");
        menu_walljump = loadImage("menu_walljump.png");
      }
    }
    // if the portals button is pressed
    else if(
    mousePressed == true &&
    mouseX > width - menu_walljump.width - menu_deathtraps.width - menu_portals.width - 40 &&
    mouseX < width - menu_walljump.width - menu_deathtraps.width &&
    mouseY > 0 &&
    mouseY < menu_start_game.height
    )
    {
      println("Portals Button");
      is_walls = false;
      is_eraser = false;
      is_portals = true;
      is_deathtraps = false;
      is_walljump = false;
      
      if(is_portals == true)
      {
        menu_walls = loadImage("menu_walls.png");
        menu_eraser = loadImage("menu_eraser.png");
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
      is_walls = false;
      is_eraser = false;
      is_portals = false;
      is_deathtraps = true;
      is_walljump = false;
      
      if(is_deathtraps == true)
      {
       menu_walls = loadImage("menu_walls.png");
        menu_eraser = loadImage("menu_eraser.png");
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
      is_walls = false;
      is_eraser = false;
      is_portals = false;
      is_deathtraps = false;
      is_walljump = true;
      
      if(is_walljump == true)
      {
        menu_walls = loadImage("menu_walls.png");
        menu_eraser = loadImage("menu_eraser.png");
        menu_portals = loadImage("menu_portals.png");
        menu_deathtraps = loadImage("menu_deathtraps.png");
        menu_walljump = loadImage("menu_walljump-selected.png");
      }
    }
    
    
    // MENU BUTTONS   
    // save map
    image(menu_save_this_map, 10, 0);
    // draw walls
    image(menu_walls, width - menu_walljump.width - menu_deathtraps.width - menu_portals.width - menu_eraser.width - menu_walls.width - 80, 10);
    // eraser
    image(menu_eraser, width - menu_walljump.width - menu_deathtraps.width - menu_portals.width - menu_eraser.width - 60, 10);
    // portals
    image(menu_portals, width - menu_walljump.width - menu_deathtraps.width - menu_portals.width - 40, 10);
    // deathtraps
    image(menu_deathtraps, width - menu_walljump.width - menu_deathtraps.width - 20, 10);
    // walljump
    image(menu_walljump, width - menu_walljump.width,10);    
    
    // only show the start game button if a map has been drawn and saved
    if(is_map_drawn == true)
    {
      // start game
      image(menu_start_game, menu_save_this_map.width + 50, 0);
    }
  }
  ////////////////////////////////////////////////////////
  
}
