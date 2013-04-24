void setup()
{
  size(1280,800);
  orientation(LANDSCAPE);
  background(255);
  smooth();
}



void draw()
{
 noStroke();
 fill(0);
 
 if(mousePressed) 
 { 
   // draw the line
   ellipse(mouseX, mouseY, 20, 20);
 }
 
}
