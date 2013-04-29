boolean bSaved = false; 
PGraphics myGraphics; 
color srcPixels[];
color dstPixels[];

void setup() {
  size(512, 256); 
  myGraphics = createGraphics(width, height);
  dstPixels = new color[width * height];

  //makeDrawing(); 
  //blurDrawing();
}


void makeDrawing() {
  myGraphics.beginDraw();
  myGraphics.background(255); 
  myGraphics.strokeWeight (5);
  myGraphics.stroke (0); 
  myGraphics.smooth(); 
  myGraphics.line (mouseX, mouseY, 210, 91); 
  myGraphics.line (210, 91, 150, 177); 
  myGraphics.endDraw();
}

void blurDrawing() {
  myGraphics.loadPixels(); 
  srcPixels = myGraphics.pixels;

  int nPasses = 20; 
  
  for (int p=0; p<nPasses; p++) {

    for (int y=0; y<height; y++) {
      for (int x=0; x<width; x++) {

        int row = (y*width) + x; 
        int i0 = row - 3;
        int i1 = row - 2;
        int i2 = row - 1;
        int i3 = row    ; 
        int i4 = row + 1;
        int i5 = row + 2;
        int i6 = row + 3;

        color c0 = (x < 3)        ? 255: srcPixels[i0];
        color c1 = (x < 2)        ? 255: srcPixels[i1];
        color c2 = (x < 1)        ? 255: srcPixels[i2];
        color c3 =                       srcPixels[i3];
        color c4 = (x >= width-1) ? 255: srcPixels[i4];
        color c5 = (x >= width-2) ? 255: srcPixels[i5];
        color c6 = (x >= width-3) ? 255: srcPixels[i6];

        float b0 =      (0xFF & c0); // extract the blue value
        float b1 = 6  * (0xFF & c1); 
        float b2 = 15 * (0xFF & c2); 
        float b3 = 20 * (0xFF & c3); 
        float b4 = 15 * (0xFF & c4); 
        float b5 = 6  * (0xFF & c5); 
        float b6 =      (0xFF & c6); 

        int avg = (int)((b0+b1+b2+b3+b4+b5+b6)/64);
        dstPixels[i3] = color(avg);
      }
    } 

    int nPixels = width * height; 
    for (int i=0; i<nPixels; i++) {
      srcPixels[i] = dstPixels[i];
    }
  }

  myGraphics.updatePixels();
}



void draw() {
  background (200); 

  makeDrawing(); 
  blurDrawing();
  
  image (myGraphics, 0,0);
}

void keyPressed() {
  bSaved = true;
}
