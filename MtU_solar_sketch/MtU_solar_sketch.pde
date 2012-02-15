PFont font;

PImage p_img;  
float curr_wheelAngle; 
float wheel_dragOffset;
int wheel_x, wheel_y;
boolean wheel_mouseOver, wheel_dragging;

//whatever

void setup() {
  size(1024, 768);  // Size must be the first statement
  frameRate(30);
  smooth();
  font = loadFont("Serif-48.vlw");
  textFont(font, 36);
  p_img = loadImage("protractor.png");
 
  curr_wheelAngle = 0;
  wheel_mouseOver = false;
  wheel_x = 500;
  wheel_y = 300;
}
void draw() { 
  update();
  background(127); 
  drawProtractor(wheel_x, wheel_y, curr_wheelAngle);
  
  text(angleFromOrbitCentre(), 10, 40);
  text(curr_wheelAngle, 10, 80);
} 

void update() {
  if (overCircle(wheel_x, wheel_y, p_img.width)) {
     wheel_mouseOver = true;
  } else {
       wheel_mouseOver = false;
  }
  if (wheel_dragging) {
    curr_wheelAngle = angleFromOrbitCentre() - wheel_dragOffset;
  }
}

void mousePressed() {
  if(wheel_mouseOver) {
    wheel_dragging = true;
    wheel_dragOffset = angleFromOrbitCentre() - curr_wheelAngle;
  }
}

void mouseReleased() {
  if(wheel_dragging) {
    wheel_dragging = false;
  }
}

void drawProtractor(float x, float y, float a) {
  pushMatrix();
  translate(x, y);
  rotate(radians(a));
  translate(-p_img.width/2, -p_img.height/2);
  image(p_img, 0, 0);
  popMatrix();
}

float angleFromOrbitCentre() {
  float dx = mouseX - wheel_x;
  float dy = mouseY - wheel_y;
  return degrees(atan2(dy, dx));  
}

boolean overCircle(int x, int y, int diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
