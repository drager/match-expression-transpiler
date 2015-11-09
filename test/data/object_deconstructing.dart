class Point {
  var x;
  var y;

  Point(x, y) {
    this.x = x;
    this.y = y;
  }
}

main() {
  return match (new Point(2, 5)) {
    Point {x: 2, y} => print('x is 2, y is $y');
    Point {x, y: 5} => print('x is $x, y is 5');
    Point {x, y: x} => print('both x and y is $x');
    Point {x, y} => print('x is $x, y is $y);
  };

}
