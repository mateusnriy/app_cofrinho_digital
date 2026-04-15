import 'package:hive/hive.dart';

part 'deposit_model.g.dart';

@HiveType(typeId: 1)
class DepositModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String goalId; // FK -> GoalModel.id

  @HiveField(2)
  double amount;

  @HiveField(3)
  DateTime date;

  @HiveField(4)
  String? note;

  DepositModel({
    required this.id,
    required this.goalId,
    required this.amount,
    required this.date,
    this.note,
  });

  DepositModel copyWith({
    String? id,
    String? goalId,
    double? amount,
    DateTime? date,
    String? note,
  }) {
    return DepositModel(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      note: note ?? this.note,
    );
  }
}
