PFont font;

PImage p_img;  
float curr_wheelAngle; 
float wheel_dragOffset;
int wheel_x, wheel_y, wheel_diameter, wheel_thickness;
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
  
  wheel_diameter = 500;
  wheel_thickness = 150;
  wheel_x = 500;
  wheel_y = 400;
}
void draw() { 
  update();
  background(127);
  drawWheel(wheel_x, wheel_y, wheel_diameter, wheel_thickness, curr_wheelAngle);
  drawProtractor(wheel_x, wheel_y, curr_wheelAngle);
  
  text(angleFromOrbitCentre(), 10, 40);
  text(curr_wheelAngle, 10, 80);
  text(curr_wheelAngle%360, 10, 120);
} 

void update() {
  if (overRing(wheel_x, wheel_y, wheel_diameter, wheel_diameter- wheel_thickness)) {
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
void drawWheel(float x, float y, float d, float thickness, float a) {
    pushMatrix();
    translate(x, y);
    rotate(radians(a));
    
    noFill();
    strokeCap(SQUARE);
    strokeWeight(thickness/2);

    int stroke_alpha = 125;
    if (wheel_mouseOver) { stroke_alpha = 200;}
    
    stroke(204, 102, 0, stroke_alpha);
    arc(0, 0, d, d, 0, PI/2);
    arc(0, 0, d, d, PI, TWO_PI-PI/2);
    
    stroke(102,204, 0, stroke_alpha);
    arc(0, 0, d, d, PI/2, PI);
    arc(0, 0, d, d, TWO_PI-PI/2, TWO_PI);
    
    popMatrix();   
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

boolean overRing(int x, int y, int external_diameter, int internal_diameter) {
  float disX = x - mouseX;
  float disY = y - mouseY;
  
  boolean inside_external = false;
  boolean outside_internal = false;
  
  if(sqrt(sq(disX) + sq(disY)) < external_diameter/2 ) {
    inside_external = true;
    if(sqrt(sq(disX) + sq(disY)) > internal_diameter/2 ) {
      outside_internal = true;
    }
  } 
  
  if (inside_external && outside_internal) {
    return true;
  } else {
    return false;
  }
}
