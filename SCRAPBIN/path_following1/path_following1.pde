    // press the mouse to set a random path
    // move the mouse to change the path
     
    int numPoints = 8;
    int marge = 50;
    int currentCurvePoint;
    PVector[] vecs = new PVector[numPoints];
     
    void setup() {
      size(500, 500);
      setPoints();
      smooth();
    }
     
    void draw() {
      background(255);
      translate(50, 50);
      vecs[3].set(mouseX-50, mouseY-50, 0);
      drawShape();
      drawPoints();
      if (frameCount % 20 == 0) { currentCurvePoint++; }
      drawCurvePoint(currentCurvePoint % (vecs.length-3));
    }
     
    void mousePressed() {
      setPoints();
    }
     
    void setPoints() {
      for (int i=0; i<numPoints-2; i++) {
        vecs[i] = new PVector(random(marge, width-marge), random(marge, height-marge));
      }
      vecs[numPoints-2] = vecs[1];
      vecs[numPoints-1] = vecs[2];
    }
     
    void drawShape() {
      noFill();
      stroke(0);
      beginShape();
      for (int i=0; i<vecs.length; i++) {
        curveVertex(vecs[i].x, vecs[i].y);
      }
      endShape();
    }
     
    void drawPoints() {
      noStroke();
      fill(255, 0, 0);
      for (int i=1; i<vecs.length-1; i++) {
        ellipse(vecs[i].x, vecs[i].y, 5, 5);
      }
    }
     
    void drawCurvePoint(int num) {
      noStroke();
      fill(0, 0, 255);
      float t = (frameCount % 20)/20.0;
      float x = curvePoint(vecs[num].x, vecs[num+1].x, vecs[num+2].x, vecs[num+3].x, t);
      float y = curvePoint(vecs[num].y, vecs[num+1].y, vecs[num+2].y, vecs[num+3].y, t);
      ellipse(x, y, 15, 15);
    }
