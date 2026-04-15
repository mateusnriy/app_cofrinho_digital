import 'package:intl/intl.dart';

class AppFormatters {
  static final _currencyFormatter = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static final _dateFormatter = DateFormat('dd/MM/yyyy', 'pt_BR');
  static final _dateTimeFormatter = DateFormat('dd/MM/yyyy • HH:mm', 'pt_BR');
  static final _monthYearFormatter = DateFormat('MMMM yyyy', 'pt_BR');

  /// Formata valor para moeda brasileira: R$ 1.250,00
  static String currency(double value) {
    return _currencyFormatter.format(value);
  }

  /// Formata valor compacto para cards: R$ 1,2k
  static String currencyCompact(double value) {
    if (value >= 1000) {
      return 'R\$ ${(value / 1000).toStringAsFixed(1)}k';
    }
    return _currencyFormatter.format(value);
  }

  /// Formata data: 25/12/2025
  static String date(DateTime date) {
    return _dateFormatter.format(date);
  }

  /// Formata data e hora: 25/12/2025 • 14:30
  static String dateTime(DateTime date) {
    return _dateTimeFormatter.format(date);
  }

  /// Formata mês e ano: dezembro 2025
  static String monthYear(DateTime date) {
    return _monthYearFormatter.format(date);
  }

  /// Retorna texto de dias restantes: "3 dias restantes", "Hoje!", "Prazo encerrado"
  static String daysRemaining(DateTime deadline) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final deadlineDay = DateTime(deadline.year, deadline.month, deadline.day);
    final diff = deadlineDay.difference(today).inDays;

    if (diff < 0) return 'Prazo encerrado';
    if (diff == 0) return 'Vence hoje!';
    if (diff == 1) return '1 dia restante';
    return '$diff dias restantes';
  }

  /// Retorna porcentagem formatada: 75%
  static String percent(double value) {
    final clamped = value.clamp(0.0, 100.0);
    return '${clamped.toStringAsFixed(0)}%';
  }

  /// Converte string "R$ 1.250,00" de volta para double
  static double? parseCurrency(String value) {
    try {
      final cleaned = value
          .replaceAll('R\$', '')
          .replaceAll(' ', '')
          .replaceAll('.', '')
          .replaceAll(',', '.');
      return double.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }
}
