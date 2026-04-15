import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/goal_model.dart';
import '../../data/models/deposit_model.dart';
import '../../core/providers/global_providers.dart';

// ── Provider de meta específica por ID ───────────────────────────────────
final goalByIdProvider = Provider.family<GoalModel?, String>((ref, goalId) {
  final repo = ref.watch(goalRepositoryProvider);
  ref.watch(goalBoxChangesProvider);
  return repo.getById(goalId);
});

// ── Provider de depósitos de uma meta ─────────────────────────────────────
final depositsByGoalProvider =
    Provider.family<List<DepositModel>, String>((ref, goalId) {
  final repo = ref.watch(depositRepositoryProvider);
  ref.watch(goalBoxChangesProvider);
  return repo.getByGoal(goalId);
});

// ── Provider de dados mensais para gráfico ────────────────────────────────
final monthlyDepositsProvider =
    Provider.family<Map<String, double>, String>((ref, goalId) {
  final repo = ref.watch(depositRepositoryProvider);
  ref.watch(goalBoxChangesProvider);
  return repo.getMonthlyByGoal(goalId);
});
