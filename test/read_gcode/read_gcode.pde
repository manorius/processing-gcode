// Serial 3D printer controls
import processing.serial.*;

// 3DPrinter
Serial myPort;
String lines[];
ArrayList<String> cLines = new ArrayList<String>();
int gcodePointer = 0;

void setup() {
  // GRAPHICS SETUP
 size(1024, 768, P3D);
 //pg = createGraphics(1024, 768, P3D);
 // 3D PRINTER SETUP
 //initialize the serial port to talk to the printer
 println(Serial.list());
  // MAKE SURE YOU ARE USING THE RIGHT SERIAL PORT AND BAUTRATE
  myPort=new Serial(this, Serial.list()[5], 115200);
  // SET 3D PRINTER
lines = loadStrings("small_pyramid.gcode");
println("there are " + lines.length + " lines");

// REMOVE SEMICOLONS FORM GCODE
for (int i = 0 ; i < lines.length; i++) {
  // CHECK IF IT'S NOT AN EMPTY LINE
  String newString = lines[i];
  if(newString.equals("")!=true)
  {
    // CHECK IF THERE IS A semicolon sign anywhere in the string
    // IF YES FIND IT AND REMOVE THE REST OF THE STRING
    //if(newString.charAt(0)==';') print("COMMENT");
    // INDEX OF ";"
    int indexOfSemi = newString.indexOf(";");
    if(indexOfSemi != -1 && indexOfSemi!=0){
     String modifiedString = newString.substring(0,indexOfSemi); 
     cLines.add(modifiedString);
     //println(modifiedString);
     
    }
    else if(indexOfSemi == -1)
    {
      cLines.add(newString);
      //println(newString);
    }
  }
 // print(lines[i].charAt(0)==null);
 // println(lines[i]);
  
}
//CHECK NEW ARRAY
for (int n = 0 ; n < cLines.size(); n++) {
println(cLines.get(n));
}

// SEND INITIAL COMMAND
      myPort.write(cLines.get(gcodePointer)+"\r\n");
      // UPDATE POINTER
      gcodePointer++;
}


String rS = "";
char   currentC;

void draw() {
  
  // RETURN CURRENT LOCATION
  myPort.write("M114\r\n");
  
  while (myPort.available() > 0) {
    int inByte = myPort.read();
    print(char(inByte));
    currentC = char(inByte);
    //print(currentC);
    if(currentC==char('o'))
    {
      rS+=currentC;
    }
    else if(currentC==char('k') && gcodePointer!=cLines.size())
    {
      rS+=currentC;
      //println(rS);
      //println(cLines.get(gcodePointer));
      myPort.write(cLines.get(gcodePointer)+"\r\n");
      // UPDATE POINTER
      gcodePointer++;
      // AND CLEAR THE STRING
      rS=""; 
    }
    else
    {
      // EMPTY STRING
     rS=""; 
    }
  }
}

int l = 0;
void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      println("up");
      l+=5;
       myPort.write("G1 Z"+l+"\r\n");
    }
    // MOVE HOTEND
    println(l);
    
  }
}
