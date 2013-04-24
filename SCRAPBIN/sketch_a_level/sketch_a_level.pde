////////////////////////////////////////////////////////
// "SKETCH-A-LEVEL"
// Interactive Art and Computational Design, Spring 2013
// M. Yvonne Hidle (yvonnehidle@gmail.com)
//
// CODE CREDITS:
// 1. Collision mapping based off code from Laurel Deel
//    http://www.openprocessing.org/sketch/43601
//
// 2. Sobel blur
//    Golan Levin
//    http://homepages.inf.ed.ac.uk/rbf/HIPR2/sobel.htm
//
// 3. Pacman sounds
//    http://www.classicgaming.cc/classics/pacman/sounds.php
//
// 4. Other sounds
//    http://www.sounddogs.com
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // import libraries
  
  // classes
  PacKitty myKitty;
  GhostA myGhostA;
  GhostB myGhostB;
  GhostC myGhostC;
  Food myFood;
  
  // images
  PImage visibleMap;
  PImage introImage;
  PImage deathImage;
  PImage levelImage;
  
  // general game variables
  int gamePhase;
  int startTime;
  int levelNum;
  int goalKibbles;
  int goalFish;
  int goalGhosts;
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// LOAD OUR CLASSES AND SETUP THE GAME
////////////////////////////////////////////////////////
void setup()
{
  size(1280,800);
  orientation(LANDSCAPE);
  imageMode(CENTER);
  smooth();
    
  // classes
  myKitty = new PacKitty();
  myGhostA = new GhostA();
  myGhostB = new GhostB();
  myGhostC = new GhostC();
  myFood = new Food();
  
  // images
  introImage = loadImage("intro-screen.png");
  deathImage = loadImage("death-screen.png");
  levelImage = loadImage("levelup-screen.png");
  visibleMap = loadImage("map.png");
  
  // general game variables
  gamePhase=0;
  startTime=0;
  levelNum = 1;
  goalKibbles = 10;
  goalFish = 1;
  goalGhosts = 0;
  
  // because the music is being annoying!
  if (gamePhase == 0)
  {
  }
  
  // intialize sobel filter map
  myGhostA.setup();
  myGhostB.setup();
  myGhostC.setup();
  
  // intialize character positions
  myGhostA.startPos();
  myGhostB.startPos();
  myGhostC.startPos();
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GAME TABLE OF CONTENTS
////////////////////////////////////////////////////////
void draw()
{ 
  
  // intro screen
  if(gamePhase == 0)
  {
    showIntro();
  }
  // goals for level
  else if(gamePhase == 1)
  {
    showLevel();
  }
  // play game
  else if(gamePhase == 2)
  {
    playGame();
  }
  // level up! 
  else if(gamePhase == 3)
  {
    upLevel();
  }
  // score!
  else if(gamePhase == 4)
  {
    score();
  }
  // make a collison map
  else if(gamePhase == 5)
  {
    generateMap();
  }
  
  // do we have any problems?
  //println(frameRate);
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// INTRO SCREEN
////////////////////////////////////////////////////////
void showIntro()
{
  // show intro image!
  background(introImage);
  
  // key presses
//  if (keyPressed==true)
//  {
//    // if spacebar is pressed, show level goals
//    if (key ==' ')
//    {
//      gamePhase=1;
//      startTime=millis();
//    }
//    // if m is pressed, show map generator
//    if (key == 'm')
//    {
//      gamePhase=5;
//    }
//  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// SHOW WHAT LEVEL YOU ARE ON
////////////////////////////////////////////////////////
void showLevel()
{
  int countDown = 3000; // three seconds
    
  // show intro image!
  background(visibleMap);
  
  // make transparent
  pushStyle();
  fill(255,100);
  rect(0,0,width,height);
  popStyle();
  
  // randomly generate character start position
  // make sure they're not on a black portion of the map
  myKitty.startPos();
  myGhostA.startPos();
  myGhostB.startPos();
  myGhostC.startPos();
  
  // show the goals
  pushStyle();
    textAlign(RIGHT);
    fill(0);
    textSize(20);
    text("L E V E L . " + levelNum, width-10, height-80);
    
    textSize(15);
    text("Eat " + goalKibbles + " Kibbles", width-10, height-60);
    text("Eat " + goalFish + " Tasty Fish", width-10, height-40);
    text("Eat " + goalGhosts + " Ghosts", width-10, height-20);
  popStyle();
  
  // if countdown passes, start the game
  pushStyle();
    textAlign(CENTER);
    fill(0);
    textSize(30);
    text((countDown/1000 - ((millis()-startTime))/1000), width-150, height-50);
  popStyle();
  
  if ((millis()-startTime) > countDown)
  {
    gamePhase=2;
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// PLAY GAME
////////////////////////////////////////////////////////
void playGame()
{ 
  background(visibleMap);

  // spawn food
  myFood.spawn();
  
  // spawn characters and move them
  myKitty.play();
  myGhostA.play();
  myGhostB.play();
  myGhostC.play();
  
  // win lose and all that
  //death();
  //win();
  
  // transfer variables from one class to another
  // to the food class
  myFood.kittyRefX = myKitty.kittyX;
  myFood.kittyRefY = myKitty.kittyY;
  myFood.kittyRefS = myKitty.kittyW;
  // to packitty class
  myKitty.isCatHighRef = myFood.isCatHigh;
  
  // is the cat high? transfer these variables
  if (myFood.isCatHigh == true)
  {
    // to ghostA class
    myGhostA.kittyRefX = myKitty.kittyX-100;
    myGhostA.kittyRefY = myKitty.kittyY-100;
    // to ghostB class
    myGhostB.kittyRefX = myKitty.kittyX-75;
    myGhostB.kittyRefY = myKitty.kittyY-75;
    // to ghostC class
    myGhostC.kittyRefX = myKitty.kittyX-200;
    myGhostC.kittyRefY = myKitty.kittyY-200;
  }
  // is the cat not high? transfer these variables
  else
  {
    // to ghostA class
    myGhostA.kittyRefX = myKitty.kittyX;
    myGhostA.kittyRefY = myKitty.kittyY;
    // to ghostB class
    myGhostB.kittyRefX = myKitty.kittyX*2;
    myGhostB.kittyRefY = myKitty.kittyY*2;
    // to ghostC class
    myGhostC.kittyRefX = myKitty.kittyX+100;
    myGhostC.kittyRefY = myKitty.kittyY+100;
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DEATH!!!
////////////////////////////////////////////////////////
void death()
{
  
float deathA = dist(myKitty.kittyX, myKitty.kittyY, myGhostA.ghostA_X, myGhostA.ghostA_Y);
float deathB = dist(myKitty.kittyX, myKitty.kittyY, myGhostB.ghostB_X, myGhostB.ghostB_Y);
float deathC = dist(myKitty.kittyX, myKitty.kittyY, myGhostC.ghostC_X, myGhostC.ghostC_Y);

if (deathA < myKitty.kittyW && myFood.isCatHigh == false || deathB < myKitty.kittyW && myFood.isCatHigh == false || deathC < myKitty.kittyW && myFood.isCatHigh == false)
{
  // pacKitty dies! 
  gamePhase=4;
}

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// EAT GHOSTS!!!
////////////////////////////////////////////////////////
void eatGhosts()
{
  
float yumGhostA = dist(myKitty.kittyX, myKitty.kittyY, myGhostA.ghostA_X, myGhostA.ghostA_Y);
float yumGhostB = dist(myKitty.kittyX, myKitty.kittyY, myGhostB.ghostB_X, myGhostB.ghostB_Y);
float yumGhostC = dist(myKitty.kittyX, myKitty.kittyY, myGhostC.ghostC_X, myGhostC.ghostC_Y);

if (yumGhostA < myKitty.kittyW && myFood.isCatHigh == true)
{
  // pacKitty eats a ghost!
  myGhostA.startPos();
  myFood.ghostsEaten++;
}

else if (yumGhostB < myKitty.kittyW && myFood.isCatHigh == true)
{
  // pacKitty eats a ghost!
  myGhostA.startPos();
  myFood.ghostsEaten++;
}

else if (yumGhostC < myKitty.kittyW && myFood.isCatHigh == true)
{
  // pacKitty eats a ghost!
  myGhostC.startPos();
  myFood.ghostsEaten++;
}

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// WIN!!!!!!!
////////////////////////////////////////////////////////
void win()
{

if (myFood.kibbleEaten >= goalKibbles && myFood.fishEaten >= goalFish && myFood.ghostsEaten >= goalGhosts)
{ 
  // new level
  levelNum++;
  
  // up the goals!
  goalKibbles = goalKibbles+5;
  goalFish++;
  goalGhosts++;
  
  // make the ghosts faster!
  //myGhostA.ghostASpeed = myGhostA.ghostASpeed + 0.5;
  //myGhostB.ghostBSpeed = myGhostB.ghostBSpeed + 0.5;
  //myGhostC.ghostCSpeed = myGhostC.ghostCSpeed + 0.5;
  
  // reset the character values!
  myKitty.startPos();
  myGhostA.startPos();
  myGhostB.startPos();
  myGhostC.startPos();
  
  // reset the food placement
  myFood.foodX = myFood.makeFoodX(myFood.foodMax);
  myFood.foodY = myFood.makeFoodY(myFood.foodMax);
  myFood.tastyFishX = int( random(0, width) );
  myFood.tastyFishY = int( random(0, height) );
  
  // reset the score
  myFood.kibbleEaten = 0;
  myFood.fishEaten = 0;
  myFood.ghostsEaten = 0;
  
  // make the cat un-high
  myFood.isCatHigh = false;
  
  // pacKitty wins this level!
  gamePhase=3;
}

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// LEVEL UP!
////////////////////////////////////////////////////////
void upLevel()
{

// level up screen image
background(levelImage);

// if spacebar is pressed, show level goals
if (keyPressed==true)
{
  if (key ==' ')
  {
  gamePhase=1;
  startTime=millis();
  }
}

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// SCORE
////////////////////////////////////////////////////////
void score()
{

  // death screen image
  background(deathImage);

  // reset the character values!
  myKitty.startPos();
  myGhostA.startPos();
  myGhostB.startPos();
  myGhostC.startPos();

  // reset the food placement
  myFood.foodX = myFood.makeFoodX(myFood.foodMax);
  myFood.foodY = myFood.makeFoodY(myFood.foodMax);
  myFood.tastyFishX = int( random(0, width) );
  myFood.tastyFishY = int( random(0, height) );
  
  // reset the score
  myFood.kibbleEaten = 0;
  myFood.fishEaten = 0;
  myFood.ghostsEaten = 0;
  
  // reset the goals
  levelNum = 1;
  goalKibbles = 10;
  goalFish = 1;
  goalGhosts = 0;
  
  // reset the ghost speeds
  //myGhostA.ghostASpeed = 1;
  //myGhostB.ghostBSpeed = 1;
  //myGhostC.ghostCSpeed = 1;
  
  // if R is pressed, show level 1 goals
  if (keyPressed==true)
  {
    if (key =='r')
    {
      gamePhase=0;
    }
  }

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GENERATE A MAP HERE
////////////////////////////////////////////////////////
void generateMap()
{
  if (keyPressed==true)
  {
    // if spacebar is pressed, show level goals
    if (key ==' ')
    {
      gamePhase=1;
       startTime=millis();
    }
    
    // if s is pressed, save new map
    if (key =='s')
    {
      saveFrame("data/map.png");
      visibleMap = loadImage("map.png");
    }
  }
    
}
////////////////////////////////////////////////////////
