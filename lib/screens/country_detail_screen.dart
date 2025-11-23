import 'package:flutter/material.dart';
import '../models/country.dart';

class CountryDetailScreen extends StatefulWidget {
  final Country country;

  const CountryDetailScreen({required this.country, super.key});

  @override
  State<CountryDetailScreen> createState() => _CountryDetailScreenState();
}

class _CountryDetailScreenState extends State<CountryDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.country.name),
      ),
      body: Center(
        child: Text(
          'Details for ${widget.country.name}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
