import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:speedometer/models/trip_model.dart';
import 'package:speedometer/presentation/pages/speedometer_page.dart';
import 'package:speedometer/presentation/pages/trip_history_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(TripAdapter());
  Hive.registerAdapter(TripDataPointAdapter());

  await Hive.openBox<Trip>('trips');
  await Hive.openBox('preferences');

  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      routes: {
        '/': (context) => const SpeedometerPage(),
        '/trip_history': (context) => const TripHistoryPage(),
      },
    );
  }
}
