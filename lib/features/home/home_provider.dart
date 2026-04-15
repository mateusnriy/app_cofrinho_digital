import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/goal_model.dart';
import '../../data/repositories/goal_repository.dart';
import '../../core/providers/global_providers.dart';

// ── Provider de ordenação ─────────────────────────────────────────────────
final sortOrderProvider =
    StateProvider<SortOrder>((ref) => SortOrder.createdAt);

// ── Provider principal da Home ────────────────────────────────────────────
final homeGoalsProvider = Provider<List<GoalModel>>((ref) {
  final repo = ref.watch(goalRepositoryProvider);
  final order = ref.watch(sortOrderProvider);

  // Observa mudanças na box para reatividade
  ref.watch(goalBoxChangesProvider);

  return repo.getActive(order: order);
});

// ── Provider de estatísticas gerais ──────────────────────────────────────
final goalStatsProvider = Provider<Map<String, dynamic>>((ref) {
  final repo = ref.watch(goalRepositoryProvider);
  ref.watch(goalBoxChangesProvider);
  return repo.getStats();
});
