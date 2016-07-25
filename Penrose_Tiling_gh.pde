final float PHI = (1 + sqrt(5))/ 2; //golden ratio

//temp manual input setup
int w = 1000; //width
int h = 1000; //height

int backgroundColor = color(200);
int outlineColor = 0;
int fillColor0 = color(255,0,0);
int fillColor1 = color(0,0,255);

int outlineWeight = 2; //high outline weight can lead to ugly edges
int loops = 7; //times the triangles get deflated -- try not to exceed 10 unless your computer can handle it

boolean drawFill = true; 
boolean drawOutline = true;
boolean save = true;

String filename = "penrose.png";

void setup()
{
  ArrayList<Triangle> triangles = new ArrayList<Triangle>();
  background(backgroundColor);
  

  //add various triangles to the arraylist for a starting "seed" for the tiling. I recommend having only one example uncommented at a time.
  
  /*//sample "fat" 108 degree triangle seed
  triangles.add(iso(new Coordinate(500,0), 108, 350)); */
  
  //sample "skinny" 36 degree triangle seed
  triangles.add(iso(new Coordinate(500,0), 36, 1000));
  
  //sample "wheel" of skinny triangles -- exhibits a lot of symmetry
  /*Coordinate origin = new Coordinate(1000,1000);
  Coordinate p = new Coordinate(1000,2000);
  for(int i=0;i<10;i++)
  {
    Coordinate temp = rotate_point(origin,36,p);
    if(i%2 == 0)
    {
      triangles.add(new Triangle(origin,p,temp,0));
    }
    else
    {
      triangles.add(new Triangle(origin,temp,p,0));
    }
    p = temp;
  }  */
  
  
  run(triangles);

}



void settings()
{
  size(w,h);
}

public class Coordinate
{
  float x;
  float y;
  
  Coordinate(float a, float b)
  {
    x = a;
    y = b;
  }
  
}

public class Triangle
{
  Coordinate a;
  Coordinate b;
  Coordinate c;
  int type; //0 for 36 degree (skinny), 1 for 108 degree (fat)
  
  Triangle(Coordinate pointA, Coordinate pointB, Coordinate pointC, int t)
  {
    a = pointA;
    b = pointB;
    c = pointC;
    type = t;
  }
  
  Triangle(Coordinate pointA, Coordinate pointB, Coordinate pointC)
  {
    a = pointA;
    b = pointB;
    c = pointC;
  }
  
  void drawTriangle()
  {
    noStroke();
    if(type == 0)
    {
      fill(fillColor0);
      stroke(fillColor0);
    }
    else if(type == 1)
    {
      fill(fillColor1);
      stroke(fillColor1);
    }
    else
    {
      fill(0);
      stroke(0);
    }
    strokeWeight(1);
    triangle(a.x,a.y,b.x,b.y,c.x,c.y);
    
    /*//acount for any errors due to roundoffs and draw these lines
    drawLine(a,b);
    drawLine(a,c);
    drawLine(b,c); */
  }
  
  void drawOutline()
  {
    stroke(outlineColor);
    strokeWeight(outlineWeight);
    drawLine(a,b);
    drawLine(a,c);
    }
  
}

void drawLine(Coordinate a, Coordinate b)
{
  line(a.x,a.y,b.x,b.y);
}

Coordinate sum(Coordinate a, Coordinate b)
{
  return new Coordinate(a.x+b.x,a.y+b.y);
}

Coordinate diff(Coordinate a, Coordinate b)
{
  return new Coordinate(a.x-b.x,a.y-b.y);
}

Coordinate divide(Coordinate a, float b) // divides both values in coordinate by b
{
  return new Coordinate(a.x/b,a.y/b);
}

Triangle iso(Coordinate a, int degree, float h) // creates isosceles triangle from point, angle at point and height (h)
{
  float rad = degree*PI/180;
  float dx = tan(rad/2)*h;
  Coordinate b = new Coordinate(a.x-dx,a.y+h);
  Coordinate c = new Coordinate(a.x+dx,a.y+h);
  
  if(degree == 36)
  {
    return new Triangle(a,b,c,0); //0 for 36 degree
  }
  if(degree == 108)
  {
    return new Triangle(a,b,c,1); //1 for 108 degree
  }
  return new Triangle(a,b,c);
}

float dist(Coordinate a, Coordinate b)
{
  return sqrt(pow((a.x-b.x),2) + pow((a.y-b.y),2));
}

Coordinate rotate_point(Coordinate origin, float angle, Coordinate p) //Credit to Nils Pipenbrinck on SO
{
  float rad = angle*PI/180;
  float px = p.x;
  float py = p.y;
  
  float s = sin(rad);
  float c = cos(rad);

  // translate point back to origin:
  px -= origin.x;
  py -= origin.y;

  // rotate point
  float xnew = px * c - py * s;
  float ynew = px * s + py * c;

  // translate point back:
  px = xnew + origin.x;
  py = ynew + origin.y;
  return new Coordinate(px,py);
}

ArrayList<Triangle> deflate(ArrayList<Triangle> triangles)
{
  ArrayList<Triangle> newTriangles = new ArrayList<Triangle>();
  for(Triangle triangle : triangles)
  {
    if(triangle.type == 0)
    {
      Coordinate P = sum(triangle.a,divide(diff(triangle.b,triangle.a),PHI)); //A + ((B - A)/PHI) -- add A to the difference of B and A divided by the golden ratio
      newTriangles.add(new Triangle(triangle.c,P,triangle.b,0)); //0 for skinny
      newTriangles.add(new Triangle(P,triangle.c,triangle.a,1)); //1 for fat
    }
    else
    {
      Coordinate Q = sum(triangle.b,divide(diff(triangle.a,triangle.b),PHI)); //B + ((A - B)/PHI) -- similar to Coordinate P's derivation
      Coordinate R = sum(triangle.b,divide(diff(triangle.c,triangle.b),PHI)); //B + ((C - B)/PHI)
      newTriangles.add(new Triangle(R,triangle.c,triangle.a,1));
      newTriangles.add(new Triangle(Q,R,triangle.b,1));
      newTriangles.add(new Triangle(R,Q,triangle.a,0));
    }
  }
  return newTriangles;
}

void run(ArrayList<Triangle> triangles)
{
    for(int i=0;i<loops;i++)
  {
    triangles = deflate(triangles);
  }
  
  for(Triangle t : triangles)
  {
    if(drawFill)
    {
    t.drawTriangle();
    }
    if(drawOutline)
    {
    t.drawOutline();
    }
  }
  
  if(save)
  {
  save(filename);
  }
}