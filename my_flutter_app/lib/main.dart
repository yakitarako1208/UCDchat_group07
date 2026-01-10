import 'package:flutter/material.dart';
import 'package:my_flutter_app/pages/home_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hakodate Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF1FA3D0),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF23A9D6)),
        scaffoldBackgroundColor: const Color(0xFFF5F7F9),
      ),
      home: const HomePage(),
    );
  }
}
