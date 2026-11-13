import 'package:flutter/material.dart';

class DogDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> dog;
  const DogDetailsScreen({super.key, required this.dog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(dog['name'] ?? 'Информация'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.network(
              dog['image_link'] ?? '',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[200],
                child: const Center(child: Icon(Icons.pets, size: 80, color: Colors.grey)),
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Физические данные", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildInfoTile(Icons.cake, "Жизнь", "${dog['min_life_expectancy']} - ${dog['max_life_expectancy']} лет"),
                _buildInfoTile(Icons.monitor_weight, "Вес (самцы)", "до ${dog['max_weight_male']} кг"),
                _buildInfoTile(Icons.height, "Рост (самцы)", "${dog['max_height_male']} см"),
              ],
            ),
          ),

          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Характер", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildInfoTile(Icons.child_care, "С детьми", "${dog['good_with_children']} / 5"),
                _buildInfoTile(Icons.sports_tennis, "Игривость", "${dog['playfulness']} / 5"),
                _buildInfoTile(Icons.shield, "Защитность", "${dog['protectiveness']} / 5"),
                _buildInfoTile(Icons.brush, "Склонность к линьке", "${dog['shedding']} / 5"),
                _buildInfoTile(Icons.school, "Дрессируемость", "${dog['trainability']} / 5"),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.black87, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          ),
          Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}