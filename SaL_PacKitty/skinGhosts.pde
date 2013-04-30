////////////////////////////////////////////////////////
// PARAMETERS FOR DRAWING ALL GHOSTS
// Takes SVG file and gives colors 
////////////////////////////////////////////////////////
class skinGhosts
{
  // BASIC VARIABLES
  float ghostW;
  float ghostH;
  PShape ghostBody;
  PShape body;
  PShape ears;
  PShape innerEars;
  PShape eyes;
  
  
  ////////////////////////////////////////////////////////
  // THE CONSTRUCTOR
  ////////////////////////////////////////////////////////
  skinGhosts()
  {
    // floats and ints
    ghostW=60;
    ghostH=ghostW;
    
    // shapes
    ghostBody = loadShape("character_ghost.svg");
    body = ghostBody.getChild("body_1_");
    ears = ghostBody.getChild("ears_1_");
    innerEars = ghostBody.getChild("inner-ears");
    eyes = ghostBody.getChild("eyes");
    
    // check for problems!
    //println("LOAD ONCE: Ghost skin constructor");
  }
  ////////////////////////////////////////////////////////
  
  
  ////////////////////////////////////////////////////////
  // DRAWING OUR DOGGY GHOSTS
  ////////////////////////////////////////////////////////
  void makeGhost(float doggyX, float doggyY, color randomCol1, color randomCol2)
  {
    pushStyle();
      rectMode(CENTER);
      shapeMode(CENTER);
      noStroke();
      
      // draw ghostBody
      shape(ghostBody, doggyX, doggyY, ghostW, ghostH);
      
      // draw ghostBody body a random color
      // disable the colors found in the SVG file
      body.disableStyle();
      fill(randomCol1);
      shape(body,doggyX,doggyY,ghostW,ghostH);
      
      // draw ghostBody ears a random color
      // disable the colors found in the SVG file
      ears.disableStyle();
      fill(randomCol1);
      shape(ears,doggyX,doggyY,ghostW,ghostH);
      
      // draw ghostBody inner ears a random color
      // disable the colors found in the SVG file
      innerEars.disableStyle();
      fill(randomCol2);
      shape(innerEars,doggyX,doggyY,ghostW,ghostH);
      
      // draw ghostBody eyes
      // disable the colors found in the SVG file
      innerEars.disableStyle();
      fill(255);
      shape(eyes,doggyX,doggyY,ghostW,ghostH);
      
    popStyle();
  }
  ////////////////////////////////////////////////////////

}
