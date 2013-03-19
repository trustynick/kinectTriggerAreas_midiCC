
class sArea{

int areaNum;  
  
int xPos;
int yPos;
int w;
int h;
int centX;
int centY;

int channel=0;
int controlNum_1;

int value = 90;


int dBarX = centX + 10;
int dBarW = 20;

int pixCent =0;
int rDepth =0; 
int depCol =0;
int gCount =0; //# of green (triggered pixels);

boolean move = false;
boolean reSize = false;
boolean changeDepth = false;
boolean trigger = false;
boolean pTrigger = false;


int thresh = 745;
int areaDep = 20;

int closestPoint = thresh;


sArea(int _x, int _y, int _w, int _h, int _a){
  
  areaNum = _a;
  xPos = _x;
  yPos = _y;
  w = _w;
  h = _h;
  controlNum_1 = areaNum;
 // controlNum_2 = _c1+1;
  
centX =int(xPos+w/2);
centY =int(yPos+ h/2);
dBarX = centX + 10;
}


//display box, depth info and text
void drawArea(){

  if(trigger){
    strokeWeight(3);
 stroke(255,0,0);
 }
 else{
      strokeWeight(1);
  stroke(255);
 } 
   
 noFill();
  rect(xPos, yPos, w, h);
  fill(255);
 
  strokeWeight(1);
 
 
 if(dView){
   
 noFill();
  
    stroke(100,100,255);
   rect(dBarX, yPos, dBarW, areaDep);
    fill(255,100,255,150);
    rect(dBarX, yPos, dBarW, abs(thresh-closestPoint));
     
  fill(255);
   
 stroke(255);
 }
 
  stroke(255);
//  if(pixCent ! = 0)
fill(depCol);
ellipse(centX, centY, 10,10);
fill(255);

textSize(24);
text(areaNum, xPos, yPos);

if(showText){
textSize(12);
text("raw: "+ rDepth+" thresh: "+ thresh , xPos, yPos+h+12);
//text("closeP: "+ closestPoint, xPos, yPos+h+24);
}
}

void checkMove(){
  if(mouseX > xPos && mouseX < xPos + w/4 && mouseY > yPos && mouseY < yPos + h/4){
  move = true;
  }
else move = false;

if(mouseX > xPos + w*.75 && mouseX < xPos+w && mouseY > yPos + h*.75 && mouseY < yPos+h ){
reSize = true;
}
else reSize = false;

if(abs(mouseX - dBarX -dBarW/2)<dBarW/2 &&  mouseY < yPos+areaDep && mouseY> yPos+areaDep - 10){
  changeDepth = true;
}
else changeDepth = false;

}
void moveArea(){
    if(move){
  
  xPos = mouseX;
  yPos = mouseY;
    centX =int(xPos+w/2);
centY =int(yPos+ h/2);
dBarX = centX + 10;
    }
    
    if(reSize){
    w = mouseX - xPos;
    h = mouseY - yPos;
      centX =int(xPos+w/2);
centY =int(yPos+ h/2);
dBarX = centX + 10;
    
    }
    
  if(changeDepth){
  areaDep =  mouseY - yPos; 
  } 
    
}

void calibrate(){

   if(abs(mouseX - centX) < 5 && abs(mouseY - centY)<10){
       thresh = rDepth;
   }
  
  

}



void checkTrigger(int _x,int _y, PImage d, int p, int r, int t){
depCol = r;
   //if in area 
          if(_x > xPos && _x < xPos + w && _y > yPos && _y < yPos + h){
        
            
            //find centroid draw it & get depth readings
          if(_x == int(xPos+w/2) && _y == yPos+int(h/2)){
          d.pixels[p] = color(depCol,depCol, 250);
       
          pixCent = p;
          rDepth = r; 
          
          }
           
           //check for pressence within area depth threshold 
           //if within depth make it green
           if(r> thresh && r<thresh+areaDep){
             
             if(r>closestPoint){
           closestPoint=r;
           
            }
             
            depCol = int(map(r, 355, t, 0, 100));
            d.pixels[p] = color(depCol,250,depCol);
            gCount ++;
           }
         
           
          }
          
          //if we reach the end  evaluate trigger
          if(_x == w && _y == h){
            
            if(gCount > 10){
            trigger = true;
            }
          else
          trigger = false;
          
          //reset gcount for next frame && closest point
          gCount = 0;
          closestPoint = thresh;
          }
          
          
          
         if(trigger == false){
          closestPoint = thresh;
          }
          
          
          if(trigger != pTrigger){
          if(trigger == true){
          sendMessage_1(); 
          }
          if(trigger == false){
          sendMessage_2();
          } 
          pTrigger = trigger;
          
          }

}


void sendMessage_1(){

 myBus.sendControllerChange(channel, controlNum_1, 127); // Send a controllerChange
 println(areaNum+ "="+ trigger + " sent:" + channel + ", " + controlNum_1 + ", " +127 );
 

}

void sendMessage_2(){
 myBus.sendControllerChange(channel, controlNum_1, 0); // Send a controllerChange
 println(areaNum+ "="+ trigger + " sent:" + channel + ", " + controlNum_1 + ", " +0 );
 

}

}
