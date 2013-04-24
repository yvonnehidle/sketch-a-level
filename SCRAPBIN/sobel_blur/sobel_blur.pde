PImage blurryWorld; 
color bgPixels[];
int nBgPixels; 
float vals[];  // neighborhood

float px, py; // particle's position
float vx, vy; // particle's velocity
float tx, ty; // target position;


void setup() {
  size (640, 480); 
  blurryWorld = loadImage("map.png");
  blurryWorld.filter(BLUR, 5);

  blurryWorld.loadPixels(); 
  bgPixels = blurryWorld.pixels;

  vals = new float[9];
}

void draw() {
  renderSimulation();
  updateSimulation();
}


float getTerrainValue (float x, float y) {
  // returns terrain of image, dark = 1;
  int imgW = blurryWorld.width; 
  int imgH = blurryWorld.height; 
  nBgPixels = imgW*imgH; 
  int testPointX = (int) constrain(round(x), 0, imgW-1); 
  int testPointY = (int) constrain(round(y), 0, imgH-1);
  int testIndex = (testPointY * imgW) + testPointX; 
  color testColor = bgPixels[testIndex]; 
  float hillValue = map(brightness(testColor), 0, 255, 1, 0); 
  return hillValue;
}


void updateSimulation() {
  float attractionToTarget = 0.3; 
  float desireToTraceHill = 3.6;

  float dx = tx - px; 
  float dy = ty - py; 
  float dh = sqrt(dx*dx + dy*dy); 

  if (dh > 0) { 
    // add in the force due to attraction
    float fx = (dx / dh) * attractionToTarget; 
    float fy = (dy / dh) * attractionToTarget; 
    vx = vx + fx; 
    vy = vy + fy;
  }


  // extract 9 terrain values, from my neighborhood.
  int e = 10;  
  vals[0] = getTerrainValue (px - e, py - e); 
  vals[1] = getTerrainValue (px, py - e); 
  vals[2] = getTerrainValue (px + e, py - e); 

  vals[3] = getTerrainValue (px - e, py    );  
  vals[4] = getTerrainValue (px, py    ); 
  vals[5] = getTerrainValue (px + e, py    ); 

  vals[6] = getTerrainValue (px - e, py + e);
  vals[7] = getTerrainValue (px, py + e); 
  vals[8] = getTerrainValue (px + e, py + e); 

  float xKernel[] = {
    -1, 0, 1, -2, 0, 2, -1, 0, 1
  };
  float yKernel[] = { 
    1, 2, 1, 0, 0, 0, -1, -2, -1
  };

  // http://homepages.inf.ed.ac.uk/rbf/HIPR2/sobel.htm
  float Gx = 0;
  float Gy = 0;
  for (int i=0; i<9; i++) {
    Gx += xKernel[i] * vals[i]; 
    Gy += yKernel[i] * vals[i];
  }
  float Gh = sqrt(Gx*Gx + Gy*Gy); 
  
  if (Gh > 0) {
    float Gorientation = atan2 (Gy, Gx);
    float avoidCrossing = pow(vals[4], 0.5);
    float hx =   avoidCrossing * desireToTraceHill * sin (Gorientation);
    float hy =   avoidCrossing * desireToTraceHill * cos (Gorientation);
    float hh = sqrt(hx*hx + hy*hy); // hill force magnitude
    //if (hh > 1.0){
    //  hx = hx / hh;
    //  hy = hy / hh;
    //}
    
    vx = vx + hx; 
    vy = vy + hy; 
     line (px, py, px+hx, py+hy); 
  }
  


  vx = vx * 0.70;
  vy = vy * 0.70; // lose 4% of our energy on each frame
  px = px + vx;   // integration
  py = py + vy;
}






void renderSimulation() {
  image (blurryWorld, 0, 0) ; 

  fill(255, 100, 0); 
  ellipse(tx, ty, 20, 20); 

  fill (0, 150, 255); 
  rect(px-10, py-10, 20, 20);
}

void mousePressed() {
  px = mouseX; 
  py = mouseY;
  tx = random(width); 
  ty = random(height) ;
}
