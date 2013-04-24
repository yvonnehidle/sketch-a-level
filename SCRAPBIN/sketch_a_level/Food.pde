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
  startHigh = millis();
}

if ((millis()-startHigh) > countDown)
{
  isCatHigh = false;
}

}
////////////////////////////////////////////////////////

}
