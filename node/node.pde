PFont Font1;
PFont Font2;//bold
boolean pressedflg = false;
Node[] M = new Node[30];
boolean[][] Edge = new boolean[30][30];
int MoveNodeIndex = -1;

//Node Class
class Node {
  int id;
  float x, y, r;
  int child_id;
  int parent_id;
  Node(int id_, float x_, float y_, float r_) {
    this.id = id_;
    this.x = x_;
    this.y = y_;
    this.r = r_;
  }
}

void setup()
{
  size(600, 600);
  frameRate(60);
  Font1 = createFont("Arial", 16);
  Font2 = createFont("Arial Bold", 20);
  //inicialize Node
  for(int i=0; i<30; i++){
    //float w = random(30, 50);
    float w = 50;
    M[i] = new Node(i+1, random(600), random(600),w);
    DrawNode(M[i]);
  }
  for(int i=0; i<30; i++){
    int k = int(random(i, 29));
    Edge[i][k] = true;
  }
}

void draw()
{
  background(255);
  //dwaw Node and Edge
  for(int i=0; i<30; i++){
    for(int j=i; j<30; j++){
      if(Edge[i][j]){
        DrawEdge(M[i], M[j]);
      }
    }
  }
  for(int i=0; i<30; i++){
    DrawNode(M[i]);
  }
  //Move Node
  if(pressedflg && MoveNodeIndex != -1){
    moveNode();
  }
}

//Draw Node function
void DrawNode(Node node) {
  color c = color(255,255,255);
  fill(c);
  ellipse(node.x, node.y, node.r, node.r);
  // change color and font
  textFont(Font1, 16);
  c = color(0,0,0);
  if(node.id %10 == 0){
    c = color(255,0,0);
    textFont(Font2, 20);
  }else if(node.id%11 == 0){
    c = color(0,0,255);
    textFont(Font2, 20);
  }
  fill(c);
  textSize(16);
  text(node.id, node.x-8, node.y);
}
void DrawEdge(Node node1, Node node2) {
  line(node1.x, node1.y, node2.x, node2.y);
}

//move node by mouse
void moveNode()
{
  M[MoveNodeIndex].x = mouseX;
  M[MoveNodeIndex].y = mouseY;
}
void mousePressed()  
{
  pressedflg = true;
  float x = mouseX;
  float y = mouseY;
  for(int i=0; i<30; i++){
    float x1 = (M[i].x - x)*(M[i].x - x);
    float y1 = (M[i].y - y)*(M[i].y - y);
    if(x1 + y1 <= M[i].r*M[i].r){
      MoveNodeIndex = i;
      return;
    }
  }
  //mouse is not on Node
  MoveNodeIndex = -1;
}

void mouseReleased()
{
  pressedflg = false;
}
