////////////////////////////////////////////////////////
// "SKETCH-A-LEVEL" ---> PACKITTY
// Interactive Art and Computational Design, Spring 2013
// M. Yvonne Hidle (yvonnehidle@gmail.com)
//
// CODE CREDITS:
// 1. Collision mapping based off code from Laurel Deel
// http://www.openprocessing.org/sketch/43601
//
// 2. Sobel blur
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
  PImage introImage;
  PImage deathImage;
  PImage levelImage;
  PImage goalImage;
  PImage drawnMap;
  
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
  introImage = loadImage("intro-screen.png");
  deathImage = loadImage("death-screen.png");
  levelImage = loadImage("levelup-screen.png");
  goalImage = loadImage("goals-screen.png");
  drawnMap = loadImage("map.png");
  
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
  player.setVolume(1.0, 1.0);
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
    
    // play the music only once!
    if(playMusicOnce == true)
    {
      player.setMediaFile("gameStart.wav");
      player.start();
      playMusicOnce = false; 
    }
  }
  
  // MAP GENERATION SCREEN
  // this is a drawing program where you draw your map
  else if(gamePhase == 1)
  {
    drawMap();
  }
  
  // SHOW LEVEL GOALS
  // this is the screen that shows your current level and goals
  else if(gamePhase == 2)
  {
    showGoals();
  }
  
  // PLAY THE GAME
  // this is the actual game that you play
  else if(gamePhase == 3)
  {
    playNow();
  }
  
  // LEVEL UP
  // the screen you see if you win the current level
  else if(gamePhase == 4)
  {
    //levelUp();
  }
  
  // DEATH AND SCORE
  // this is the screen you see after death, show level and goal achievements
  else if(gamePhase == 5)
  {
    showDeath();
  }
  
  // check for problems!
  println(frameRate);
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// INTRODUCTION SCREEN
// this is the screen you see when you run the application
////////////////////////////////////////////////////////
void showIntro()
{
  // show intro image!
  background(introImage);
  
  // if the user touches the screen, start the map generator!
  if (mousePressed)
  {
    // clear the background once, make it white
    background(255);
    // change our game phase to 1
    gamePhase = 1;
  }
  
  // check for problems!
  //println("LOOPING: Show introduction");
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// MAP GENERATION SCREEN
// this is a drawing program where you draw your map
////////////////////////////////////////////////////////
void drawMap()
{
  myMap.drawNow();
  
  if(myMap.is_map_drawn == true)
  {  
    // intialize these classes once, and only once
    myBlue.resetMap();
    myGreen.resetMap();
    myRed.resetMap();
    myKitty.resetMap();
    myMap.is_map_drawn = false;
  }
  
  // check for problems!
  //println("LOOPING: Map generator");
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// SHOW LEVEL GOALS
// this is the screen that shows your current level and goals
////////////////////////////////////////////////////////
void showGoals()
{
  // countdown, 5 seconds until game starts
  int countDown = 5000;
  
  // show goal image
  background(goalImage);
  
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
    gamePhase=3;
  }
  
  // check for problems!
  //println("LOOPING: Showing goals");
}
////////////////////////////////////////////////////////

////////////////////////////////////////////////////////
// PLAY THE GAME
// this is the actual game that you play
////////////////////////////////////////////////////////
void playNow()
{
  // show the map the user drew
  image(drawnMap, 0, 0);
  //background(drawnMap);
  
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
  
  // winning and losing
  lose();
  //win();
  
  // check for problems!
  //println("LOOPING: Game play");
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
    fill(255);
    rect(0,0,width,50);
  popStyle();
  
  pushStyle();
    textAlign(LEFT);
    fill(0);
    textSize(20);
    text("L E V E L : " + levelNum, 20, 30);
      
    textSize(15);
    text(nf(myFood.kibbleEaten,0,0) + "/" + goalKibbles + " Kibbles", 200, 30);
    text(nf(myFood.fishEaten,0,0) + "/" + goalFish + " Tasty Fish", 400, 30);
    text(nf(myFood.ghostsEaten,0,0) + "/" + goalGhosts + " Ghosts", 600, 30);
  popStyle();
}
////////////////////////////////////////////////////////

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
  // pacKitty dies!
  playMusicOnce = true;
  gamePhase=5;
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
  background(deathImage);
  
  // play the music only once!
  if(playMusicOnce == true)
  {
    player.setMediaFile("death.wav");
    player.start();
    playMusicOnce = false; 
  }
  
  // if the user touches the screen, start the map generator!
  if (mousePressed)
  {
    // clear the background once, make it white
    background(255);
    // change our game phase to 0
    playMusicOnce = true;
    gamePhase = 0;
  }
  
  // check for problems!
  //println("LOOPING: Show death screen");
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
