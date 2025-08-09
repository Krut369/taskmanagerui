import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart'; // Add this import
import 'screens/task_list_screen.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Set to false in production
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6B46C1)),
        useMaterial3: true,
        fontFamily: 'System',
      ),
      home: const TaskListScreen(),
      debugShowCheckedModeBanner: false,

      // Required for DevicePreview to work
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}
