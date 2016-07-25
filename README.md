# Penrose Tiling Program

This is a simple program to generate Penrose tilings. A GUI is in progress but is incomplete. It will be added soon.

I give almost all credit to [this blog](http://preshing.com/20110831/penrose-tiling-explained/) for explaining the algorithm to me (as well as providing the neat "wheel" example).

#Instructions

Set variables to your liking and add "seed" (think an initial value that the generator generates from) triangles to the arraylist (triangles.add(triangle);). After doing so, all you need to do is run the program.

# Variables:

## integers:

colors may be created using the color(r,g,b,alpha) function as well

w: width of the sketch
h: height of the sketch
backgroundColor: color of the background
outlineColor: color of the outline
fillColor0: color of the "skinny" (36 degree) triangle
fillColor1: color of the "fat" (108) degree triangle
outlineWeight: weight of the outline -- high outline weight can lead to ugly edges
loops: number of times deflated -- try not to exceed 10 unless you think your computer can handle it (deflation increases triangle count exponentially by the golden ratio, so bear that in mind. 10 loops will take maybe 5-30 seconds on my computer depending on resolution)

## booleans:

drawFill: draw the fill if true
drawOutline: draw the outline if true
save: save if true

## Strings:

filename: file name to save to

# Functions/Object Initalizers:

## Coordinate c = new Coordinate(int x, int y):

Initialize c to be a coordinate with location at (x,y).

## Triangle tri = new Triangle(Cooridnate a, Coordinate b, Coordinate c, int t):

Initialize tri to be a triangle made from coordinates a, b, and c. Int t is optional and is used to specify what kind of triangle tri is (0 for skinny, 1 for fat).

## iso(Coordinate a, int degree, float h):

Returns an isosceles triangle. You really only will want either skinny (36) or fat (108) ones, but it will accept other. h is the height of the triangle, if it isn't clear. The variable degree is in degrees.

## rotate_point(Coordinate origin, float angle, Coordinate p):

Returns a new point rotated angle degrees about the origin point. I used this to create the "wheel" of skinny triangles example.

# Planned features

* Add GUI (using G4P, likely)

* Allow iso() to create triangles in any rotation, not just 0/180 degrees.
