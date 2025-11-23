import 'package:flutter/material.dart';
import '../models/country.dart';
import '../services/country_service.dart';

class CountryProvider with ChangeNotifier {
  List<Country> _countries = [];
  bool _isLoading = false;
  String _error = '';

  List<Country> get countries => _countries;
  bool get isLoading => _isLoading;
  String get error => _error;
  bool get hasError => _error.isNotEmpty;

  CountryProvider() {
    loadCountries();
  }

  Future<void> loadCountries() async {
    _isLoading = true;
    notifyListeners(); 

    try {
      _countries = await CountryService().getAllCountries();
      _error = '';
    } catch (e) {
      _error = 'Failed to load countries: $e';
      _countries = []; 
    }

    _isLoading = false;
    notifyListeners(); 
  }
}