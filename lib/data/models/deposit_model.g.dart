// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deposit_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DepositModelAdapter extends TypeAdapter<DepositModel> {
  @override
  final int typeId = 1;

  @override
  DepositModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DepositModel(
      id: fields[0] as String,
      goalId: fields[1] as String,
      amount: fields[2] as double,
      date: fields[3] as DateTime,
      note: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DepositModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.goalId)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.date)
      ..writeByte(4)
      ..write(obj.note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DepositModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
