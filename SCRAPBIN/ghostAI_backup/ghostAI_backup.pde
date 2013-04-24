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
  import ddf.minim.*;
  import ddf.minim.signals.*;
  import ddf.minim.analysis.*;
  import ddf.minim.effects.*;
  import processing.video.*;
  
  // classes
  PacKitty myKitty;
  GhostA myGhostA;
  GhostB myGhostB;
  GhostC myGhostC;
  Food myFood;
  
  // camera related
  Capture cam;
  color trackColor;
  
  // images
  PImage visibleMap;
  PImage introImage;
  PImage deathImage;
  PImage levelImage;
  
  // audio stuff
  Minim minim;
  AudioPlayer intro;
  AudioPlayer kibble;
  AudioPlayer fish;
  AudioPlayer death;
  AudioPlayer levelComplete;
  AudioPlayer catnip;
  AudioPlayer grow;
  AudioPlayer shrink;
  AudioPlayer eatghost;
  
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
  size(640,480);
  imageMode(CENTER);
  smooth();
  
  // camera related
  //cam = new Capture(this, 640, 480);
  //cam.start();   
  trackColor = color(51,62,47);
    
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
  
  // audio stuff
  minim = new Minim(this);
  intro = minim.loadFile("pacman_beginning.wav");
  kibble = minim.loadFile("chomp_kibble.mp3");
  fish = minim.loadFile("chomp_fish.mp3");
  death = minim.loadFile("pacman_death.wav");
  levelComplete = minim.loadFile("pacman_levelcomplete.wav");
  catnip = minim.loadFile("catnip.wav");
  grow = minim.loadFile("catnip-grow.wav");
  shrink = minim.loadFile("catnip-shrink.wav");
  eatghost = minim.loadFile("eatghost.mp3");
  
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
    intro.play();
    intro.rewind();
  }
  
  // intialize sobel filter map
  myGhostA.setup();
  
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
  if (keyPressed==true)
  {
    // if spacebar is pressed, show level goals
    if (key ==' ')
    {
      gamePhase=1;
      startTime=millis();
    }
    // if m is pressed, show map generator
    if (key == 'm')
    {
      gamePhase=5;
    }
  }
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
  // capture the video
//  cam.start();
//  if (cam.available()) 
//  {
//    cam.read();
//  }
//  image(cam, width/2, height/2, width, height);
  background(visibleMap);

  // spawn food
  myFood.spawn();
  
  // spawn characters and move them
  myKitty.play();
  myGhostA.play();
  //myGhostB.play();
  myGhostC.play();
  
  // win lose and all that
  //death();
  //win();
  
  // transfer variables from one class to another
  // to ghostA class
  myGhostA.kittyRefX = myKitty.kittyX;
  myGhostA.kittyRefY = myKitty.kittyY;
  // to ghostB class
  myGhostB.kittyRefX = myKitty.kittyX*2;
  myGhostB.kittyRefY = myKitty.kittyY*2;
  // to ghostC class
  myGhostC.kittyRefX = myKitty.kittyX;
  myGhostC.kittyRefY = myKitty.kittyY;
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
      myGhostA.kittyRefX = myKitty.kittyX-50;
      myGhostA.kittyRefY = myKitty.kittyY-50;
      // to ghostB class
      myGhostB.kittyRefX = myKitty.kittyX-100;
      myGhostB.kittyRefY = myKitty.kittyY-100;
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
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DEATH!!!
////////////////////////////////////////////////////////
void death()
{
  
float deathA = dist(myKitty.kittyX, myKitty.kittyY, myGhostA.ghostA_X, myGhostA.ghostA_Y);
float deathB = dist(myKitty.kittyX, myKitty.kittyY, myGhostB.ghostBX, myGhostB.ghostBY);
float deathC = dist(myKitty.kittyX, myKitty.kittyY, myGhostC.ghostCX, myGhostC.ghostCY);

if (deathA < myKitty.kittyW && myFood.isCatHigh == false || deathB < myKitty.kittyW && myFood.isCatHigh == false || deathC < myKitty.kittyW && myFood.isCatHigh == false)
{
  // pacKitty dies! 
  catnip.pause();
  catnip.rewind();
  death.play();
  death.rewind();
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
float yumGhostB = dist(myKitty.kittyX, myKitty.kittyY, myGhostB.ghostBX, myGhostB.ghostBY);
float yumGhostC = dist(myKitty.kittyX, myKitty.kittyY, myGhostC.ghostCX, myGhostC.ghostCY);

if (yumGhostA < myKitty.kittyW && myFood.isCatHigh == true)
{
  // pacKitty eats a ghost!
  eatghost.play();
  eatghost.rewind();
  myGhostA.startPos();
  myFood.ghostsEaten++;
}

else if (yumGhostB < myKitty.kittyW && myFood.isCatHigh == true)
{
  // pacKitty eats a ghost!
  eatghost.play();
  eatghost.rewind();
  myGhostA.startPos();
  myFood.ghostsEaten++;
}

else if (yumGhostC < myKitty.kittyW && myFood.isCatHigh == true)
{
  // pacKitty eats a ghost!
  eatghost.play();
  eatghost.rewind();
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
  myGhostB.ghostBSpeed = myGhostB.ghostBSpeed + 0.5;
  myGhostC.ghostCSpeed = myGhostC.ghostCSpeed + 0.5;
  
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
  catnip.pause();
  catnip.rewind();
  levelComplete.play();
  levelComplete.rewind();
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
  myGhostB.ghostBSpeed = 1;
  myGhostC.ghostCSpeed = 1;
  
  // if R is pressed, show level 1 goals
  if (keyPressed==true)
  {
    if (key =='r')
    {
      gamePhase=0;
      catnip.pause();
      catnip.rewind();
      intro.play();
      intro.rewind();
    }
  }

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GENERATE A MAP HERE
////////////////////////////////////////////////////////
void generateMap()
{
  
  // camera stuff!
  if (cam.available() == true) 
  {
    cam.read();
  }
  cam.filter(THRESHOLD,.4);
  image(cam, width/2, height/2, width, height);
    
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
      cam.stop();
      saveFrame("data/map.png");
      visibleMap = loadImage("map.png");
    }
  }
    
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// CALBIRATE COLORS  
////////////////////////////////////////////////////////
//void mousePressed() 
//{
//  // Save color where the mouse is clicked in trackColor variable
//  int loc = mouseX + mouseY*cam.width;
//  trackColor = cam.pixels[loc];
//}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// CLOSE THE AUDIO DOWN
////////////////////////////////////////////////////////
void stop()
{
intro.close();
kibble.close();
fish.close();
death.close();
levelComplete.close();
catnip.close();
grow.close();
shrink.close();
eatghost.close();

minim.stop();
super.stop();
}
////////////////////////////////////////////////////////
