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
// GIVES PACKITTY RANDOM X VALUES
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
//  // local variables
//  float worldRecord = 500;   // Before we begin searching, the "world record" for closest color is set to a high number that is easy for the first pixel to beat.
//  int closestX = 0;          // X coordinate of closest color
//  int closestY = 0;          // Y coordinate of closest color
//  boolean up_left = false;
//  boolean up_right = false;
//  boolean down_right = false;
//  boolean down_left = false;
//  boolean kittyState1 = false;      // is packitty looking up?
//  boolean kittyState2 = false;      // is packitty looking down?
//  boolean kittyState3 = false;      // is packitty looking left?
//  boolean kittyState4 = true;       // is packitty looking right?
//  
//  // begin to go through extra pixel of video
//  cam.loadPixels();
//  for (int x = 0; x < cam.width; x ++ ) 
//  {
//    for (int y = 0; y < cam.height; y ++ ) 
//    {
//      int loc = x + y*cam.width;                     // id of pixel
//      color currentColor = cam.pixels[loc];          // what is current color
//      float r1 = red(currentColor);
//      float g1 = green(currentColor);
//      float b1 = blue(currentColor);
//      float r2 = red(trackColor);
//      float g2 = green(trackColor);
//      float b2 = blue(trackColor);
//      float d = dist(r1,g1,b1,r2,g2,b2);               // compare the current color with the color we are tracking.
//
//      // if current color is more similar to tracked color than
//      // closest color, save current location and current difference
//      if (d < worldRecord) 
//      {
//        worldRecord = d;
//        closestX = x;
//        closestY = y;
//      }
//    }
//  }  
//  
//  // store previous cat values so we can compare them!
//  previous_kittyX = kittyX;
//  previous_kittyY = kittyY;
//  
//  // We only consider the color found if its color distance is less than the threshold
//  if (worldRecord < 5) 
//  { 
//    float dx = closestX - kittyX;
//    float dy = closestY - kittyY;
//    
//    if(abs(dx) > 1) 
//    {
//      kittyX += dx * kittyE;
//    }
//    if(abs(dy) > 1) 
//    {
//      kittyY += dy * kittyE;
//    }
//  }
//  
//  
//  // CAT ROTATES GO HERE
//  // rotate packitty LEFT
//  if(previous_kittyX > kittyX)
//  {
//    pushMatrix();
//      scale(-1, 1);
//      spawn(-kittyX, kittyY);
//    popMatrix();
//  }
//  
//  // rotate packitty RIGHT
//  else if (previous_kittyX < kittyX)
//  {
//    pushMatrix();
//      spawn(kittyX, kittyY);
//    popMatrix();
//  }
  
  // CHECK FOR PROBLEMS HERE
  //println(previous_kittyX + " vs " + kittyX);
  
  
  
  // booleans
  boolean up_left = false;
  boolean up_right = false;
  boolean down_right = false;
  boolean down_left = false;
  boolean kittyState1 = false;      // is packitty looking up?
  boolean kittyState2 = false;      // is packitty looking down?
  boolean kittyState3 = false;      // is packitty looking left?
  boolean kittyState4 = true;      // is packitty looking right?
  
  // rotate packitty up, down, right, and left
  if (key == CODED)
  {
    
    
  // move packitty up
  // check for walls
  if (keyCode == UP)
  {
  kittyState1=true;
  kittyState2=false;
  kittyState3=false;
  kittyState4=false;
  
  // this checks for walls
  if (kittyY >= kittyW/2 + kittySpeed)
  {
  up_left = collisionMap[int(kittyX - kittyW/2)][int(kittyY - kittySpeed - kittyW/2)];
  up_right = collisionMap[int(kittyX + kittyW/2)][int(kittyY - kittySpeed - kittyW/2)];
  down_right = collisionMap[int(kittyX + kittyW/2)][int(kittyY - kittySpeed + kittyW/2)];
  down_left = collisionMap[int(kittyX - kittyW/2)][int(kittyY - kittySpeed + kittyW/2)];
  
  // corner tracker
  //pushStyle();
  //stroke(0,255,0);
  //strokeWeight(5);
  //point(int(kittyX - kittyW/2),int(kittyY - kittySpeed - kittyW/2));
  //point(int(kittyX + kittyW/2),int(kittyY - kittySpeed - kittyW/2));
  //point(int(kittyX + kittyW/2),int(kittyY - kittySpeed + kittyW/2));
  //point(int(kittyX - kittyW/2),int(kittyY - kittySpeed + kittyW/2));
  //popStyle();
  
  // if there are no walls move
  if (up_left && up_right && down_right && down_left) 
  {
  kittyY -= kittySpeed;
  }}} 
    
    
  // move packitty down
  // check for walls
  else if (keyCode == DOWN)
  {
  kittyState2=true;
  kittyState3=false;
  kittyState4=false;
  kittyState1=false;
  
  // this checks for walls
  if (kittyY <= height - kittyW/2 - kittySpeed)
  {
  up_left = collisionMap[int(kittyX - kittyW/2)][int(kittyY + kittySpeed - kittyW/2)];
  up_right = collisionMap[int(kittyX + kittyW/2)][int(kittyY + kittySpeed - kittyW/2)];
  down_right = collisionMap[int(kittyX + kittyW/2)][int(kittyY + kittySpeed + kittyW/2)];
  down_left = collisionMap[int(kittyX - kittyW/2)][int(kittyY + kittySpeed + kittyW/2)];
  
  //corner tracker
  //pushStyle();
  //stroke(255,255,0);
  //strokeWeight(5);
  //point(int(kittyX - kittyW/2),int(kittyY + kittySpeed - kittyW/2));
  //point(int(kittyX + kittyW/2),int(kittyY + kittySpeed - kittyW/2));
  //point(int(kittyX + kittyW/2),int(kittyY + kittySpeed + kittyW/2));
  //point(int(kittyX - kittyW/2),int(kittyY + kittySpeed + kittyW/2));
  //popStyle();
  
  // if there are no walls you may move
  if (up_left && up_right && down_right && down_left)
  {
  kittyY += kittySpeed;
  }}}
  
  
  // move packitty left
  // check for walls
  else if (keyCode == LEFT)
  {
  kittyState3=true;
  kittyState4=false;
  kittyState1=false;
  kittyState2=false;
  
  // this checks for walls
  if (kittyX >= kittyW/2 + kittySpeed)
  {
  up_left = collisionMap[int(kittyX - kittySpeed - kittyW/2)][int(kittyY - kittyW/2)];
  up_right = collisionMap[int(kittyX + kittySpeed - kittyW/2)][int(kittyY - kittyW/2)];
  down_right = collisionMap[int(kittyX - kittySpeed + kittyW/2)][int(kittyY + kittyW/2)];
  down_left = collisionMap[int(kittyX - kittySpeed - kittyW/2)][int(kittyY + kittyW/2)];
  
  //corner tracker
  //pushStyle();
  //strokeWeight(5);
  //stroke(255,0,0);
  //point(int(kittyX - kittySpeed - kittyW/2),int(kittyY - kittyW/2));
  //point(int(kittyX + kittySpeed + kittyW/2),int(kittyY - kittyW/2));
  //point(int(kittyX - kittySpeed + kittyW/2),int(kittyY + kittyW/2));
  //point(int(kittyX - kittySpeed - kittyW/2),int(kittyY + kittyW/2));
  //popStyle();
  
  // if there are no walls move
  if (up_left && up_right && down_right && down_left) 
  {
  kittyX -= kittySpeed;
  }}}
    
  
  // move packitty right
  // check for walls
  else if (keyCode == RIGHT)
  {
  kittyState4=true;
  kittyState1=false;
  kittyState2=false;
  kittyState3=false;
  
  // this checks for walls
  if (kittyX <= width - kittyW/2 - kittySpeed)
  {
  up_left = collisionMap[int(kittyX + kittySpeed - kittyW/2)][int(kittyY - kittyW/2)];
  up_right = collisionMap[int(kittyX + kittySpeed + kittyW/2)][int(kittyY - kittyW/2)];
  down_right = collisionMap[int(kittyX + kittySpeed + kittyW/2)][int(kittyY + kittyW/2)];
  down_left = collisionMap[int(kittyX + kittySpeed - kittyW/2)][int(kittyY + kittyW/2)];
  
  //corner tracker
  //pushStyle();
  //stroke(0,0,255);
  //strokeWeight(5);
  //point(int(kittyX + kittySpeed - kittyW/2),int(kittyY - kittyW/2));
  //point(int(kittyX + kittySpeed + kittyW/2),int(kittyY - kittyW/2));
  //point(int(kittyX + kittySpeed + kittyW/2),int(kittyY + kittyW/2));
  //point(int(kittyX + kittySpeed - kittyW/2),int(kittyY + kittyW/2));
  //popStyle();
  
  // if there are no walls move
  if (up_left && up_right && down_right && down_left) 
  {
  kittyX += kittySpeed;
  }}}
  
  // check for problems
  //println("kittyX: "+kittyX+" ||| kittyY: "+kittyY);
  }
  
  
  // this is where the actual rotation of packitty happens
  // rotate packitty UP
  if (kittyState1==true)
  {
  pushMatrix();
    translate(kittyX, kittyY);
    rotate(radians(-90));
    spawn(0, 0);
  popMatrix();
  }
  
  // rotate packitty DOWN
  else if (kittyState2==true)
  {
  pushMatrix();
    translate(kittyX, kittyY);
    rotate(radians(90));
    spawn(0, 0);
  popMatrix();
  }
  
  // rotate packitty LEFT
  else if (kittyState3==true)
  {
  pushMatrix();
    scale(-1, 1);
    spawn(-kittyX, kittyY);
  popMatrix();
  }
  
  // rotate packitty RIGHT
  else if (kittyState4==true)
  {
  pushMatrix();
    spawn(kittyX, kittyY);
  popMatrix();
  }
  
}
////////////////////////////////////////////////////////

}

