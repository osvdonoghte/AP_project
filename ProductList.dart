import 'package:flutter/material.dart';

class CategoryProductScreen extends StatelessWidget {
  final String
  categoryName; // The category name passed from the previous screen

  const CategoryProductScreen({Key? key, required this.categoryName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          categoryName,
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        actions: [
          // Search bar on the right side
          Container(
            height: 40,
            width: 250,
            margin: const EdgeInsets.only(
                right: 16), // Move search bar to the right
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'جستجو...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SortingBar(),
              const SizedBox(height: 16),
              _ProductList(),
            ],
          ),
        ),
      ),
    );
  }
}

class _SortingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300], // Casual grey background
              foregroundColor:
              Colors.black, // Text color (replaces 'onPrimary')
            ),
            child: const Text('بیشترین قیمت'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor:
              Colors.black, // Text color (replaces 'onPrimary')
            ),
            child: const Text('کمترین قیمت'),
          ),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[300],
              foregroundColor:
              Colors.black, // Text color (replaces 'onPrimary')
            ),
            child: const Text('پرفروش‌ترین'),
          ),
        ],
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  // Sample data for products
  final List<ProductEntity> products = [
    ProductEntity(
      id: 1,
      name: 'Product 1',
      imageUrl: 'assets/product1.png',
      price: 1000,
      originalPrice: 1200,
      rating: 4.5,
    ),
    ProductEntity(
      id: 2,
      name: 'Product 2',
      imageUrl: 'assets/product2.png',
      price: 800,
      originalPrice: 1000,
      rating: 4.0,
    ),
    ProductEntity(
      id: 3,
      name: 'Product 3',
      imageUrl: 'assets/product3.png',
      price: 1500,
      originalPrice: 1600,
      rating: 5.0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns in grid
          crossAxisSpacing: 16.0, // Spacing between items
          mainAxisSpacing: 16.0, // Spacing between rows
          childAspectRatio: 0.8, // Adjust the aspect ratio for smaller cards
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductItem(product: product);
        },
      ),
    );
  }
}

class _ProductItem extends StatelessWidget {
  final ProductEntity product;

  const _ProductItem({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: Colors.grey[100],
      elevation: 4, // Adds shadow to make the box look better
      child: Padding(
        padding: const EdgeInsets.all(
            8.0), // Reduces padding to make the box smaller
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              product.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 14, // Smaller font size
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis, // Handles long names
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  'تومان ${product.price}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                if (product.originalPrice > product.price)
                  Text(
                    'تومان ${product.originalPrice}',
                    style: const TextStyle(
                      fontSize: 10,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  product.rating.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const Spacer(),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: Icon(Icons.add_shopping_cart, color: Colors.black),
                onPressed: () {
                  // Add product to cart
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Models
class ProductEntity {
  final int id;
  final String name;
  final String imageUrl;
  final int price;
  final int originalPrice;
  final double rating;

  ProductEntity({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.originalPrice,
    required this.rating,
  });
}

void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CategoryProductScreen(
          categoryName: 'Electronics'), // Example category name
    ),
  );
}
