fib(int n) => match (n) {
  0 => 0;
  1 => 1;
  n => fib(n-1) + fib(n-2);
};

main() {
  print(fib(6));
}
