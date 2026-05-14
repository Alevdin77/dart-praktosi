import 'dart:io';
import 'package:auto_salon/src/domain/validators/text_validator.dart';
import 'package:auto_salon/src/domain/validators/number_validator.dart';

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