import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/country.dart';

class CountryService {
  // Étape DH-02: Implémentation du service HTTP
  // Cette méthode récupère tous les pays depuis l'API REST Countries
  
  Future<List<Country>> getAllCountries() async {
    try {
      // Étape DH-03: Gestion des erreurs API
      // On utilise try/catch pour capturer les erreurs de réseau
      final response = await http.get(
        Uri.parse('https://www.apicountries.com/'),
      );

      // Vérifier si la requête a réussi (status code 200)
      if (response.statusCode == 200) {
        // Convertir la réponse JSON en liste d'objets Country
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Country.fromJson(json)).toList();
      } else {
        // Si la requête échoue, lever une exception
        throw Exception('Failed to load countries: ${response.statusCode}');
      }
    } catch (e) {
      // Capturer les erreurs de réseau ou de parsing
      throw Exception('Failed to load countries: $e');
    }
  }
}