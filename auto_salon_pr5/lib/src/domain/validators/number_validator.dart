bool isPriceValid(double price) {
  return price > 0;
}

bool isYearValid(int year) {
  int currentYear = DateTime.now().year;
  return year >= 1900 && year <= currentYear;
}