////////////////////////////////////////////////////////
// THIS IS WHERE ALL THE FOOD IS CREATED
////////////////////////////////////////////////////////
class allFood
{
  // map related
  boolean[][] foodMap;
  
  // reference
  float kittyRefX;
  float kittyRefY;
  
  // tasty fish
  float fishEaten;
  int fishSize;
  int tastyFishX;
  int tastyFishY;
  PShape tastyFish;
  
  // the ghosts
  float ghostsEaten;
  
  // kibbles!
  float kibbleEaten;
  int foodSize;
  final int foodMax = 100;
  int[] foodX;
  int[] foodY;
  PShape foodBits;
  
  // catnip!
  int catNipX;
  int catNipY;
  float catNipS;
  boolean isCatHigh;
  int startHigh;
  PShape catNip;
  
  ////////////////////////////////////////////////////////
  // VARIABLES VALUES (CONSTRUCTOR)
  ////////////////////////////////////////////////////////
  allFood()
  {
    // MAKE THE MAP BLACK OR WHITE, HAVE THE FOOD GENERATE RIGHT
    foodMap = new boolean[drawnMap.width][drawnMap.height];
    color black = color(0);
    color white = color(255);
    
    // looks through collision map rows
    for (int i = 0; i < drawnMap.width; i++)
    {
      // looks through collision map columns
      for (int j = 0; j < drawnMap.height; j++)
      {
        color c = drawnMap.get(i, j);
        if (c == black)
        {
          foodMap[i][j] = false;
        }
        else if (c == white)
        {
          foodMap[i][j] = true;
        }
      }
    }
    
    // FOOD VARIABLES NOW!
    // tasty fish
    fishEaten = 0;
    fishSize = 40;
    tastyFishX = int( random(0, width) );
    tastyFishY = int( random(0, height) );
    tastyFish = loadShape("fish.svg");
    
    // the ghosts
    ghostsEaten = 0;

    // kibbles!
    kibbleEaten = 0;
    foodSize = 20;
    foodX = new int[foodMax];
    foodY = new int[foodMax];
    foodX = makeFoodX(foodMax);
    foodY = makeFoodY(foodMax);
    foodBits = loadShape("food.svg");
    
    // catnip!
    catNipX = int( random(0, width) );
    catNipY = int( random(0, height) );
    catNipS = 25;
    isCatHigh = false;
    startHigh = 0;
    catNip = loadShape("catnip.svg");
    
    // check for problems!
    //println("LOAD ONCE: Food constructor");
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // SPAWNS THE KITTY FOOD
  ////////////////////////////////////////////////////////
  void spawn()
  {
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
    // all for the kibbles
    for(int i=0; i<foodX.length; i++)
    {
      // booleans for collision map
      boolean up_left = false;
      boolean up_right = false;
      boolean down_right = false;
      boolean down_left = false;
      
      // if any of these come back true there is a wall
      up_left = foodMap[foodX[i]][foodY[i]];
      up_right = foodMap[foodX[i]][foodY[i]];
      down_right = foodMap[foodX[i]][foodY[i]];
      down_left = foodMap[foodX[i]][foodY[i]];
      
      // if there no wall, this x value is OK
      if (up_left && up_right && down_right && down_left)
      {
        shape(foodBits, foodX[i], foodY[i], foodSize, foodSize);
      }
      
      // if kitty overlaps food, eat it!
      float kittyEat = dist(kittyRefX,kittyRefY,foodX[i],foodY[i]);
      if (kittyEat < foodSize)
      {
        // play eating sound
        player.setMediaFile("eatKibble.mp3");
        player.start();
      
        // hide the kibble
        foodX[i] = int( random(0, width) );
        foodY[i] = int( random(0, height) );
        
        // kibble counter +1
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
    up_left = foodMap[tastyFishX][tastyFishY];
    up_right = foodMap[tastyFishX][tastyFishY];
    down_right = foodMap[tastyFishX][tastyFishY];
    down_left = foodMap[tastyFishX][tastyFishY];
      
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
      // play eating sound
      player.setMediaFile("eatFish.mp3");
      player.start();
      
      // hide the fish
      tastyFishX = int( random(0, width) );
      tastyFishY = int( random(0, height) );
      
      // kibble eaten+1
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
    int countDown = 16000;
    
    // booleans for collision map
    boolean up_left = false;
    boolean up_right = false;
    boolean down_right = false;
    boolean down_left = false;
    
    // if any of these come back true there is a wall
    up_left = foodMap[catNipX][catNipY];
    up_right = foodMap[catNipX][catNipY];
    down_right = foodMap[catNipX][catNipY];
    down_left = foodMap[catNipX][catNipY];
      
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
      // cat grows
      //player.setMediaFile("catnip-grow.wav");
      
      // catnip relocates
      catNipX = int( random(0, width) );
      catNipY = int( random(0, height) );
      
      // the cat is high
      isCatHigh = true;
      
      // start high timer
      startHigh = millis();
      
      // play catnip music
      player.setMediaFile("catnip.wav");
      player.start();
    }
    
    if ((millis()-startHigh) > countDown)
    {
      // cat is not high
      isCatHigh = false;
      
      // cat shrinks
      //player.setMediaFile("catnip-shrink.wav");
      //player.start();
    }
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
    
    // check for problems!
    println("LOAD ONCE: Making food X values");
    
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
    
    // check for problems!
    println("LOAD ONCE: Making food X values");
    
    return tempValue;
  }
  ////////////////////////////////////////////////////////
  
}
