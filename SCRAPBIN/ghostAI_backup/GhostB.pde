////////////////////////////////////////////////////////
// MOVEMENT INFORMATION FOR GHOST A
// THE PINK ONE
// Ghost is randomly generated DoggyGhost class
//
// This ghost moves using Perlin's noise
////////////////////////////////////////////////////////
class GhostB extends Maze
{

  
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // ints and floats
  float ghostBX;
  float ghostBY;
  float tx;
  float ty;
  float ghostBSpeed = 1;
  float kittyRefX, kittyRefY;
  
  // booleans
  boolean movingX = false;
  boolean movingY = true;
  
  // classes
  DoggyGhost myDoggy;
  PacKitty myKitty;
////////////////////////////////////////////////////////

  
////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
GhostB()
{
  // take the variables from the maze class
  // we need them to make packitty move
  super();
  
  // classes
  myDoggy = new DoggyGhost();
  
  // floats
  ghostBX = int( random(100,width-100) );
  ghostBY = int( random(100,height-100) );
  tx = 0;
  ty = 10000;
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
  up_left = collisionMap[int(ghostBX - myDoggy.doggyW/2)][int(ghostBY - myDoggy.doggyH/2)];
  up_right = collisionMap[int(ghostBX + myDoggy.doggyW/2)][int(ghostBY - myDoggy.doggyH/2)];
  down_right = collisionMap[int(ghostBX + myDoggy.doggyW/2)][int(ghostBY + myDoggy.doggyH/2)];
  down_left = collisionMap[int(ghostBX - myDoggy.doggyW/2)][int(ghostBY + myDoggy.doggyH/2)];

  if(up_left==false || up_right==false || down_right==false || down_left==false || ghostBX < kittyRefX+100 && ghostBX > kittyRefX-100 && ghostBY < kittyRefY+100 && ghostBY > kittyRefY-100)
  {
    ghostBX = int( random(100, width-100) );
    ghostBY = int( random(100, height-100) );
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DRAWING AND MOVING GHOST
////////////////////////////////////////////////////////
void play()
{
  // draw ghost using doggyghost class
  myDoggy.spawn(ghostBX,ghostBY,color(240,193,242),color(199,123,203));
  
  // move the ghost
  move();
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MOVE THE GHOST
////////////////////////////////////////////////////////
void move()
{
  // booleans
  boolean up_left = false;
  boolean up_right = false;
  boolean down_right = false;
  boolean down_left = false;
   
  // if any of these come back true there is a wall
  up_left = collisionMap[int(ghostBX - ghostBSpeed - myDoggy.doggyW/2)][int(ghostBY - myDoggy.doggyH/2)];
  up_right = collisionMap[int(ghostBX - ghostBSpeed + myDoggy.doggyW/2)][int(ghostBY - myDoggy.doggyH/2)];
  down_right = collisionMap[int(ghostBX - ghostBSpeed + myDoggy.doggyW/2)][int(ghostBY + myDoggy.doggyH/2)];
  down_left = collisionMap[int(ghostBX - ghostBSpeed - myDoggy.doggyW/2)][int(ghostBY + myDoggy.doggyH/2)];
  
  // corner tracker
  //pushStyle();
  //strokeWeight(5);
  //stroke(255,0,0);
  //point(int(ghostBX - ghostBSpeed - myDoggy.doggyW/2),int(ghostBY - myDoggy.doggyH/2));
  //point(int(ghostBX + ghostBSpeed + myDoggy.doggyW/2),int(ghostBY - myDoggy.doggyH/2));
  //point(int(ghostBX - ghostBSpeed + myDoggy.doggyW/2),int(ghostBY + myDoggy.doggyH/2));
  //point(int(ghostBX - ghostBSpeed - myDoggy.doggyW/2),int(ghostBY + myDoggy.doggyH/2));
  //popStyle();
        
  // if there is no wall move
  if (up_left && up_right && down_right && down_left) 
  {
    // move down
    ghostBY = map(noise(ty),0,1,0,height);
    ty +=0.005;
    // move right
    ghostBX = map(noise(tx),0,1,0,width);
    tx +=0.005;
  }

  // if ghost is stuck do this
  else if (up_left == false || up_right == false || down_right == true || down_left == true)
  {
    // move left
    ghostBX = map(noise(tx),0,1,0,width);
    tx -=0.005;
  }  
  
  // if ghost is stuck do this
  else if (up_left == true || up_right == true || down_right == false || down_left == false)
  {
    // move up
    ghostBY = map(noise(ty),0,1,0,height);
    ty -=0.005;
  }  
}
////////////////////////////////////////////////////////

}
