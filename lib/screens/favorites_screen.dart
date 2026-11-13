import 'package:flutter/material.dart';
import 'dog_details_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> favorites;
  
  const FavoritesScreen({super.key, required this.favorites});

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text("В избранном пока пусто", style: TextStyle(color: Colors.grey, fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: favorites.length,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        final dog = favorites[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                dog['image_link'] ?? '',
                width: 60, height: 60, fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.pets, size: 40, color: Colors.grey),
              ),
            ),
            title: Text(dog['name'] ?? 'Без названия', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DogDetailsScreen(dog: dog)));
            },
          ),
        );
      },
    );
  }
}