import 'dart:io';
import 'package:sqlite3/sqlite3.dart';
import 'package:path/path.dart' as path;

// Модели
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

class Customer {
  int? id;
  String name;
  String phone;

  Customer({this.id, required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name, 'phone': phone};
  }

  static Customer fromMap(Map<String, dynamic> map) {
    return Customer(id: map['id'], name: map['name'], phone: map['phone']);
  }

  @override
  String toString() {
    return 'ID: $id | $name | тел: $phone';
  }
}

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

// Бд
class DatabaseHelper {
  static DatabaseHelper? _instance;
  Database _db;

  DatabaseHelper._internal(this._db);

  static Future<DatabaseHelper> init() async {
    if (_instance != null) return _instance!;
    String homeDir = Platform.environment['HOME'] ?? '.';
    String dbDir = '$homeDir/.local/share/auto_salon';
    await Directory(dbDir).create(recursive: true);
    String dbPath = path.join(dbDir, 'auto_salon.db');
    var db = sqlite3.open(dbPath);
    _instance = DatabaseHelper._internal(db);
    await _instance!._createTables();
    return _instance!;
  }

  Future<void> _createTables() async {
    _db.execute('''
      CREATE TABLE IF NOT EXISTS cars(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        brand TEXT NOT NULL,
        model TEXT NOT NULL,
        year INTEGER NOT NULL,
        price REAL NOT NULL
      )
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS customers(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        phone TEXT NOT NULL
      )
    ''');
    _db.execute('''
      CREATE TABLE IF NOT EXISTS sales(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        carId INTEGER NOT NULL,
        customerId INTEGER NOT NULL,
        saleDate TEXT NOT NULL,
        finalPrice REAL NOT NULL,
        FOREIGN KEY(carId) REFERENCES cars(id),
        FOREIGN KEY(customerId) REFERENCES customers(id)
      )
    ''');
  }

  // Машины
  void insertCar(Car car) {
    _db.execute(
      'INSERT INTO cars (brand, model, year, price) VALUES (?, ?, ?, ?)',
      [car.brand, car.model, car.year, car.price],
    );
  }

  List<Car> getCars() {
    ResultSet result = _db.select('SELECT * FROM cars');
    return result.map((row) => Car.fromMap(row)).toList();
  }

  Car? getCarById(int id) {
    ResultSet result = _db.select('SELECT * FROM cars WHERE id = ?', [id]);
    if (result.isNotEmpty) return Car.fromMap(result.first);
    return null;
  }

  void updateCar(Car car) {
    _db.execute(
      'UPDATE cars SET brand = ?, model = ?, year = ?, price = ? WHERE id = ?',
      [car.brand, car.model, car.year, car.price, car.id],
    );
  }

  void deleteCar(int id) {
    _db.execute('DELETE FROM cars WHERE id = ?', [id]);
  }

  // Покупатели
  void insertCustomer(Customer customer) {
    _db.execute('INSERT INTO customers (name, phone) VALUES (?, ?)', [customer.name, customer.phone]);
  }

  List<Customer> getCustomers() {
    ResultSet result = _db.select('SELECT * FROM customers');
    return result.map((row) => Customer.fromMap(row)).toList();
  }

  Customer? getCustomerById(int id) {
    ResultSet result = _db.select('SELECT * FROM customers WHERE id = ?', [id]);
    if (result.isNotEmpty) return Customer.fromMap(result.first);
    return null;
  }

  void updateCustomer(Customer customer) {
    _db.execute('UPDATE customers SET name = ?, phone = ? WHERE id = ?', [customer.name, customer.phone, customer.id]);
  }

  void deleteCustomer(int id) {
    _db.execute('DELETE FROM customers WHERE id = ?', [id]);
  }

  // Продажи
  void insertSale(Sale sale) {
    _db.execute(
      'INSERT INTO sales (carId, customerId, saleDate, finalPrice) VALUES (?, ?, ?, ?)',
      [sale.carId, sale.customerId, sale.saleDate.toIso8601String(), sale.finalPrice],
    );
  }

  List<Sale> getSales() {
    ResultSet result = _db.select('SELECT * FROM sales');
    return result.map((row) => Sale.fromMap(row)).toList();
  }

  void deleteSale(int id) {
    _db.execute('DELETE FROM sales WHERE id = ?', [id]);
  }

  void close() {
    _db.dispose();
  }
}

// Валидация
bool isNotEmpty(String text) {
  return text.trim().isNotEmpty;
}

bool isPriceValid(double price) {
  return price > 0;
}

bool isYearValid(int year) {
  int currentYear = DateTime.now().year;
  return year >= 1900 && year <= currentYear;
}

// Ввод
String askString(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    if (input != null && isNotEmpty(input)) return input.trim();
    print('Ошибка: поле не может быть пустым');
  }
}

int askInt(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    if (input != null) {
      int? value = int.tryParse(input);
      if (value != null) return value;
    }
    print('Ошибка: введите целое число');
  }
}

double askDouble(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    if (input != null) {
      double? value = double.tryParse(input);
      if (value != null) return value;
    }
    print('Ошибка: введите число');
  }
}

DateTime askDate(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    if (input != null) {
      DateTime? date = DateTime.tryParse(input);
      if (date != null) return date;
    }
    print('Ошибка: введите дату в формате гггг-мм-дд');
  }
}

// главное меню

void main() async {
  DatabaseHelper db = await DatabaseHelper.init();

  while (true) {
    print('Автосалон');
    print('1. Добавить машину');
    print('2. Показать все машины');
    print('3. Добавить покупателя');
    print('4. Показать всех покупателей');
    print('5. Оформить продажу');
    print('6. Показать все продажи');
    print('7. Показать всё из бд');
    print('8. Удалить машину');
    print('9. Удалить покупателя');
    print('0. Выход');
    stdout.write('Выберите действие: ');

    String? choice = stdin.readLineSync();
    print('');

    switch (choice) {
      case '1':
        String brand = askString('Марка: ');
        String model = askString('Модель: ');
        int year = askInt('Год: ');
        if (!isYearValid(year)) {
          print('Ошибка: год должен быть от 1900 до ${DateTime.now().year}');
          break;
        }
        double price = askDouble('Цена: ');
        if (!isPriceValid(price)) {
          print('Ошибка: цена должна быть больше 0');
          break;
        }
        db.insertCar(Car(brand: brand, model: model, year: year, price: price));
        print('Машина добавлена');
        break;

      case '2':
        var cars = db.getCars();
        if (cars.isEmpty) {
          print('Нет машин');
        } else {
          for (var car in cars) print(car);
        }
        break;

      case '3':
        String name = askString('Имя покупателя: ');
        String phone = askString('Телефон: ');
        db.insertCustomer(Customer(name: name, phone: phone));
        print('Покупатель добавлен');
        break;

      case '4':
        var customers = db.getCustomers();
        if (customers.isEmpty) {
          print('Нет покупателей');
        } else {
          for (var customer in customers) print(customer);
        }
        break;

      case '5':
        var carsList = db.getCars();
        if (carsList.isEmpty) {
          print('Сначала добавьте машины');
          break;
        }
        print('Доступные машины:');
        for (var car in carsList) print(car);

        int carId = askInt('Id машины: ');
        var selectedCar = db.getCarById(carId);
        if (selectedCar == null) {
          print('Машина не найдена');
          break;
        }

        var customersList = db.getCustomers();
        if (customersList.isEmpty) {
          print('Сначала добавьте покупателей');
          break;
        }
        print('Покупатели:');
        for (var customer in customersList) print(customer);

        int customerId = askInt('Id покупателя: ');
        var selectedCustomer = db.getCustomerById(customerId);
        if (selectedCustomer == null) {
          print('Покупатель не найден');
          break;
        }

        DateTime saleDate = askDate('Дата продажи (гггг-мм-дд): ');
        double finalPrice = askDouble('Цена продажи: ');

        db.insertSale(Sale(
          carId: carId,
          customerId: customerId,
          saleDate: saleDate,
          finalPrice: finalPrice,
        ));
        print('Продажа оформлена');
        break;

      case '6':
        var sales = db.getSales();
        if (sales.isEmpty) {
          print('Нет продаж');
        } else {
          for (var sale in sales) print(sale);
        }
        break;

      case '7':
        print('Машины');
        for (var car in db.getCars()) print(car);
        print('Покупатели');
        for (var customer in db.getCustomers()) print(customer);
        print('Продажи');
        for (var sale in db.getSales()) print(sale);
        break;

        case '8':
  var carsForDelete = db.getCars();
  if (carsForDelete.isEmpty) {
    print('Нет машин для удаления');
    break;
  }
  print('Все машины:');
  for (var car in carsForDelete) print(car);
  int delId = askInt('Id машины для удаления: ');
  db.deleteCar(delId);
  print('Машина удалена (если существовала)');
  break;

case '9':
  var customersForDelete = db.getCustomers();
  if (customersForDelete.isEmpty) {
    print('нет покупателей для удаления');
    break;
  }
  print('Все покупатели:');
  for (var customer in customersForDelete) print(customer);
  int delCustId = askInt('Id покупателя для удаления: ');
  db.deleteCustomer(delCustId);
  print('Покупатель удалён (если существовал)');
  break;

      case '0':
        db.close();
        print('До свидания!');
        return;

      default:
        print('Неверный выбор');
    }
  }
}