PFont font;

PImage p_img;  
float curr_orbit_angle; 
float orbit_drag_offset;
int orbit_x, orbit_y;
boolean orbit_mouseOver, orbit_dragging;

//whatever

void setup() {
  size(1024, 768);  // Size must be the first statement
  frameRate(30);
  smooth();
  font = loadFont("Serif-48.vlw");
  textFont(font, 36);
  p_img = loadImage("protractor.png");
 
  curr_orbit_angle = 0;
  orbit_mouseOver = false;
  orbit_x = 500;
  orbit_y = 300;
}
void draw() { 
  update();
  background(127); 
  drawProtractor(orbit_x, orbit_y, curr_orbit_angle);
  
  text(angleFromOrbitCentre(), 10, 20);
} 

void update() {
  if (overCircle(orbit_x, orbit_y, p_img.width)) {
     orbit_mouseOver = true;
  } else {
       orbit_mouseOver = false;
  }
  if (orbit_dragging) {
    curr_orbit_angle = angleFromOrbitCentre() + orbit_drag_offset;
  }
}

void mousePressed() {
  if(orbit_mouseOver) {
    orbit_dragging = true;
    orbit_drag_offset = curr_orbit_angle ;
  }
}

void mouseReleased() {
  if(orbit_dragging) {
    orbit_dragging = false;
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
  float dx = mouseX - orbit_x;
  float dy = mouseY - orbit_y;
  return degrees(atan2(dy, dx)) + 180;  
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
