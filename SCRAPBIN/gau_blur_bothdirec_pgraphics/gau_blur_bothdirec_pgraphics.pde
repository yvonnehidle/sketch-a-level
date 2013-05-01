PGraphics myGraphics; 
color srcPixels[];
color dstPixels[];

void setup() {
  size(400, 400); 
  background(255);
  myGraphics = createGraphics(width, height);
  dstPixels = new color[width * height];
}

void draw() 
{ 
  drawLine();
}


void drawLine()
{
  myGraphics.beginDraw();
    myGraphics.background(255); 
    myGraphics.strokeWeight (20);
    myGraphics.stroke (0); 
    myGraphics.smooth(); 
    myGraphics.line (128, 40, 370, 200); 
    myGraphics.endDraw();
    
  if(mousePressed == true)
  { 
    blurDrawing(); 
    image (myGraphics, 0,0);
  }
}

void blurDrawing() {
  myGraphics.loadPixels(); 
  srcPixels = myGraphics.pixels;
  
    int nPasses = 20; 
    
    for (int p=0; p<nPasses; p++) {
  
      for (int y=0; y<height; y++) {
        for (int x=0; x<width; x++) {
          
          // FOR THE X DIRECTION
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
          
          
          
          // FOR THE Y DIRECTION
          int j0 = (y-3)*width + x;
          int j1 = (y-2)*width + x;
          int j2 = (y-1)*width + x;
          int j3 = (y)*width + x;
          int j4 = (y+1)*width + x;
          int j5 = (y+2)*width + x;
          int j6 = (y+3)*width + x;
          
          color color0 = (y < 3)          ? 255: srcPixels[j0];
          color color1 = (y < 2)          ? 255: srcPixels[j1];
          color color2 = (y < 1)          ? 255: srcPixels[j2];
          color color3 =                         srcPixels[j3];
          color color4 = (y >= height-1)  ? 255: srcPixels[j4];
          color color5 = (y >= height-2)  ? 255: srcPixels[j5];
          color color6 = (y >= height-3)  ? 255: srcPixels[j6];
          
          float blue0 =      (0xFF & color0);
          float blue1 = 6  * (0xFF & color1);
          float blue2 = 15 * (0xFF & color2);
          float blue3 = 20 * (0xFF & color3);
          float blue4 = 15 * (0xFF & color4);
          float blue5 = 6  * (0xFF & color5);
          float blue6 =      (0xFF & color6);
          
          int avg2 = (int)((blue0+blue1+blue2+blue3+blue4+blue5+blue6)/64);
          dstPixels[j3] = color(avg2);
        }
      } 
  
      int nPixels = width * height; 
      for (int i=0; i<nPixels; i++) {
        srcPixels[i] = dstPixels[i];
      }
    }
  
    myGraphics.updatePixels();
  }
