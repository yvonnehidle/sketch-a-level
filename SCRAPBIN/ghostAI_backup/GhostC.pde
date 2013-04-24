////////////////////////////////////////////////////////
// MOVEMENT INFORMATION FOR GHOST A
// THE GREEN ONE
// Ghost is randomly generated DoggyGhost class
//
// This ghost is a random, he travels where he wants
// to travel regardless of the position of PacKitty
////////////////////////////////////////////////////////
class GhostC extends Maze
{

  
////////////////////////////////////////////////////////
// GLOBAL VARIABLES
////////////////////////////////////////////////////////
  // ints and floats
  float ghostCX;
  float ghostCY;
  float ghostCSpeed = 1;
  int moveState = 4;
  float kittyRefX, kittyRefY;
  
  // classes
  DoggyGhost myDoggy;
////////////////////////////////////////////////////////

  
////////////////////////////////////////////////////////
// VARIABLES VALUES (CONSTRUCTOR)
////////////////////////////////////////////////////////
GhostC()
{
  // take the variables from the maze class
  // we need them to make packitty move
  super();
  
  // classes
  myDoggy = new DoggyGhost();
  
  // floats
  ghostCX = int( random(100,width-100) );
  ghostCY = int( random(100,height-100) );
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
  up_left = collisionMap[int(ghostCX - myDoggy.doggyW/2)][int(ghostCY - myDoggy.doggyH/2)];
  up_right = collisionMap[int(ghostCX + myDoggy.doggyW/2)][int(ghostCY - myDoggy.doggyH/2)];
  down_right = collisionMap[int(ghostCX + myDoggy.doggyW/2)][int(ghostCY + myDoggy.doggyH/2)];
  down_left = collisionMap[int(ghostCX - myDoggy.doggyW/2)][int(ghostCY + myDoggy.doggyH/2)];

  if(up_left==false || up_right==false || down_right==false || down_left==false || ghostCX < kittyRefX+100 && ghostCX > kittyRefX-100 && ghostCY < kittyRefY+100 && ghostCY > kittyRefY-100)
  {
    ghostCX = int( random(100, width-100) );
    ghostCY = int( random(100, height-100) );
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// DRAWING AND MOVING GHOST
////////////////////////////////////////////////////////
void play()
{
  // check for problems
  //println(moveState);
  //println(moveStateP);
  //println("mouseX: "+mouseX+" || mouseY: "+mouseY);
  
  // draw the ghost here
  myDoggy.spawn(ghostCX,ghostCY,color(95,229,116),color(55,152,70));
  
  // movement state for randomly generated ghost direction
  // if moveState is generated to be 1, move RIGHT
  if(moveState == 1)
  {
    moveRight();
  }
  // if moveState is generated to be 2, move left
  else if(moveState == 2)
  {
    moveLeft();
  }
  // if moveState is generated to be 3, move up
  else if(moveState == 3)
  {
   moveUp();
  }
  // if moveState is generated to be 4, move down
  else if(moveState == 4)
  {
    moveDown();
  }
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MOVE GHOST LEFT
////////////////////////////////////////////////////////
void moveLeft()
{
  // booleans
  boolean up_left = false;
  boolean up_right = false;
  boolean down_right = false;
  boolean down_left = false;
   
  // if any of these come back true there is a wall
  up_left = collisionMap[int(ghostCX - ghostCSpeed - myDoggy.doggyW/2)][int(ghostCY - myDoggy.doggyH/2)];
  up_right = collisionMap[int(ghostCX - ghostCSpeed + myDoggy.doggyW/2)][int(ghostCY - myDoggy.doggyH/2)];
  down_right = collisionMap[int(ghostCX - ghostCSpeed + myDoggy.doggyW/2)][int(ghostCY + myDoggy.doggyH/2)];
  down_left = collisionMap[int(ghostCX - ghostCSpeed - myDoggy.doggyW/2)][int(ghostCY + myDoggy.doggyH/2)];
  
  // corner tracker
  //pushStyle();
  //strokeWeight(5);
  //stroke(255,0,0);
  //point(int(ghostCX - ghostCSpeed - myDoggy.doggyW/2),int(ghostCY - myDoggy.doggyH/2));
  //point(int(ghostCX + ghostCSpeed + myDoggy.doggyW/2),int(ghostCY - myDoggy.doggyH/2));
  //point(int(ghostCX - ghostCSpeed + myDoggy.doggyW/2),int(ghostCY + myDoggy.doggyH/2));
  //point(int(ghostCX - ghostCSpeed - myDoggy.doggyW/2),int(ghostCY + myDoggy.doggyH/2));
  //popStyle();
        
  // if there is no wall move
  if (up_left && up_right && down_right && down_left) 
  {
    ghostCX = ghostCX - ghostCSpeed;
  }
        
  // if ghost is stuck do this
  else if (up_left == false || up_right == false || down_right == false || down_left == false)
  {       
    // generate a random movement state
    moveState = int( random(1,5) );
  }  
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MOVE GHOST RIGHT
////////////////////////////////////////////////////////
void moveRight()
{

// booleans
boolean up_left = false;
boolean up_right = false;
boolean down_right = false;
boolean down_left = false;
  
up_left = collisionMap[int(ghostCX + ghostCSpeed - myDoggy.doggyW/2)][int(ghostCY - myDoggy.doggyH/2)];
up_right = collisionMap[int(ghostCX + ghostCSpeed + myDoggy.doggyW/2)][int(ghostCY - myDoggy.doggyH/2)];
down_right = collisionMap[int(ghostCX + ghostCSpeed + myDoggy.doggyW/2)][int(ghostCY + myDoggy.doggyH/2)];
down_left = collisionMap[int(ghostCX + ghostCSpeed - myDoggy.doggyW/2)][int(ghostCY + myDoggy.doggyH/2)];

//corner tracker
//pushStyle();
//stroke(0,0,255);
//strokeWeight(5);
//point(int(ghostCX + ghostCSpeed - myDoggy.doggyW/2),int(ghostCY - myDoggy.doggyH/2));
//point(int(ghostCX + ghostCSpeed + myDoggy.doggyW/2),int(ghostCY - myDoggy.doggyH/2));
//point(int(ghostCX + ghostCSpeed + myDoggy.doggyW/2),int(ghostCY + myDoggy.doggyH/2));
//point(int(ghostCX + ghostCSpeed - myDoggy.doggyW/2),int(ghostCY + myDoggy.doggyH/2));
//popStyle();
        
        // if there is no wall move
        if (up_left && up_right && down_right && down_left) 
        {
        ghostCX = ghostCX + ghostCSpeed;
        }

        // if ghost is stuck do this
        else if (up_left == false || up_right == false || down_right == false || down_left == false)
        {       
        // generate a random movement state
        moveState = int( random(1,5) );
        }
  
}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MOVE GHOST DOWN
////////////////////////////////////////////////////////
void moveDown()
{
  
// booleans
boolean up_left = false;
boolean up_right = false;
boolean down_right = false;
boolean down_left = false;

// if any of these come back true there is a wall
up_left = collisionMap[int(ghostCX - myDoggy.doggyW/2)][int(ghostCY + ghostCSpeed - myDoggy.doggyH/2)];
up_right = collisionMap[int(ghostCX + myDoggy.doggyW/2)][int(ghostCY + ghostCSpeed - myDoggy.doggyH/2)];
down_right = collisionMap[int(ghostCX + myDoggy.doggyW/2)][int(ghostCY + ghostCSpeed + myDoggy.doggyH/2)];
down_left = collisionMap[int(ghostCX - myDoggy.doggyW/2)][int(ghostCY + ghostCSpeed + myDoggy.doggyH/2)];

// corner tracker
//pushStyle();
//strokeWeight(5);
//stroke(255,255,0);
//point(int(ghostCX - myDoggy.doggyW/2),int(ghostCY + ghostCSpeed - myDoggy.doggyH/2));
//point(int(ghostCX + myDoggy.doggyW/2),int(ghostCY + ghostCSpeed - myDoggy.doggyH/2));
//point(int(ghostCX + myDoggy.doggyW/2),int(ghostCY + ghostCSpeed + myDoggy.doggyH/2));
//point(int(ghostCX - myDoggy.doggyW/2),int(ghostCY + ghostCSpeed + myDoggy.doggyH/2));
//popStyle();

        // if there is no wall move
        if (up_left && up_right && down_right && down_left)
        {
        ghostCY = ghostCY + ghostCSpeed;
        }
        
        // if ghost is stuck do this
        else if (up_left == false || up_right == false || down_right == false || down_left == false)
        {       
        // generate a random movement state
        moveState = int( random(1,5) );
        }

}
////////////////////////////////////////////////////////


////////////////////////////////////////////////////////
// MOVE GHOST UP
////////////////////////////////////////////////////////
void moveUp()
{

// booleans
boolean up_left = false;
boolean up_right = false;
boolean down_right = false;
boolean down_left = false;

// if any of these come back true there is a wall
up_left = collisionMap[int(ghostCX - myDoggy.doggyW/2)][int(ghostCY - ghostCSpeed - myDoggy.doggyH/2)];
up_right = collisionMap[int(ghostCX + myDoggy.doggyW/2)][int(ghostCY - ghostCSpeed - myDoggy.doggyH/2)];
down_right = collisionMap[int(ghostCX + myDoggy.doggyW/2)][int(ghostCY - ghostCSpeed + myDoggy.doggyH/2)];
down_left = collisionMap[int(ghostCX - myDoggy.doggyW/2)][int(ghostCY - ghostCSpeed + myDoggy.doggyH/2)];

// corner tracker
//pushStyle();
//stroke(0,255,0);
//strokeWeight(5);
//point(int(ghostCX - myDoggy.doggyW/2),int(ghostCY - ghostCSpeed - myDoggy.doggyH/2));
//point(int(ghostCX + myDoggy.doggyW/2),int(ghostCY - ghostCSpeed - myDoggy.doggyH/2));
//point(int(ghostCX + myDoggy.doggyW/2),int(ghostCY - ghostCSpeed + myDoggy.doggyH/2));
//point(int(ghostCX - myDoggy.doggyW/2),int(ghostCY - ghostCSpeed + myDoggy.doggyH/2));
//popStyle();

        // if there is no wall move
        if (up_left && up_right && down_right && down_left) 
        {
        ghostCY = ghostCY - ghostCSpeed;
        }
        
        // if ghost is stuck do this
        else if (up_left == false || up_right == false || down_right == false || down_left == false)
        {       
        // generate a random movement state
        moveState = int( random(1,5) );
        }

}
////////////////////////////////////////////////////////

}
