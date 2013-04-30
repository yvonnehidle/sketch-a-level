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
  PImage screen_intro;
  PImage screen_death;
  PImage screen_levelup;
  PImage screen_goals;
  PImage screen_score;
  PImage drawnMap;
  PImage navigation_start;
  PImage navigation_continue;
  PImage navigation_score;
  PImage navigation_restart;
  
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
  boolean playMusicOnce; 
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
  screen_intro = loadImage("screen_intro.png");
  screen_death = loadImage("screen_death.png");
  screen_levelup = loadImage("screen_levelup.png");
  screen_goals = loadImage("screen_goals.png");
  screen_score = loadImage("screen_score.png");
  drawnMap = loadImage("map.png");
  navigation_start = loadImage("navigation_start.png");
  navigation_continue = loadImage("navigation_continue.png");
  navigation_score = loadImage("navigation_score.png");
  navigation_restart = loadImage("navigation_restart.png");
  
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
    showIntro();
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
    showGoals();
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
    levelUp();
  }
  
  // DEATH
  // this is the screen you see after death
  else if(gamePhase == 6)
  {
    showDeath();
  }
  
  // SCORE
  // if you want to see your score, go here
  else if(gamePhase == 7)
  {
    showScore();
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
  background(screen_intro);
  
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
          width -  navigation_start.width - 20,
          height - navigation_start.height - 70
          );
  popStyle();
  
  // if the user touches the screen, start the map generator!
  if (
  mousePressed == true &&
  mouseX > width - navigation_start.width - 20 &&
  mouseX < width &&
  mouseY > height - navigation_start.height - 70 &&
  mouseY < height &&
  gamePhase == 0
  )
  {
    // clear the background once, make it white
    background(255);
    // proceed to drawing the map
    gamePhase = 1;
  }
  
  // check for problems!
  //println("LOOPING: Show introduction");
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
  
  // show goal image
  background(screen_goals);
  
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
  myRed.kittyRefX = myKitty.kittyX;
  myRed.kittyRefY = myKitty.kittyY;
  // to the blue ghost
  myBlue.kittyRefX = myKitty.kittyX+100;
  myBlue.kittyRefY = myKitty.kittyY+100;
  // to the blue ghost
  myGreen.kittyRefX = myKitty.kittyX-100;
  myGreen.kittyRefY = myKitty.kittyY-100;
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
  
  // spawn portals, death traps, wall jumps oh my!
  specials();
  
  // winning and losing
  //lose();
  win();
  
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
    
    // reset the character values!
    myFood.isCatHigh = false;
    
    // reset the food placement
    
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
  background(screen_levelup);
  
  // show the continue button
  pushStyle();
    imageMode(CORNER);
    image(navigation_continue,
          width -  navigation_continue.width - 20,
          height - navigation_continue.height - 70
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
  mouseX > width - navigation_continue.width - 20 &&
  mouseX < width &&
  mouseY > height - navigation_continue.height - 70 &&
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
      
    // make the ghosts go back to level 1
      
    // reset the character values!
    myFood.isCatHigh = false;
      
    // reset the food placement
      
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
  background(screen_death);
  
  // BUTTON IMAGES
  // show the continue button
  pushStyle();
    imageMode(CORNER);
    image(navigation_score,
          70,
          150
          );
    image(navigation_restart,
          70,
          150 + navigation_score.height + 20
          );
  popStyle();
  
  // MUSIC
  // play the music only once!
  if(playMusicOnce == true)
  {
    player.setMediaFile("death.wav");
    player.start();
    playMusicOnce = false; 
  }
  
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
  
  // THE RESET BUTTON
  // if the user touches the restart button, go to the intro page
  if (
  mousePressed == true &&
  mouseX > 90 &&
  mouseX < 90 + navigation_restart.width &&
  mouseY > 150 + navigation_score.height &&
  mouseY < 150 + navigation_score.height + 20 + navigation_restart.height
  )
  {
    println("RESTART TO INTRO");
    // change our game phase to 0
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
  background(screen_score);
  
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
    image(navigation_restart,
          width/2 - navigation_restart.width/2,
          height/2 + navigation_restart.height + 70
          );
  popStyle();
  
  // if the user touches the screen, show our new goals
  if (
  mousePressed == true &&
  mouseX > width/2 - navigation_restart.width/2 &&
  mouseX < width/2 + navigation_restart.width/2 &&
  mouseY > height/2 + navigation_restart.height + 70 &&
  mouseY < height/2 + navigation_restart.height + 70 + navigation_restart.height
  )
  {
    // reset character values
    myFood.isCatHigh = false;
    
    // reset total score values
    myFood.total_kibbleEaten = 0;
    myFood.total_fishEaten = 0;
    myFood.total_ghostsEaten = 0;
    myFood.total_catNipEaten = 0;
    
    // proceed to intro map
    gamePhase = 0;
  }
  
  // display your score
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
      myKitty.kittyX = myMap.portalX[choosePortal];
      myKitty.kittyY = myMap.portalY[choosePortal];
      //println("PORT ME!");
    }
  }
  
  // ALL THINGS DEATH TRAPS
  int[] myTrap = new int[myMap.trapsMax];
  
  for(int i=0; i<myMap.trapsMax; i++)
  {
    // draw them now, only if not on menu
    if(myMap.trapY[i] > 50)
    {
      image(myMap.character_deathtrap,myMap.trapX[i],myMap.trapY[i],myMap.trapSize,myMap.trapSize);
    }
    
    // intialize distances from deathtrap to kitty
    myTrap[i] = int( dist(myKitty.kittyX, myKitty.kittyY, myMap.trapX[i], myMap.trapY[i]) );
    
    // if kitty overlaps trap, then die
    if (myTrap[i] < myMap.trapSize)
    {
      gamePhase=6;
    }
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
