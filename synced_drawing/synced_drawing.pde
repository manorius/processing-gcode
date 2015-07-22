// Syphon
import codeanticode.syphon.*;
import oscP5.*;
import netP5.*;
// Serial 3D printer controls
import processing.serial.*;
import controlP5.*;
import java.awt.event.KeyEvent;


SyphonServer server;
OscP5 oscP5;
NetAddress myBroadcastLocation;
float factor;

// ANIMATION
PGraphics pg;
color c = color(0);
float x = 12;
float y = 0;
float speed = 1;
float bWidth = 500;
float bHeight = 500;
float[] hotXY= new float[2];
float[] pointerXY= new float[2];

// 3DPrinter
Serial myPort;


void setup() {
  // GRAPHICS SETUP
 size(1024, 768, P3D);
 pg = createGraphics(1024, 768, P3D);
 // 3D PRINTER SETUP
 //initialize the serial port to talk to the printer
  println(Serial.list());
  // MAKE SURE YOU ARE USING THE RIGHT SERIAL PORT AND BAUTRATE
  myPort=new Serial(this, Serial.list()[5], 115200);
  // SET 3D PRINTER
   myPort.write("G28 X0 Y0 Z0\r\n");
   myPort.write("G92 E0\r\n");
   myPort.write("G1 Y0 Z3\r\n");
   myPort.write("G1 Y150\r\n");
   myPort.write("G1 X0\r\n");
   myPort.write("G1 X150\r\n");
   hotXY[0] = 150;
   hotXY[1] = 150;
   pointerXY[0] = 500;
   pointerXY[1] = 500;
 // SYPHON SETUP
  server = new SyphonServer(this, "Processing Cube");
  // OSC SETUP
  oscP5 = new OscP5(this, 5001);
  myBroadcastLocation = new NetAddress("127.0.0.1", 5000);
  factor = 1;
}

void draw() {
  
  display();
}

void display() {
  pg.beginDraw();
  background(0);
  drawingBackground();
  drawingBed(pointerXY[0]);
  drawLine();
  pg.endDraw();
  image(pg,0,0); 
  server.sendImage(pg);
}
void drawingBackground()
{
  pg.fill(0);
  pg.strokeWeight(1);
  pg.stroke(255, 0, 0);
  pg.rect(x,y,bWidth*2,bHeight);
}

void drawingBed(float xLoc)
{
  
  pg.fill(255);
  pg.rect(xLoc,y,bWidth,bHeight);
  
}

void moveHotEnd()
{
  myPort.write("G1 X"+hotXY[0]+" Y"+hotXY[1]+"\r\n");
  println("move");
}

void drawLine()
{
  pg.fill(0,0);
  pg.strokeWeight(2.5);
  pg.stroke(255, 0, 0);
 pg.ellipse(x + bWidth, pointerXY[1], 60, 60); 
 pg.strokeWeight(0);
 pg.fill(255,0,0);
  pg.rect(x + bWidth-30,pointerXY[1]-2.5,60,5);
  pg.rect(x + bWidth-2.5,pointerXY[1]-30,5,60);
  
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      println("up");
      hotXY[1] =(hotXY[1]>=0 && hotXY[1]<150)? hotXY[1]+1:hotXY[1];
    } else if (keyCode == DOWN) {
      println("down");
      hotXY[1] =(hotXY[1]>0 && hotXY[1]<=150)? hotXY[1]-1:hotXY[1];
    } 
    if (keyCode == LEFT) {
      println("left");
      hotXY[0] =(hotXY[0]>=0 && hotXY[0]<150)? hotXY[0]+1:hotXY[0];
    } else if (keyCode == RIGHT) {
      println("right");
      hotXY[0] =(hotXY[0]>0 && hotXY[0]<=150)? hotXY[0]-1:hotXY[0];
    } 
    
    // UPDATE POINTER
    pointerXY[0] = map(hotXY[0],0,150,x+bWidth,x);
    pointerXY[1] = map(hotXY[1],0,150,bHeight,y);
    
    // MOVE HOTEND
    println(hotXY[0]+" - "+hotXY[1]);
    moveHotEnd();
  }
}

boolean sketchFullScreen() {
  return false;
}
