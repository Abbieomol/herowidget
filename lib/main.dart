import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hero Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, String>> items = [
    {'url': 'https://picsum.photos/id/1015/400/400', 'title': 'Mountain River', 'category': 'Nature'},
    {'url': 'https://picsum.photos/id/1016/400/400', 'title': 'Canyon View', 'category': 'Nature'},
    {'url': 'https://picsum.photos/id/1018/400/400', 'title': 'Forest Lake', 'category': 'Nature'},
    {'url': 'https://picsum.photos/id/1024/400/400', 'title': 'Desert Dune', 'category': 'Travel'},
    {'url': 'https://picsum.photos/id/1035/400/400', 'title': 'Snowy Peak', 'category': 'Travel'},
    {'url': 'https://picsum.photos/id/1039/400/400', 'title': 'Ocean Cliff', 'category': 'Travel'},
  ];

  final Set<int> favorites = {};
  String selectedCategory = 'All';

  List<String> get categories => ['All', 'Nature', 'Travel', 'Favorites'];

  List<MapEntry<int, Map<String, String>>> get filteredItems {
    final indexed = items.asMap().entries.toList();
    if (selectedCategory == 'All') return indexed;
    if (selectedCategory == 'Favorites') {
      return indexed.where((e) => favorites.contains(e.key)).toList();
    }
    return indexed.where((e) => e.value['category'] == selectedCategory).toList();
  }

  void toggleFavorite(int index) {
    setState(() {
      if (favorites.contains(index)) {
        favorites.remove(index);
      } else {
        favorites.add(index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final visibleItems = filteredItems;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade900],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Gallery',
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.favorite, color: Colors.white, size: 20),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                child: Text(
                  '${favorites.length} favorite${favorites.length == 1 ? '' : 's'} saved',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ),
              // Filter chip bar
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => SizedBox(width: 8),
                  itemBuilder: (context, i) {
                    final cat = categories[i];
                    final selected = cat == selectedCategory;
                    return ChoiceChip(
                      label: Text(cat),
                      selected: selected,
                      onSelected: (_) => setState(() => selectedCategory = cat),
                      selectedColor: Colors.white,
                      backgroundColor: Colors.white24,
                      labelStyle: TextStyle(
                        color: selected ? Colors.deepPurple.shade700 : const Color.fromARGB(255, 62, 61, 61),
                        fontWeight: FontWeight.w600,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 161, 135, 135),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: visibleItems.isEmpty
                      ? Center(
                          child: Text(
                            'No photos here yet',
                            style: TextStyle(color: const Color.fromARGB(255, 78, 70, 70), fontSize: 16),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.85,
                          ),
                          itemCount: visibleItems.length,
                          itemBuilder: (context, i) {
                            final index = visibleItems[i].key;
                            final item = visibleItems[i].value;
                            return _GalleryTile(
                              url: item['url']!,
                              title: item['title']!,
                              tag: 'hero-$index',
                              isFavorite: favorites.contains(index),
                              onFavoriteToggle: () => toggleFavorite(index),
                            );
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GalleryTile extends StatelessWidget {
  final String url;
  final String title;
  final String tag;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const _GalleryTile({
    required this.url,
    required this.title,
    required this.tag,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: Duration(milliseconds: 400),
            pageBuilder: (context, animation, secondaryAnimation) =>
                DetailScreen(url: url, title: title, tag: tag),
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Hero(
              tag: tag,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                  image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: onFavoriteToggle,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black45,
                        child: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.redAccent : const Color.fromARGB(255, 12, 1, 1),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        ],
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String url;
  final String title;
  final String tag;

  const DetailScreen({super.key, required this.url, required this.title, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: Hero(
              tag: tag,
              child: Image.network(url, fit: BoxFit.contain),
            ),
          ),
          Positioned(
            top: 40,
            left: 16,
            child: SafeArea(
              child: CircleAvatar(
                backgroundColor: Colors.black45,
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}