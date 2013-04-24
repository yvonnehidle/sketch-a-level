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

