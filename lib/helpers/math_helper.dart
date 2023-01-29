int maxFromArr<T>(List<T> arr, int Function(T) mapper) {
  return arr
      .map((item) => mapper(item))
      .toList()
      .reduce((curr, next) => curr > next ? curr : next);
}

int minFromArr<T>(List<T> arr, int Function(T) mapper) {
  return arr
      .map((item) => mapper(item))
      .toList()
      .reduce((curr, next) => curr < next ? curr : next);
}
