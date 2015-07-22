// Syphon
import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;


SyphonServer server;
OscP5 oscP5;
NetAddress myBroadcastLocation;
float factor;

// ANIMATION
PGraphics pg;
color c = color(0);
float x = 0;
float y = 0;
float speed = 1;
float bWidth = 500;
float bHeight = 500;


void setup() {
 size(1024, 768, P3D);
 pg = createGraphics(1024, 768, P3D);
 // SYPHON SETUP
  server = new SyphonServer(this, "Processing Cube");
  // OSC SETUP
  oscP5 = new OscP5(this, 5001);
  myBroadcastLocation = new NetAddress("127.0.0.1", 5000);
  factor = 1;
}

void draw() {
  background(255);
  display();
}

void display() {
  pg.beginDraw();
  pg.fill(c);
  pg.strokeWeight(5);
  pg.stroke(204, 102, 0);
  pg.rect(x,y,bWidth,bHeight);
  pg.endDraw();
  image(pg, bWidth,bHeight,100,100); 
  image(pg, 51, 30);
  image(pg, 0, 0);
  server.sendImage(pg);
}
void background()
{
  
}

boolean sketchFullScreen() {
  return false;
}
