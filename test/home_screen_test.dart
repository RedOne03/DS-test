// test/home_screen_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

// Funciones extraídas del código original para probar
String getRecurrenceText(String recurrence) {
  switch (recurrence) {
    case 'daily':
      return 'Diario';
    case 'weekdays':
      return 'Días laborables';
    case 'weekend':
      return 'Fin de semana';
    default:
      return 'Sin repetición';
  }
}

bool canMarkTaskAsCompleted(DateTime taskDate) {
  DateTime today = DateTime.now();
  DateTime todayMidnight = DateTime(today.year, today.month, today.day);
  DateTime taskDateMidnight =
      DateTime(taskDate.year, taskDate.month, taskDate.day);

  return !taskDateMidnight.isAfter(todayMidnight);
}

bool isWeekday(DateTime date) {
  return date.weekday >= DateTime.monday && date.weekday <= DateTime.friday;
}

bool isWeekend(DateTime date) {
  return date.weekday == DateTime.saturday || date.weekday == DateTime.sunday;
}

bool validateTaskForm(String? title, String? startTime, String? endTime) {
  return title != null &&
      title.isNotEmpty &&
      startTime != null &&
      startTime.isNotEmpty &&
      endTime != null &&
      endTime.isNotEmpty;
}

void main() {
  group('HomeScreen Tests', () {
    test('getRecurrenceText returns correct values', () {
      expect(getRecurrenceText('daily'), equals('Diario'));
      expect(getRecurrenceText('weekdays'), equals('Días laborables'));
      expect(getRecurrenceText('weekend'), equals('Fin de semana'));
      expect(getRecurrenceText('none'), equals('Sin repetición'));
    });

    test('canMarkTaskAsCompleted works correctly', () {
      final today = DateTime.now();
      final yesterday = today.subtract(Duration(days: 1));
      final tomorrow = today.add(Duration(days: 1));

      expect(canMarkTaskAsCompleted(today), isTrue);
      expect(canMarkTaskAsCompleted(yesterday), isTrue);
      expect(canMarkTaskAsCompleted(tomorrow), isFalse);
    });

    test('isWeekday identifies weekdays correctly', () {
      final monday = DateTime(2024, 1, 1); // Lunes
      final friday = DateTime(2024, 1, 5); // Viernes
      final saturday = DateTime(2024, 1, 6); // Sábado

      expect(isWeekday(monday), isTrue);
      expect(isWeekday(friday), isTrue);
      expect(isWeekday(saturday), isFalse);
    });

    test('isWeekend identifies weekends correctly', () {
      final friday = DateTime(2024, 1, 5); // Viernes
      final saturday = DateTime(2024, 1, 6); // Sábado
      final sunday = DateTime(2024, 1, 7); // Domingo

      expect(isWeekend(friday), isFalse);
      expect(isWeekend(saturday), isTrue);
      expect(isWeekend(sunday), isTrue);
    });

    test('validateTaskForm validates required fields', () {
      expect(validateTaskForm('Tarea', '09:00', '10:00'), isTrue);
      expect(validateTaskForm('', '09:00', '10:00'), isFalse);
      expect(validateTaskForm('Tarea', '', '10:00'), isFalse);
      expect(validateTaskForm('Tarea', '09:00', ''), isFalse);
      expect(validateTaskForm(null, '09:00', '10:00'), isFalse);
    });

    test('date formatting works correctly', () {
      final testDate = DateTime(2024, 12, 25);
      final formatted = DateFormat('dd/MM/yyyy').format(testDate);

      expect(formatted, equals('25/12/2024'));
    });
  });
}
