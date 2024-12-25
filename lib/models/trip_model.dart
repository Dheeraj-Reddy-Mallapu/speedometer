import 'package:hive_flutter/hive_flutter.dart';

part 'trip_model.g.dart';

@HiveType(typeId: 1)
class Trip {
  @HiveField(1)
  String id;
  @HiveField(2)
  String name;
  @HiveField(3)
  DateTime startTime;
  @HiveField(4)
  DateTime endTime;
  @HiveField(5)
  List<TripDataPoint> values;

  Trip({
    required this.id,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.values,
  });

  Trip copyWith({
    String? id,
    String? name,
    DateTime? startTime,
    DateTime? endTime,
    List<TripDataPoint>? values,
  }) =>
      Trip(
        id: id ?? this.id,
        name: name ?? this.name,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        values: values ?? this.values,
      );

  factory Trip.fromMap(Map<String, dynamic> json) => Trip(
        id: json["id"],
        name: json["name"],
        startTime: DateTime.parse(json["startTime"]),
        endTime: DateTime.parse(json["endTime"]),
        values: List<TripDataPoint>.from(
            json["values"].map((x) => TripDataPoint.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "startTime": startTime.toIso8601String(),
        "endTime": endTime.toIso8601String(),
        "values": List<dynamic>.from(values.map((x) => x.toMap())),
      };

  Trip addDataPoint(TripDataPoint dataPoint) {
    return copyWith(
      values: [...values, dataPoint],
    );
  }

  Trip addMultipleDataPoints(List<TripDataPoint> dataPoints) {
    return copyWith(values: [...values, ...dataPoints]);
  }
}

@HiveType(typeId: 2)
class TripDataPoint {
  @HiveField(1)
  double speed;
  @HiveField(2)
  double speedAccuracy;
  @HiveField(3)
  double latitude;
  @HiveField(4)
  double longitude;
  @HiveField(5)
  DateTime timeStamp;

  TripDataPoint({
    required this.speed,
    required this.speedAccuracy,
    required this.latitude,
    required this.longitude,
    required this.timeStamp,
  });

  TripDataPoint copyWith({
    double? speed,
    double? speedAccuracy,
    double? latitude,
    double? longitude,
    DateTime? timeStamp,
  }) =>
      TripDataPoint(
        speed: speed ?? this.speed,
        speedAccuracy: speedAccuracy ?? this.speedAccuracy,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        timeStamp: timeStamp ?? this.timeStamp,
      );

  factory TripDataPoint.fromMap(Map<String, dynamic> json) => TripDataPoint(
        speed: json["speed"]?.toDouble(),
        speedAccuracy: json["speedAccuracy"]?.toDouble(),
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        timeStamp: DateTime.parse(json["timeStamp"]),
      );

  Map<String, dynamic> toMap() => {
        "speed": speed,
        "speedAccuracy": speedAccuracy,
        "latitude": latitude,
        "longitude": longitude,
        "timeStamp": timeStamp.toIso8601String(),
      };
}
