List<String> students = [
  'Анна Иванова',
  'Борис Петров',
  'Виктор Сидоров',
  'Галина Смирнова',
  'Дмитрий Кузнецов',
  'Елена Васильева',
];

List<String> subjects = [
  'Математика',
  'Русский язык',
  'Информатика',
  'Физика',
];

// Оценки: строки - студенты, столбцы - предметы
List<List<int>> grades = [
  [5, 4, 5, 3], // Анна
  [4, 3, 4, 4], // Борис
  [5, 5, 5, 5], // Виктор
  [3, 4, 3, 3], // Галина
  [4, 4, 4, 4], // Дмитрий
  [2, 3, 5, 4], // Елена
];

void main() {
  print('Журнал успеваемости группы');
  print('');

  // 1. Список студентов и предметов
  print('Студенты:');
  for (int i = 0; i < students.length; i++) {
    print('${i + 1}. ${students[i]}');
  }
  print('');

  print('Предметы:');
  for (int i = 0; i < subjects.length; i++) {
    print('${i + 1}. ${subjects[i]}');
  }
  print('');

  // 2. Все оценки каждого студента
  print('Оценки:');
  for (int i = 0; i < students.length; i++) {
    print('${students[i]}:');
    for (int j = 0; j < subjects.length; j++) {
      print('  ${subjects[j]}: ${grades[i][j]}');
    }
  }
  print('');

  // 3. Средний балл по каждому предмету
  print('Средний балл по предметам:');
  for (int j = 0; j < subjects.length; j++) {
    double sum = 0;
    for (int i = 0; i < students.length; i++) {
      sum += grades[i][j];
    }
    double avg = sum / students.length;
    print('${subjects[j]}: ${avg.toStringAsFixed(2)}');
  }
  print('');

  // 4. Средний балл каждого студента
  print('Средний балл студентов:');
  for (int i = 0; i < students.length; i++) {
    double sum = 0;
    for (int j = 0; j < subjects.length; j++) {
      sum += grades[i][j];
    }
    double avg = sum / subjects.length;
    print('${students[i]}: ${avg.toStringAsFixed(2)}');
  }
  print('');

  // 5. Лучший студент
  double bestAvg = 0;
  String bestStudent = '';
  for (int i = 0; i < students.length; i++) {
    double sum = 0;
    for (int j = 0; j < subjects.length; j++) {
      sum += grades[i][j];
    }
    double avg = sum / subjects.length;
    if (avg > bestAvg) {
      bestAvg = avg;
      bestStudent = students[i];
    }
  }
  print('Лучший студент: $bestStudent (средний балл: ${bestAvg.toStringAsFixed(2)})');
  print('');

  // 6. Предмет с низшим средним баллом
  double minAvg = 10;
  String worstSubject = '';
  for (int j = 0; j < subjects.length; j++) {
    double sum = 0;
    for (int i = 0; i < students.length; i++) {
      sum += grades[i][j];
    }
    double avg = sum / students.length;
    if (avg < minAvg) {
      minAvg = avg;
      worstSubject = subjects[j];
    }
  }
  print('Предмет с низшим средним баллом: $worstSubject (${minAvg.toStringAsFixed(2)})');
  print('');

  // 7. Общий средний балл группы
  double totalSum = 0;
  int totalCount = 0;
  for (int i = 0; i < students.length; i++) {
    for (int j = 0; j < subjects.length; j++) {
      totalSum += grades[i][j];
      totalCount++;
    }
  }
  double totalAvg = totalSum / totalCount;
  print('Общий средний балл по группе: ${totalAvg.toStringAsFixed(2)}');
  print('');

  // 8. Перечень предметов без повторов и их количество
  print('Предметы:');
  for (int i = 0; i < subjects.length; i++) {
    print('${i + 1}. ${subjects[i]}');
  }
  print('Всего предметов: ${subjects.length}');
  print('');

  // 9. Студенты без двоек
  print('Студенты без двоек:');
  for (int i = 0; i < students.length; i++) {
    bool hasTwo = false;
    for (int j = 0; j < subjects.length; j++) {
      if (grades[i][j] == 2) {
        hasTwo = true;
        break;
      }
    }
    if (!hasTwo) {
      print(students[i]);
    }
  }
  print('');

  // 10. Студенты с оценками не ниже 4
  print('Студенты с оценками не ниже 4:');
  for (int i = 0; i < students.length; i++) {
    bool allGood = true;
    for (int j = 0; j < subjects.length; j++) {
      if (grades[i][j] < 4) {
        allGood = false;
        break;
      }
    }
    if (allGood) {
      print(students[i]);
    }
  }
}