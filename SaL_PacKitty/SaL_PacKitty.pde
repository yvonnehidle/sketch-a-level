////////////////////////////////////////////////////////
// "SKETCH-A-LEVEL" ---> PACKITTY
// Interactive Art and Computational Design, Spring 2013
// M. Yvonne Hidle (yvonnehidle@gmail.com)
//
// CODE CREDITS:
// 1. Sobel blur
// Golan Levin
// http://homepages.inf.ed.ac.uk/rbf/HIPR2/sobel.htm
//
// 3. Pacman sounds
// http://www.classicgaming.cc/classics/pacman/sounds.php
//
// 4. Other sounds
// http://www.sounddogs.com
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // libraries
  import apwidgets.*;

  // images
  PImage screen;
  PImage drawnMap;
  PImage navigation_start;
  PImage navigation_score;
  PImage navigation_newmap;
  PImage navigation_guide;
  
  // screen booleans
  boolean is_intro;
  boolean is_goals;
  boolean is_levelup;
  boolean is_death;
  boolean is_score;
  boolean is_instructions;
  
  // general game variables
  int gamePhase;
  int startTime;
  
  // game goal variables
  int levelNum;
  int goalKibbles;
  int goalFish;
  int goalGhosts;
  
  // classes
  mapGenerator myMap;
  pacKitty myKitty;
  redGhost myRed;
  blueGhost myBlue;
  greenGhost myGreen;
  allFood myFood;
  
  // audio related
  PMediaPlayer player;
  PMediaPlayer player2;
  boolean playMusicOnce; 
  
  // miscellaneous
  boolean isShrunk;
  int startShrink;
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// LOAD OUR CLASSES AND SETUP THE GAME
////////////////////////////////////////////////////////
void setup()
{
  size(1280,800);
  orientation(LANDSCAPE);
  imageMode(CENTER);
  //smooth();
  
  // images
  screen = loadImage("screen_intro.png");
  drawnMap = loadImage("blankmap.png");
  navigation_start = loadImage("navigation_start.png");
  navigation_score = loadImage("navigation_score.png");
  navigation_newmap = loadImage("navigation_newmap.png");
  navigation_guide = loadImage("navigation_guide.png");
  
  // screen booleans
  is_intro = true;
  is_goals = false;
  is_levelup = false;
  is_death = false;
  is_score = false;
  is_instructions = false;
  
  // general game variables
  gamePhase=0;
  startTime=0;
  
  // game goal variables
  levelNum = 1;
  goalKibbles = 10;
  goalFish = 1;
  goalGhosts = 0;
  
  // classes
  myMap = new mapGenerator();
  myKitty = new pacKitty();
  myRed = new redGhost();
  myBlue = new blueGhost();
  myGreen = new greenGhost();
  myFood = new allFood();
  
  // audio related
  player = new PMediaPlayer(this);
  player.setLooping(false);
  playMusicOnce = true;
  player2 = new PMediaPlayer(this);
  player2.setLooping(false);
  
  // miscellaneous
  isShrunk = false;
  startShrink = 0;
  
  // check for problems!
  //println("LOAD ONCE: Drawing setup");
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// GAME TABLE OF CONTENTS
////////////////////////////////////////////////////////
void draw()
{
  // INTRODUCTION SCREEN
  // this is the screen you see when you run the application
  if(gamePhase == 0)
  {
    // make true
    is_intro = true;
    
    // load the introduction image
    if(is_intro == true)
    {
      screen = loadImage("screen_intro.png");
      navigation_start = loadImage("navigation_start.png");
    }
    
    // show the introduction
    showIntro();
    
    // return to false
    is_intro = false;
  }
  
  // MAP GENERATION SCREEN
  // this is a drawing program
  // you draw walls
  else if(gamePhase == 1)
  {
    myMap.drawMap();
  }
  
  // SYMBOL GENERATION SCREEN
  // this is a contiunation of the drawing program
  // you place symbols
  else if(gamePhase == 2)
  {
    myMap.drawSymbols();
  }
  
  // SHOW LEVEL GOALS
  // this is the screen that shows your current level and goals
  else if(gamePhase == 3)
  {
    // make true
    is_goals = true;
    
    // load the goals screen
    if(is_goals == true)
    {
      screen = loadImage("screen_goals.png");
    }
    
    // show the goals page
    showGoals();
    
    // make false
    is_goals = false;
  }
  
  // PLAY THE GAME
  // this is the actual game that you play
  else if(gamePhase == 4)
  {   
    playNow();
  }
  
  // LEVEL UP
  // the screen you see if you win the current level
  else if(gamePhase == 5)
  {
    // make true
    is_levelup = true;
    
    // load the introduction image
    if(is_levelup == true)
    {
      screen = loadImage("screen_levelup.png");
      navigation_start = loadImage("navigation_continue.png");
    }
    
    // show the levelup screen
    levelUp();
    
    // make false
    is_levelup = false;
  }
  
  // DEATH
  // this is the screen you see after death
  else if(gamePhase == 6)
  {
    // make true
    is_death = true;
    
    // load the introduction image
    if(is_death == true)
    {
      screen = loadImage("screen_death.png");
      navigation_start = loadImage("navigation_restart.png");
    }
    
    // show death screen
    showDeath();
    
    // make false
    is_death = false;
  }
  
  // SCORE
  // if you want to see your score, go here
  else if(gamePhase == 7)
  {
    // make true
    is_score = true;
    
    // load the score image
    if(is_score == true)
    {
      screen = loadImage("screen_score.png");
      navigation_start = loadImage("navigation_restart.png");
    }
    
    // show the score screen
    showScore();
    
    // make false
    is_score = false;
  }
  
  // INSTRUCTIONS
  // the game is explained!
  else if(gamePhase == 8)
  {
    // make true
    is_instructions = true;
    
    // load the score image
    if(is_instructions == true)
    {
      screen = loadImage("screen_instructions.png");
      navigation_start = loadImage("navigation_start.png");
    }
    
    // show the score screen
    showInstructions();
    
    // make false
    is_instructions = false;
  }
  
  // check for problems!
  println(frameRate);
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// INTRODUCTION SCREEN
// this is the screen you see when you run the application
////////////////////////////////////////////////////////
void showIntro()
{
  // show intro image!
  background(screen);
  
  // play the music only once!
  if(playMusicOnce == true)
  {
    player.setMediaFile("gameStart.wav");
    player.start();
    playMusicOnce = false;
  }
  
  // level goes back to 1
  // not very clean, but the best place to put it to resolve score issue
  levelNum = 1;
  
  // show the start button
  pushStyle();
    imageMode(CORNER);
    image(navigation_start,
          width -  navigation_start.width - 15,
          height - 60 - navigation_start.height
          );
    image(navigation_guide,
          width -  navigation_guide.width - 15,
          height - 60 - navigation_start.height - 10 - navigation_guide.height
          );
  popStyle();
  
  
  // START BUTTON
  // if the user touches the screen, start the map generator!
  if (
  mousePressed == true &&
  mouseX > width - navigation_start.width - 15 &&
  mouseX < width &&
  mouseY > height - 60 - navigation_start.height &&
  mouseY < height &&
  gamePhase == 0
  )
  {
    // clear the background once, make it white
    background(255);
    // proceed to drawing the map
    gamePhase = 1;
    //println("START BUTTON");
  }
  
  
  // INSTRUCTIONS
  // if the user touches the screen, start the map generator!
  if (
  mousePressed == true &&
  mouseX > width - navigation_guide.width - 15 &&
  mouseX < width &&
  mouseY > height - 60 - navigation_start.height - 10 - navigation_guide.height &&
  mouseY < height - 60 - navigation_start.height &&
  gamePhase == 0
  )
  {
    // proceed to drawing the map
    gamePhase = 8;
    //println("GUIDE BUTTON");
  }
  
  // check for problems!
  //println("LOOPING: Show introduction");
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// INSTRUCTION SCREEN
// this is the screen with instructions!
////////////////////////////////////////////////////////
void showInstructions()
{
  // show intro image!
  background(screen);
  
  // show the start button
  pushStyle();
    imageMode(CORNER);
    image(navigation_start,
          width -  navigation_start.width - 20,
          height - navigation_start.height - 100
          );
  popStyle();
  
  // START BUTTON
  // if the user touches the screen, start the map generator!
  if (
  mousePressed == true &&
  mouseX > width - navigation_start.width - 20 &&
  mouseX < width &&
  mouseY > height - navigation_start.height - 100 &&
  mouseY < height
  )
  {
    // clear the background once, make it white
    background(255);
    // proceed to drawing the map
    gamePhase = 1;
    //println("START BUTTON");
  }
  
  // check for problems!
  //println("LOOPING: Show instructions");
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// SHOW LEVEL GOALS
// this is the screen that shows your current level and goals
////////////////////////////////////////////////////////
void showGoals()
{
  // show goal image
  background(screen);
  
  // countdown, 5 seconds until game starts
  int countDown = 5000;
  
  // intialize these classes once, and only once
  if( (millis()-startTime) > 2000 && (millis()-startTime) < 2500 )
  {
    myBlue.resetMap();
    myGreen.resetMap();
    myRed.resetMap();
    myKitty.resetMap();
    myFood.resetMap();
  }
  
  // display level goals and timer
  pushStyle();
    textAlign(CENTER);
    fill(0);    
    textSize(30);
    text((countDown/1000 - ((millis()-startTime))/1000), width/2, height/2-220);
    
    textSize(20);
    text("L E V E L : " + levelNum, width/2, height/2-160);
    text("Eat " + goalKibbles + " Kibbles", width/2, height/2-120);
    text("Eat " + goalFish + " Tasty Fish", width/2, height/2-80);
    text("Eat " + goalGhosts + " Ghosts", width/2, height/2-40);
  popStyle();
  
  // our countdown timer, after the time is up go play the game
  if ((millis()-startTime) > countDown)
  {
    gamePhase=4;
  }
  
  // check for problems!
  //println("LOOPING: Showing goals");
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// PLAY THE GAME
// this is the actual game that you play
////////////////////////////////////////////////////////
void playNow()
{
  // show the map the user drew
  //image(drawnMap, 0, 0);
  background(drawnMap);
  
  // transfer variables from one class to another
  // to the red ghost
  myRed.kittyRefX = myKitty.kittyX-50;
  myRed.kittyRefY = myKitty.kittyY-50;
  myRed.isCatHighRef = myFood.isCatHigh;
  // to the blue ghost
  myBlue.kittyRefX = myKitty.kittyX;
  myBlue.kittyRefY = myKitty.kittyY;
  myBlue.isCatHighRef = myFood.isCatHigh;
  // to the blue ghost
  myGreen.kittyRefX = myKitty.kittyX+50;
  myGreen.kittyRefY = myKitty.kittyY+50;
  myGreen.isCatHighRef = myFood.isCatHigh;
  // to the food class
  myFood.kittyRefX = myKitty.kittyX;
  myFood.kittyRefY = myKitty.kittyY;
  // to the kitty class
  myKitty.isCatHighRef = myFood.isCatHigh;
  
  // show the game menu
  gameMenu();
  
  // spawn food
  myFood.spawn();

  // spawn characters and move them
  myKitty.play();
  myRed.play();
  myBlue.play();
  myGreen.play();
  
  // spawn portals, death traps, wall shrinks oh my!
  specials();
  eatGhosts();
  
  // winning and losing
  lose();
  win();
  
  //noLoop();
  
  // check for problems!
  //println("LOOPING: Game play");
  //println("Kibbles Eaten: " + myFood.kibbleEaten);
  //println("Kibbles Goal: " + goalKibbles);
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// GAME MENU
// this is the menu on the top that shows goals and options
////////////////////////////////////////////////////////
void gameMenu()
{
  // hide the menu (temp fix)
  pushStyle();
    fill(0);
    rect(0,0,width,50);
  popStyle();
  
  pushStyle();
    textAlign(LEFT);
    fill(255);
    textSize(20);
    text("L E V E L : " + levelNum, 20, 30);
      
    textSize(15);
    text(nf(myFood.kibbleEaten,0,0) + "/" + goalKibbles + " Kibbles", 200, 30);
    text(nf(myFood.fishEaten,0,0) + "/" + goalFish + " Tasty Fish", 400, 30);
    text(nf(myFood.ghostsEaten,0,0) + "/" + goalGhosts + " Ghosts", 600, 30);
  popStyle();
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// WIN!!! I.E. YOU LEVEL UP!
////////////////////////////////////////////////////////
void win()
{
  if (myFood.kibbleEaten >= goalKibbles && myFood.fishEaten >= goalFish)
  {    
    // new level
    levelNum++;
    
    // up the goals!
    goalKibbles = goalKibbles+5;
    goalFish++;
    goalGhosts++;
    
    // make the ghosts faster!
    myBlue.frictionClear = myBlue.frictionClear + 0.1;
    myGreen.frictionClear = myGreen.frictionClear + 0.1;
    myRed.frictionClear = myRed.frictionClear + 0.1;
    
    // reset the character values!
    myBlue.ghostX = myBlue.ghostXstart;
    myBlue.ghostY = myBlue.ghostYstart;
    myGreen.ghostX = myGreen.ghostXstart;
    myGreen.ghostY = myGreen.ghostYstart;
    myRed.ghostX = myRed.ghostXstart;
    myRed.ghostY = myRed.ghostYstart;
    myKitty.kittyX = myKitty.kittyXstart;
    myKitty.kittyY = myKitty.kittyYstart;
    myFood.isCatHigh = false;
    
    // reset the score
    myFood.kibbleEaten = 0;
    myFood.fishEaten = 0;
    myFood.ghostsEaten = 0;
    
    // pacKitty wins this level!
    playMusicOnce = true;
    gamePhase=5;
  }
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// LEVEL UP SCREEN
// look! you leveled up!
////////////////////////////////////////////////////////
void levelUp()
{
  // show intro image!
  background(screen);
  
  // show the continue button
  pushStyle();
    imageMode(CORNER);
    image(navigation_start,
          width -  navigation_start.width - 20,
          height - navigation_start.height - 70
          );
  popStyle();
  
  if(playMusicOnce == true)
  {
    player.setMediaFile("win.wav");
    player.start();
    playMusicOnce = false;
  }
  
  // if the user touches the screen, show our new goals
  if (
  mousePressed == true &&
  mouseX > width - navigation_start.width - 20 &&
  mouseX < width &&
  mouseY > height - navigation_start.height - 70 &&
  mouseY < height
  )
  {
    // start timer
    startTime=millis();
    // proceed to drawing the map
    gamePhase = 3;
  }
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// DEATH!!! I.E. YOU LOSE
////////////////////////////////////////////////////////
void lose()
{
  float blueDeath = dist(myKitty.kittyX, myKitty.kittyY, myBlue.ghostX, myBlue.ghostY);
  float greenDeath = dist(myKitty.kittyX, myKitty.kittyY, myGreen.ghostX, myGreen.ghostY);
  float redDeath = dist(myKitty.kittyX, myKitty.kittyY, myRed.ghostX, myRed.ghostY);
  
  if (blueDeath < myKitty.kittyW && myFood.isCatHigh == false || greenDeath < myKitty.kittyW && myFood.isCatHigh == false || redDeath < myKitty.kittyW && myFood.isCatHigh == false)
  {     
    // make all goals go back to level 1
    goalKibbles = 10;
    goalFish = 1;
    goalGhosts = 0;
      
    // make the ghosts slow again
    myBlue.frictionClear = 0.7;
    myGreen.frictionClear = 0.7;
    myRed.frictionClear = 0.7;
      
    // reset the character values!
    myBlue.ghostX = myBlue.ghostXstart;
    myBlue.ghostY = myBlue.ghostYstart;
    myGreen.ghostX = myGreen.ghostXstart;
    myGreen.ghostY = myGreen.ghostYstart;
    myRed.ghostX = myRed.ghostXstart;
    myRed.ghostY = myRed.ghostYstart;
    myKitty.kittyX = myKitty.kittyXstart;
    myKitty.kittyY = myKitty.kittyYstart;
    myFood.isCatHigh = false;
      
    // reset the score
    myFood.kibbleEaten = 0;
    myFood.fishEaten = 0;
    myFood.ghostsEaten = 0;
  
    // pacKitty dies!
    playMusicOnce = true;
    gamePhase=6;
  }
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// DEATH SCREEN
// this is the screen you see when you die
////////////////////////////////////////////////////////
void showDeath()
{
  // show intro image!
  background(screen);
  
  // MUSIC
  // play the music only once!
  if(playMusicOnce == true)
  {
    player.setMediaFile("death.wav");
    player.start();
    playMusicOnce = false; 
  }
  
  // BUTTON IMAGES 
  // show the continue button
  pushStyle();
    imageMode(CORNER);
    image(navigation_score,
          70,
          150
          );
    image(navigation_start,
          70,
          150 + navigation_score.height + 20
          );
    image(navigation_newmap,
          70,
          150 + navigation_score.height + 20 + navigation_start.height + 20
          );
  popStyle();
  
  
  // THE SCORE BUTTON
  // if the user touches the score button, show the score
  if (
  mousePressed == true &&
  mouseX > 70 &&
  mouseX < 70 + navigation_score.width &&
  mouseY > 150 &&
  mouseY < 150 + navigation_score.height
  )
  {
    println("SCORE!");
    // get the music ready
    playMusicOnce = true;
    // change our game phase to 7
    gamePhase = 7;
  }
  
  
  // THE RESTART BUTTON
  // if the user touches the restart button, go to the goals page
  if (
  mousePressed == true &&
  mouseX > 70 &&
  mouseX < 70 + navigation_start.width &&
  mouseY > 150 + navigation_score.height &&
  mouseY < 150 + navigation_score.height + 20 + navigation_start.height
  )
  {
    // start timer
    startTime=millis();
    
    println("RESTART TO INTRO");
    // change our game phase to 0
    playMusicOnce = true;
    gamePhase = 3;
  }
  
  
  // THE NEW MAP BUTTON
  // if the user touches the new map button, go to the intro
  if (
  mousePressed == true &&
  mouseX > 70 &&
  mouseX < 70 + navigation_start.width &&
  mouseY > 150 + navigation_score.height + 20 + navigation_start.height &&
  mouseY < 150 + navigation_score.height + 20 + navigation_start.height + 20 + navigation_newmap.height
  )
  {
    // reset portals
    myMap.portalX[0] = width-550;
    myMap.portalY[0] = 20;
    myMap.portalX[1] = width-500;
    myMap.portalY[1] = 20;
    myMap.portalX[2] = width-450;
    myMap.portalY[2] = 20;
    
    // reset deathtraps
    myMap.trapX[0] = width-350;
    myMap.trapY[0] = 20;
    myMap.trapX[1] = width-300;
    myMap.trapY[1] = 20;
    myMap.trapX[2] = width-250;
    myMap.trapY[2] = 20;
    myMap.trapX[3] = width-200;
    myMap.trapY[3] = 20;
    myMap.trapX[4] = width-150;
    myMap.trapY[4] = 20;
    
    // reset shrinks
    myMap.shrinkX[0] = width-50;
    myMap.shrinkY[0] = 20;
    
    // change our game phase to 0
    println("RESTART TO GOALS");
    playMusicOnce = true;
    gamePhase = 0;
  }
  
  // check for problems!
  //println("LOOPING: Show death screen");
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// SCORE SCREEN
// how much you have eaten total!
////////////////////////////////////////////////////////
void showScore()
{
  // show intro image!
  background(screen);
  
  // play the music
  if(playMusicOnce == true)
  {
    player.setMediaFile("score.wav");
    player.start();
    playMusicOnce = false;
  }
  
  // show the continue button  
  pushStyle();
    imageMode(CORNER);
    image(navigation_start,
          width/2 - navigation_start.width/2,
          height/2 + 100
          );
    image(navigation_newmap,
          width/2 - navigation_start.width/2,
          height/2 + 100 + navigation_start.height + 20
          );
  popStyle();
  
  
  // THE RESTART BUTTON IS THIS
  // you go back to goals!
  if (
  mousePressed == true &&
  mouseX > width/2 - navigation_start.width/2 &&
  mouseX < width/2 + navigation_start.width/2 &&
  mouseY > height/2 + 100 &&
  mouseY < height/2 + 100 + navigation_start.height
  )
  {
    // reset character values
    myFood.isCatHigh = false;
    
    // reset total score values
    myFood.total_kibbleEaten = 0;
    myFood.total_fishEaten = 0;
    myFood.total_ghostsEaten = 0;
    myFood.total_catNipEaten = 0;
    
    // start timer
    startTime=millis();
    
    // proceed to goals map!
    gamePhase = 3;
  }
  
  
  // THE NEW MAP BUTTON IS THIS
  // you go back to the introduction page!
  if (
  mousePressed == true &&
  mouseX > width/2 - navigation_start.width/2 &&
  mouseX < width/2 + navigation_start.width/2 &&
  mouseY > height/2 + 100 + navigation_start.height + 20 &&
  mouseY < height/2 + 100 + navigation_start.height + 20 + navigation_newmap.height
  )
  {
    // reset character values
    myFood.isCatHigh = false;
    
    // reset portals
    myMap.portalX[0] = width-550;
    myMap.portalY[0] = 20;
    myMap.portalX[1] = width-500;
    myMap.portalY[1] = 20;
    myMap.portalX[2] = width-450;
    myMap.portalY[2] = 20;
    
    // reset deathtraps
    myMap.trapX[0] = width-350;
    myMap.trapY[0] = 20;
    myMap.trapX[1] = width-300;
    myMap.trapY[1] = 20;
    myMap.trapX[2] = width-250;
    myMap.trapY[2] = 20;
    myMap.trapX[3] = width-200;
    myMap.trapY[3] = 20;
    myMap.trapX[4] = width-150;
    myMap.trapY[4] = 20;
    
    // reset shrinks
    myMap.shrinkX[0] = width-50;
    myMap.shrinkY[0] = 20;
    
    // proceed to intro map
    gamePhase = 0;
  }
  
  
  // DISPLAY YOUR SCORE
  pushStyle();
    textAlign(CENTER);
    fill(0);      
    textSize(20);
    text("Highest Level: " + nf(levelNum,0,0), width/2, height/2-160);
    text("Kibbles Eaten: " + nf(myFood.total_kibbleEaten,0,0), width/2, height/2-120);
    text("Tasty Fish Eaten: " + nf(myFood.total_fishEaten,0,0), width/2, height/2-80);
    text("Ghosts Eaten: " + nf(myFood.total_ghostsEaten,0,0), width/2, height/2-40);
    text("Cat Nip Eaten: " + nf(myFood.total_catNipEaten,0,0), width/2, height/2);
  popStyle();
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// SPECIAL FEATURES
// this function gets called by main
// we need it to show all our portals and what-not
////////////////////////////////////////////////////////
void specials()
{
  // ALL THINGS PORTALS! 
  int[] myPort = new int[myMap.portalsMax];
  int[] myPortBlue = new int[myMap.portalsMax];
  int[] myPortGreen = new int[myMap.portalsMax];
  int[] myPortRed = new int[myMap.portalsMax];
  
  // make them portal you!
  for(int i=0; i<myMap.portalsMax; i++)
  {
    // draw them now, only if not on main bar
    if(myMap.portalY[i] > 50)
    {
      image(myMap.character_portal,myMap.portalX[i],myMap.portalY[i],myMap.portalSize,myMap.portalSize);
    }
  
    // intialize distances from portal to kitty
    myPort[i] = int( dist(myKitty.kittyX,myKitty.kittyY,myMap.portalX[i],myMap.portalY[i]) );
    // intialize distances from deathtrap to ghost
    myPortBlue[i] = int( dist(myBlue.ghostX, myBlue.ghostY, myMap.portalX[i], myMap.portalY[i]) );
    myPortGreen[i] = int( dist(myGreen.ghostX, myGreen.ghostY, myMap.portalX[i], myMap.portalY[i]) );
    myPortRed[i] = int( dist(myRed.ghostX, myRed.ghostY, myMap.portalX[i], myMap.portalY[i]) );
    
    // if kitty overlaps our portal, port him properly
    if (myPort[i] < myMap.portalSize)
    { 
      // randomly roll a number
      int choosePortal = int( random(0,3) );
      
      // if the portals are the same, reroll
      if(myMap.portalX[i] == myMap.portalX[choosePortal])
      {
        //println("Portal the same, try again");
        choosePortal = int( random(0,3) );
      }
      
      // relocate the kitty
      myKitty.kittyX = myMap.portalX[choosePortal] - 50;
      myKitty.kittyY = myMap.portalY[choosePortal] - 50;
      //println("PORT ME!");
    }
    
    
    // if blue overlaps our portal, port him properly
    if (myPortBlue[i] < myMap.portalSize)
    { 
      // randomly roll a number
      int choosePortal = int( random(0,3) );
      
      // if the portals are the same, reroll
      if(myMap.portalX[i] == myMap.portalX[choosePortal])
      {
        //println("Portal the same, try again");
        choosePortal = int( random(0,3) );
      }
      
      // relocate the ghost
      myBlue.ghostX = myMap.portalX[choosePortal] - 50;
      myBlue.ghostY = myMap.portalY[choosePortal] - 50;
    }
    
    
    // if green overlaps our portal, port him properly
    if (myPortGreen[i] < myMap.portalSize)
    { 
      // randomly roll a number
      int choosePortal = int( random(0,3) );
      
      // if the portals are the same, reroll
      if(myMap.portalX[i] == myMap.portalX[choosePortal])
      {
        //println("Portal the same, try again");
        choosePortal = int( random(0,3) );
      }
      
      // relocate the ghost
      myGreen.ghostX = myMap.portalX[choosePortal] - 50;
      myGreen.ghostY = myMap.portalY[choosePortal] - 50;
    }
    
    
    // if red overlaps our portal, port him properly
    if (myPortRed[i] < myMap.portalSize)
    { 
      // randomly roll a number
      int choosePortal = int( random(0,3) );
      
      // if the portals are the same, reroll
      if(myMap.portalX[i] == myMap.portalX[choosePortal])
      {
        //println("Portal the same, try again");
        choosePortal = int( random(0,3) );
      }
      
      // relocate the ghost
      myRed.ghostX = myMap.portalX[choosePortal] - 50;
      myRed.ghostY = myMap.portalY[choosePortal] - 50;
    }
  }
  
  
  // ALL THINGS DEATH TRAPS
  int[] myTrap = new int[myMap.trapsMax];
  int[] myTrapBlue = new int[myMap.trapsMax];
  int[] myTrapGreen = new int[myMap.trapsMax];
  int[] myTrapRed = new int[myMap.trapsMax];
  
  for(int i=0; i<myMap.trapsMax; i++)
  {
    // draw them now, only if not on menu
    if(myMap.trapY[i] > 50)
    {
      image(myMap.character_deathtrap,myMap.trapX[i],myMap.trapY[i],myMap.trapSize,myMap.trapSize);
    }
    
    // intialize distances from deathtrap to kitty
    myTrap[i] = int( dist(myKitty.kittyX, myKitty.kittyY, myMap.trapX[i], myMap.trapY[i]) );
    // intialize distances from deathtrap to ghost
    myTrapBlue[i] = int( dist(myBlue.ghostX, myBlue.ghostY, myMap.trapX[i], myMap.trapY[i]) );
    myTrapGreen[i] = int( dist(myGreen.ghostX, myGreen.ghostY, myMap.trapX[i], myMap.trapY[i]) );
    myTrapRed[i] = int( dist(myRed.ghostX, myRed.ghostY, myMap.trapX[i], myMap.trapY[i]) );
    
    // if kitty overlaps trap, then die
    if (myTrap[i] < myMap.trapSize)
    {
      // reset the cat values
      myKitty.kittyX = myKitty.kittyXstart;
      myKitty.kittyY = myKitty.kittyYstart;
      myFood.isCatHigh = false;
      
      // die!
      gamePhase=6;
    }
    
    // if blue ghost hits the trap, he must die!
    if (myTrapBlue[i] < myMap.trapSize)
    {
      myBlue.ghostX = myBlue.ghostXstart;
      myBlue.ghostY = myBlue.ghostYstart;
    }
    
    // if green ghost hits the trap, he must die!
    if (myTrapGreen[i] < myMap.trapSize)
    {
      myGreen.ghostX = myGreen.ghostXstart;
      myGreen.ghostY = myGreen.ghostYstart;
    }
    
    // if red ghost hits the trap, he must die!
    if (myTrapRed[i] < myMap.trapSize)
    {
      myRed.ghostX = myRed.ghostXstart;
      myRed.ghostY = myRed.ghostYstart;
    }
  }
  
  
  // ALL THINGS FOR SHRINKS
  int[] myShrink = new int[myMap.shrinkMax];
  int countDown = 10000;
  
  for(int i=0; i<myMap.shrinkMax; i++)
  {
    // draw them now, only if not on menu
    if(myMap.shrinkY[i] > 50)
    {
      image(myMap.character_shrink,myMap.shrinkX[i],myMap.shrinkY[i],myMap.shrinkSize,myMap.shrinkSize);
    }
    
    // intialize distances from shrink to kitty
    myShrink[i] = int( dist(myKitty.kittyX, myKitty.kittyY, myMap.shrinkX[i], myMap.shrinkY[i]) );
    
    // if kitty overlaps shrink, then....
    if (myShrink[i] < myMap.shrinkSize && isShrunk == false)
    {
      // cat grows
      player2.setMediaFile("catnip-shrink.wav");
      player2.start();
      
      // start high timer
      startShrink = millis();
      
      // is shrunk is true
      isShrunk = true;      
    }
    
    if ((millis()-startShrink) > countDown)
    {
      // cat shrinks
      player2.setMediaFile("catnip-grow.wav");
      
      // cat is big again
      isShrunk = false;
    }
  }
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// EAT GHOSTS!!!
////////////////////////////////////////////////////////
void eatGhosts()
{
  // set distances from different ghosts
  float yum_myBlue = dist(myKitty.kittyX, myKitty.kittyY, myBlue.ghostX, myBlue.ghostY);
  float yum_myGreen = dist(myKitty.kittyX, myKitty.kittyY, myGreen.ghostX, myGreen.ghostY);
  float yum_myRed = dist(myKitty.kittyX, myKitty.kittyY, myRed.ghostX, myRed.ghostY);
  
  // eat the blue ghost
  if(yum_myBlue < myKitty.kittyW && myFood.isCatHigh == true)
  {
    player2.setMediaFile("eatGhost.mp3");
    player2.start();
    myBlue.ghostX = myBlue.ghostXstart;
    myBlue.ghostY = myBlue.ghostYstart;
    myFood.ghostsEaten++;
    myFood.total_ghostsEaten++;
  }
  
  // eat the green ghost
  if (yum_myGreen < myKitty.kittyW && myFood.isCatHigh == true)
  {
    player2.setMediaFile("eatGhost.mp3");
    player2.start();
    myGreen.ghostX = myGreen.ghostXstart;
    myGreen.ghostY = myGreen.ghostYstart;
    myFood.ghostsEaten++;
    myFood.total_ghostsEaten++;
  }
  
  // eat the red ghost
  if (yum_myRed < myKitty.kittyW && myFood.isCatHigh == true)
  {
    player2.setMediaFile("eatGhost.mp3");
    player2.start();
    myRed.ghostX = myRed.ghostXstart;
    myRed.ghostY = myRed.ghostYstart;
    myFood.ghostsEaten++;
    myFood.total_ghostsEaten++;
  }
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// AUDIO RELATED
////////////////////////////////////////////////////////
public void onDestroy() 
{
  super.onDestroy();
  if(player != null) 
  {
    player.release();
  }
}
////////////////////////////////////////////////////////
