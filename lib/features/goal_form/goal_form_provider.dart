import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../data/models/goal_model.dart';
import '../../core/providers/global_providers.dart';
import '../../data/repositories/goal_repository.dart'; // Import necessário para o tipo

class GoalFormState {
  final String name;
  final String amountText;
  final DateTime? deadline;
  final int iconCodePoint;
  final int colorValue;
  final String? note;
  final String? reminderTime;
  final bool isLoading;
  final String? errorMessage;

  const GoalFormState({
    this.name = '',
    this.amountText = '',
    this.deadline,
    int? iconCodePoint,
    int? colorValue,
    this.note,
    this.reminderTime,
    this.isLoading = false,
    this.errorMessage,
  })  : iconCodePoint = iconCodePoint ?? 0xe7e8,
        colorValue = colorValue ?? 0xFF2D6A4F;

  GoalFormState copyWith({
    String? name,
    String? amountText,
    DateTime? deadline,
    int? iconCodePoint,
    int? colorValue,
    String? note,
    String? reminderTime,
    bool? isLoading,
    String? errorMessage,
  }) {
    return GoalFormState(
      name: name ?? this.name,
      amountText: amountText ?? this.amountText,
      deadline: deadline ?? this.deadline,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
      colorValue: colorValue ?? this.colorValue,
      note: note ?? this.note,
      reminderTime: reminderTime ?? this.reminderTime,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  double? get parsedAmount {
    final cleaned = amountText
        .replaceAll('R\$', '')
        .replaceAll(' ', '')
        .replaceAll('.', '')
        .replaceAll(',', '.');
    return double.tryParse(cleaned);
  }

  String? validate() {
    if (name.trim().isEmpty) return 'Informe o nome da meta';
    if (parsedAmount == null || parsedAmount! <= 0) {
      return 'Informe um valor válido';
    }
    if (deadline == null) return 'Selecione um prazo';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selectedDate =
        DateTime(deadline!.year, deadline!.month, deadline!.day);

    if (selectedDate.isBefore(today)) {
      return 'O prazo deve ser uma data futura ou hoje';
    }
    return null;
  }
}

class GoalFormNotifier extends StateNotifier<GoalFormState> {
  final GoalRepository _repo; // Correção principal: Ocultava erro dinâmico

  GoalFormNotifier(this._repo) : super(const GoalFormState());

  void loadFromExisting(GoalModel goal) {
    state = GoalFormState(
      name: goal.name,
      amountText: goal.targetAmount.toStringAsFixed(2).replaceAll('.', ','),
      deadline: goal.deadline,
      iconCodePoint: goal.iconCodePoint,
      colorValue: goal.colorValue,
      note: goal.note,
      reminderTime: goal.reminderTime,
    );
  }

  void setName(String value) => state = state.copyWith(name: value);
  void setAmount(String value) => state = state.copyWith(amountText: value);
  void setDeadline(DateTime value) => state = state.copyWith(deadline: value);
  void setIcon(int codePoint) =>
      state = state.copyWith(iconCodePoint: codePoint);
  void setColor(int colorValue) =>
      state = state.copyWith(colorValue: colorValue);
  void setNote(String? value) => state = state.copyWith(note: value);
  void setReminder(String? value) =>
      state = state.copyWith(reminderTime: value);

  Future<bool> save({String? existingId}) async {
    final error = state.validate();
    if (error != null) {
      state = state.copyWith(errorMessage: error);
      return false;
    }

    state = state.copyWith(isLoading: true);

    final goal = GoalModel(
      id: existingId ?? const Uuid().v4(),
      name: state.name.trim(),
      targetAmount: state.parsedAmount!,
      deadline: state.deadline!,
      iconCodePoint: state.iconCodePoint,
      colorValue: state.colorValue,
      note: state.note?.trim().isEmpty == true ? null : state.note?.trim(),
      reminderTime: state.reminderTime,
      createdAt: DateTime.now(),
      savedAmount: existingId != null
          ? (_repo.getById(existingId)?.savedAmount ?? 0)
          : 0,
    );

    await _repo.save(goal);

    state = state.copyWith(isLoading: false);
    return true;
  }
}

final goalFormProvider =
    StateNotifierProvider.autoDispose<GoalFormNotifier, GoalFormState>((ref) {
  final repo = ref.watch(goalRepositoryProvider);
  return GoalFormNotifier(repo);
});
