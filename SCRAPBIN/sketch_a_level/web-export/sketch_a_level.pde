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
      cam.stop();
      saveFrame("data/map.png");
      visibleMap = loadImage("map.png");
    }
  }
    
}
////////////////////////////////////////////////////////
////////////////////////////////////////////////////////
// DRAWS ALL DOGGYGHOSTS
// Takes SVG file and gives random colors 
////////////////////////////////////////////////////////
class DoggyGhost
{
  
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
// floats and ints
float doggyW;             // width
float doggyH;             // height
float doggyX;             // x position
float doggyY;             // y position
float doggySpeed;         // speed
color randomCol1;         // a random color
color randomCol2;

// shapes
PShape doggyGhost;
PShape body;
PShape ears;
PShape innerEars;
PShape eyes;
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
DoggyGhost()
{
// floats and ints
doggyX=width/2;
doggyY=height/2;
doggyW=40;
doggyH=doggyW;
doggySpeed=3;

// shapes
doggyGhost = loadShape("doggy-ghost.svg");
body = doggyGhost.getChild("body_1_");
ears = doggyGhost.getChild("ears_1_");
innerEars = doggyGhost.getChild("inner-ears");
eyes = doggyGhost.getChild("eyes");
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DRAWING DOGGYGHOST
////////////////////////////////////////////////////////
void spawn(float doggyX,float doggyY, color randomCol1, color randomCol2)
{
pushStyle();
rectMode(CENTER);
shapeMode(CENTER);
noStroke();

// draw doggyghost
shape(doggyGhost, doggyX, doggyY, doggyW, doggyH);

// draw doggyghost body a random color
// disable the colors found in the SVG file
body.disableStyle();
fill(randomCol1);
shape(body,doggyX,doggyY,doggyW,doggyH);

// draw doggyghost ears a random color
// disable the colors found in the SVG file
ears.disableStyle();
fill(randomCol1);
shape(ears,doggyX,doggyY,doggyW,doggyH);

// draw doggyghost inner ears a random color
// disable the colors found in the SVG file
innerEars.disableStyle();
fill(randomCol2);
shape(innerEars,doggyX,doggyY,doggyW,doggyH);

// draw doggyghost eyes
// disable the colors found in the SVG file
innerEars.disableStyle();
fill(255);
shape(eyes,doggyX,doggyY,doggyW,doggyH);


// test stuff for massing
//fill(255,0,0);
//rect(doggyX,doggyY,doggyW,doggyH);
//
//stroke(0);
//strokeWeight(10);
//point(doggyX,doggyY);

popStyle();
}
////////////////////////////////////////////////////////

}
class Food extends Maze
{
 
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // references
  float kittyRefX;
  float kittyRefY;
  float kittyRefS;
  
  // stuff eaten
  float kibbleEaten;
  float fishEaten;
  float ghostsEaten;
  
  // tastyfish!
  int fishSize;
  int tastyFishX;
  int tastyFishY;
  
  // catnip!
  int catNipX;
  int catNipY;
  float catNipS;
  boolean isCatHigh;
  int startHigh;
  
  // arrays
  final int foodMax = 100;
  int[] foodX;
  int[] foodY;
  
  // shapes
  PShape foodBits;
  PShape tastyFish;
  PShape catNip;
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
Food()
{
  // stuff eaten
  kibbleEaten = 0;
  fishEaten = 0;
  ghostsEaten = 0;
  
  // tastyfish!
  fishSize = 30;
  tastyFishX = int( random(0, width) );
  tastyFishY = int( random(0, height) );
  
  // catnip!
  catNipX = int( random(0, width) );
  catNipY = int( random(0, height) );
  catNipS = 25;
  isCatHigh = false;
  startHigh = 0;
  
  // arrays
  foodX = new int[foodMax];
  foodY = new int[foodMax];
  foodX = makeFoodX(foodMax);
  foodY = makeFoodY(foodMax);
  
  // shapes
  foodBits = loadShape("food.svg");
  tastyFish = loadShape("tasty-fish.svg");
  catNip = loadShape("catnip.svg");
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GIVES THE KITTY FOOD RANDOM X VALUES
////////////////////////////////////////////////////////
int[] makeFoodX(int total)
{
  
int[]tempValue = new int[total];

for(int i=1; i<tempValue.length; i++)
{     
  tempValue[i] = int( random(0,width) );
}

return tempValue;

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GIVES THE KITTY FOOD RANDOM Y VALUES
////////////////////////////////////////////////////////
int[] makeFoodY(int total)
{
  
int[]tempValue = new int[total];

for(int i=0; i<tempValue.length; i++)
{
    tempValue[i] = int( random(0,height) );
}


return tempValue;

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// SPAWNS THE KITTY FOOD
////////////////////////////////////////////////////////
void spawn()
{
  // how many food bits has kitty eaten?
  pushStyle();
  fill(0);
  textSize(15);
  textAlign(RIGHT);
  text(nf(kibbleEaten,0,0) + "/" + goalKibbles + " Kibbles", width-10, height-60);
  text(nf(fishEaten,0,0) + "/" + goalFish + " Tasty Fish", width-10, height-40);
  text(nf(ghostsEaten,0,0) + "/" + goalGhosts + " Ghosts", width-10, height-20);
  popStyle();
  
  // mmm food
  kibbles();
  tastyFish();
  catNip();
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// THE KIBBLES
////////////////////////////////////////////////////////
void kibbles()
{

int foodSize = 15;

// all for the kibbles
for(int i=0; i<foodX.length; i++)
{
    // booleans for collision map
    boolean up_left = false;
    boolean up_right = false;
    boolean down_right = false;
    boolean down_left = false;

    // if any of these come back true there is a wall
    up_left = collisionMap[foodX[i]][foodY[i]];
    up_right = collisionMap[foodX[i]][foodY[i]];
    down_right = collisionMap[foodX[i]][foodY[i]];
    down_left = collisionMap[foodX[i]][foodY[i]];
  
    // if there no wall, this x value is OK
    if (up_left && up_right && down_right && down_left) 
    {
      shape(foodBits, foodX[i], foodY[i], foodSize, foodSize);
    }
    
    // if kitty overlaps food, eat it!
    float kittyEat = dist(kittyRefX,kittyRefY,foodX[i],foodY[i]);
    if (kittyEat < foodSize)
    {
    foodX[i] = 0;
    foodY[i] = 0;
    kibbleEaten++;
    kibble.play();
    kibble.rewind();
    }
}

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// THE TASTY FISH
////////////////////////////////////////////////////////
void tastyFish()
{
  
// booleans for collision map
boolean up_left = false;
boolean up_right = false;
boolean down_right = false;
boolean down_left = false;

// if any of these come back true there is a wall
up_left = collisionMap[tastyFishX][tastyFishY];
up_right = collisionMap[tastyFishX][tastyFishY];
down_right = collisionMap[tastyFishX][tastyFishY];
down_left = collisionMap[tastyFishX][tastyFishY];
  
// if there no wall, this x value is OK
if (up_left && up_right && down_right && down_left) 
{
  shape(tastyFish,tastyFishX,tastyFishY,fishSize,fishSize);
}

else if (up_left==false || up_right==false || down_right==false || down_left==false)
{
  tastyFishX = int( random(0, width) );
  tastyFishY = int( random(0, height) );
}

// if kitty overlaps tastyfish, eat it!
float kittyEatFish = dist(kittyRefX,kittyRefY,tastyFishX,tastyFishY);

if (kittyEatFish < fishSize)
{
  tastyFishX = 0;
  tastyFishY = 0;
  fishEaten++;
  fish.play();
  fish.rewind();
}

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// CAT NIP BALL TIME!
////////////////////////////////////////////////////////
void catNip()
{ 
// countdown for packitty's high
int countDown = 16000; // three seconds

// booleans for collision map
boolean up_left = false;
boolean up_right = false;
boolean down_right = false;
boolean down_left = false;

// if any of these come back true there is a wall
up_left = collisionMap[catNipX][catNipY];
up_right = collisionMap[catNipX][catNipY];
down_right = collisionMap[catNipX][catNipY];
down_left = collisionMap[catNipX][catNipY];
  
// if there no wall, this x value is OK
if (up_left && up_right && down_right && down_left && isCatHigh == false) 
{
  pushMatrix();
  translate(catNipX,catNipY);
  rotate( radians(frameCount) );
  shape(catNip,0,0,catNipS,catNipS);
  popMatrix();
}

else if (up_left==false || up_right==false || down_right==false || down_left==false)
{
  catNipX = int( random(0, width) );
  catNipY = int( random(0, height) );
}

// if kitty overlaps catnip, eat it!
float kittyEat = dist(kittyRefX,kittyRefY,catNipX,catNipY);

if (kittyEat < catNipS && isCatHigh == false)
{
  catNipX = 0;
  catNipY = 0;
  isCatHigh = true;
  catnip.play();
  catnip.rewind();
  startHigh = millis();
}

if ((millis()-startHigh) > countDown)
{
  shrink.play();
  isCatHigh = false;
}

}
////////////////////////////////////////////////////////

}
////////////////////////////////////////////////////////
// THE RED GHOST
// Ghost tries to be at the same point PacKitty is
// Predictable, constant
////////////////////////////////////////////////////////
class GhostA
{

  
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // ghost related
  float ghostA_X;               // ghost X
  float ghostA_Y;               // ghost Y
  float ghostA_VX;              // ghost velocity in the X
  float ghostA_VY;              // ghost velocity in the Y
  float kittyRefX;              // kitty's X
  float kittyRefY;              // kitty's Y
  
  // map related
  color mapPixels[];             // colors in collision map
  int n_mapPixels;               // number of pixels in collison map
  float pixelValues[];           // neighborhood for the pixels
  
  // classes
  DoggyGhost myDoggy;
////////////////////////////////////////////////////////

  
////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
GhostA()
{
  // classes
  myDoggy = new DoggyGhost();
  
  // floats
  ghostA_X = int( random(100, width-100) );
  ghostA_Y = int( random(100, height-100) );
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// SETUP: RUN THIS ONLY ONCE!
////////////////////////////////////////////////////////
void setup()
{
  // blur our collision map!
  visibleMap.filter(BLUR, 5);        // blur our collision map
  visibleMap.loadPixels();           // load the pixels of our map, just once!
  mapPixels = visibleMap.pixels;     // get those pixels!
  pixelValues = new float[9];        // we want a neighborhood of 9 pixels
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// INTIALIZE STARTING POSITION
////////////////////////////////////////////////////////
void startPos()
{
  if(ghostA_X < kittyRefX+100 && ghostA_X > kittyRefX-100 && ghostA_Y < kittyRefY+100 && ghostA_Y > kittyRefY-100)
  {
    ghostA_X = int( random(100, width-100) );
    ghostA_Y = int( random(100, height-100) );
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DRAWING AND MOVING GHOST
////////////////////////////////////////////////////////
void play()
{
  renderGhost();
  updateGhost(); 
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// RENDER OUR GHOST
////////////////////////////////////////////////////////
void renderGhost()
{
  // draw ghost using doggyghost class
  myDoggy.spawn(ghostA_X,ghostA_Y,color(255,0,0),color(108,37,37));
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MAKE OUR GHOST MOVE!
////////////////////////////////////////////////////////
void updateGhost()
{
  float attractionToTarget = 0.3; 
  float desireToTraceHill = 3.6;
  float dx = kittyRefX - ghostA_X + myDoggy.doggyW/2; 
  float dy = kittyRefY - ghostA_Y + myDoggy.doggyW/2; 
  float dh = sqrt(dx*dx + dy*dy); 

  if (dh > 0) 
  { 
    // add in the force due to attraction
    float fx = (dx / dh) * attractionToTarget; 
    float fy = (dy / dh) * attractionToTarget; 
    ghostA_VX = ghostA_VX + fx; 
    ghostA_VY = ghostA_VY + fy;
  }

  // extract 9 terrain values, from my neighborhood
  int terrainArea = 10;  
  pixelValues[0] = getTerrainValue (ghostA_X - terrainArea,   ghostA_Y - terrainArea); 
  pixelValues[1] = getTerrainValue (ghostA_X,                 ghostA_Y - terrainArea); 
  pixelValues[2] = getTerrainValue (ghostA_X + terrainArea,   ghostA_Y - terrainArea); 
  pixelValues[3] = getTerrainValue (ghostA_X - terrainArea,   ghostA_Y);  
  pixelValues[4] = getTerrainValue (ghostA_X,                 ghostA_Y); 
  pixelValues[5] = getTerrainValue (ghostA_X + terrainArea,   ghostA_Y); 
  pixelValues[6] = getTerrainValue (ghostA_X - terrainArea,   ghostA_Y + terrainArea);
  pixelValues[7] = getTerrainValue (ghostA_X,                 ghostA_Y + terrainArea); 
  pixelValues[8] = getTerrainValue (ghostA_X + terrainArea,   ghostA_Y + terrainArea); 

  // refer to:
  // http://homepages.inf.ed.ac.uk/rbf/HIPR2/sobel.htm
  float xKernel[] = 
  {
    -1, 0, 1, -2, 0, 2, -1, 0, 1
  };
  float yKernel[] = 
  { 
    1, 2, 1, 0, 0, 0, -1, -2, -1
  };

  float Gx = 0;
  float Gy = 0;
  for (int i=0; i<9; i++)
  {
    Gx += xKernel[i] * pixelValues[i]; 
    Gy += yKernel[i] * pixelValues[i];
  }
  float Gh = sqrt(Gx*Gx + Gy*Gy); 
  
  if (Gh > 0) {
    float Gorientation = atan2 (Gy, Gx);
    float avoidCrossing = pow(pixelValues[4], 0.5);
    float hx =   avoidCrossing * desireToTraceHill * sin (Gorientation);
    float hy =   avoidCrossing * desireToTraceHill * cos (Gorientation);
    float hh = sqrt(hx*hx + hy*hy);  // hill force magnitude
    //if (hh > 1.0){
    //  hx = hx / hh;
    //  hy = hy / hh;
    //}
    
    ghostA_VX = ghostA_VX + hx; 
    ghostA_VY = ghostA_VY + hy; 
    line (ghostA_X, ghostA_Y, ghostA_X+hx, ghostA_Y+hy); 
  }
  
  ghostA_VX = ghostA_VX * 0.70;
  ghostA_VY = ghostA_VY * 0.70;             // lose our energy on each frame
  ghostA_X = ghostA_X + ghostA_VX;          // integration
  ghostA_Y = ghostA_Y + ghostA_VY;
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GET THE "TERRAIN" VALUES FOR THE COLLISION MAP
// Returns terrain of image
// Dark = 1
// Light = 0
////////////////////////////////////////////////////////
float getTerrainValue (float x, float y) 
{
  // get the width and height of our collison map
  int imgW = visibleMap.width; 
  int imgH = visibleMap.height; 
  
  // the number of pixels in our collison map
  n_mapPixels = imgW*imgH; 
  
  // constrain to keep the values within the bounds of the image
  int testPointX = (int) constrain(round(x), 0, imgW-1); 
  int testPointY = (int) constrain(round(y), 0, imgH-1);
  
  // what's the ID of this pixel?
  int testIndex = (testPointY * imgW) + testPointX; 
  
  // what is the color of the above pixel?
  color testColor = mapPixels[testIndex]; 
  
  // map the brightness so it is a valye between 1 and 0, instead of 255 and 0
  float hillValue = map(brightness(testColor), 0, 255, 1, 0); 
  
  // return the value generated
  return hillValue;
}
////////////////////////////////////////////////////////

}
////////////////////////////////////////////////////////
// THE BLUE GHOST
////////////////////////////////////////////////////////
class GhostB
{

  
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // ghost related
  float ghostB_X;               // ghost X
  float ghostB_Y;               // ghost Y
  float ghostB_VX;              // ghost velocity in the X
  float ghostB_VY;              // ghost velocity in the Y
  float kittyRefX;              // kitty's X
  float kittyRefY;              // kitty's Y
  
  // map related
  color mapPixels[];             // colors in collision map
  int n_mapPixels;               // number of pixels in collison map
  float pixelValues[];           // neighborhood for the pixels
  
  // classes
  DoggyGhost myDoggy;
////////////////////////////////////////////////////////

  
////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
GhostB()
{
  // classes
  myDoggy = new DoggyGhost();
  
  // floats
  ghostB_X = int( random(100, width-100) );
  ghostB_Y = int( random(100, height-100) );
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// SETUP: RUN THIS ONLY ONCE!
////////////////////////////////////////////////////////
void setup()
{
  // blur our collision map!
  visibleMap.filter(BLUR, 5);        // blur our collision map
  visibleMap.loadPixels();           // load the pixels of our map, just once!
  mapPixels = visibleMap.pixels;     // get those pixels!
  pixelValues = new float[9];        // we want a neighborhood of 9 pixels
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// INTIALIZE STARTING POSITION
////////////////////////////////////////////////////////
void startPos()
{
  if(ghostB_X < kittyRefX+100 && ghostB_X > kittyRefX-100 && ghostB_Y < kittyRefY+100 && ghostB_Y > kittyRefY-100)
  {
    ghostB_X = int( random(100, width-100) );
    ghostB_Y = int( random(100, height-100) );
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DRAWING AND MOVING GHOST
////////////////////////////////////////////////////////
void play()
{
  renderGhost();
  updateGhost(); 
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// RENDER OUR GHOST
////////////////////////////////////////////////////////
void renderGhost()
{
  // draw ghost using doggyghost class
  myDoggy.spawn(ghostB_X,ghostB_Y,color(84,55,219),color(126,100,242));
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MAKE OUR GHOST MOVE!
////////////////////////////////////////////////////////
void updateGhost()
{
  float attractionToTarget = 0.3; 
  float desireToTraceHill = 3.6;
  float dx = kittyRefX - ghostB_X + myDoggy.doggyW/2; 
  float dy = kittyRefY - ghostB_Y + myDoggy.doggyW/2; 
  float dh = sqrt(dx*dx + dy*dy); 

  if (dh > 0) 
  { 
    // add in the force due to attraction
    float fx = (dx / dh) * attractionToTarget; 
    float fy = (dy / dh) * attractionToTarget; 
    ghostB_VX = ghostB_VX + fx; 
    ghostB_VY = ghostB_VY + fy;
  }

  // extract 9 terrain values, from my neighborhood
  int terrainArea = 10;  
  pixelValues[0] = getTerrainValue (ghostB_X - terrainArea,   ghostB_Y - terrainArea); 
  pixelValues[1] = getTerrainValue (ghostB_X,                 ghostB_Y - terrainArea); 
  pixelValues[2] = getTerrainValue (ghostB_X + terrainArea,   ghostB_Y - terrainArea); 
  pixelValues[3] = getTerrainValue (ghostB_X - terrainArea,   ghostB_Y);  
  pixelValues[4] = getTerrainValue (ghostB_X,                 ghostB_Y); 
  pixelValues[5] = getTerrainValue (ghostB_X + terrainArea,   ghostB_Y); 
  pixelValues[6] = getTerrainValue (ghostB_X - terrainArea,   ghostB_Y + terrainArea);
  pixelValues[7] = getTerrainValue (ghostB_X,                 ghostB_Y + terrainArea); 
  pixelValues[8] = getTerrainValue (ghostB_X + terrainArea,   ghostB_Y + terrainArea); 

  // refer to:
  // http://homepages.inf.ed.ac.uk/rbf/HIPR2/sobel.htm
  float xKernel[] = 
  {
    -1, 0, 1, -2, 0, 2, -1, 0, 1
  };
  float yKernel[] = 
  { 
    1, 2, 1, 0, 0, 0, -1, -2, -1
  };

  float Gx = 0;
  float Gy = 0;
  for (int i=0; i<9; i++)
  {
    Gx += xKernel[i] * pixelValues[i]; 
    Gy += yKernel[i] * pixelValues[i];
  }
  float Gh = sqrt(Gx*Gx + Gy*Gy); 
  
  if (Gh > 0) {
    float Gorientation = atan2 (Gy, Gx);
    float avoidCrossing = pow(pixelValues[4], 0.5);
    float hx =   avoidCrossing * desireToTraceHill * sin (Gorientation);
    float hy =   avoidCrossing * desireToTraceHill * cos (Gorientation);
    float hh = sqrt(hx*hx + hy*hy);  // hill force magnitude
    //if (hh > 1.0){
    //  hx = hx / hh;
    //  hy = hy / hh;
    //}
    
    ghostB_VX = ghostB_VX + hx; 
    ghostB_VY = ghostB_VY + hy; 
    line (ghostB_X, ghostB_Y, ghostB_X+hx, ghostB_Y+hy); 
  }
  
  ghostB_VX = ghostB_VX * 0.70;
  ghostB_VY = ghostB_VY * 0.70;             // lose our energy on each frame
  ghostB_X = ghostB_X + ghostB_VX;          // integration
  ghostB_Y = ghostB_Y + ghostB_VY;
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GET THE "TERRAIN" VALUES FOR THE COLLISION MAP
// Returns terrain of image
// Dark = 1
// Light = 0
////////////////////////////////////////////////////////
float getTerrainValue (float x, float y) 
{
  // get the width and height of our collison map
  int imgW = visibleMap.width; 
  int imgH = visibleMap.height; 
  
  // the number of pixels in our collison map
  n_mapPixels = imgW*imgH; 
  
  // constrain to keep the values within the bounds of the image
  int testPointX = (int) constrain(round(x), 0, imgW-1); 
  int testPointY = (int) constrain(round(y), 0, imgH-1);
  
  // what's the ID of this pixel?
  int testIndex = (testPointY * imgW) + testPointX; 
  
  // what is the color of the above pixel?
  color testColor = mapPixels[testIndex]; 
  
  // map the brightness so it is a valye between 1 and 0, instead of 255 and 0
  float hillValue = map(brightness(testColor), 0, 255, 1, 0); 
  
  // return the value generated
  return hillValue;
}
////////////////////////////////////////////////////////

}
////////////////////////////////////////////////////////
// THE YELLOW GHOST
////////////////////////////////////////////////////////
class GhostC
{

  
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // ghost related
  float ghostC_X;               // ghost X
  float ghostC_Y;               // ghost Y
  float ghostC_VX;              // ghost velocity in the X
  float ghostC_VY;              // ghost velocity in the Y
  float kittyRefX;              // kitty's X
  float kittyRefY;              // kitty's Y
  
  // map related
  color mapPixels[];             // colors in collision map
  int n_mapPixels;               // number of pixels in collison map
  float pixelValues[];           // neighborhood for the pixels
  
  // classes
  DoggyGhost myDoggy;
////////////////////////////////////////////////////////

  
////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
GhostC()
{
  // classes
  myDoggy = new DoggyGhost();
  
  // floats
  ghostC_X = int( random(100, width-100) );
  ghostC_Y = int( random(100, height-100) );
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// SETUP: RUN THIS ONLY ONCE!
////////////////////////////////////////////////////////
void setup()
{
  // blur our collision map!
  visibleMap.filter(BLUR, 5);        // blur our collision map
  visibleMap.loadPixels();           // load the pixels of our map, just once!
  mapPixels = visibleMap.pixels;     // get those pixels!
  pixelValues = new float[9];        // we want a neighborhood of 9 pixels
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// INTIALIZE STARTING POSITION
////////////////////////////////////////////////////////
void startPos()
{
  if(ghostC_X < kittyRefX+100 && ghostC_X > kittyRefX-100 && ghostC_Y < kittyRefY+100 && ghostC_Y > kittyRefY-100)
  {
    ghostC_X = int( random(100, width-100) );
    ghostC_Y = int( random(100, height-100) );
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DRAWING AND MOVING GHOST
////////////////////////////////////////////////////////
void play()
{
  renderGhost();
  updateGhost(); 
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// RENDER OUR GHOST
////////////////////////////////////////////////////////
void renderGhost()
{
  // draw ghost using doggyghost class
  myDoggy.spawn(ghostC_X,ghostC_Y,color(237,250,66),color(201,211,68));
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MAKE OUR GHOST MOVE!
////////////////////////////////////////////////////////
void updateGhost()
{
  float attractionToTarget = 0.3; 
  float desireToTraceHill = 3.6;
  float dx = kittyRefX - ghostC_X + myDoggy.doggyW/2; 
  float dy = kittyRefY - ghostC_Y + myDoggy.doggyW/2; 
  float dh = sqrt(dx*dx + dy*dy); 

  if (dh > 0) 
  { 
    // add in the force due to attraction
    float fx = (dx / dh) * attractionToTarget; 
    float fy = (dy / dh) * attractionToTarget; 
    ghostC_VX = ghostC_VX + fx; 
    ghostC_VY = ghostC_VY + fy;
  }

  // extract 9 terrain values, from my neighborhood
  int terrainArea = 10;  
  pixelValues[0] = getTerrainValue (ghostC_X - terrainArea,   ghostC_Y - terrainArea); 
  pixelValues[1] = getTerrainValue (ghostC_X,                 ghostC_Y - terrainArea); 
  pixelValues[2] = getTerrainValue (ghostC_X + terrainArea,   ghostC_Y - terrainArea); 
  pixelValues[3] = getTerrainValue (ghostC_X - terrainArea,   ghostC_Y);  
  pixelValues[4] = getTerrainValue (ghostC_X,                 ghostC_Y); 
  pixelValues[5] = getTerrainValue (ghostC_X + terrainArea,   ghostC_Y); 
  pixelValues[6] = getTerrainValue (ghostC_X - terrainArea,   ghostC_Y + terrainArea);
  pixelValues[7] = getTerrainValue (ghostC_X,                 ghostC_Y + terrainArea); 
  pixelValues[8] = getTerrainValue (ghostC_X + terrainArea,   ghostC_Y + terrainArea); 

  // refer to:
  // http://homepages.inf.ed.ac.uk/rbf/HIPR2/sobel.htm
  float xKernel[] = 
  {
    -1, 0, 1, -2, 0, 2, -1, 0, 1
  };
  float yKernel[] = 
  { 
    1, 2, 1, 0, 0, 0, -1, -2, -1
  };

  float Gx = 0;
  float Gy = 0;
  for (int i=0; i<9; i++)
  {
    Gx += xKernel[i] * pixelValues[i]; 
    Gy += yKernel[i] * pixelValues[i];
  }
  float Gh = sqrt(Gx*Gx + Gy*Gy); 
  
  if (Gh > 0) {
    float Gorientation = atan2 (Gy, Gx);
    float avoidCrossing = pow(pixelValues[4], 0.5);
    float hx =   avoidCrossing * desireToTraceHill * sin (Gorientation);
    float hy =   avoidCrossing * desireToTraceHill * cos (Gorientation);
    float hh = sqrt(hx*hx + hy*hy);  // hill force magnitude
    //if (hh > 1.0){
    //  hx = hx / hh;
    //  hy = hy / hh;
    //}
    
    ghostC_VX = ghostC_VX + hx; 
    ghostC_VY = ghostC_VY + hy; 
    line (ghostC_X, ghostC_Y, ghostC_X+hx, ghostC_Y+hy); 
  }
  
  ghostC_VX = ghostC_VX * 0.70;
  ghostC_VY = ghostC_VY * 0.70;             // lose our energy on each frame
  ghostC_X = ghostC_X + ghostC_VX;          // integration
  ghostC_Y = ghostC_Y + ghostC_VY;
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// GET THE "TERRAIN" VALUES FOR THE COLLISION MAP
// Returns terrain of image
// Dark = 1
// Light = 0
////////////////////////////////////////////////////////
float getTerrainValue (float x, float y) 
{
  // get the width and height of our collison map
  int imgW = visibleMap.width; 
  int imgH = visibleMap.height; 
  
  // the number of pixels in our collison map
  n_mapPixels = imgW*imgH; 
  
  // constrain to keep the values within the bounds of the image
  int testPointX = (int) constrain(round(x), 0, imgW-1); 
  int testPointY = (int) constrain(round(y), 0, imgH-1);
  
  // what's the ID of this pixel?
  int testIndex = (testPointY * imgW) + testPointX; 
  
  // what is the color of the above pixel?
  color testColor = mapPixels[testIndex]; 
  
  // map the brightness so it is a valye between 1 and 0, instead of 255 and 0
  float hillValue = map(brightness(testColor), 0, 255, 1, 0); 
  
  // return the value generated
  return hillValue;
}
////////////////////////////////////////////////////////

}
////////////////////////////////////////////////////////
// DRAWS THE MAZE
// This is where the collison map is set up
// All classes inherit this for movement
////////////////////////////////////////////////////////
class Maze
{
  
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
// maze variables
PImage visib;
boolean[][] collisionMap;
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
Maze()
{
  // the collision map must be black and white
  PImage collisionImage = loadImage("map.png");
  
  // generate our collision map as an two-dimensional boolean array
  // black is false (blocked)
  // white is true (clear)
  collisionMap = new boolean[collisionImage.width][collisionImage.height];
  color black = color(0);
  color white = color(255);
  
  // looks through collision map rows
  for (int i = 0; i < collisionImage.width; i++)
  {
    
    // looks through collision map columns
    for (int j = 0; j < collisionImage.height; j++)
    {
    color c = collisionImage.get(i, j);
    if (c == black) 
    {
    collisionMap[i][j] = false;
    }
    
    else if (c == white) 
    {
    collisionMap[i][j] = true;
    }
    
    else 
    {
    // make sure the only colors are black and white
    //println("There are colors other than black and white in the collision map!");
    }
    
    }
  }
}
////////////////////////////////////////////////////////
}
////////////////////////////////////////////////////////
// DRAWS AND MOVES PACKITTY
// Inherits maze class for movement parameters
////////////////////////////////////////////////////////


class PacKitty extends Maze
{
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
// shapes
PShape packitty = loadShape("packitty.svg");

// floats and ints
float kittyW=30;
float kittyH=kittyW;
float kittyE = 0.05;                                    
float kittyX=int( random(100, width-100) );
float kittyY=int( random(100, height-100) );  
float previous_kittyX;
float previous_kittyY;
float kittySpeed=3;
float lipBottom=radians(30);
float lipTop=radians(330);

// booleans
boolean lipBottomClosed=false;   // is packitty's bottom lip closed?
boolean lipTopClosed=false;      // is packitty's top lip closed?
boolean isCatHighRef;
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
PacKitty()
{
// take the variables from the maze class
// we need them to make packitty move
super();

// define style
noStroke();
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// INTIALIZE STARTING POSITION
////////////////////////////////////////////////////////
void startPos()
{
  // booleans
  boolean up_left = false;
  boolean up_right = false;
  boolean down_right = false;
  boolean down_left = false;
 
  // if any of these come back true there is a wall
  up_left = collisionMap[int(kittyX - kittyW/2)][int(kittyY - kittyW/2)];
  up_right = collisionMap[int(kittyX + kittyW/2)][int(kittyY - kittyW/2)];
  down_right = collisionMap[int(kittyX + kittyW/2)][int(kittyY + kittyW/2)];
  down_left = collisionMap[int(kittyX - kittyW/2)][int(kittyY + kittyW/2)];

  if (up_left==false || up_right==false || down_right==false || down_left==false)
  {
    kittyX = int( random(100, width-100) );
    kittyY = int( random(100, height-100) );
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DRAWING PACKITTY
////////////////////////////////////////////////////////
void spawn(float kittyX, float kittyY)
{
  // OPEN AND CLOSE PACKITTY'S MOUTH SMOOTHLY
  // bottom lip
  if (lipBottom > radians(0) && lipBottomClosed == false)
  {
    lipBottom=lipBottom-radians(1);
  }
  
  if (lipBottom < radians(0))
  {
    lipBottomClosed=true;
  }
  
  if (lipBottomClosed == true)
  {
    lipBottom=lipBottom+radians(1);
  }
  
  if (lipBottom > radians(30))
  {
    lipBottomClosed=false;
  }
  
  // top lip
  if (lipTop < radians(360) && lipTopClosed == false)
  {
    lipTop=lipTop+radians(1);
  }
  
  if (lipTop > radians(360))
  {
    lipTopClosed=true;
  }
  
  if (lipTopClosed == true)
  {
    lipTop=lipTop-radians(1);
  }
  
  if (lipTop < radians(330))
  {
    lipTopClosed=false;
  }

  // IS THE CAT HIGGGHHHHHS
  if (isCatHighRef == true)
  {
    // make the cat grow!
    grow.play();
    float grow = 1.25;
    
    // packitty's body & mouth
    fill(137, 172, 191);
    arc(kittyX, kittyY, kittyW*grow, kittyH*grow, lipBottom, lipTop);
    
    // packitty's accessories!
    shapeMode(CENTER);
    shape(packitty, kittyX-5, kittyY-2, 60*grow, 60*grow);
  }
  else 
  {
    // packitty's body & mouth
    fill(137, 172, 191);
    arc(kittyX, kittyY, kittyW, kittyH, lipBottom, lipTop);
    
    // packitty's accessories!
    shapeMode(CENTER);
    shape(packitty, kittyX-5, kittyY-2, 60, 60);
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MOVE PACKITTY
////////////////////////////////////////////////////////
void play()
{ 
  // VARIABLES FOR CAT MOVEMENT
  float fingerX = mouseX;
  float fingerY = mouseY;
  float distX = fingerX - kittyX;
  float distY = fingerY - kittyY;
  boolean up_left = false;
  boolean up_right = false;
  boolean down_right = false;
  boolean down_left = false;
  
  // this checks for walls
  up_left = collisionMap[int(kittyX - kittyW/2)][int(kittyY - kittySpeed - kittyW/2)];
  up_right = collisionMap[int(kittyX + kittyW/2)][int(kittyY - kittySpeed - kittyW/2)];
  down_right = collisionMap[int(kittyX + kittyW/2)][int(kittyY - kittySpeed + kittyW/2)];
  down_left = collisionMap[int(kittyX - kittyW/2)][int(kittyY - kittySpeed + kittyW/2)];
    
  // corner tracker
  pushStyle();
  stroke(0,255,0);
  strokeWeight(5);
  point(int(kittyX - kittyW/2),int(kittyY - kittySpeed - kittyW/2));
  point(int(kittyX + kittyW/2),int(kittyY - kittySpeed - kittyW/2));
  point(int(kittyX + kittyW/2),int(kittyY - kittySpeed + kittyW/2));
  point(int(kittyX - kittyW/2),int(kittyY - kittySpeed + kittyW/2));
  popStyle();
    
  // if there are no walls move
  if (up_left && up_right && down_right && down_left) 
  {
    if(abs(distX) > 1) 
    {
      kittyX += distX * kittyE;
    }
    
    if(abs(distY) > 1) 
    {
      kittyY += distY * kittyE;
    }
  }
  // if there is a wall up or down, backup!
  else
  {
    kittyX += distX * kittyE;
    kittyY -= distY * kittyE;
  } 

  // show packitty
  spawn(kittyX, kittyY);
}
////////////////////////////////////////////////////////

}


