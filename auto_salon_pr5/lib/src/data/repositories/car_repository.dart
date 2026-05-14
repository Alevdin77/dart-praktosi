import 'package:auto_salon/src/domain/models/car.dart';
import 'package:auto_salon/src/data/database.dart';

class CarRepository {
  final DatabaseHelper _db;

  CarRepository(this._db);

  void create(Car car) {
    _db.db.execute(
      'INSERT INTO cars (brand, model, year, price) VALUES (?, ?, ?, ?)',
      [car.brand, car.model, car.year, car.price],
    );
  }

  List<Car> readAll() {
    var result = _db.db.select('SELECT * FROM cars');
    return result.map((row) => Car.fromMap(row)).toList();
  }

  Car? readById(int id) {
    var result = _db.db.select('SELECT * FROM cars WHERE id = ?', [id]);
    if (result.isNotEmpty) return Car.fromMap(result.first);
    return null;
  }

  void update(Car car) {
    _db.db.execute(
      'UPDATE cars SET brand = ?, model = ?, year = ?, price = ? WHERE id = ?',
      [car.brand, car.model, car.year, car.price, car.id],
    );
  }

  void delete(int id) {
    _db.db.execute('DELETE FROM cars WHERE id = ?', [id]);
  }
}