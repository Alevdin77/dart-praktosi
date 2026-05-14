import 'dart:io';
import 'dart:math';

void main() {
  print('Калькулятор');
  print('Доступные операции:');
  print('+  -  *  /  ~/  %  pow');
  print('==  !=  >  <  >=  <=');
  print('&&  ||  !');
  print('');

  stdout.write('Введите первое число: ');
  double a = double.parse(stdin.readLineSync()!);

  stdout.write('Введите оператор: ');
  String op = stdin.readLineSync()!;

  // Для унарной операции "!" второе число не нужно
  double b = 0;
  if (op != '!') {
    stdout.write('Введите второе число: ');
    b = double.parse(stdin.readLineSync()!);
  }

  switch (op) {
    // Арифметика
    case '+':
      print('$a + $b = ${a + b}');
      break;
    case '-':
      print('$a - $b = ${a - b}');
      break;
    case '*':
      print('$a * $b = ${a * b}');
      break;
    case '/':
      if (b == 0) {
        print('Ошибка: деление на ноль');
        return;
      }
      print('$a / $b = ${a / b}');
      break;
    case '~/':
      if (b == 0) {
        print('Ошибка: деление на ноль');
        return;
      }
      print('$a ~/ $b = ${a ~/ b}');
      break;
    case '%':
      if (b == 0) {
        print('Ошибка: деление на ноль');
        return;
      }
      print('$a % $b = ${a % b}');
      break;
    case 'pow':
      print('$a ^ $b = ${pow(a, b)}');
      break;

    // Сравнения
    case '==':
      print('$a == $b -> ${a == b}');
      break;
    case '!=':
      print('$a != $b -> ${a != b}');
      break;
    case '>':
      print('$a > $b -> ${a > b}');
      break;
    case '<':
      print('$a < $b -> ${a < b}');
      break;
    case '>=':
      print('$a >= $b -> ${a >= b}');
      break;
    case '<=':
      print('$a <= $b -> ${a <= b}');
      break;

    // Логические операции
    case '&&':
      print('$a && $b -> ${(a != 0) && (b != 0)}');
      break;
    case '||':
      print('$a || $b -> ${(a != 0) || (b != 0)}');
      break;
    case '!':
      print('!$a -> ${!(a != 0)}');
      break;

    default:
      print('Неизвестный оператор');
  }
}