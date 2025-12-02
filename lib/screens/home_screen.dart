import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../widgets/country_card.dart';
import '../providers/theme_provider.dart';
import 'favorites_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavoritesScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          ),
        ],
      ),
      drawer: _buildSimpleDrawer(context), // Drawer simplifié
      body: Consumer<CountryProvider>(
        builder: (context, countryProvider, child) {
          if (countryProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (countryProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Erreur: ${countryProvider.error}'),
                  ElevatedButton(
                    onPressed: countryProvider.loadCountries,
                    child: const Text('Réessayer'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Barre de recherche seulement
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: countryProvider.setQuery,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher un pays',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: countryProvider.loadCountries,
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: countryProvider.visibleCountries.length,
                    itemBuilder: (context, index) {
                      final country = countryProvider.visibleCountries[index];
                      return CountryCard(country: country);
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Provider.of<CountryProvider>(context, listen: false).loadCountries(),
        child: const Icon(Icons.refresh),
      ),
    );
  }

  // Drawer simplifié
  Widget _buildSimpleDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            child: Text(
              'Options de tri',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const Text('Choisissez un mode de tri:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 20),
          // Options de tri
          _buildSortOption(
            context,
            SortOption.nameAsc,
            'Nom (A → Z)',
            Icons.sort_by_alpha,
          ),
          _buildSortOption(
            context,
            SortOption.nameDesc,
            'Nom (Z → A)',
            Icons.sort_by_alpha,
          ),
          _buildSortOption(
            context,
            SortOption.populationAsc,
            'Population (croissante)',
            Icons.arrow_upward,
          ),
          _buildSortOption(
            context,
            SortOption.populationDesc,
            'Population (décroissante)',
            Icons.arrow_downward,
          ),
          const Divider(),
          // Statistiques simples
          Consumer<CountryProvider>(
            builder: (context, provider, child) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text('Pays: ${provider.visibleCountries.length}/${provider.countries.length}'),
                    Text('Favoris: ${provider.favoriteCountries.length}'),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Widget pour chaque option de tri
  Widget _buildSortOption(
    BuildContext context,
    SortOption option,
    String title,
    IconData icon,
  ) {
    return Consumer<CountryProvider>(
      builder: (context, provider, child) {
        final isSelected = provider.visibleCountries.isNotEmpty && provider.sort == option;
        
        return ListTile(
          leading: Icon(icon, color: isSelected ? Colors.blue : null),
          title: Text(title),
          trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
          tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
          onTap: () {
            provider.setSort(option);
            Navigator.pop(context); // Ferme le drawer
          },
        );
      },
    );
  }
}