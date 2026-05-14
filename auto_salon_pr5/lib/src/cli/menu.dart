import 'dart:io';
import 'package:auto_salon/src/domain/models/car.dart';
import 'package:auto_salon/src/domain/models/customer.dart';
import 'package:auto_salon/src/domain/models/sale.dart';
import 'package:auto_salon/src/domain/validators/number_validator.dart';
import 'package:auto_salon/src/data/database.dart';
import 'package:auto_salon/src/data/repositories/car_repository.dart';
import 'package:auto_salon/src/data/repositories/customer_repository.dart';
import 'package:auto_salon/src/data/repositories/sale_repository.dart';
import 'package:auto_salon/src/cli/input_helper.dart';

class Menu {
  late CarRepository carRepo;
  late CustomerRepository customerRepo;
  late SaleRepository saleRepo;

  Future<void> run() async {
    final db = await DatabaseHelper.init();
    carRepo = CarRepository(db);
    customerRepo = CustomerRepository(db);
    saleRepo = SaleRepository(db);

    while (true) {
      print('\nАвтосалон');
      print('1. Добавить машину');
      print('2. Показать все машины');
      print('3. Добавить покупателя');
      print('4. Показать всех покупателей');
      print('5. Оформить продажу');
      print('6. Показать все продажи');
      print('7. Показать всё из БД');
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
          carRepo.create(Car(brand: brand, model: model, year: year, price: price));
          print('Машина добавлена');
          break;

        case '2':
          var cars = carRepo.readAll();
          if (cars.isEmpty) print('Нет машин');
          else for (var car in cars) print(car);
          break;

        case '3':
          String name = askString('Имя покупателя: ');
          String phone = askString('Телефон: ');
          customerRepo.create(Customer(name: name, phone: phone));
          print('Покупатель добавлен');
          break;

        case '4':
          var customers = customerRepo.readAll();
          if (customers.isEmpty) print('Нет покупателей');
          else for (var customer in customers) print(customer);
          break;

        case '5':
          var carsList = carRepo.readAll();
          if (carsList.isEmpty) {
            print('Сначала добавьте машины');
            break;
          }
          print('Доступные машины:');
          for (var car in carsList) print(car);
          int carId = askInt('ID машины: ');
          var selectedCar = carRepo.readById(carId);
          if (selectedCar == null) {
            print('Машина не найдена');
            break;
          }
          var customersList = customerRepo.readAll();
          if (customersList.isEmpty) {
            print('Сначала добавьте покупателей');
            break;
          }
          print('Покупатели:');
          for (var customer in customersList) print(customer);
          int customerId = askInt('ID покупателя: ');
          var selectedCustomer = customerRepo.readById(customerId);
          if (selectedCustomer == null) {
            print('Покупатель не найден');
            break;
          }
          DateTime saleDate = askDate('Дата продажи (гггг-мм-дд): ');
          double finalPrice = askDouble('Цена продажи: ');
          saleRepo.create(Sale(carId: carId, customerId: customerId, saleDate: saleDate, finalPrice: finalPrice));
          print('Продажа оформлена');
          break;

        case '6':
          var sales = saleRepo.readAll();
          if (sales.isEmpty) print('Нет продаж');
          else for (var sale in sales) print(sale);
          break;

        case '7':
          print('\n--- Машины ---');
          for (var car in carRepo.readAll()) print(car);
          print('\n--- Покупатели ---');
          for (var customer in customerRepo.readAll()) print(customer);
          print('\n--- Продажи ---');
          for (var sale in saleRepo.readAll()) print(sale);
          break;

        case '8':
          var carsForDelete = carRepo.readAll();
          if (carsForDelete.isEmpty) {
            print('Нет машин для удаления');
            break;
          }
          print('Все машины:');
          for (var car in carsForDelete) print(car);
          int delId = askInt('ID машины для удаления: ');
          carRepo.delete(delId);
          print('Машина удалена');
          break;

        case '9':
          var customersForDelete = customerRepo.readAll();
          if (customersForDelete.isEmpty) {
            print('Нет покупателей для удаления');
            break;
          }
          print('Все покупатели:');
          for (var customer in customersForDelete) print(customer);
          int delCustId = askInt('ID покупателя для удаления: ');
          customerRepo.delete(delCustId);
          print('Покупатель удалён');
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
}