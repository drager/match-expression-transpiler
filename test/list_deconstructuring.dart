match ([2, 5]) {
  [2, b] => print('x is 2, b is $b');
  [a, 5] => print('x is $a, b is 5');
  [a, a] => print('the zero and first indices are $a');
  [a, b is int] => print('a is $a, b is the integer $b');
  [a, b] => print('a is $a, b is $b');
  [a, b, ...] => print('a is $a, b is $b but the list has more than two elements');
  _ => print('the list has fewer than 2 elements');
};
