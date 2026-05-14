class Car {
  int? id;
  String brand;
  String model;
  int year;
  double price;

  Car({this.id, required this.brand, required this.model, required this.year, required this.price});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'price': price,
    };
  }

  static Car fromMap(Map<String, dynamic> map) {
    return Car(
      id: map['id'],
      brand: map['brand'],
      model: map['model'],
      year: map['year'],
      price: map['price'],
    );
  }

  @override
  String toString() {
    return 'ID: $id | $brand $model | $year год | ${price.toStringAsFixed(2)} ₽';
  }
}