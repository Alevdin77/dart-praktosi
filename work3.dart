import 'dart:io';
import 'dart:math';
import 'package:characters/characters.dart';

enum Nastroenie { radostnoe,
grustnoe,
krutoe,
spokoynoe,
zloe,
ustavshee,
vlyublennoe }

void main() {
  print('ГЕНЕРАТОР НАСТРОЕНИЯ\n');

  stdout.write('Введите имя: ');
  String? name = stdin.readLineSync();
  if (name == null || name == '') name = 'Гость';

  var r = Random();
  var vibor = Nastroenie.values[r.nextInt(Nastroenie.values.length)];

  String em = '';
  String mood = '';

  if (vibor == Nastroenie.radostnoe) { em = '\u{1F600}'; mood = 'радостное'; }
  if (vibor == Nastroenie.grustnoe) { em = '\u{1F61E}'; mood = 'грустное'; }
  if (vibor == Nastroenie.krutoe) { em = '\u{1F60E}'; mood = 'крутое'; }
  if (vibor == Nastroenie.spokoynoe) { em = '\u{1F60A}'; mood = 'спокойное'; }
  if (vibor == Nastroenie.zloe) { em = '\u{1F620}'; mood = 'злое'; }
  if (vibor == Nastroenie.ustavshee) { em = '\u{1F62B}'; mood = 'уставшее'; }
  if (vibor == Nastroenie.vlyublennoe) { em = '\u{1F60D}'; mood = 'влюбленное'; }

  int e = r.nextInt(10) + 1;
  print('\n$name, у вас $mood настроение $em (энергия: $e из 10)\n');

  String h = em.runes.first.toRadixString(16).toUpperCase();
  if (h.length == 4) h = '0' + h;
  if (h.length == 5) h = '0' + h;
  print('Код эмодзи: U+$h\n');

  print('Хотите разобрать эмодзи? (да/нет)');
  if (stdin.readLineSync() == 'да') {
    print('\nВведите эмодзи:');
    String? txt = stdin.readLineSync();
    if (txt != null && txt != '') {
      print('\nРазбор: $txt');
      print('Обычных единиц: ${txt.length}');
      print('Кодовых точек: ${txt.runes.length}');
      print('Реальных символов: ${txt.characters.length}\n');

      int n = 1;
      for (var znak in txt.characters) {
        var kody = znak.runes.toList();
        String out = '';
        for (int i = 0; i < kody.length; i++) {
          String sh = kody[i].toRadixString(16).toUpperCase();
          if (sh.length == 4) sh = '0' + sh;
          if (sh.length == 5) sh = '0' + sh;
          if (i > 0) out += ' + ';
          out += 'U+' + sh;
        }
        print('Знак $n: $znak -> $out');
        n++;
      }
    }
  }

  print('\nПока!');
}