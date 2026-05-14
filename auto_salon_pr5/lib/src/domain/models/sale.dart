class Sale {
  int? id;
  int carId;
  int customerId;
  DateTime saleDate;
  double finalPrice;

  Sale({this.id, required this.carId, required this.customerId, required this.saleDate, required this.finalPrice});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'carId': carId,
      'customerId': customerId,
      'saleDate': saleDate.toIso8601String(),
      'finalPrice': finalPrice,
    };
  }

  static Sale fromMap(Map<String, dynamic> map) {
    return Sale(
      id: map['id'],
      carId: map['carId'],
      customerId: map['customerId'],
      saleDate: DateTime.parse(map['saleDate']),
      finalPrice: map['finalPrice'],
    );
  }

  @override
  String toString() {
    return 'ID продажи: $id | Машина ID: $carId | Покупатель ID: $customerId | Дата: ${saleDate.toLocal().toString().split(' ')[0]} | Цена: ${finalPrice.toStringAsFixed(2)} ₽';
  }
}