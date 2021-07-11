int n = 30; //node num
Point[] P = new Point[n];
ArrayList<Edge> E = new ArrayList<Edge>();
ArrayList<Tri> T = new ArrayList<Tri>();
ArrayList<Edge> Q = new ArrayList<Edge>();//stack
int ScreenSize = 900;
int M = 150;
int count = 0;
int tmp = -1;

void setup()
{
  size(900, 900);
  frameRate(60);
  initialize();
}

void draw()
{
  background(255);
  drawNode();
  drawEdge();
  
  int i = count/30;
  if(tmp < i){
    tmp = i;
    if(i<n){
      Point p = P[i];
      int t = findTriangleInsideP(p);
      makeTriangle_addStack(p, t);
      judgeIllegalEdges();
    }else{
      finalize();
    }
  }
  count++;
}

void judgeIllegalEdges() {
  while (Q.size()>0) {
    Edge e = Q.get(0);
    Q.remove(0);
    int t0=-1, t1=-1;
    for (int i=0; i<T.size(); i++) {
      //find 2 triangle
      if (T.get(i).hasEdge(e)){
        if (t0==-1){
          t0 = i;
        }else{
          t1 = i;
          break;
        }
      }
    }
    if(t1 == -1) continue;//not find 2 triangle
    FlipCheck(t0, t1, e);//check flip and add stack
  }
}

void FlipCheck(int t0, int t1, Edge e){
  Point p0;
  if((!T.get(t0).p0.isEqual(e.p0)) && (!T.get(t0).p0.isEqual(e.p1))) p0 = T.get(t0).p0;
  else if((!T.get(t0).p1.isEqual(e.p0)) && (!T.get(t0).p1.isEqual(e.p1))) p0 = T.get(t0).p1;
  else p0 = T.get(t0).p2;
  Point p1;
  if((!T.get(t1).p0.isEqual(e.p0)) && (!T.get(t1).p0.isEqual(e.p1))) p1 = T.get(t1).p0;
  else if((!T.get(t1).p1.isEqual(e.p0)) && (!T.get(t1).p1.isEqual(e.p1))) p1 = T.get(t1).p1;
  else p1 = T.get(t1).p2;
  if(T.get(t1).isPointInsideCircle(p0)){
    //flip!!
    T.add(new Tri(p0, p1, e.p0));
    T.add(new Tri(p0, p1, e.p1));
    int e_index = -1;
    for(int i=0;i<E.size();i++){
      if(E.get(i).isEqual(e)){
        e_index = i;
        break;
      }
    }
    E.remove(e_index);
    E.add(new Edge(p0, p1));
    T.remove(t0);//t0<t1
    T.remove(t1-1);//because index shift remove(t0)
    //add stack
    Q.add(new Edge(e.p0, p0));
    Q.add(new Edge(e.p0, p1));
    Q.add(new Edge(e.p1, p0));
    Q.add(new Edge(e.p1, p1));
  }
}

void makeTriangle_addStack(Point p, int t) {
  Point p0 = T.get(t).p0;
  Point p1 = T.get(t).p1;
  Point p2 = T.get(t).p2;
  Edge e0 = new Edge(p0, p);
  Edge e1 = new Edge(p1, p);
  Edge e2 = new Edge(p2, p);
  Edge e01 = new Edge(p0, p1);
  Edge e12 = new Edge(p1, p2);
  Edge e20 = new Edge(p2, p0);
  T.add(new Tri(p, p0, p1));
  T.add(new Tri(p, p1, p2));
  T.add(new Tri(p, p2, p0));
  E.add(e0);
  E.add(e1);
  E.add(e2);
  T.remove(t);
  //add edge to stack
  Q.add(e01);
  Q.add(e12);
  Q.add(e20);
}

int findTriangleInsideP(Point p) {
  for (int j=0; j<T.size(); j++) {
    //triangle (p0x, p0y),(p1x, p1y),(p2x, p2y)
    //check point (px, py)
    float p0x = T.get(j).p0.x;
    float p0y = T.get(j).p0.y;
    float p1x = T.get(j).p1.x;
    float p1y = T.get(j).p1.y;
    float p2x = T.get(j).p2.x;
    float p2y = T.get(j).p2.y;
    float px = p.x;
    float py = p.y;
    float Area = 0.5 *(-p1y*p2x + p0y*(-p1x + p2x) + p0x*(p1y - p2y) + p1x*p2y);
    float s = 1/(2*Area)*(p0y*p2x - p0x*p2y + (p2y - p0y)*px + (p0x - p2x)*py);
    float t = 1/(2*Area)*(p0x*p1y - p0y*p1x + (p0y - p1y)*px + (p1x - p0x)*py);
    if ((0<s && s<1) && (0<t && t<1)&&(0<1-s-t && 1-s-t<1)) {
      return j; //Inside Triangle
    }
  }
  return 0;//this is not called
}
// ****************  initialize and finalize  ***************************
void initialize() {
  //make first triangle node
  Point p0 = new Point(6*M, 3*M);
  Point p1 = new Point(3*M, 6*M);
  Point p2 = new Point(0, 0);
  Edge e0 = new Edge(p0, p1);
  Edge e1 = new Edge(p1, p2);
  Edge e2 = new Edge(p2, p0);
  E.add(e0);
  E.add(e1);
  E.add(e2);
  T.add(new Tri(p0, p1, p2));
  //make 30 random points
  for (int i=0; i<n; i++) {
    P[i] = new Point(random(3*M, 3*M+M), random(3*M, 3*M+M));
  }
}
//remove edge from first 3 points 
void finalize() {
  int i = 0;
  while (i<E.size()) {
    float p0x = E.get(i).p0.x;
    float p0y = E.get(i).p0.y;
    float p1x = E.get(i).p1.x;
    float p1y = E.get(i).p1.y;
    float[] X = new float[]{0, 6*M, 6*M};
    float[] Y = new float[]{0, 3*M, 3*M};
    boolean F = false;
    for (int j=0; j<3; j++) {
      float x = X[j];
      float y = Y[j];
      if ( (p0x==x && p0y==y) | (p0x==y && p0y==x) | (p1x==x && p1y==y) | (p1x==y && p1y==x)) {
        E.remove(i);
        F = true;
        break;
      }
    }
    if (F) continue;
    i++;
  }
}
// *********************  draw  ****************************************
void drawNode() {
  for (int i=0; i<P.length; i++) {
    point(P[i].x, P[i].y);
  }
}
void drawEdge() {
  for (int i=0; i<E.size(); i++) {
    line(E.get(i).p0.x, E.get(i).p0.y, E.get(i).p1.x, E.get(i).p1.y);
  }
}

// *********************  class  ****************************************
class Point {
  float x, y;
  Point(float p_x, float p_y) {
    this.x = p_x;
    this.y = p_y;
  }
  boolean isEqual(Point p){
    return (this.x==p.x)&&(this.y==p.y);
  }
}
class Edge {
  Point p0, p1;
  Edge(Point p_0, Point p_1) {
    if(p_0.x < p_1.x){
      this.p0 = p_0;
      this.p1 = p_1;
    }else{
      this.p0 = p_1;
      this.p1 = p_0;
    }   
  }
  boolean isEqual(Edge e){
    return this.p0.isEqual(e.p0)&&this.p1.isEqual(e.p1) || this.p1.isEqual(e.p0)&&this.p0.isEqual(e.p1);
  }
}
class Tri {
  Point p0, p1, p2;
  Edge e0, e1, e2;
  Circle c;
  Tri(Point p_0, Point p_1, Point p_2) {
    this.p0 = p_0;
    this.p1 = p_1;
    this.p2 = p_2;
    this.e0 = new Edge(p_0, p_1);
    this.e1 = new Edge(p_1, p_2);
    this.e2 = new Edge(p_2, p_0);
    //this.e0 = e_0;
    //this.e1 = e_1;
    //this.e2 = e_2;
    this.c = this.makeCircle(p_0, p_1, p_2);
  }
  Circle makeCircle(Point p0, Point p1, Point p2) {
    float x1 = p0.x;
    float y1 = p0.y;
    float x2 = p1.x;
    float y2 = p1.y;
    float x3 = p2.x;
    float y3 = p2.y;
    float c = 2.0 * ((x2 - x1) * (y3 - y1) - (y2 - y1) * (x3 - x1));
    //(x, y) radius r;
    float x = ((y3 - y1) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)+(y1 - y2) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1))/c;
    float y = ((x1 - x3) * (x2 * x2 - x1 * x1 + y2 * y2 - y1 * y1)+(x2 - x1) * (x3 * x3 - x1 * x1 + y3 * y3 - y1 * y1))/c;
    float r = dist(x, y, x1, y1);
    return new Circle(new Point(x, y), r);
  }
  boolean isPointInsideCircle(Point p){
    if(this.c.radius > dist(p.x, p.y, this.c.center.x, this.c.center.y)) return true;
    else return false;
  }
  boolean hasEdge(Edge e){
    return this.e0.isEqual(e) | this.e1.isEqual(e) | this.e2.isEqual(e);
  }
}
class Circle {
  Point center;
  float radius;
  Circle(Point c, float r) {
    this.center = c;
    this.radius = r;
  }
}
// *******************************************************************
