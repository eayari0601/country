import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../widgets/country_card.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {}, // ThemeProvider is not defined; remove toggle call
          ),
          Consumer<CountryProvider>(
            builder: (context, provider, _) {
              return PopupMenuButton<SortOption>(
                onSelected: provider.setSort,
                icon: const Icon(Icons.sort),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: SortOption.nameAsc, child: Text('Name ↑')),
                  PopupMenuItem(value: SortOption.nameDesc, child: Text('Name ↓')),
                  PopupMenuItem(value: SortOption.populationAsc, child: Text('Population ↑')),
                  PopupMenuItem(value: SortOption.populationDesc, child: Text('Population ↓')),
                ],
              );
            },
          ),
        ],
      ),
      body: Consumer<CountryProvider>(
        builder: (context, countryProvider, child) {
          if (countryProvider.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading countries...'),
                ],
              ),
            );
          }

          if (countryProvider.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64),
                  const SizedBox(height: 16),
                  Text('Error: ${countryProvider.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: countryProvider.loadCountries,
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: countryProvider.setQuery,
                  decoration: const InputDecoration(
                    hintText: 'Search by name or capital',
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
}