import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: CategoryScreen(),
  ));
}

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('دسته بندی کالاها'),
        centerTitle: true, // Centers the title in the AppBar
        backgroundColor: Colors.grey[300], // Apply grey background color
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: [
            _CategoryItem(
              icon: Icons.woman,
              title: 'پوشاک زنانه',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductScreen(category: 'پوشاک زنانه'),
                  ),
                );
              },
            ),
            _CategoryItem(
              icon: Icons.sports_basketball,
              title: 'لوازم ورزشی',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductScreen(category: 'لوازم ورزشی'),
                  ),
                );
              },
            ),
            _CategoryItem(
              icon: Icons.tv,
              title: 'کالاهای دیجیتال',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductScreen(category: 'کالاهای دیجیتال'),
                  ),
                );
              },
            ),
            _CategoryItem(
              icon: Icons.brush, // Replaced Icons.lipstick with Icons.brush
              title: 'آرایش و بهداشتی',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductScreen(category: 'آرایش و بهداشتی'),
                  ),
                );
              },
            ),
            _CategoryItem(
              icon: Icons.man, // Replaced Icons.jacket with Icons.umbrella
              title: 'پوشاک مردانه',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductScreen(category: 'پوشاک مردانه'),
                  ),
                );
              },
            ),
            _CategoryItem(
              icon: Icons.kitchen,
              title: 'لوازم آشپزخانه',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductScreen(category: 'لوازم آشپزخانه'),
                  ),
                );
              },
            ),
            _CategoryItem(
              icon: Icons.music_note,
              title: 'آلات موسیقی',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ProductScreen(category: 'آلات موسیقی'),
                  ),
                );
              },
            ),
            _CategoryItem(
              icon: Icons.diamond,
              title: 'طلا و نقره',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductScreen(category: 'طلا و نقره'),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _CategoryItem(
      {Key? key, required this.icon, required this.title, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle, // Make the container circular
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40.0),
            SizedBox(height: 8.0),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12.0),
            ),
          ],
        ),
      ),
    );
  }
}

class ProductScreen extends StatelessWidget {
  final String category;

  const ProductScreen({Key? key, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('محصولات - $category'),
      ),
      body: Center(
        child: Text('لیست محصولات مربوط به $category'),
      ),
    );
  }
}
