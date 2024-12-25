// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TripAdapter extends TypeAdapter<Trip> {
  @override
  final int typeId = 1;

  @override
  Trip read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Trip(
      id: fields[1] as String,
      name: fields[2] as String,
      startTime: fields[3] as DateTime,
      endTime: fields[4] as DateTime,
      values: (fields[5] as List).cast<TripDataPoint>(),
    );
  }

  @override
  void write(BinaryWriter writer, Trip obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.startTime)
      ..writeByte(4)
      ..write(obj.endTime)
      ..writeByte(5)
      ..write(obj.values);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class TripDataPointAdapter extends TypeAdapter<TripDataPoint> {
  @override
  final int typeId = 2;

  @override
  TripDataPoint read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TripDataPoint(
      speed: fields[1] as double,
      speedAccuracy: fields[2] as double,
      latitude: fields[3] as double,
      longitude: fields[4] as double,
      timeStamp: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, TripDataPoint obj) {
    writer
      ..writeByte(5)
      ..writeByte(1)
      ..write(obj.speed)
      ..writeByte(2)
      ..write(obj.speedAccuracy)
      ..writeByte(3)
      ..write(obj.latitude)
      ..writeByte(4)
      ..write(obj.longitude)
      ..writeByte(5)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TripDataPointAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
