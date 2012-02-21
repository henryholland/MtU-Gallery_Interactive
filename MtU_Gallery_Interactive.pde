import processing.opengl.*;

PFont font;

PImage p_img;  

float curr_wheelAngle, prev_wheelAngle; 
float wheel_acceleration, wheel_damping, wheel_acceleration_max;
float wheel_dragOffset;
int wheel_x, wheel_y, wheel_diameter, wheel_thickness;
boolean wheel_mouseOver, wheel_dragging;


//whatever

void setup() {
  size(1024, 768);
  
  frameRate(30);
  smooth();
  
  font = loadFont("Serif-48.vlw");
  textFont(font, 36);
  
  p_img = loadImage("protractor.png");
 
  curr_wheelAngle = 0;
  wheel_mouseOver = false;
  wheel_damping = 0.9;
  wheel_acceleration = 0;
  wheel_acceleration_max = 10;
  wheel_diameter = 500;
  wheel_thickness = 350;
  wheel_x = 500;
  wheel_y = 400;
}

void draw() { 
  
  updateWheel();
  background(127);
 
//  drawWheel(wheel_x, wheel_y, wheel_diameter, wheel_thickness, curr_wheelAngle);
//  rotateX(PI/6);
//  rotateY(PI/3);
  drawWheel(wheel_x, wheel_y, wheel_diameter, wheel_thickness, curr_wheelAngle);
  //drawProtractor(wheel_x, wheel_y, curr_wheelAngle);
  
  float wheel_value;
  
  if (curr_wheelAngle <= 0) {
    wheel_value = 0 - (curr_wheelAngle%360);
  } else {
    wheel_value = 360-(curr_wheelAngle%360);
  }
  
  text(wheel_acceleration, 10, 80);
  text(wheel_value, 10, 120);
} 

void updateWheel() {
  if (overRing(wheel_x, wheel_y, wheel_diameter, wheel_diameter- wheel_thickness)) {
     wheel_mouseOver = true;
  } else {
     wheel_mouseOver = false;
  }
  if (wheel_dragging) {
    curr_wheelAngle = (angleFromOrbitCentre() - wheel_dragOffset)%360;
    wheel_acceleration = (((curr_wheelAngle - prev_wheelAngle) + wheel_acceleration)/2) % wheel_acceleration_max;
    prev_wheelAngle = curr_wheelAngle;
  } else {
    curr_wheelAngle = (curr_wheelAngle+wheel_acceleration)%360;
    if (Math.pow(wheel_acceleration, 2) > .0001 ) {
      wheel_acceleration *= wheel_damping;
    } else{
      wheel_acceleration = 0;
    }
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
    
    float adjusted_diameter = d-(thickness/2);
    
    stroke(204, 102, 0, stroke_alpha);
    arc(0, 0, adjusted_diameter, adjusted_diameter, 0, PI/2);
    arc(0, 0, adjusted_diameter, adjusted_diameter, PI, TWO_PI-PI/2);
    
    stroke(102,204, 0, stroke_alpha);
    arc(0, 0, adjusted_diameter, adjusted_diameter, PI/2, PI);
    arc(0, 0, adjusted_diameter, adjusted_diameter, TWO_PI-PI/2, TWO_PI);
    
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
