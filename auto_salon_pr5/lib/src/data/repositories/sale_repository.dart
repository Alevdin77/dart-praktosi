import 'package:auto_salon/src/domain/models/sale.dart';
import 'package:auto_salon/src/data/database.dart';

class SaleRepository {
  final DatabaseHelper _db;

  SaleRepository(this._db);

  void create(Sale sale) {
    _db.db.execute(
      'INSERT INTO sales (carId, customerId, saleDate, finalPrice) VALUES (?, ?, ?, ?)',
      [sale.carId, sale.customerId, sale.saleDate.toIso8601String(), sale.finalPrice],
    );
  }

  List<Sale> readAll() {
    var result = _db.db.select('SELECT * FROM sales');
    return result.map((row) => Sale.fromMap(row)).toList();
  }

  void delete(int id) {
    _db.db.execute('DELETE FROM sales WHERE id = ?', [id]);
  }
}