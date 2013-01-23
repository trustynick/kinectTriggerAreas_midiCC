// Daniel Shiffman
// Tracking the average location beyond a given depth threshold
// Thanks to Dan O'Sullivan
// http://www.shiffman.net
// https://github.com/shiffman/libfreenect/tree/master/wrappers/java/processing

import org.openkinect.*;
import org.openkinect.processing.*;
import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus


// Showing how we can farm all the kinect stuff out to a separate class
KinectTracker tracker;
// Kinect Library object
Kinect kinect;
//sArea area1;

ArrayList areas;
int areaTot =0;

boolean dView = false;
boolean showText = true;
boolean keyShift;

void setup() {
  size(640,520);
  kinect = new Kinect(this);
  tracker = new KinectTracker();
 // area1 = new sArea(200,200,50,50);
  
  loadData();
  
  areas = new ArrayList();
  
  //                   Parent In Out
  //                     |    |  |
  myBus = new MidiBus(this, 0, 0); // Create a new MidiBus using the device index to select the Midi input and output devices respectively.

  
  
}

void draw() {
  background(255);

  // Run the tracking analysis
  tracker.track();
  // Show the image
  tracker.display();

 

  // Display some info
  int t = tracker.getThreshold();
  fill(0);
  textSize(12);
 // text("threshold: " + t + "    " +  "framerate: " + (int)frameRate + "    " + "UP increase threshold, DOWN decrease threshold  " + "areas = " + areas.size(),10,500);


//display our areas
if(areas.size() != 0){
for(int i = areas.size()-1; i>=0; i--){
sArea nArea = (sArea) areas.get(i);
  nArea.drawArea();
}
}
}





void keyReleased() {


   if (key == CODED) {
     if (keyCode == CONTROL){
  keyShift = false;
  // println("keyShift =" +keyShift);
  }
}
  
}

void keyPressed() {
 
  
  if(key == 's' || key == 'S'){
  
 saveData();
  }
  
  
  
// if(int(key)-48>=0 && int(key)-48 <10){ 
 int pressed = int(key)-48;
 
  //println("key ="+ pressed);
// }
  
  int t = tracker.getThreshold();
  if (key == CODED) {
    if (keyCode == UP) {
      t+=5;
      tracker.setThreshold(t);
    } 
    else if (keyCode == DOWN) {
      t-=5;
      tracker.setThreshold(t);
    }
  
 if (keyCode == CONTROL){
  keyShift = true;
  // println("keyShift =" +keyShift);
  
  }
    
  }
  
  if(key == 'a' || key =='A'){
    areas.add(new sArea(mouseX, mouseY, 50,50, areaTot ));
  areaTot = areas.size();  
  }
  
  if(key == 'd' || key == 'D'){
  dView = !dView;
  
  }
  
  if(key == 't' || key == 'T'){
  showText = ! showText;
  }
  
for(int i = areas.size()-1; i>=0; i--){
 
  
 sArea nArea = (sArea) areas.get(i); 
  if( int(pressed) == i){
  
    println("trigger ");
      
  nArea.sendMessage_1();
    

}
}
}

void stop() {
  tracker.quit();
  super.stop();
}


void mousePressed(){
  if(areas.size() != 0){
for(int i = areas.size()-1; i>=0; i--){
  sArea nArea = (sArea) areas.get(i);
  nArea.checkMove();
  nArea.calibrate();
  
}}
}

void mouseDragged(){
  
 if(areas.size() != 0){
for(int i = areas.size()-1; i>=0; i--){  
   sArea nArea = (sArea) areas.get(i);
nArea.moveArea();
}
}
}

//save data to txt file
void saveData() {
  if(areas.size()!= 0){
  
  // For each area make one String to be saved
  String[] data = new String[areas.size()];
  
  for (int i = 0; i < areas.size(); i++ ) {
    sArea nArea = (sArea) areas.get(i);
    
    // Concatenate areas variables
    //data[i] = bubbles[i].r + " , " + bubbles[i].g + " , " + bubbles[i].diameter;
    
    data [i] = nArea.xPos + " , " + nArea.yPos+ " , " + nArea.w + " , " + nArea.h + " , " + nArea.areaNum;
    
    println("saved # "+nArea.areaNum);
    
  }
  
  // Save to File
  // The same file is overwritten by adding the data folder path to saveStrings().
  saveStrings("data/kinnect_trigger_areas" + "_" + year() +"_" + month() + "_" + day() + "_" + hour() + "_" + minute() , data);

  }
}

public  void loadData(){
  
  // we'll have a look in the data folder
java.io.File folder = new java.io.File(dataPath(""));

// let's set a filter (which returns true if file's extension is .txt)
java.io.FilenameFilter txtFilter = new java.io.FilenameFilter() {
  boolean accept(File dir, String name) {
    return name.toLowerCase().endsWith(".txt");
  }
};

// get and display the number of jpg files
println(filenames.length + " jpg files in specified directory");
 
// display the filenames
for (int i = 0; i < filenames.length; i++) {
  println(filenames[i]);
}


/*
// list the files in the data folder, passing the filter as parameter
String[] filenames = folder.list(txtFilter);


// Load text file as an array of Strings
  String[] data = loadStrings("data.txt");
  
  // The size of the array of Bubble objects is determined by the total number of lines in the text file.
  bubbles = new Bubble[data.length]; 
  for (int i = 0; i < bubbles.length; i ++ ) {
    // Each line is split into an array of floating point numbers.
    float[] values = float(split(data[i], "," )); 
    // The values in the array are passed into the Bubble class constructor.
    bubbles[i] = new Bubble(values[0],values[1],values[2]); 
    */
  }

