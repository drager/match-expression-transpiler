main() {
  match (90) {
    x is int => print('x is an integer'); // As 90 is an int this case would match and the other would be ignored
    x is num => print('x is another type of number');
    90 => print('x is equal to 90');
  };
}
