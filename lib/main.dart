import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// --- Data Models ---

class SubCategory {
  final int id;
  final String name;
  final String description;

  SubCategory({required this.id, required this.name, required this.description});
}

class Category {
  final int id;
  final String name;
  final IconData icon;
  final List<SubCategory> subCategories;

  Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.subCategories,
  });
}

// --- Main App Widget (Home Page) ---

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  // --- Sample Data ---
  final List<Category> _categories = [
    Category(
      id: 1,
      name: 'Elektronika',
      icon: Icons.electrical_services,
      subCategories: [
        SubCategory(id: 101, name: 'Telefonok', description: 'Okostelefonok és tartozékok.'),
        SubCategory(id: 102, name: 'Laptopok', description: 'Hordozható számítógépek munkához és szórakozáshoz.'),
        SubCategory(id: 103, name: 'Fényképezőgépek', description: 'Digitális fényképezőgépek.'),
      ],
    ),
    Category(
      id: 2,
      name: 'Bútorok',
      icon: Icons.chair,
      subCategories: [
        SubCategory(id: 201, name: 'Asztalok', description: 'Étkezőasztalok, íróasztalok.'),
        SubCategory(id: 202, name: 'Székek', description: 'Kényelmes székek otthonra és irodába.'),
      ],
    ),
  ];

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  Widget _buildAppBarTitle() {
    if (_isSearching) {
      return TextField(
        controller: _searchController,
        autofocus: true,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
          hintText: 'Keresés...',
          hintStyle: TextStyle(color: Colors.white54),
          border: InputBorder.none,
        ),
      );
    } else {
      return const Text("Kategóriák", style: TextStyle(color: Colors.white));
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: Scaffold(
        appBar: AppBar(
          title: _buildAppBarTitle(),
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.lime),
              onPressed: _toggleSearch,
            ),
          ],
        ),
        body: ListView.builder(
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final category = _categories[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(category.icon, size: 40, color: Colors.deepPurple),
                title: Text(category.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SubCategoryListPage(category: category),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- SubCategory List Page ---

class SubCategoryListPage extends StatelessWidget {
  final Category category;

  const SubCategoryListPage({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: ListView.builder(
        itemCount: category.subCategories.length,
        itemBuilder: (context, index) {
          final subCategory = category.subCategories[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              title: Text(subCategory.name),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubCategoryDetailPage(subCategory: subCategory),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// --- SubCategory Detail Page ---

class SubCategoryDetailPage extends StatelessWidget {
  final SubCategory subCategory;

  const SubCategoryDetailPage({Key? key, required this.subCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subCategory.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ID: ${subCategory.id}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  subCategory.description,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
