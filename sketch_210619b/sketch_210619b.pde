boolean pressedflg = false;
int sec = 0;
color randColor = color(0,0,0);
float size = 1;

void setup()
{
  size(600,600);
  frameRate(100);
}

void draw()
{
  //change color
  if(sec %60 == 0){
    randColor = color(random(255),random(255), random(255));
  }
  sec++;
  
  //print cercle
  if(pressedflg){
    fill(randColor);
    ellipse(100,100,mouseX*size,mouseY*size);
  }
  
  //clear screen and change size
  if(!pressedflg){
    size = random(2);
    background(255);
  }
}

void mousePressed()  
{
  pressedflg = true;
}

void mouseReleased()
{
  pressedflg = false;
}
