import 'package:auto_salon/src/domain/models/customer.dart';
import 'package:auto_salon/src/data/database.dart';

class CustomerRepository {
  final DatabaseHelper _db;

  CustomerRepository(this._db);

  void create(Customer customer) {
    _db.db.execute('INSERT INTO customers (name, phone) VALUES (?, ?)', [customer.name, customer.phone]);
  }

  List<Customer> readAll() {
    var result = _db.db.select('SELECT * FROM customers');
    return result.map((row) => Customer.fromMap(row)).toList();
  }

  Customer? readById(int id) {
    var result = _db.db.select('SELECT * FROM customers WHERE id = ?', [id]);
    if (result.isNotEmpty) return Customer.fromMap(result.first);
    return null;
  }

  void update(Customer customer) {
    _db.db.execute('UPDATE customers SET name = ?, phone = ? WHERE id = ?',
        [customer.name, customer.phone, customer.id]);
  }

  void delete(int id) {
    _db.db.execute('DELETE FROM customers WHERE id = ?', [id]);
  }
}