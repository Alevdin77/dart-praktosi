import 'dart:math';

// 1. кружка и человек
class Krugka {
  int voda = 0;
  void nalit(int skolko) { voda += skolko; if (voda > 500) voda = 500; print('в кружке $voda мл'); }
  void pit(int skolko) { if (skolko > voda) print('мало воды'); else { voda -= skolko; print('выпил $skolko мл, осталось $voda мл'); } }
}
class Chelovek {
  String imya;
  Chelovek(this.imya);
  void pitIzKrugki(Krugka k, int skolko) { print('$imya пьёт'); k.pit(skolko); }
}

// 2. шкаф
class Shkaf {
  List<String> veschi = [];
  void polozhit(String v) { veschi.add(v); print('положили $v'); }
  void vziat(String v) { if (veschi.contains(v)) { veschi.remove(v); print('взяли $v'); } else print('нет $v'); }
  void pokazat() { print('в шкафу: $veschi'); }
}

// 3. гриф и блины
class Blin { int ves; Blin(this.ves); }
class Grif {
  int maxVes, tekVes = 0;
  Grif(this.maxVes);
  void dobavitSleva(Blin b) { if (tekVes + b.ves > maxVes) return; tekVes += b.ves; print('+${b.ves}кг слева, всего $tekVes кг'); }
  void dobavitSprava(Blin b) { if (tekVes + b.ves > maxVes) return; tekVes += b.ves; print('+${b.ves}кг справа, всего $tekVes кг'); }
}

// 4. конвертер (курс: 1 доллар = 74.88 рубля)
class Konverter {
  double rubliVDollary(double r) => r / 74.88;
  double dollaryVRubli(double d) => d * 74.88;
}

// 5. гараж
class Garazh<T> {
  List<T> spisok = [];
  void postavit(T x) { spisok.add(x); print('поставили $x'); }
  T? vziat() { if (spisok.isEmpty) return null; return spisok.removeLast(); }
}

// 6. перегрузка
class MoeChislo {
  int znach;
  MoeChislo(this.znach);
  MoeChislo operator +(MoeChislo o) => MoeChislo(znach + o.znach);
  MoeChislo operator -(MoeChislo o) => MoeChislo(znach - o.znach);
}

// 7. машина
enum CarState { stop, drive, left, right }
class Car {
  String name;
  CarState state;
  Car(this.name, this.state);
  void go(CarState ns) { state = ns; print('$name ${state == CarState.stop ? "стоп" : state == CarState.drive ? "едет" : state == CarState.left ? "налево" : "направо"}'); }
}

// 8. фигуры
abstract class Figura { double ploshad(); }
class Pramougolnik extends Figura { double a, b; Pramougolnik(this.a, this.b); @override double ploshad() => a * b; }
class Krug extends Figura { double r; Krug(this.r); @override double ploshad() => 3.14 * r * r; }

// 9. системы счисления
class Chisla {
  String vDvoichnuyu(int n) => n.toRadixString(2);
  String vShestnadcat(int n) => n.toRadixString(16).toUpperCase();
}

// 10. максимум площади
class SpisokFigur {
  List<Figura> figury = [];
  void dobavit(Figura f) { figury.add(f); }
  Figura maxPloshad() { Figura m = figury[0]; for (var f in figury) if (f.ploshad() > m.ploshad()) m = f; return m; }
}

// 11. стол и приборы
class Pribor { String name; Pribor(this.name); }
class Stol {
  List<Pribor> pribory = [];
  void postavit(Pribor p) { pribory.add(p); print('поставили ${p.name}'); }
  void ubrat(String name) { for (int i = 0; i < pribory.length; i++) { if (pribory[i].name == name) { pribory.removeAt(i); print('убрали $name'); return; } } print('нет $name'); }
  void pokazat() { print('на столе: ${pribory.map((p)=>p.name).toList()}'); }
}

void main() {
  print('ПР 4\n');

  print('1. кружка');
  Krugka k = Krugka(); k.nalit(300);
  Chelovek('Дима').pitIzKrugki(k, 100);

  print('\n2. шкаф');
  Shkaf sh = Shkaf(); sh.polozhit('шапка'); sh.polozhit('шарф'); sh.pokazat(); sh.vziat('шарф'); sh.pokazat();

  print('\n3. гриф');
  Grif g = Grif(100); g.dobavitSleva(Blin(20)); g.dobavitSprava(Blin(20)); g.dobavitSleva(Blin(10));

  print('\n4. конвертер');
  Konverter kv = Konverter(); print('100 руб = ${kv.rubliVDollary(100).toStringAsFixed(2)} usd'); print('1 usd = ${kv.dollaryVRubli(1).toStringAsFixed(2)} руб');

  print('\n5. гараж');
  Garazh<String> gr = Garazh<String>(); gr.postavit('bmw'); gr.postavit('audi'); gr.vziat();

  print('\n6. числа');
  MoeChislo n1 = MoeChislo(10), n2 = MoeChislo(3); print('10 + 3 = ${(n1 + n2).znach}');

  print('\n7. машина');
  Car('bmw', CarState.stop).go(CarState.drive);

  print('\n8. фигуры');
  print(Pramougolnik(5, 3).ploshad());

  print('\n9. системы');
  Chisla cn = Chisla(); print('255 = ${cn.vDvoichnuyu(255)}');

  print('\n10. макс площадь');
  SpisokFigur fl = SpisokFigur(); fl.dobavit(Pramougolnik(5, 3)); fl.dobavit(Krug(4)); print(fl.maxPloshad().ploshad());

  print('\n11. стол');
  Stol st = Stol(); st.postavit(Pribor('вилка')); st.postavit(Pribor('ложка')); st.pokazat(); st.ubrat('ложка'); st.pokazat();
}