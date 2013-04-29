////////////////////////////////////////////////////////
// THIS IS WHERE ALL THE FOOD IS CREATED
////////////////////////////////////////////////////////
class allFood
{
  // reference
  float kittyRefX;
  float kittyRefY;
  
  // tasty fish
  float fishEaten;
  float total_fishEaten;
  int fishSize;
  int tastyFishX;
  int tastyFishY;
  PImage tastyFish;
  
  // the ghosts
  float ghostsEaten;
  float total_ghostsEaten;
  
  // kibbles!
  float kibbleEaten;
  float total_kibbleEaten;
  final int foodMax = 100;
  int foodSize;
  int[] foodX;
  int[] foodY;
  PImage foodBits;
  
  // catnip!
  float total_catNipEaten;
  int catNipX;
  int catNipY;
  float catNipS;
  boolean isCatHigh;
  int startHigh;
  PShape catNip;
  
  // map related
  int darknessThreshold;
  
  ////////////////////////////////////////////////////////
  // VARIABLES VALUES (CONSTRUCTOR)
  ////////////////////////////////////////////////////////
  allFood()
  {   
    // FOOD VARIABLES NOW!
    // tasty fish
    fishEaten = 0;
    total_fishEaten = 0;
    fishSize = 40;
    tastyFishX = int( random(0, width) );
    tastyFishY = int( random(0, height) );
    tastyFish = loadImage("fish.png");
    
    // the ghosts
    ghostsEaten = 0;
    total_ghostsEaten = 0;

    // kibbles!
    kibbleEaten = 0;
    total_kibbleEaten = 0;
    foodSize = 20;
    foodX = new int[foodMax];
    foodY = new int[foodMax];
    foodX = makeFoodX(foodMax);
    foodY = makeFoodY(foodMax);
    foodBits = loadImage("food.png");
    
    // catnip!
    total_catNipEaten = 0;
    catNipX = int( random(0, width) );
    catNipY = int( random(0, height) );
    catNipS = 25;
    isCatHigh = false;
    startHigh = 0;
    catNip = loadShape("catnip.svg");
    
    // map related
    darknessThreshold = 150;
    
    // check for problems!
    //println("LOAD ONCE: Food constructor");
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // RUN THIS ONLY ONCE!
  ////////////////////////////////////////////////////////
  void resetMap()
  {
    drawnMap.loadPixels(); // load the pixels of our map, just once!
    
    // check for problems!
    println("LOAD ONCE: Food map calibrated");
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // SPAWNS THE FOOD
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
    for(int i=0; i<foodX.length; i++)
    {
      // what is the pixel number in the array?
      int loc = int( foodX[i] + foodY[i] * drawnMap.width );
      // do the cat and the food overlap?
      float kittyEat = dist(kittyRefX,kittyRefY,foodX[i],foodY[i]);
      
      // ON WALL
      // if the brightness of the pixel is less than our darkness threshold
      // then do not spawn any food!
      if(brightness(drawnMap.pixels[loc]) < darknessThreshold || foodY[i] < 50)
      {
      }
      
      // NOT ON WALL
      // else spawn us some food!
      else
      {
        image(foodBits, foodX[i], foodY[i], foodSize, foodSize);
      }
      
      // EAT THE FOOD
      // if kitty overlaps food, eat it!
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
        total_kibbleEaten++;
      }
    }
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // THE TASTY FISH
  ////////////////////////////////////////////////////////
  void tastyFish()
  {
    // what is the pixel number in the array?
    int loc = int( tastyFishX + tastyFishY * drawnMap.width );
    // do the cat and the food overlap?
    float kittyEatFish = dist(kittyRefX,kittyRefY,tastyFishX,tastyFishY);
      
    // ON WALL
    // if the brightness of the pixel is less than our darkness threshold
    // then do not spawn any food!
    if(brightness(drawnMap.pixels[loc]) < darknessThreshold || tastyFishY < 50)
    {
      tastyFishX = int( random(0, width) );
      tastyFishY = int( random(0, height-50) );
    }
      
    // NOT ON WALL
    // else spawn us some food!
    else
    {
      image(tastyFish,tastyFishX,tastyFishY,fishSize,fishSize);
    }
      
    // EAT THE FOOD
    // if kitty overlaps tastyfish, eat it!   
    if (kittyEatFish < fishSize)
    {
      // play eating sound
      player.setMediaFile("eatFish.mp3");
      player.start();
      
      // hide the fish
      tastyFishX = int( random(0, width) );
      tastyFishY = int( random(0, height-50) );
      
      // kibble eaten+1
      fishEaten++;
      total_fishEaten++;
    }    
  }
  ////////////////////////////////////////////////////////
  
  ////////////////////////////////////////////////////////
  // CAT NIP BALL TIME!
  ////////////////////////////////////////////////////////
  void catNip()
  {
    // what is the pixel number in the array?
    int loc = int( catNipX + catNipY * drawnMap.width );
    // do the cat and the food overlap?
    float kittyEat = dist(kittyRefX,kittyRefY,catNipX,catNipY);
    // countdown for packitty's high
    int countDown = 16000;
      
    // ON WALL
    // if the brightness of the pixel is less than our darkness threshold
    // then do not spawn any food!
    if(brightness(drawnMap.pixels[loc]) < darknessThreshold || tastyFishY < 50)
    {
      catNipX = int( random(0, width) );
      catNipY = int( random(0, height) );
    }
      
    // NOT ON WALL
    // else spawn us some food!
    else
    {
      shape(catNip,catNipX,catNipY,catNipS,catNipS);
    }
      
    // EAT THE FOOD
    // if kitty overlaps catnip, eat it!   
    if (kittyEat < catNipS && isCatHigh == false)
    { 
      // cat grows
      //player.setMediaFile("catnip-grow.wav");
      
      // count the catnip
      total_catNipEaten++;
      
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
