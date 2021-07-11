int c = 0;
int sec = 0;
color randColor = color(0,0,0);
float fontsize = 16;

void setup()
{
  size(600,600);
  frameRate(60);
  background(0);
}

void draw()
{
  noStroke();
  //change background color black to white
  if(c<255){
    c += 1;      
  }
  background(c);
  
  // change color per 1 sec
  if(sec %60 == 0){
    randColor = color(random(255),random(255), random(255));
  }
  fill(randColor);
  triangle(300, 220, 380, 380, 220, 380);
  
  //print Hello World and change font size
  PFont myFont = loadFont("TimesNewRomanPSMT-48.vlw");
  textFont(myFont);
  if(sec %60 == 0){
    fontsize = random(64);
  }
  textSize(fontsize);
  fill(0);
  text("Hello World", 200, 150);
  
  sec += 1;
}
