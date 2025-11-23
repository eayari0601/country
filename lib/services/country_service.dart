import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  Future<List<Country>> getAllCountries() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.apicountries.com/api/countries'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> countriesData = data['data'];
        
        List<Country> countries = [];
        for (var countryData in countriesData) {
          countries.add(Country.fromJson(countryData));
        }
        return countries;
      } else {
        throw Exception('Failed to load countries');
      }
    } catch (e) {
      throw Exception('Failed to load countries: $e');
    }
  }
}