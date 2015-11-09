enum Fruit {
  apple, banana
}

var x = Fruit.banana;

var name = match (x) {
  Fruit.apple  => 'apple';
  Fruit.banana => 'banana';
};

main() {
  print(name);
}
