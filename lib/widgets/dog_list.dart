import 'package:flutter/material.dart';
import '../services/dog_service.dart';
import '../screens/dog_details_screen.dart';
import '../screens/favorites_screen.dart';

class DogList extends StatefulWidget {
  const DogList({super.key});
  @override
  State<DogList> createState() => _DogListState();
}

class _DogListState extends State<DogList> with SingleTickerProviderStateMixin {
  final DogService _dogService = DogService();
  final TextEditingController _searchController = TextEditingController();
  
  List<dynamic> _dogs = [];
  bool _isLoading = false;
  List<Map<String, dynamic>> _favorites = [];
  int _currentIndex = 0;

  late final AnimationController _animationController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  );

  late final Animation<double> _rotationAnimation = Tween<double>(
    begin: 0, end: 2 * 3.14159
  ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));

  final List<String> _randomBreeds = [
    'husky', 'poodle', 'beagle', 'boxer', 'chihuahua', 
    'dalmatian', 'pug', 'rottweiler', 'shih tzu'
  ];

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchDogs() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return; 

    setState(() => _isLoading = true);
    final result = await _dogService.fetchDogs(breedName: query);
    
    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (result == null) {
        _dogs = [];
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ошибка сети. Проверьте интернет.")),
        );
      } else {
        _dogs = result;
      }
    });
  }

  void _getRandomDog() {
    _animationController.forward(from: 0);
    final random = _randomBreeds[DateTime.now().millisecond % _randomBreeds.length];
    _searchController.text = random;
    setState(() => _currentIndex = 0); 
    _searchDogs();
  }

  void _toggleFavorite(Map<String, dynamic> dog) {
    setState(() {
      if (_favorites.contains(dog)) {
        _favorites.remove(dog);
      } else {
        _favorites.add(dog);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),       
      appBar: AppBar(
        title: Text(
          _currentIndex == 0 ? "Поиск" : (_currentIndex == 1 ? "Случайная" : "Избранное"),
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        centerTitle: false,
        titleSpacing: 20,
      ),
      
      body: _buildBody(),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB), width: 1)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey[400],
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Поиск"),
            BottomNavigationBarItem(icon: Icon(Icons.casino_outlined), label: "Случайная"),
            BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Избранное"),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_currentIndex == 2) return FavoritesScreen(favorites: _favorites);

    if (_currentIndex == 1) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _rotationAnimation,
              child: const Icon(Icons.casino_outlined, size: 80, color: Colors.black87),
            ),
            const SizedBox(height: 24),
            const Text("Не знаете, какую породу выбрать?", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _getRandomDog,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black, 
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Тык", style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Поле поиска в стиле iOS
        Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
          child: TextField(
            controller: _searchController,
            onChanged: (text) {
              if (text.length > 2) _searchDogs();
            },
            decoration: InputDecoration(
              hintText: "Найти породу",
              hintStyle: TextStyle(color: Colors.grey[400], fontSize: 16),
              filled: true,
              fillColor: const Color(0xFFF3F4F6), // Светло-серое поле
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        
        Expanded(child: _buildResults()),
      ],
    );
  }

  Widget _buildResults() {
    if (_isLoading) return const Center(child: CircularProgressIndicator(color: Colors.black));
    
    if (_dogs.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.pets, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text("Ничего не найдено", style: TextStyle(color: Colors.grey[500], fontSize: 16)),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: _dogs.length,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      itemBuilder: (context, index) {
        final dog = _dogs[index];
        final isFav = _favorites.contains(dog);
        final hasImage = dog['image_link'] != null && dog['image_link'].toString().isNotEmpty;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)), // Тонкая аккуратная рамка
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            
            leading: hasImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      dog['image_link'],
                      width: 56, height: 56, fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => 
                          const Icon(Icons.pets, size: 30, color: Colors.grey),
                    ),
                  )
                : Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.pets, size: 24, color: Colors.grey),
                  ),

            title: Text(dog['name'] ?? 'Без названия', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: Colors.black87)),
            subtitle: Text("Живет до ${dog['max_life_expectancy'] ?? '?'} лет", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            
            trailing: IconButton(
              icon: Icon(isFav ? Icons.favorite : Icons.favorite_border, color: isFav ? Colors.black : Colors.grey[400]),
              onPressed: () => _toggleFavorite(dog),
            ),
            
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DogDetailsScreen(dog: dog)),
              );
            },
          ),
        );
      },
    );
  }
}