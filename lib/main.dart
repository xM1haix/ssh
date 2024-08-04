import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tefis_tool/splashscreen.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final LocalAuthentication auth = LocalAuthentication();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('fingerPrint',
      await auth.canCheckBiometrics && await auth.isDeviceSupported());
  await openDatabase(join(await getDatabasesPath(), 'my_database.db'),
      onCreate: (db, version) => db.execute(
          'CREATE TABLE ssh_details(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER, username TEXT, password TEXT, created_at TEXT DEFAULT CURRENT_TIMESTAMP)'),
      version: 1);
  runApp(
    MaterialApp(
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    ),
  );
}
