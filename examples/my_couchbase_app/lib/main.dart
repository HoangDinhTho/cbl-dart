import 'package:cbl_flutter/cbl_flutter.dart';
import 'package:flutter/material.dart';

import 'presents/home/home_page.dart';

Future<void> main() async {
  // Ensure widgets are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Couchbase Lite with default settings
  await CouchbaseLiteFlutter.init();

  runApp(const MainApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Couchbase App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      navigatorKey: navigatorKey,
      home: const HomePage(),
    );
  }
}
