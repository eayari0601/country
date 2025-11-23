import 'package:flutter/material.dart';
import '../models/country.dart';
import '../screens/country_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';

class CountryCard extends StatelessWidget {
  final Country country;

  const CountryCard({required this.country, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CountryDetailScreen(country: country),
          ),
        );
      },
      child: Card(
        elevation: 4,
        child: Column(
          children: [
            Flexible(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: country.flag.isNotEmpty
                        ? Hero(
                            tag: 'flag_${country.code}',
                            child: Image.network(
                              country.flag,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          )
                        : Container(
                            color: Colors.grey[300],
                            child: const Icon(Icons.flag, size: 40),
                          ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Consumer<CountryProvider>(
                      builder: (context, provider, _) {
                        final isFav = provider.isFavorite(country.code);
                        return IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.white,
                          ),
                          onPressed: () async {
                            final wasFav = provider.isFavorite(country.code);
                            await provider.toggleFavorite(country.code);
                            final nowFav = provider.isFavorite(country.code);

                            final snackBar = SnackBar(
                              content: Text(
                                nowFav
                                    ? 'Ajouté aux favoris: ${country.name}'
                                    : 'Retiré des favoris: ${country.name}',
                              ),
                              duration: const Duration(seconds: 4),
                              action: nowFav
                                  ? SnackBarAction(
                                      label: 'Annuler',
                                      onPressed: () async {
                                        // Annuler l’ajout: retirer des favoris
                                        if (provider.isFavorite(country.code)) {
                                          await provider.toggleFavorite(country.code);
                                        }
                                      },
                                    )
                                  : null,
                            );
                            ScaffoldMessenger.of(context)
                              ..hideCurrentSnackBar()
                              ..showSnackBar(snackBar);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      country.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Capital: ${country.capital}',
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}