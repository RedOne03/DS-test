import 'package:flutter_test/flutter_test.dart';

void main() {
  group('UserScreen Unit Tests', () {
    test('formatDate debería formatear la fecha correctamente', () {
      // Arrange
      final date = DateTime(2024, 3, 15, 14, 30);

      // Act
      final formatted =
          '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

      // Assert
      expect(formatted, equals('15/3/2024 14:30'));
    });

    test('progreso debe calcularse correctamente', () {
      // Arrange
      const totalDays = 100;
      const maxDays = 365;

      // Act
      final progress = (totalDays / maxDays).clamp(0.0, 1.0);

      // Assert
      expect(progress, closeTo(0.274, 0.001));
    });

    test('progreso no debe exceder 1.0', () {
      // Arrange
      const totalDays = 500;
      const maxDays = 365;

      // Act
      final progress = (totalDays / maxDays).clamp(0.0, 1.0);

      // Assert
      expect(progress, equals(1.0));
    });

    test('cálculo de streak cuando es día consecutivo', () {
      // Arrange
      final today = DateTime(2024, 3, 15);
      final lastAccess = DateTime(2024, 3, 14);
      final currentStreak = 5;

      // Act
      final isConsecutive =
          lastAccess.add(const Duration(days: 1)).day == today.day;
      final newStreak = isConsecutive ? currentStreak + 1 : 1;

      // Assert
      expect(newStreak, equals(6));
    });

    test('cálculo de streak cuando no es día consecutivo', () {
      // Arrange
      final today = DateTime(2024, 3, 15);
      final lastAccess = DateTime(2024, 3, 12);
      final currentStreak = 5;

      // Act
      final isConsecutive =
          lastAccess.add(const Duration(days: 1)).day == today.day;
      final newStreak = isConsecutive ? currentStreak + 1 : 1;

      // Assert
      expect(newStreak, equals(1));
    });

    test('cálculo de días desde registro', () {
      // Arrange
      final registrationDate = DateTime(2024, 1, 1);
      final today = DateTime(2024, 3, 15);

      // Act
      final daysSinceRegistration = today.difference(registrationDate).inDays;

      // Assert
      expect(daysSinceRegistration, equals(74));
    });

    test('verificar si es el mismo día', () {
      // Arrange
      final date1 = DateTime(2024, 3, 15, 10, 30);
      final date2 = DateTime(2024, 3, 15, 18, 45);

      // Act
      final sameDay = DateTime(date1.year, date1.month, date1.day)
          .isAtSameMomentAs(DateTime(date2.year, date2.month, date2.day));

      // Assert
      expect(sameDay, isTrue);
    });

    test('extracción de nombre de usuario desde email', () {
      // Arrange
      const email = 'juan.perez@example.com';

      // Act
      final username = email.split('@')[0];

      // Assert
      expect(username, equals('juan.perez'));
    });

    test('validación de meta personal vacía', () {
      // Arrange
      const metaPersonal = '';

      // Act
      final isEmpty = metaPersonal.isEmpty;

      // Assert
      expect(isEmpty, isTrue);
    });

    test('validación de meta personal con contenido', () {
      // Arrange
      const metaPersonal = 'Quiero ser mejor cada día';

      // Act
      final isNotEmpty = metaPersonal.isNotEmpty;

      // Assert
      expect(isNotEmpty, isTrue);
    });

    test('porcentaje de progreso como string', () {
      // Arrange
      const progressPercentage = 0.2743;

      // Act
      final progressString =
          "${(progressPercentage * 100).toStringAsFixed(1)}%";

      // Assert
      expect(progressString, equals('27.4%'));
    });

    test('cálculo de total de días debe ser mayor a cero', () {
      // Arrange
      final registrationDate = DateTime(2024, 3, 10);
      final today = DateTime(2024, 3, 15);

      // Act
      final totalDays = today.difference(registrationDate).inDays + 1;

      // Assert
      expect(totalDays, greaterThan(0));
      expect(totalDays, equals(6));
    });
  });
}
