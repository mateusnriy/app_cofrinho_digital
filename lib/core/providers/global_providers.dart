import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/goal_repository.dart';
import '../../data/repositories/deposit_repository.dart';

final goalRepositoryProvider = Provider<GoalRepository>((ref) {
  return GoalRepository();
});

final depositRepositoryProvider = Provider<DepositRepository>((ref) {
  return DepositRepository();
});

final goalBoxChangesProvider = StreamProvider<void>((ref) {
  final repo = ref.watch(goalRepositoryProvider);
  return repo.watchAll.map((_) {});
});
