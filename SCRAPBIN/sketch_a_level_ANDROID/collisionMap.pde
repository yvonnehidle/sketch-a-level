////////////////////////////////////////////////////////
// TURN THE DRAWING INTO A COLLISION MAP
// This is where the collison map is set up
////////////////////////////////////////////////////////
class collisionMap
{
  // BASIC VARIABLES
  boolean[][] collisionMap;
  
  ////////////////////////////////////////////////////////
  // VARIABLES VALUES (CONSTRUCTOR)
  ////////////////////////////////////////////////////////
  collisionMap()
  {   
    // generate our collision map as an two-dimensional boolean array
    // black is false (blocked)
    // white is true (clear)
    collisionMap = new boolean[drawnMap.width][drawnMap.height];
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
