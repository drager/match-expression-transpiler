main() {
  var message = match (new DateTime.now().weekday) {
    1 | 2 | 3 | 4 | 5 => 'This is a weekday';
    6 | 7 => 'This is a weekend day';
    _ => 'Not a legal day';
  };

  print(message);
}
