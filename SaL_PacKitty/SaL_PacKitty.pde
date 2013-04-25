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
  PImage introImage;
  PImage deathImage;
  PImage levelImage;
  PImage goalImage;
  PImage drawnMap;
  PImage game_start;
  PImage game_continue;
  PImage game_score;
  PImage game_restart;
  
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
  game_start = loadImage("game_start.png");
  game_continue = loadImage("game_continue.png");
  game_score = loadImage("game_score.png");
  game_restart = loadImage("game_restart.png");
  
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
  //println(frameRate);
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
  background(introImage);
  
  // play the music only once!
  if(playMusicOnce == true)
  {
    player.setMediaFile("gameStart.wav");
    player.start();
    playMusicOnce = false;
  }
  
  // show the start button
  pushStyle();
    imageMode(CORNER);
    image(game_start,
          width -  game_start.width - 20,
          height - game_start.height - 70
          );
  popStyle();
  
  // if the user touches the screen, start the map generator!
  if (
  mousePressed == true &&
  mouseX > width - game_start.width - 20 &&
  mouseX < width &&
  mouseY > height - game_start.height - 70 &&
  mouseY < height
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
  if(levelNum == 1 && (millis()-startTime) > 2000 && (millis()-startTime) < 2500)
  {
    myBlue.resetMap();
    myGreen.resetMap();
    myRed.resetMap();
    myKitty.resetMap();
    myFood.resetMap();
  }
  
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
  
  // winning and losing
  lose();
  win();
  
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
  background(levelImage);
  
  // show the continue button
  pushStyle();
    imageMode(CORNER);
    image(game_continue,
          width -  game_continue.width - 20,
          height - game_continue.height - 70
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
  mouseX > width - game_continue.width - 20 &&
  mouseX < width &&
  mouseY > height - game_continue.height - 70 &&
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
  background(deathImage);
  
  // show the continue button
  pushStyle();
    imageMode(CORNER);
    image(game_score,
          70,
          150
          );
    image(game_restart,
          70,
          150 + game_score.height + 20
          );
  popStyle();
  
  // play the music only once!
  if(playMusicOnce == true)
  {
    player.setMediaFile("death.wav");
    player.start();
    playMusicOnce = false; 
  }
  
  // if the user touches the score button, show the score
  if (
  mousePressed == true &&
  mouseX > 70 &&
  mouseX < 70 + game_score.width &&
  mouseY > 150 &&
  mouseY < 150 + game_score.height
  )
  {
    println("SCORE!");
    // change our game phase to 7
    gamePhase = 7;
  }
  
  // if the user touches the restart button, go to the intro page
  if (
  mousePressed == true &&
  mouseX > 90 &&
  mouseX < 90 + game_restart.width &&
  mouseY > 150 + game_score.height &&
  mouseY < 150 + game_score.height + 20 + game_restart.height
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
  background(goalImage);
  
  // show the continue button
  pushStyle();
    imageMode(CORNER);
    image(game_restart,
          width -  game_restart.width - 20,
          height - game_restart.height - 70
          );
  popStyle();
  
  // if the user touches the screen, show our new goals
  if (
  mousePressed == true &&
  mouseX > width - game_restart.width - 20 &&
  mouseX < width &&
  mouseY > height - game_restart.height - 70 &&
  mouseY < height
  )
  {
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
