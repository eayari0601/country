import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:country/providers/country_provider.dart';
import 'package:country/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
     
      create: (context) => CountryProvider(),
      child: MaterialApp(
        title: 'Country Explorer',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            brightness: Brightness.dark,
            seedColor: Colors.blue,
          ),
        ),
       
        home: const HomeScreen(),
      ),
    );
  }
}