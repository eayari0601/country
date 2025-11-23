import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  Future<List<Country>> getAllCountries() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.apicountries.com/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> countriesData = json.decode(response.body);
        
        List<Country> countries = [];
        for (var countryData in countriesData) {
          countries.add(Country.fromJson(countryData));
        }
        return countries;
      } else {
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }
}